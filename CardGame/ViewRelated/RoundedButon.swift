//
//  RoundedButon.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-12.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class RoundedButon: UIButton { // simple button class with rounded corners
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.masksToBounds = true
    }
}
