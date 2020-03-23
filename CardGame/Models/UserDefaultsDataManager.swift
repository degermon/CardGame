//
//  UserDefaultsDataManager.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-23.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

class UserDefaultsDataManager {
    static let shared = UserDefaultsDataManager()
    private let defaults = UserDefaults.standard
    
    func saveDifficulty(difficulty: String) {
        defaults.set(difficulty, forKey: KeyKeeper.shared.difficultyKey)
    }
    
    func saveSelectedSkin(skin: String) {
        defaults.set(skin, forKey: KeyKeeper.shared.selectedSkinKey)
    }
    
    func getDifficultyFromDefaults() -> String {
        guard let difficulty = defaults.object(forKey: KeyKeeper.shared.difficultyKey) as? String else {
            return ""
        }
        return difficulty
    }
    
    func getSkinFromDefaults() -> String {
        guard let skin = defaults.object(forKey: KeyKeeper.shared.selectedSkinKey) as? String else {
            return ""
        }
        return skin
    }
}
