//
//  SettingsView.swift
//  flagGuessingGame
//
//  Created by Megan Hastie on 28/04/2025.
//


/*
 In the settings, the user will pick how difficult they want the game to be (number of options), and the game view will differ based on that.
 */


import SwiftUI

struct SettingsView: View {
    @State private var difficulty = "2"
    let difficulties = ["1", "2", "3"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer().frame(height: 40)
                    
                    // Title
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.ultraThinMaterial)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .padding(.horizontal, 40)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Text("Settings")
                            .font(.system(size: 44, weight: .heavy, design: .rounded))
                            .foregroundColor(Color("customGreen"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Difficulty Selector
                    VStack(spacing: 20) {
                        
                        
                        HStack(spacing: 20) {
                            ForEach(difficulties, id: \.self) { level in
                                difficultyButton(for: level)
                            }
                        }
                        
                        Text("Select Difficulty")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    Spacer()
                    
                    // Start Game Button
                    NavigationLink(destination: GameView(difficulty: difficulty)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color("customGreen"), Color("customBlue")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 60)
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                            
                            Text("Start Game")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 45)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    private func difficultyButton(for level: String) -> some View {
        Button(action: {
            difficulty = level
        }) {
            ZStack {
                Circle()
                    .fill(
                        difficulty == level
                        ? AnyShapeStyle(LinearGradient(
                            gradient: Gradient(colors: [Color("customGreen"), Color("customBlue")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing))
                        : AnyShapeStyle(Color.white.opacity(0.3))
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                
                Text(level.prefix(1)) // First letter (E, M, H)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(difficulty == level ? .white : .white.opacity(0.8))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: difficulty)
    }
}

#Preview {
    SettingsView()
}


