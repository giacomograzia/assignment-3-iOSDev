//
//  Country.swift
//  flagGuessingGame
//
//  Created by Giacomo Grazia on 29/4/2025.
//

import SwiftUI

struct Country: Codable, Identifiable {
    let id = UUID() // Needed for ForEach
    let emoji: String
    let countryName: String

    enum CodingKeys: String, CodingKey {
        case emoji
        case countryName = "Country_y"
    }
}
