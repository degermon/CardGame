//
//  CardCollectionViewCell.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-05.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellButton: UIButton!
    
    var buttonAction : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
    // cell rounded section
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = true
        setBorder()
    }
    
    func setBorder(borderWidth: CGFloat = 1.0, borderColor: CGColor = UIColor.red.cgColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        buttonAction?()
    }
}
