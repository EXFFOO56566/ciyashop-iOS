//
//  TopCategoryItemCell.swift
//  CiyaShop
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CategoryBannerItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnShopNow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = true;
        
        self.layoutIfNeeded()
        
        self.lblCategory.font = UIFont.appBoldFontName(size: fontSize13)
        self.lblCategory.textColor = .white
        
        self.btnShopNow.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
        self.btnShopNow.backgroundColor = secondaryColor
        self.btnShopNow.setTitle(getLocalizationString(key: "shopNow"), for: .normal)
        self.btnShopNow.setTitleColor(.white, for: .normal)
        self.btnShopNow.layer.cornerRadius = self.btnShopNow.frame.size.height/2
        
    }

}
