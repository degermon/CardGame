//
//  FirstVCAlertExt.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-05-12.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

extension FirstViewController {
    
    func displayDifficultyAlert() {
        let alert = UIAlertController(title: "", message: "Choose your difficuly:", preferredStyle: .alert)
        
        for item in CardGameSettings.shared.getAllGameDifficulties() {
            alert.addAction(UIAlertAction(title: item, style: .default, handler: { (_) in
                CardGameSettings.shared.setDifficulty(difficulty: item)
                UserDefaultsDataManager.shared.saveDifficulty(difficulty: item)
                self.difficultySelected()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Last Played", style: .cancel, handler: { (_) in
            // Do not change difficulty, leave current (saved) one
            self.difficultySelected()
        }))
        
        self.present(alert, animated: true)
    }
}
