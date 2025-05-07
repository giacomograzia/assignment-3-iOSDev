//  LeaderboardView.swift
//  flagGuessingGame
//
//  Created by Megan Hastie on 29/04/2025.

import SwiftUI

/*
 Shows the name and scores of previous players. Allows user to play again.
 */

struct LeaderboardView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var navigateToSettings = false

    @State private var playerScores: [PlayerScore] = []

    var playerName: String
    var score: Int

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                Color.black.opacity(0.1).ignoresSafeArea()
                contentView
            }
            .onAppear {
                loadPlayerScores()
                savePlayerScores()
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView()
            }
        }
    }

    private var backgroundView: some View {
        Image("Background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

    private var contentView: some View {
        VStack(spacing: 20) {
            Spacer()
            headerView
            playerInfoView
            leaderboardView
            Spacer()
            playAgainButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var headerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .frame(height: 100)
                .padding(.horizontal, 40)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)

            Text("Leaderboard")
                .font(.system(size: 48, weight: .heavy, design: .rounded))
                .foregroundColor(Color("customGreen"))
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 25)
    }

    private var playerInfoView: some View {
        VStack(spacing: 8) {
            Text("Player: \(playerName)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("Score: \(score)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.bottom, 20)
    }

    private var leaderboardView: some View {
        let sortedScores = playerScores.sorted(by: { $0.score > $1.score })

        return ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .padding(.horizontal, 20)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 10) {
                Text("Top Players")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("customBlue"))
                    .frame(maxWidth: .infinity, alignment: .center)

                List {
                    ForEach(0..<sortedScores.count, id: \.self) { index in
                        let playerScore = sortedScores[index]
                        HStack {
                            Text("\(leaderboardEmoji(for: index)) \(playerScore.playerName)")
                                .font(.headline)
                                .foregroundColor(Color("customBlue"))
                            Spacer()
                            Text("\(playerScore.score)")
                                .font(.headline)
                                .foregroundColor(Color("customGreen"))
                        }
                    }
                    .onDelete(perform: deletePlayerScore)
                }
                .frame(height: 250)
                .listStyle(PlainListStyle())
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            .padding(.horizontal)
        }
        .frame(maxWidth: 400)
    }

    private var playAgainButton: some View {
        Button(action: {
            navigateToSettings = true
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color("customGreen"), Color("customBlue")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 60)
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)

                Text("Play Again")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 70)
        }
    }

    private func loadPlayerScores() {
        guard let data = UserDefaults.standard.data(forKey: "PlayerScores"),
              let decoded = try? JSONDecoder().decode([PlayerScore].self, from: data)
        else {
            playerScores = []
            return
        }
        playerScores = decoded
    }

    private func savePlayerScores() {
        let newPlayerScore = PlayerScore(playerName: playerName, score: score)
        playerScores.append(newPlayerScore)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(playerScores) {
            UserDefaults.standard.set(encoded, forKey: "PlayerScores")
        }
    }

    private func deletePlayerScore(at offsets: IndexSet) {
        playerScores = playerScores.sorted(by: { $0.score > $1.score })
        playerScores.remove(atOffsets: offsets)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(playerScores) {
            UserDefaults.standard.set(encoded, forKey: "PlayerScores")
        }
    }

    private func leaderboardEmoji(for index: Int) -> String {
        switch index {
        case 0: return "🥇"
        case 1: return "🥈"
        case 2: return "🥉"
        default: return ""
        }
    }
}

#Preview {
    LeaderboardView(playerName: "Diva", score: 20)
}
