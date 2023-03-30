//
//  NoAddressesCell.swift
//  CiyaShop
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class DownloadCell: UITableViewCell {

    @IBOutlet weak var vwContent: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblExpireTitle: UILabel!
    @IBOutlet weak var lblExpireValue: UILabel!
    @IBOutlet weak var lblRemainingTitle: UILabel!
    @IBOutlet weak var lblRemainingValue: UILabel!
    
    @IBOutlet weak var btnDownload: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblTitle.textColor = secondaryColor
        
        self.lblFileName.font = UIFont.appRegularFontName(size: fontSize12)
        self.lblFileName.textColor = grayTextColor
        
        self.lblExpireTitle.font = UIFont.appLightFontName(size: fontSize12)
        self.lblExpireTitle.textColor = grayTextColor
        self.lblExpireTitle.text = getLocalizationString(key: "Expire")
        
        self.lblExpireValue.font = UIFont.appLightFontName(size: fontSize12)
        self.lblExpireValue.textColor = grayTextColor
    
        self.lblRemainingTitle.font = UIFont.appLightFontName(size: fontSize12)
        self.lblRemainingTitle.textColor = grayTextColor
        self.lblRemainingTitle.text = getLocalizationString(key: "Remaining")
        
        self.lblRemainingValue.font = UIFont.appLightFontName(size: fontSize12)
        self.lblRemainingValue.textColor = grayTextColor
        
        self.btnDownload.backgroundColor = secondaryColor
        self.btnDownload.tintColor = secondaryColor
        
        vwContent.layer.borderColor = UIColor.gray.cgColor
        vwContent.layer.borderWidth = 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setProductData(product : JSON) {
        
        self.lblTitle.text = product["product_name"].string
        self.lblFileName.text = product["download_name"].string
        
        if product["downloads_remaining"].intValue != 0 {
            self.lblRemainingValue.text = String(format: "%d", product["downloads_remaining"].intValue)
        } else {
            self.lblRemainingValue.text = "-"
        }
        
        if product["access_expires"].string != "never" {
            self.lblExpireValue.text = String(format: "%d", product["downloads_remaining"].intValue)
            
            let expireDate = convertStringToDate(strDate: product["access_expires"].string!, formatter: "")
            
            if expireDate != nil {
                self.lblExpireValue.text =  convertDateToString(date: expireDate!, formatter: "dd-MM-yyyy")
            } else {
                self.lblExpireValue.text = ""
            }
            

        } else {
            self.lblExpireValue.text = "-"
        }

    }
}
