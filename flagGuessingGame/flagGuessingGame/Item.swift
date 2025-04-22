//
//  Item.swift
//  flagGuessingGame
//
//  Created by Giacomo Grazia on 22/4/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
