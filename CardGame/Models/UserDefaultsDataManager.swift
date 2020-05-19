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
        defaults.set(difficulty, forKey: KeyKeeper.shared.USER_DEFAULTS_KEY_DIFFICULTY)
    }
    
    func saveSelectedSkin(skin: String) {
        defaults.set(skin, forKey: KeyKeeper.shared.USER_DEFAULTS_KEY_SELECTED_SKIN)
    }
    
    func getDifficultyFromDefaults() -> String {
        guard let difficulty = defaults.object(forKey: KeyKeeper.shared.USER_DEFAULTS_KEY_DIFFICULTY) as? String else {
            return ""
        }
        return difficulty
    }
    
    func getSkinFromDefaults() -> String {
        guard let skin = defaults.object(forKey: KeyKeeper.shared.USER_DEFAULTS_KEY_SELECTED_SKIN) as? String else {
            return ""
        }
        return skin
    }
    
    func saveDictionary(dict: Dictionary<String, Int>) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: true)
            defaults.set(encodedData, forKey: KeyKeeper.shared.USER_DEFAULTS_KEY_HIGHSCORE)
        } catch {
            print("Error in saving dictionary to User Defaults")
        }
    }
        
    func getHighScore() -> Dictionary<String, Int> {
        guard let data = defaults.object(forKey: KeyKeeper.shared.USER_DEFAULTS_KEY_HIGHSCORE) as? Data else {
            return ["Easy": 0, "Normal": 0, "Hard": 0] // default zeroes if no such entry exists in user defaults
        }

        let decodedDict = NSKeyedUnarchiver.unarchiveObject(with: data) as! Dictionary<String, Int>
        return decodedDict
    }
}
