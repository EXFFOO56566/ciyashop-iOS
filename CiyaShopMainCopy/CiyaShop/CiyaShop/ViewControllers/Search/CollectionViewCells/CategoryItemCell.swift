//
//  TopCategoryItemCell.swift
//  CiyaShop
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CategoryItemCell: UICollectionViewCell {

    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = true;
                
        self.contentView.setNeedsLayout()
        self.layoutSubviews()
        self.layoutIfNeeded()
        
        lblCategory.font = UIFont.appRegularFontName(size: fontSize12)
        lblCategory.textColor = grayTextColor//secondaryColor
        imgCategory.layer.cornerRadius = (imgCategory.frame.size.width)/2
        
        vwContent.backgroundColor = .white//primaryColor
        
        vwContent.layer.borderWidth = 0.5
        vwContent.layer.borderColor = secondaryColor.withAlphaComponent(0.25).cgColor
        
    }

}
