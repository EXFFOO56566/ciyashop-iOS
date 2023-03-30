//
//  UIView.swift
//  CiyaShop
//
//  Created by Apple on 12/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
    func setBackgroundColor() {
        self.backgroundColor = headerColor
    }
    
    func setPrimaryColor() {
        self.backgroundColor = primaryColor
    }
    
    func setSecondaryColor()  {
        self.backgroundColor = secondaryColor
    }

    func cornerRadius(radius:CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func viewBorder(borderWidth:CGFloat,borderColor:UIColor)
    {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }

    func roundTopLeftBottomRightCorners( radius: CGFloat) {
        
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundBottomLeftTopRightCorners(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func rotateView(degrees: CGFloat) {
        rotateRadians(radians: CGFloat.pi * degrees / 180.0)
    }

    func rotateRadians(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 8
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    
}


