//
//  MainVCAlertExt.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-30.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

extension MainViewController {
    func showEndgameAlert() {
        let alertController = UIAlertController(title: "Game over", message: "Your score \(GameScore.shared.getCurrentScoreFor(difficulty:  CardGameSettings.shared.checkDifficulty()))", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "New Game", style: .default, handler: { (_) in
            self.startNewGame()
        }))
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
