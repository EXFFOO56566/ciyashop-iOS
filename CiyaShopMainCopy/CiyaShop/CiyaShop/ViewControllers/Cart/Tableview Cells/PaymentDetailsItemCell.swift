//
//  WishlistItemCell.swift
//  CiyaShop
//
//  Created by Apple on 01/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import SwiftyJSON

class PaymentDetailsItemCell: UITableViewCell {

    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblSubTotalValue: UILabel!
    
    @IBOutlet weak var lblTotalAmountTitle: UILabel!
    @IBOutlet weak var lblTotalAmountValue: UILabel!
    
    @IBOutlet weak var vwPaymentDetails: UIView!
    
    @IBOutlet weak var btnContinueCheckout: UIButton!
    var selectedCheckoutType = productCheckoutType.cart
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupCell()
        
        self.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell() {
       
        self.lblSubTotalTitle.font = UIFont.appRegularFontName(size: fontSize14)
        self.lblSubTotalTitle.text = getLocalizationString(key: "PriceRange")
        self.lblSubTotalTitle.textColor = grayTextColor//secondaryColor
        
        self.lblSubTotalValue.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblSubTotalValue.textColor = grayTextColor//secondaryColor

        self.lblTotalAmountTitle.font = UIFont.appRegularFontName(size: fontSize14)
        self.lblTotalAmountTitle.text = getLocalizationString(key: "AmountPayable")
        self.lblTotalAmountTitle.textColor = grayTextColor//secondaryColor
        
        self.lblTotalAmountValue.font = UIFont.appRegularFontName(size: fontSize14)
        self.lblTotalAmountValue.textColor = grayTextColor//secondaryColor
        
        
        self.vwPaymentDetails.layer.borderColor = UIColor.hexToColor(hex: "#E3E4E6").cgColor//UIColor.lightGray.cgColor
        self.vwPaymentDetails.layer.borderWidth = 0.5
        self.vwPaymentDetails.layer.cornerRadius = 5
        
        self.btnContinueCheckout.setTitle(getLocalizationString(key: "ContinueToCheckout"), for: .normal)
        self.btnContinueCheckout.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueCheckout.backgroundColor = secondaryColor
        self.btnContinueCheckout.setTitleColor(.white, for: .normal)
        self.btnContinueCheckout.layer.cornerRadius = self.btnContinueCheckout.frame.size.height/2
    }
    
    func setPaymentData(product : JSON) {
    
        self.layoutIfNeeded()
    }
    
    
    func setPaymentDetails() {
        
        var subTotal : Double = 0.00
        var shipping : Double = 0.00
        var totalAmount : Double = 0.00
        
        var arrayData : [JSON] = []
        
        if(selectedCheckoutType == .cart)
        {
            arrayData = arrCart
        }else{
            arrayData = arrBuyNow
        }
        
        for item in arrayData {
            subTotal = subTotal + Double(item["price"].floatValue).roundToDecimal() * Double(item["qty"].floatValue).roundToDecimal()
            shipping = 0.00 //shipping + Double(item["price"].floatValue).roundToDecimal()
        }
        totalAmount = subTotal + shipping
       
        lblSubTotalTitle.text = getLocalizationString(key: "PriceRange") + "   " + String(arrCart.count) + " " + getLocalizationString(key: "Items")
        
        if strCurrencySymbolPosition == "left" {
            self.lblSubTotalValue.text = strCurrencySymbol + convertCurrencyFormat(value: subTotal)// String(format: "%.*f",decimalPoints ,subTotal)
//            self.lblShippingValue.text = strCurrencySymbol + String(format: "%.*f",decimalPoints ,shipping)
            self.lblTotalAmountValue.text =  strCurrencySymbol + convertCurrencyFormat(value: totalAmount)

        } else if strCurrencySymbolPosition == "left_space" {
            self.lblSubTotalValue.text = strCurrencySymbol + " " + convertCurrencyFormat(value: subTotal)
//            self.lblShippingValue.text = strCurrencySymbol + " " + String(format: "%.*f",decimalPoints ,shipping)
            self.lblTotalAmountValue.text =  strCurrencySymbol + " " + convertCurrencyFormat(value: totalAmount)

        } else if strCurrencySymbolPosition == "right" {
            self.lblSubTotalValue.text = convertCurrencyFormat(value: subTotal) + strCurrencySymbol
//            self.lblShippingValue.text = String(format: "%.*f",decimalPoints ,shipping) + strCurrencySymbol
            self.lblTotalAmountValue.text = convertCurrencyFormat(value: totalAmount) + strCurrencySymbol

        } else if strCurrencySymbolPosition == "right_space" {
            self.lblSubTotalValue.text = convertCurrencyFormat(value: subTotal)  + " " + strCurrencySymbol
//            self.lblShippingValue.text = strCurrencySymbol + " " + String(format: "%.*f",decimalPoints ,shipping) + " " + strCurrencySymbol
            self.lblTotalAmountValue.text =  convertCurrencyFormat(value: totalAmount) + " " + strCurrencySymbol

        } else {
            self.lblSubTotalValue.text = strCurrencySymbol + " " + convertCurrencyFormat(value: subTotal)
//            self.lblShippingValue.text = strCurrencySymbol + " " + String(format: "%.*f",decimalPoints ,shipping)
            self.lblTotalAmountValue.text =  strCurrencySymbol + " " + convertCurrencyFormat(value: totalAmount)
        }
        
        
    }
    
}
