//
//  NoAddressesCell.swift
//  CiyaShop
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class NoAddressesCell: UITableViewCell {

    @IBOutlet weak var vwContent: UIView!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblPleaseAddAddress: UILabel!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblHeaderTitle.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblHeaderTitle.textColor = secondaryColor
        
        self.lblPleaseAddAddress.font = UIFont.appLightFontName(size: fontSize12)
        self.lblPleaseAddAddress.textColor = grayTextColor
        self.lblPleaseAddAddress.text = getLocalizationString(key: "PleaseAddAddress")
        
        self.btnAdd.backgroundColor = .clear
        self.btnAdd.tintColor = grayTextColor
        self.btnAdd.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
        self.btnAdd.setTitle(getLocalizationString(key: "Add"), for: .normal)
        
        vwContent.layer.borderColor = UIColor.gray.cgColor
        vwContent.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setHeaderTitle(indexPath : IndexPath)  {
        
        if indexPath.row == 0  {
            self.lblHeaderTitle.text = getLocalizationString(key: "BillingAddress")
        } else {
            self.lblHeaderTitle.text = getLocalizationString(key: "ShippingAddress")
        }
    }
    
}
