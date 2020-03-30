//
//  MainVCAlertExt.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-30.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

extension MainViewController {
    func displayDifficultyAlert() {
        let alert = UIAlertController(title: "", message: "Choose your difficuly:", preferredStyle: .alert)
        
        for item in CardGameSettings.shared.getAllGameDifficulties() {
            alert.addAction(UIAlertAction(title: item, style: .default, handler: { (_) in
                CardGameSettings.shared.setDifficulty(difficulty: item)
                UserDefaultsDataManager.shared.saveDifficulty(difficulty: item)
                self.updateCards()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Last Played", style: .cancel, handler: { (_) in
        }))
        
        self.present(alert, animated: true)
    }
    
    func showEndgameAlert() {
        let alertController = UIAlertController(title: "Game over", message: "Your score \(GameScore.shared.getCurrentScoreFor(difficulty:  CardGameSettings.shared.checkDifficulty()))", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "New Game", style: .default, handler: { (_) in
            self.startNewGame()
        }))
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
