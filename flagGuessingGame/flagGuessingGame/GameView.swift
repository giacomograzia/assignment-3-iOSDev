//
//  GameView.swift
//  flagGuessingGame
//
//  Created by Giacomo Grazia on 29/4/2025.
//

import SwiftUI

struct GameView: View {
    // Variables from SettingsView
    let difficulty: String
    let playerName: String
    let startingLives: Int

    @State private var countries: [Country] = []
    @State private var correctCountry: Country?
    @State private var options: [Country] = []

    @State private var showFeedback = false
    @State private var feedbackText = ""
    @State private var feedbackColor = Color.green
    @State private var showCountryName = false
    @State private var selectedCountryName = ""

    @State private var livesRemaining: Int
    @State private var currentScore: Int = 0
    @State private var totalScorePossible: Int = 0

    init(difficulty: String, playerName: String, startingLives: Int) {
        self.difficulty = difficulty
        self.playerName = playerName
        self.startingLives = startingLives
        self._livesRemaining = State(initialValue: startingLives)
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
            // Background
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Color.black.opacity(0.3)
                .ignoresSafeArea()

            if showFeedback {
                VStack {
                    Spacer()
                    Text(feedbackText)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(feedbackColor)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .padding(.bottom, 10)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showFeedback)
            }


            VStack(spacing: 0) {
                // HUD at top
                VStack {
                    HStack {
                        // Player name
                        Text(playerName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)

                        // Score
                        VStack(spacing: 4) {
                            Text("Score: \(currentScore)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Best: \(totalScorePossible)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)


                        // Lives
                        HStack(spacing: 4) {
                            ForEach(0..<startingLives, id: \.self) { index in
                                Image(systemName: index < livesRemaining ? "heart.fill" : "heart")
                                    .foregroundColor(index < livesRemaining ? .red : .gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 60) // safe offset under Dynamic Island
                    .padding(.bottom, 12)
                    .padding(.horizontal, 20)
                }
                .background(.ultraThinMaterial)
                .padding(.horizontal, 50)
                .ignoresSafeArea(edges: .top)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)

                Spacer() // pushes rest of content down
            }



            VStack(spacing: 30) {
                Spacer()

                // Flag and score
                if let correctCountry = correctCountry {
                    Spacer()
                    Spacer()
                    VStack(spacing: 12) {
                        Text(correctCountry.emoji)
                            .font(.system(size: 120))
                            .shadow(radius: 10)

                        if showCountryName {
                            Text(selectedCountryName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(feedbackColor)
                        }

                        Text("\(correctCountry.normalizedScore) points")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 2)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 10)
                }

                // Answer buttons
                VStack(spacing: 20) {
                    Spacer()
                    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2) // 2 columns layout

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(options, id: \.id) { country in
                            Button(action: {
                                countryTapped(country)
                            }) {
                                VStack {
                                    Text(country.countryName)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(2)
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 5)
                                }
                                .frame(height: 100) // ✅ Fixed tile height
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("customGreen"), Color("customBlue")]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
                            }
                        }
                    }
                    .padding(.horizontal, 100)

                }

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadNewRound()
        }
    }

    // MARK: - Functions

    private func loadNewRound() {
        countries = CountryDataManager.loadCountries()

        guard countries.count >= numberOfOptions else { return }

        correctCountry = countries.randomElement()

        if let correctCountry = correctCountry {
            var wrongOptions = countries.filter { $0.countryName != correctCountry.countryName }
            wrongOptions.shuffle()
            wrongOptions = Array(wrongOptions.prefix(numberOfOptions - 1))

            options = wrongOptions + [correctCountry]
            options.shuffle()

            totalScorePossible += correctCountry.normalizedScore
        }
    }

    private func countryTapped(_ selected: Country) {
        selectedCountryName = correctCountry?.countryName ?? ""
        showCountryName = true

        if selected.countryName == correctCountry?.countryName {
            feedbackText = "Correct"
            feedbackColor = Color("customGreen")
            currentScore += correctCountry?.normalizedScore ?? 0
        } else {
            feedbackText = "Wrong"
            feedbackColor = Color.red
            livesRemaining -= 1
        }

        showFeedback = true

        if livesRemaining == 0 {
            saveScoreToLeaderboard()
            // TODO: maybe show an end screen later
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                loadNewRound()
                showFeedback = false
                showCountryName = false
            }
        }
    }

    private func saveScoreToLeaderboard() {
        print("Saving score: \(currentScore) for player \(playerName)")
        // TODO: Save score to persistent storage
    }
}

#Preview {
    GameView(difficulty: "3", playerName: "Test", startingLives: 3)
}
