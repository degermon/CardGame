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
            let skin = CardGameSettings.shared.getCardSkinNames()[indexPath.item]
            UserDefaultsDataManager.shared.saveSelectedSkin(skin: skin)
            CardGameSettings.shared.setCardSkin(skin: skin)
            self.delegate?.updateCards()
            self.skinSelected(cell: cell) // select new
        }
                
        configureCellDefaultState(cell: cell, skinName: CardGameSettings.shared.getCardSkinNames()[indexPath.item])
        
        return cell
    }
}
