//
//  CardCollectionViewCell.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-05.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
    // cell rounded section
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.masksToBounds = true
    }
}
