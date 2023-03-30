//
//  TopCategoryItemCell.swift
//  CiyaShop
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FeatureBoxItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imgFeature: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        
        self.bottomView.backgroundColor = .white
        self.bottomView.layer.borderWidth = 0.5
        self.bottomView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        self.topView.backgroundColor = .white
        self.topView.layer.borderWidth = 0.5
        self.topView.layer.borderColor = secondaryColor.cgColor
        
        self.innerView.layer.cornerRadius = self.innerView.frame.size.height/2
        self.innerView.backgroundColor = secondaryColor
        
        
        self.topView.layer.cornerRadius = self.topView.frame.size.height/2
        self.imgFeature.layer.cornerRadius = self.imgFeature.frame.size.height/2
        
        self.imgFeature.backgroundColor = secondaryColor
        
        self.lblTitle.font = UIFont.appRegularFontName(size: fontSize13)
        self.lblTitle.textColor = grayTextColor//secondaryColor
        
        self.lblContent.font = UIFont.appRegularFontName(size: fontSize11)
        self.lblContent.textColor = grayTextColor//secondaryColor.withAlphaComponent(0.7)
        
    }

}
