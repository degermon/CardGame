//
//  KeyKeeper.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-23.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

class KeyKeeper {
    static let shared = KeyKeeper()
    let USER_DEFAULTS_KEY_DIFFICULTY = "difficultyKey"
    let USER_DEFAULTS_KEY_SELECTED_SKIN = "selectedSkinKey"
    let USER_DEFAULTS_KEY_HIGHSCORE = "highscoreKey"
}
