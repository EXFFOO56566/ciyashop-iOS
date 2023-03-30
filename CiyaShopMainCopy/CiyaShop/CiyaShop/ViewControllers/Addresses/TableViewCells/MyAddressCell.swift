//
//  MyAddressCell.swift
//  CiyaShop
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MyAddressCell: UITableViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var imgAddressIcon: UIImageView!
    @IBOutlet weak var imgUserIcon: UIImageView!
    @IBOutlet weak var imgPhoneIcon: UIImageView!
    @IBOutlet weak var imgEmailIcon: UIImageView!
    
    @IBOutlet weak var imgPhoneTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vwContent: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblHeaderTitle.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblHeaderTitle.textColor = secondaryColor
        
        self.lblAddress.font = UIFont.appLightFontName(size: fontSize12)
        self.lblAddress.textColor = grayTextColor
        
        self.lblUserName.font = UIFont.appLightFontName(size: fontSize12)
        self.lblUserName.textColor = grayTextColor
        
        self.lblPhone.font = UIFont.appLightFontName(size: fontSize12)
        self.lblPhone.textColor = grayTextColor
        
        self.lblEmail.font = UIFont.appLightFontName(size: fontSize12)
        self.lblEmail.textColor = grayTextColor
        
        self.btnEdit.backgroundColor = .clear
        self.btnEdit.tintColor = grayTextColor
        self.btnEdit.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
        self.btnEdit.setTitle(getLocalizationString(key: "Edit"), for: .normal)
        
        self.btnRemove.backgroundColor = .clear
        self.btnRemove.tintColor = grayTextColor
        self.btnRemove.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
        self.btnRemove.setTitle(getLocalizationString(key: "Remove"), for: .normal)
        
        self.imgAddressIcon.tintColor = grayTextColor
        self.imgUserIcon.tintColor = grayTextColor
        self.imgPhoneIcon.tintColor = grayTextColor
        self.imgEmailIcon.tintColor = grayTextColor
        
    
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
    
    func setBillingAddress()  {
        
        self.lblAddress.text = dictLoginData["billing"]["address_1"].string! + " " + dictLoginData["billing"]["address_2"].string! + "," + dictLoginData["billing"]["city"].string! + " " + dictLoginData["billing"]["postcode"].string!
        self.lblUserName.text = dictLoginData["billing"]["first_name"].string! + " " + dictLoginData["billing"]["last_name"].string!

        self.lblPhone.text = "-"
        self.lblEmail.text = "-"
        
        if let billingPhone = dictLoginData["billing"]["phone"].string {
            if billingPhone != "" {
                self.lblPhone.text = billingPhone
            }
        }
        
        if let billingEmail = dictLoginData["billing"]["email"].string {
            self.lblEmail.text = billingEmail
        } else {
            self.lblEmail.text = "-"
        }
        
        self.lblPhone.isHidden = false
        self.imgPhoneIcon.isHidden = false
        self.imgPhoneTopConstraint.constant = 8
        self.imgPhoneIcon.image = UIImage(named: "phoneaddress-icon")
        
    }
    
    func setShippingAddress()  {
        self.lblAddress.text = dictLoginData["shipping"]["address_1"].string! + " " + dictLoginData["shipping"]["address_2"].string! + "," + dictLoginData["shipping"]["city"].string! + " " + dictLoginData["shipping"]["postcode"].string!
        self.lblUserName.text = dictLoginData["shipping"]["first_name"].string! + " " + dictLoginData["shipping"]["last_name"].string!
        
        self.lblPhone.text = "-"
        self.lblEmail.text = "-"
       
        if let shippingPhone = dictLoginData["shipping"]["phone"].string {
            if shippingPhone != "" {
                self.lblPhone.text = shippingPhone
            }
        }
                
        if let shippingEmail = dictLoginData["shipping"]["email"].string {
            if shippingEmail != "" {
                self.lblEmail.text = shippingEmail
            }
        }
         self.lblPhone.text = ""
        self.lblPhone.isHidden = true
        self.imgPhoneIcon.isHidden = true
        self.imgPhoneTopConstraint.constant = 0
        self.imgPhoneIcon.image = nil
    }
}
