//
//  File.swift
//  CiyaShop
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

public class GradientView: UIView {
    private var gradientLayer: CAGradientLayer?
    var colors : [CGColor]?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard gradientLayer == nil else {
            gradientLayer?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            return
        }

        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradientLayer!.colors = colors
        gradientLayer!.locations = [0, 1]
        gradientLayer!.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer!.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer!, at: 0)
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: 24, height: 24))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
    }
}

