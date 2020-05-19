//
//  BackgroundGradient.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-05-14.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class BackgroundGradient {
    
    private let gradientLayer = CAGradientLayer()

    //set a gradient background with two colors
    func setBackground(for view: UIView, color1: CGColor, color2: CGColor, animate: Bool) {
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1, color2]
        gradientLayer.shouldRasterize = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
        
        // add the gradient to the view
        view.layer.insertSublayer(gradientLayer, at: 0)
           
        if animate {
            animateBackground(gradientLayer: gradientLayer)
        }
    }
       
    private func animateBackground(gradientLayer: CAGradientLayer) {
        gradientLayer.locations =  [0.0, 1.0]

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.25]
        animation.toValue = [0.75, 1.0]
        animation.duration = 4.0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        // add the animation to the gradient
        gradientLayer.add(animation, forKey: nil)
    }
}
