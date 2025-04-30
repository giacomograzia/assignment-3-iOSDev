//
//  GameView.swift
//  flagGuessingGame
//
//  Created by Giacomo Grazia on 29/4/2025.
//

import SwiftUI

struct GameView: View {
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

    @State private var isOptionDisabled = false
    @State private var isGameOver = false

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

            VStack(spacing: 0) {
                // HUD
                VStack {
                    HStack {
                        Text(playerName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        
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
                        .frame(maxWidth: .infinity)
                        
                        HStack(spacing: 4) {
                            ForEach(0..<startingLives, id: \.self) { index in
                                Image(systemName: index < livesRemaining ? "heart.fill" : "heart")
                                    .foregroundColor(index < livesRemaining ? .red : .gray)
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
                
                
                // Flag section
                if let correctCountry = correctCountry {
                    VStack(spacing: 5) {
                        Text(correctCountry.emoji)
                            .font(.system(size: 120))
                            .shadow(radius: 10)
                        
                        ZStack {
                            // Actual name – only shown after selection
                            if showCountryName {
                                Text(selectedCountryName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(feedbackColor)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.6)
                                    .frame(maxWidth: 250)
                                    .fixedSize(horizontal: false, vertical: true) // allows wrapping but fixes box size
                                    .transition(.opacity)
                                    .padding(.horizontal, 10)
                            } else {
                                Text(String(repeating: "█", count: max(6, correctCountry.countryName.count)))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white.opacity(0.3))
                                    .blur(radius: 2)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.6)
                                    .frame(maxWidth: 250)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .transition(.opacity)
                                    .padding(.horizontal, 10)
                            }

                        }
                        .animation(.easeInOut(duration: 0.3), value: showCountryName)

                        
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
                
                // Answer buttons
                VStack(spacing: 20) {
                    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(options, id: \.id) { country in
                            Button(action: {
                                if !isOptionDisabled {
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
                                            gradient: Gradient(colors: [Color("customGreen"), Color("customBlue")]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
                            }
                            .disabled(isOptionDisabled)
                        }
                    }
                    .padding(.horizontal, 105)
                }
                
                Spacer()
            }
            .fullScreenCover(isPresented: $isGameOver, onDismiss: {
                // You stay in GameView after leaderboard closes
            }) {
                LeaderboardView(playerName: playerName, score: currentScore)
            }

        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadNewRound()
        }
    }

    // MARK: - Logic

    private func loadNewRound() {
        isOptionDisabled = false
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

        if livesRemaining <= 0 {
            saveScoreToLeaderboard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isGameOver = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showCountryName = false
                loadNewRound()
            }
        }
    }


    private func saveScoreToLeaderboard() {
        print("Saving score: \(currentScore) for player \(playerName)")
        // You can save to UserDefaults or local file later
    }
}

#Preview {
    GameView(difficulty: "3", playerName: "Diva", startingLives: 3)
}

