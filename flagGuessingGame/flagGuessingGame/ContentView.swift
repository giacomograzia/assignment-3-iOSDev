//
//  ContentView.swift
//  flagGuessingGame
//
//  Created by Giacomo Grazia on 22/4/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Color overlay for better contrast
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Title
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.ultraThinMaterial)
                            .frame(maxWidth: .infinity)
                            .frame(height: 110)
                            .padding(.horizontal, 40)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)

                        Text("Flag Quest")
                            .font(.system(size: 48, weight: .heavy, design: .rounded))
                            .foregroundColor(Color("customGreen"))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 50)


                    Spacer()
                    
                    // Play button
                    NavigationLink(destination: SettingsView()) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color("customGreen"), Color("customBlue")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 40, weight: .bold))
                        }
                    }
                    .padding(.bottom, 40)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
