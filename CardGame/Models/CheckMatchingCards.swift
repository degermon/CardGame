//
//  CheckMatchingCards.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-12.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class CheckMatchingCards {
    
    func checkForMatch(cardsSymbolArray: [String]) -> Bool {
        let firstCard = cardsSymbolArray[0]
        let count = cardsSymbolArray.count - 1
        
        for item in cardsSymbolArray[1...count] {
            if !firstCard.elementsEqual(item) {
                return false
            }
        }
        return true
    }
}
