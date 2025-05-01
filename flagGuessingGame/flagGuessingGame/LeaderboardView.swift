//
//  LeaderboardView.swift
//  flagGuessingGame
//
//  Created by Megan Hastie on 29/04/2025.
//

import SwiftUI

struct LeaderboardView: View {
    
    @Environment(\.dismiss) private var dismiss
    
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
                .padding(.horizontal, 25)
                
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
                ZStack(alignment: .top) {
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
                    .padding(.top, 20) // Padding from top of box
                    .padding(.bottom, 20)
                }
                
                .frame(maxWidth: 400)
                
                Spacer()
                
                
                /*
                 * uncomment to clear the player scores for demoing
                 
                 Button(action: clearPlayerScores) {
                 Text("Clear High Scores")
                 .foregroundColor(.red)
                 .padding()
                 .background(Color(.systemGray6))
                 .clipShape(RoundedRectangle(cornerRadius: 10))
                 }
                 */
                 
                
                
                
                // BUTTON NEEDS TO POINT TO SETTINGS VIEW so players can start another game
                Button(action: {
                    dismiss()
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
    
    
    /*
     private func clearPlayerScores() {
     UserDefaults.standard.removeObject(forKey: "PlayerScores")
     playerScores = []
     }
     */
     
    
}

#Preview {
    LeaderboardView(playerName: "Diva", score: 20)
}
