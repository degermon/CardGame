//
//  SettingsVCCollectionViewExt.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-18.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CardGameSettings.shared.getCardSkinNames().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.buttonAction = { [unowned self] in
            CardGameSettings.shared.setCardSkinFor(index: indexPath.item)
            self.delegate?.updateCards()
        }
                
        configureCellDefaultState(cell: cell, skinName: CardGameSettings.shared.getCardSkinNames()[indexPath.item])
        
        return cell
    }
}
