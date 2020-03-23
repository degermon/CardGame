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
    
    private var gameDifficulty: String = ""
    private let allGameDifficulties = ["Easy", "Normal", "Hard"]
    private var cardBackImage = UIImage()
    private let cardSkinNames = ["tarrotCardBack", "dragonCardBack", "violetCardBack", "linedCardBack"]
    
    func setDifficulty(difficulty: String) {
        gameDifficulty = difficulty
    }
    
    func setCardSkin(skin: String) {
        guard let image = UIImage(named: skin) else {
            return
        }
        cardBackImage = image
    }
    
    func checkDifficulty() -> String {
        return gameDifficulty
    }
    
    func getAllGameDifficulties() -> [String] {
        return allGameDifficulties
    }
    
    func getCardBackImage() -> UIImage {
        return cardBackImage
    }
    
    func getCardSkinNames() -> [String] {
        return cardSkinNames
    }
    
    func checkDefaults () { // read data from defaults
        let skin = UserDefaultsDataManager.shared.getSkinFromDefaults()
        if skin == "" {
            guard let first = cardSkinNames.first else {
                return
            }
            setCardSkin(skin: first)
        } else {
            setCardSkin(skin: skin)
        }
        
        let difficulty = UserDefaultsDataManager.shared.getDifficultyFromDefaults()
        if difficulty == "" {
            guard let first = allGameDifficulties.first else {
                return
            }
            setDifficulty(difficulty: first)
        } else {
            setDifficulty(difficulty: difficulty)
        }
    }
}
