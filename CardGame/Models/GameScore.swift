//
//  GameScore.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-13.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

class GameScore {
    
    static let shared = GameScore()
    private var scoreDictionary: [String: Int] = ["Easy": 0, "Normal": 0, "Hard": 0]
    
    func updateScoreFor(difficulty: String, by result: Bool) {
        guard let score = scoreDictionary[difficulty] else { return }

        if result == true {
            scoreDictionary[difficulty] = score + 3
        } else {
            scoreDictionary[difficulty] = score - 1
        }
    }
    
    func clearScore() {
        for key in scoreDictionary.keys { scoreDictionary[key] = 0 }
    }
    
    func getCurrentScoreFor(difficulty: String) -> Int {
        guard let score = scoreDictionary[difficulty] else { return 0 }
        
        if score < 0 {
            return 0
        } else {
            return score
        }
    }
}
