//
//  Playerscores.swift
//  flagGuessingGame
//
//  Created by Megan Hastie on 29/04/2025.
//

import Foundation

struct PlayerScore: Identifiable, Codable{
    var id = UUID()
    let playerName: String
    var score: Int
}
