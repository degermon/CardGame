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
    
    private var gameDifficulty: String = "Easy" // Easy by default
    private let allGameDifficulties = ["Easy", "Normal", "Hard"]
    private var cardBackImage = UIImage(named: "tarrotCardBack") // first default value
    private let cardSkinNames = ["tarrotCardBack", "dragonCardBack", "violetCardBack", "linedCardBack"]
    
    func setDifficulty(difficulty: String) {
        gameDifficulty = difficulty
    }
    
    func setCardSkinFor(index: Int) {
        if index < cardSkinNames.count {
            cardBackImage = UIImage(named: cardSkinNames[index])
        }
    }
    
    func checkDifficulty() -> String {
        return gameDifficulty
    }
    
    func getAllGameDifficulties() -> [String] {
        return allGameDifficulties
    }
    
    func getCardBackImage() -> UIImage {
        return cardBackImage ?? UIImage()
    }
    
    func getCardSkinNames() -> [String] {
        return cardSkinNames
    }
}
