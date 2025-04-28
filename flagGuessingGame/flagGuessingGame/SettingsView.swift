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

struct SettingsView: View{
    
    //allows user to choose difficulty level of game
    @State private var difficulty = "Medium"
    let difficulties = ["Easy", "Medium", "Hard"]
    
        var body: some View {
            NavigationView {
                VStack {
                    //title
                    Text("Settings")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundColor(.green)
                        .padding(.top)
                        
                    
                    Spacer()
                   
                    //slider to pick difficulty
                    Text("Select Difficulty")
                        .font(.title3)
                        .padding(.bottom, 5)
                                    
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    Spacer()

                    //button to start the game, passes through the difficulty
                    NavigationLink(destination: GameView(difficulty: difficulty)) {
                        Text("Start Game")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.bottom)
                .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            }
        }
    }

#Preview {
    SettingsView()
}

