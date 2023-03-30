//
//  UIButton.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 25/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIButton
{
    func makeRoundButton()
    {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
        
    }
    func setUpThemeButtonUI()
    {
        self.tintColor =  secondaryColor
    }
}
