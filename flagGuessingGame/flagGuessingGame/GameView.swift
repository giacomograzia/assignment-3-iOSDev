//  GameView.swift
//  flagGuessingGame
//
//  Created by Giacomo Grazia on 29/4/2025.

import SwiftUI

/*
 The code for the game. Users have 3 lives and 10 seconds to guess a flag. If time runs out or the user runs out of lives, a game over overlay will be displayed and the user will be navigated to the leaderboard.
 */

struct GameView: View {
    //passed from settingsView
    let difficulty: String
    let playerName: String
    let startingLives: Int

    @State private var countries: [Country] = []
    @State private var correctCountry: Country?
    @State private var options: [Country] = []

    @State private var selectedCountryName = ""
    @State private var showCountryName = false
    @State private var feedbackColor = Color.green

    @State private var livesRemaining: Int
    @State private var currentScore: Int = 0
    @State private var totalScorePossible: Int = 0
    @State private var bestScore: Int = 0

    @State private var isOptionDisabled = false
    @State private var isGameOver = false
    @State private var showGameOverOverlay = false

    @State private var timeRemaining: Int = 30
    @State private var timerColor: Color = .white
    @State private var timer: Timer?
    @State private var showTimeoutMessage: Bool = false

    @State private var usedCountries: Set<String> = []
    @State private var didSaveScore = false

    init(difficulty: String, playerName: String, startingLives: Int = 3) {
        self.difficulty = difficulty
        self.playerName = playerName
        self.startingLives = 3  // Fixed to always start with 3 lives
        self._livesRemaining = State(initialValue: 3)  // Ensure livesRemaining also starts with 3
    }

    var numberOfOptions: Int {
        switch difficulty {
        case "1": return 2
        case "2": return 4
        case "3": return 6
        default: return 4
        }
    }

