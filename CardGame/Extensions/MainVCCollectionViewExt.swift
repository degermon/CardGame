//
//  MainVCCollectionViewExt.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-18.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolsForGame.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        configureCellDefaultState(cell: cell)
        cell.buttonAction = { [unowned self] in
            self.configureClickedCellState(cell: cell, for: indexPath)
        }
        
        return cell
    }
}
