//
//  NoAddressesCell.swift
//  CiyaShop
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrdersItemCell: UITableViewCell {

    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var lblTotalAmountTitle: UILabel!
    @IBOutlet weak var lblTotalAmountValue: UILabel!
    
    @IBOutlet weak var lblQuantityTitle: UILabel!
    @IBOutlet weak var lblQuantityValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        self.lblProductName.font = UIFont.appBoldFontName(size: fontSize11)
        self.lblProductName.textColor = secondaryColor
        
        self.lblTotalAmountTitle.font = UIFont.appLightFontName(size: fontSize11)
        self.lblTotalAmountTitle.text = getLocalizationString(key: "ProductPrice")
        self.lblTotalAmountTitle.textColor = grayTextColor
        
        self.lblTotalAmountValue.font = UIFont.appRegularFontName(size: fontSize11)
        self.lblTotalAmountValue.textColor = secondaryColor
        
        self.lblQuantityTitle.font = UIFont.appLightFontName(size: fontSize11)
        self.lblQuantityTitle.text = getLocalizationString(key: "Quantity")
        self.lblQuantityTitle.textColor = grayTextColor
        
        self.lblQuantityValue.font = UIFont.appRegularFontName(size: fontSize11)
        self.lblQuantityValue.textColor = secondaryColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupData(item : JSON) {
        
        self.lblProductName.text = item["name"].stringValue
        self.lblTotalAmountValue.text =  strCurrencySymbol + " " + String(format: "%.*f",decimalPoints ,item["price"].doubleValue) + " X " + item["quantity"].stringValue + " = " +  strCurrencySymbol + " " + String(format: "%.*f",decimalPoints ,item["subtotal"].doubleValue)
        self.lblQuantityValue.text = item["quantity"].stringValue
    }

}
