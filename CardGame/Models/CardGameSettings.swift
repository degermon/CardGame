//
//  CardGameSettings.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-06.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class CardGameSettings {
    static let shared = CardGameSettings()
    
    private var gameDifficulty: Bool = false // false - easy, true - hard
    private var cardBackImage = UIImage(named: "tarrotCardBack") // first default value
    
    func setDifficulty(difficulty: Bool) {
        gameDifficulty = difficulty
    }
    
    func checkDifficulty() -> Bool {
        return gameDifficulty
    }
    
    func getCardBackImage() -> UIImage {
        return cardBackImage ?? UIImage()
    }
}
