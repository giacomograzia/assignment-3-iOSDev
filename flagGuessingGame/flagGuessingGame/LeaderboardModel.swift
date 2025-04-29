//
//  LeaderboardModel.swift
//  flagGuessingGame
//
//  Created by Megan Hastie on 29/04/2025.
//

import Foundation
import UIKit
import SwiftUICore

class LeaderboardModel: ObservableObject{
   @State private var playerSores: [PlayerScore] = []
    var playerName: String = ""
    var score: Int = 0
}
