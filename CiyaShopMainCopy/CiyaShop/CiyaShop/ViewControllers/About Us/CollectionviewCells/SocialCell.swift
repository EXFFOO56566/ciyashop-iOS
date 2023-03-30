//
//  SocialCell.swift
//  CiyaShop
//
//  Created by Apple on 10/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SocialCell: UICollectionViewCell {
    
    @IBOutlet weak var imgSocialLogo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgSocialLogo.tintColor = secondaryColor
        
    }

}
