//
//  CountryDataManager.swift
//  flagGuessingGame
//
//  Created by Giacomo Grazia on 29/4/2025.
//

import SwiftUI

class CountryDataManager {
    static func loadCountries() -> [Country] {
        guard let url = Bundle.main.url(forResource: "emoji_flags_data", withExtension: "json") else {
            print("❌ Failed to find emoji_flags_data.json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let countries = try JSONDecoder().decode([Country].self, from: data)
            return countries
        } catch {
            print("Error decoding countries: \(error)")
            return []
        }
    }
}
