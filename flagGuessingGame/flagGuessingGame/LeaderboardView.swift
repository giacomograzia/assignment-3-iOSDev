//
//  LeaderboardView.swift
//  flagGuessingGame
//
//  Created by Megan Hastie on 29/04/2025.
//

import SwiftUI

struct LeaderboardView: View {
    
    @State private var playerScores: [PlayerScore] = []
    
    var playerName: String
    var score: Int
    
    var body: some View {
        ZStack {
            //background
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            //colour overlay for better contrast
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                //title
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
                
                //current player data
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
                
                //leaderboard list
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .padding(.horizontal, 20)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    VStack(spacing: 10) {
                        ForEach(playerScores.sorted(by: { $0.score > $1.score }).prefix(5)) { playerScore in
                            HStack {
                                Text(playerScore.playerName)
                                    .font(.headline)
                                    .foregroundColor(Color("customBlue"))
                                Spacer()
                                Text("\(playerScore.score)")
                                    .font(.headline)
                                    .foregroundColor(Color("customGreen"))
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .frame(maxWidth: 400)
                
                Spacer()
                
                
               /*
                * uncomment to clear the player scores for demoing
                *
                Button(action: clearPlayerScores) {
                    Text("Clear High Scores")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                */
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .onAppear {
            loadPlayerScores()
            savePlayerScores()
        }
        .navigationBarHidden(true)
    }
    
    private func loadPlayerScores() {
        if let data = UserDefaults.standard.data(forKey: "PlayerScores") {
            let decoder = JSONDecoder()
            if let decodedPlayerScores = try? decoder.decode([PlayerScore].self, from: data) {
                playerScores = decodedPlayerScores
            }
        }
    }
    
    private func savePlayerScores() {
        let newPlayerScore = PlayerScore(playerName: playerName, score: score)
        playerScores.append(newPlayerScore)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(playerScores) {
            UserDefaults.standard.set(encoded, forKey: "PlayerScores")
        }
    }
    
    
    /*
    private func clearPlayerScores() {
        UserDefaults.standard.removeObject(forKey: "PlayerScores")
        playerScores = []
    }
     */
    
}

#Preview {
    LeaderboardView(playerName: "Test Player", score: 100)
}
