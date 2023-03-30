//
//  UserProfileCell.swift
//  CiyaShop
//
//  Created by Apple on 06/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblWalletBalance: UILabel!

    @IBOutlet weak var btnEditProfileImage: UIButton!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var constraintHeightWalletBalance: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnEditProfileImage.layer.cornerRadius = self.btnEditProfileImage.frame.size.height / 2
        self.imgEdit.layer.cornerRadius = self.imgEdit.frame.size.height / 2
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height / 2
        
        self.lblName.textColor = secondaryColor
        self.lblPhone.textColor = secondaryColor
        self.lblEmail.textColor = secondaryColor
        self.lblWalletBalance.textColor = secondaryColor

        self.lblName.font = UIFont.appLightFontName(size: fontSize12)
        self.lblPhone.font = UIFont.appLightFontName(size: fontSize12)
        self.lblEmail.font = UIFont.appLightFontName(size: fontSize12)
        self.lblWalletBalance.font = UIFont.appLightFontName(size: fontSize12)

        imgEdit.tintColor = primaryColor
        imgEdit.backgroundColor = secondaryColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
