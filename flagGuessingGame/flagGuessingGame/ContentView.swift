//
//  ContentView.swift
//  flagGuessingGame
//
//  Created by Giacomo Grazia on 22/4/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View{
        NavigationView {
            ZStack {
                //add code for game background here
                VStack {
                    //game title - to be decided
                    Text("Example Title")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundColor(.green)
                        .shadow(radius: 10)
                        .padding(.top, 100)
                    
                    Spacer()
                    
                    //navigation buttons
                    HStack {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "play")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .scaledToFit()
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    ContentView()
}
