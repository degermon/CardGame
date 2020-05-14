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
    private let colors = ["Easy": (#colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1).cgColor, #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor), "Normal": (#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor, #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor), "Hard": (#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor, #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor)]
    
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
    
    func getColorFor(difficulty: String) -> (CGColor, CGColor) {
        guard let colorsToReturn = colors[difficulty] else {
            return (#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor)
        }
        return colorsToReturn
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
