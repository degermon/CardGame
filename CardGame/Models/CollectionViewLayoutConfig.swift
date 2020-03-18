//
//  CollectionViewLayoutConfig.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-06.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class CollectionViewLayoutConfig { // simply took out part of code from MainViewController to a seperate file/class
    
    private var size: CGFloat?
    
    func configureLayout(for view: UICollectionView, itemPerRow: CGFloat, lineSpacing: CGFloat, interItemSpacing: CGFloat) {
        
        let width = (view.frame.width - (itemPerRow - 1) * interItemSpacing) / itemPerRow
        let height = 1.5 * width
        size = width - 10
        
        let viewFlowLayout = UICollectionViewFlowLayout()
        
        viewFlowLayout.itemSize = CGSize(width: width, height: height)
        viewFlowLayout.sectionInset = .zero
        viewFlowLayout.minimumLineSpacing = lineSpacing
        viewFlowLayout.minimumInteritemSpacing = interItemSpacing
        
        view.setCollectionViewLayout(viewFlowLayout, animated: true)
    }
    
    func getSize() -> CGFloat {
        guard let size = size else { return 0.0 }
        return size
    }
}
