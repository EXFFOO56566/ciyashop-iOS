//
//  CouponCell.swift
//  CiyaShop
//
//  Created by Apple on 01/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponCell: UICollectionViewCell {

    
    @IBOutlet weak var vwContent: GradientView!
    @IBOutlet weak var lblScratchHere: UILabel!
    
    @IBOutlet weak var lblCouponCode: UILabel!
    @IBOutlet weak var lblCouponCodeValue: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblScratchHere.font = UIFont.appRegularFontName(size: fontSize12)
        self.lblScratchHere.text = getLocalizationString(key: "ScratchHereCouponCode")
        self.lblScratchHere.textColor = primaryColor
        
        self.lblCouponCode.font = UIFont.appRegularFontName(size: fontSize14)
        self.lblCouponCode.text = getLocalizationString(key: "CouponCode")
        self.lblCouponCode.textColor = primaryColor
        
        self.lblCouponCodeValue.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblCouponCodeValue.textColor = primaryColor
        
        self.lblDescription.font = UIFont.appRegularFontName(size: fontSize12)
        self.lblDescription.textColor = primaryColor
    }
    

    func setBackground(color : UIColor) {
        self.vwContent.backgroundColor = color
    }
    
    
    func setCouponDetails(couponDetail : JSON) {
        
        if couponDetail["is_coupon_scratched"] == "no" {
            lblScratchHere.isHidden = false
            
            lblCouponCode.isHidden = true
            lblCouponCodeValue.isHidden = true
            lblDescription.isHidden = true
        } else {
            lblScratchHere.isHidden = true
            
            lblCouponCode.isHidden = false
            lblCouponCodeValue.isHidden = false
            lblDescription.isHidden = false
            
            lblCouponCodeValue.text = couponDetail["code"].string?.uppercased()
            lblDescription.text = couponDetail["description"].string
        }
        
    }

}
