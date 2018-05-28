//
//  GradientView.swift
//  Chat-App
//
//  Created by Danny Bokati on 12/24/17.
//  Copyright © 2017 Gtech Developeres. All rights reserved.
//

import UIKit
@IBDesignable
class GradientView: UIView {

    @IBInspectable var topcolor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 1)
    @IBInspectable var bottomcolor: UIColor = #colorLiteral(red: 0.1725490196, green: 0.831372549, blue: 0.8470588235, alpha: 1)
 
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topcolor.cgColor, bottomcolor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }

}