    var body: some View {
        ZStack {
            //game background
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            //code for top bar - name, timer, score, best high score, lives
                            Text(playerName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            Text("⏱ \(timeRemaining)s")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(timerColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                        VStack(spacing: 4) {
                            Text("Score: \(currentScore)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Best: \(bestScore)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .frame(maxWidth: .infinity)

                        HStack(spacing: 4) {
                            ForEach(Array(0..<startingLives), id: \.self) {
                                index in
                                Image(
                                    systemName: index < livesRemaining
                                        ? "heart.fill" : "heart"
                                )
                                .foregroundColor(
                                    index < livesRemaining ? .red : .gray
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 12)
                    .padding(.horizontal, 70)
                }
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)

                if let correctCountry = correctCountry {
                    VStack(spacing: 5) {
                        Text(correctCountry.emoji)
                            .font(.system(size: 120))
                            .shadow(radius: 10)

                        ZStack {
                            if showCountryName {
                                Text(selectedCountryName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(feedbackColor)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.6)
                                    .frame(maxWidth: 250)
                                    .fixedSize(
                                        horizontal: false,
                                        vertical: true
                                    )
                                    .transition(.opacity)
                                    .padding(.horizontal, 10)
                            } else {
                                // Fixed-length fog for consistency
                                Text("██████████")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white.opacity(0.3))
                                    .blur(radius: 2)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.6)
                                    .frame(maxWidth: 250)
                                    .fixedSize(
                                        horizontal: false,
                                        vertical: true
                                    )
                                    .transition(.opacity)
                                    .padding(.horizontal, 10)
                            }
                        }
                        .animation(
                            .easeInOut(duration: 0.3),
                            value: showCountryName
                        )

                        Text("\(correctCountry.normalizedScore) points")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 20)
                }

                Spacer()
                Spacer()

                VStack(spacing: 20) {
                    let columns: [GridItem] = Array(
                        repeating: GridItem(.flexible(), spacing: 20),
                        count: 2
                    )

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(options, id: \.id) { country in
                            Button(action: {
                                if !isOptionDisabled {
                                    timer?.invalidate()
                                    isOptionDisabled = true
                                    countryTapped(country)
                                }
                            }) {
                                Text(country.countryName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 100)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color("customGreen"),
                                                Color("customBlue"),
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .shadow(
                                        color: .black.opacity(0.25),
                                        radius: 5,
                                        x: 0,
                                        y: 3
                                    )
                            }
                            .disabled(isOptionDisabled)
                        }
                    }
                    .padding(.horizontal, 105)
                }

                Spacer()
            }

            //code for handling the game ending

            if showGameOverOverlay {
                ZStack {
                    Color.black.opacity(0.85)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        if showTimeoutMessage {
                            Text("⏰ Time's up!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        Text("Game Over")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 10)

                        Text("Final Score: \(currentScore)")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .zIndex(999)
                .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isGameOver) {
            LeaderboardView(playerName: playerName, score: currentScore)
                .interactiveDismissDisabled(true)  // Prevent closing with Escape
                .onDisappear {
                    // Trigger game reinitialization when returning from the leaderboard
                    livesRemaining = startingLives
                    currentScore = 0
                    totalScorePossible = 0
                    showCountryName = false
                    isOptionDisabled = false
                    showGameOverOverlay = false
                    usedCountries.removeAll()
                    loadBestScore()
                    loadNewRound()
                    startTimer()
                }
        }
        .onAppear {
            livesRemaining = startingLives
            currentScore = 0
            totalScorePossible = 0
            showCountryName = false
            isOptionDisabled = false
            showGameOverOverlay = false
            usedCountries.removeAll()  // Reset the used countries set

            // Load best score from storage
            loadBestScore()

            // Load countries once
            countries = CountryDataManager.loadCountries()

            loadNewRound()
            startTimer()  // Start the timer only once when the game view appears
            // UserDefaults.standard.removeObject(forKey: "PlayerScores")
            didSaveScore = false

        }

    }

    // Load a new round and ensure the timer is running
    private func loadNewRound() {
        isOptionDisabled = false

        // Reset the used countries set if all countries have been used
        if usedCountries.count == countries.count {
            usedCountries.removeAll()
        }

        // Filter out the already used countries
        let availableCountries = countries.filter {
            !usedCountries.contains($0.countryName)
        }

        // Ensure we have enough countries to choose from
        guard !availableCountries.isEmpty else { return }

        // Select a new correct country from the available (unused) countries
        correctCountry = availableCountries.randomElement()

        if let correctCountry = correctCountry {
            // Mark the chosen country as used
            usedCountries.insert(correctCountry.countryName)

            var wrongOptions = countries.filter {
                $0.countryName != correctCountry.countryName
            }
            wrongOptions.shuffle()
            wrongOptions = Array(wrongOptions.prefix(numberOfOptions - 1))

            options = wrongOptions + [correctCountry]
            options.shuffle()

            totalScorePossible += correctCountry.normalizedScore
        }

        startTimer()
    }

    // Handle when a country option is chosen
    private func countryTapped(_ selected: Country) {
        guard let correct = correctCountry else { return }

        selectedCountryName = correct.countryName
        showCountryName = true

        if selected.countryName == correct.countryName {
            feedbackColor = Color("customGreen")
            currentScore += correct.normalizedScore
        } else {
            feedbackColor = .red
            livesRemaining -= 1
        }

        // Check if the game is over (either by lives or timeout)
        if livesRemaining <= 0 || timeRemaining <= 0 {
            handleGameOver()
        } else {
            // Delay before loading a new round, but do not invalidate the timer
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showCountryName = false
                loadNewRound()
            }
        }
    }

    // Starts the timer, or restarts it if needed
    private func startTimer() {
        // Invalidate any existing timer before starting a new one
        timer?.invalidate()
        timer = nil

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 3 {
                    timerColor = .red
                }
            } else {
                handleTimeout()
            }
        }
    }

    // Unified Game Over Handler
    private func handleGameOver() {
        if isGameOver { return }  // still prevents re-entry
        isGameOver = true
        timer?.invalidate()
        timer = nil

        // Save only once per game
        if !didSaveScore {
            saveScoreToLeaderboard()
            didSaveScore = true
        }

        withAnimation { showGameOverOverlay = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { showGameOverOverlay = false }
            isGameOver = true  // keeps the full-screen cover up
        }
    }

    // Handles the timer running out
    private func handleTimeout() {
        timer?.invalidate()
        timer = nil

        selectedCountryName = correctCountry?.countryName ?? ""
        showCountryName = true
        feedbackColor = .red
        livesRemaining -= 1
        withAnimation {
            showTimeoutMessage = true
        }
        // Trigger game over when lives run out or time is up
        if livesRemaining <= 0 || timeRemaining <= 0 {
            handleGameOver()
        }

    }

    //saves users score when they finish the game/ die
    private func saveScoreToLeaderboard() {
        var savedScores = loadLeaderboard()
        let newScore = PlayerScore(playerName: playerName, score: currentScore)

        // Check if the score already exists for this player
        if let index = savedScores.firstIndex(where: {
            $0.playerName == playerName
        }) {
            // Update the score only if it's higher
            if currentScore > savedScores[index].score {
                savedScores[index].score = currentScore
            }
        } else {
            // Add a new score if it doesn't exist
            savedScores.append(newScore)
        }

        // Sort scores in descending order
        savedScores.sort { $0.score > $1.score }
        saveLeaderboard(savedScores)
    }

    //loads previous player scores
    func loadLeaderboard() -> [PlayerScore] {
        guard let data = UserDefaults.standard.data(forKey: "PlayerScores")
        else {
            return []
        }
        let decoder = JSONDecoder()
        if let scores = try? decoder.decode([PlayerScore].self, from: data) {
            return scores
        }
        return []
    }

    //update and save leaderboard
    func saveLeaderboard(_ scores: [PlayerScore]) {
        if let data = try? JSONEncoder().encode(scores) {
            UserDefaults.standard.set(data, forKey: "PlayerScores")
        }
    }

    //resets game for when user wants to play again
    private func resetGame() {
        livesRemaining = startingLives
        currentScore = 0
        totalScorePossible = 0
        showCountryName = false
        isOptionDisabled = false
        showGameOverOverlay = false
        isGameOver = false  // Reset the game over state
        loadNewRound()
    }

    //gets the highest score in leaderboard
    private func loadBestScore() {
        let scores = loadLeaderboard()
        bestScore = scores.map(\.score).max() ?? 0
    }
}

#Preview {
    GameView(difficulty: "3", playerName: "Diva", startingLives: 3)
}
