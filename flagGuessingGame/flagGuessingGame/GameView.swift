//
//  GameView 2.swift
//  flagGuessingGame
//
//  Created by Giacomo Grazia on 29/4/2025.
//


import SwiftUI

struct GameView: View {
    let difficulty: String // comes from SettingsView
    @State private var countries: [Country] = []
    @State private var correctCountry: Country?
    @State private var options: [Country] = []
    
    @State private var showFeedback = false
    @State private var feedbackText = ""
    @State private var feedbackColor = Color.green
    @State private var showCountryName = false
    @State private var selectedCountryName = ""

    
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
            // Background same as ContentView
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


            VStack(spacing: 30) {
                Spacer()
                
                // Flag
                if let flag = correctCountry?.emoji {
                    VStack(spacing: 12) {
                        Text(flag)
                            .font(.system(size: 120))
                            .shadow(radius: 10)
                        
                        if showCountryName {
                            Text(selectedCountryName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(feedbackColor)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 40)
                }

                
                Spacer()
                
                // Options
                VStack(spacing: 20) {
                    let columns: [GridItem] = {
                        switch numberOfOptions {
                        case 2:
                            return Array(repeating: GridItem(.flexible(), spacing: 20), count: 2) // 2 columns
                        case 4:
                            return Array(repeating: GridItem(.flexible(), spacing: 20), count: 2) // 2 columns
                        case 6:
                            return Array(repeating: GridItem(.flexible(), spacing: 20), count: 2) // 3 columns
                        default:
                            return Array(repeating: GridItem(.flexible(), spacing: 20), count: 2) // default to 2
                        }
                    }()
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(options, id: \.id) { country in
                            Button(action: {
                                countryTapped(country)
                            }) {
                                Text(country.countryName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(LinearGradient(
                                        gradient: Gradient(colors: [Color("customGreen"), Color("customBlue")]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
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
        }
    }
    
    private func countryTapped(_ selected: Country) {
        selectedCountryName = correctCountry?.countryName ?? ""
        showCountryName = true
        
        if selected.countryName == correctCountry?.countryName {
            feedbackText = "Correct"
            feedbackColor = Color("customGreen") // use your custom color!
        } else {
            feedbackText = "Wrong"
            feedbackColor = Color.red
        }

        
        showFeedback = true
        
        // After a short delay, start a new round
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            loadNewRound()
            showFeedback = false
            showCountryName = false
        }
    }

}

#Preview {
    GameView(difficulty: "3")
}
