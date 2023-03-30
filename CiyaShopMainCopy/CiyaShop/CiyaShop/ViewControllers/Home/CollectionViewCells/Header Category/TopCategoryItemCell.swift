//
//  TopCategoryItemCell.swift
//  CiyaShop
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class TopCategoryItemCell: UICollectionViewCell {

    
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = true;
        
        self.contentView.setNeedsLayout()
        self.layoutIfNeeded()
        
        lblCategory.font = UIFont.appRegularFontName(size: fontSize11)
        lblCategory.textColor = secondaryColor
        imgCategory.layer.cornerRadius = (imgCategory.frame.size.width)/2
        
        
    }

}
