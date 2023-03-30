//
//  SizeColorCollectionViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 12/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SizeColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var imgProduct: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblName.textColor = secondaryColor
        lblName.font = UIFont.appRegularFontName(size: 12)
        imgSelect.tintColor = .white
        imgSelect.backgroundColor = secondaryColor.withAlphaComponent(0.35)
        
        vwBack.backgroundColor = .white
        vwBack.layer.borderWidth = 1
        vwBack.layer.borderColor = secondaryColor.cgColor
        
        imgSelect.isHidden = true
        imgProduct.isHidden = true
        lblName.isHidden = false
        
        vwBack.cornerRadius(radius: 3)
    }
    
    
}
