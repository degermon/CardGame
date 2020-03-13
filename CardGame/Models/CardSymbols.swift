//
//  CardSymbols.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-05.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

class CardSymbols {
    static let shared = CardSymbols()
    private var symbols = ["👺", "🤮", "🤑", "🎃", "🤒", "👀", "🧠", "🧑🏻‍🎤", "💧", "👿", "👽", "☠️", "🤡", "🧶", "🐸", "🌍"]
    
    func getSymbols(difficulty: String) -> [String] {
        switch difficulty {
        case "Easy":
            return symbolsForEasyGame()
        case "Normal":
            return symbolsForNormalGame()
        case "Hard":
            return symbolsForHardGame()
        default:
            return symbolsForEasyGame()
        }
    }
    
    private func symbolsForEasyGame() -> [String] {
        var symbolsForGame: [String] = Array(symbols.shuffled().prefix(8)) // get 8 symbol pairs for array
        symbolsForGame += symbolsForGame // make it double (pairs)
        return symbolsForGame.shuffled()
    }
    
    private func symbolsForNormalGame() -> [String] {
        var symbolsForGame: [String] = Array(symbols.shuffled().prefix(5)) // get 5 symbol for array
        symbolsForGame += symbolsForGame + symbolsForGame// make it triple (pairs)
        return symbolsForGame.shuffled()
    }
    
    private func symbolsForHardGame() -> [String] {
        var symbolsForGame: [String] = Array(symbols.shuffled().prefix(6)) // get 6 symbols for array
        symbolsForGame += symbolsForGame + symbolsForGame + symbolsForGame // make it quadruplet (pairs)
        return symbolsForGame.shuffled()
    }
}
