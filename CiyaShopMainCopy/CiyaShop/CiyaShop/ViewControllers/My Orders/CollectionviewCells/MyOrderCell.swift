//
//  MyOrderCell.swift
//  CiyaShop
//
//  Created by Apple on 30/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON


class MyOrderCell: UICollectionViewCell {

    @IBOutlet weak var vwContent: UIView!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblOrderIdTitle: UILabel!
    @IBOutlet weak var lblOrderIdValue: UILabel!
    
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var lblTotalAmountTitle: UILabel!
    @IBOutlet weak var lblTotalAmountValue: UILabel!
    
    @IBOutlet weak var lblQuantityTitle: UILabel!
    @IBOutlet weak var lblQuantityValue: UILabel!
    
    @IBOutlet weak var lblOrderMessage: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var btnRetry: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vwContent.layer.borderColor = UIColor.hexToColor(hex: "#E3E4E6").cgColor//UIColor.lightGray.cgColor
        vwContent.layer.borderWidth = 0.5
        vwContent.layer.cornerRadius = 5
        
        self.lblOrderIdTitle.font = UIFont.appLightFontName(size: fontSize12)
        self.lblOrderIdTitle.text = getLocalizationString(key: "OrderId")
        self.lblOrderIdTitle.textColor = grayTextColor
        
        self.lblOrderIdValue.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblOrderIdValue.textColor = secondaryColor
        
        self.lblOrderDate.font = UIFont.appLightFontName(size: fontSize12)
        self.lblOrderDate.textColor = grayTextColor
        
        self.lblProductName.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblProductName.textColor = secondaryColor
        
        self.lblTotalAmountTitle.font = UIFont.appLightFontName(size: fontSize12)
        self.lblTotalAmountTitle.text = getLocalizationString(key: "TotalAmount")
        self.lblTotalAmountTitle.textColor = grayTextColor
        
        self.lblTotalAmountValue.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblTotalAmountValue.textColor = secondaryColor
        
        self.lblQuantityTitle.font = UIFont.appLightFontName(size: fontSize12)
        self.lblQuantityTitle.text = getLocalizationString(key: "Quantity")
        self.lblQuantityTitle.textColor = grayTextColor
        
        self.lblQuantityValue.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblQuantityValue.textColor = secondaryColor
        
        self.lblOrderMessage.font = UIFont.appLightFontName(size: fontSize12)
        self.lblOrderMessage.textColor = grayTextColor
        
        self.lblOrderStatus.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblOrderStatus.textColor = secondaryColor
        
        self.btnDetails.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
        self.btnDetails.backgroundColor = secondaryColor
        self.btnDetails.setTitle(getLocalizationString(key: "Details"), for: .normal)
        self.btnDetails.layer.cornerRadius = self.btnDetails.frame.size.height / 2
        
        self.btnRetry.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
        self.btnRetry.backgroundColor = secondaryColor.withAlphaComponent(0.7)
        self.btnRetry.setTitle(getLocalizationString(key: "Retry"), for: .normal)
        self.btnRetry.layer.cornerRadius = self.btnDetails.frame.size.height / 2
        
    }

    func setProductData(orderDetail : JSON) {
        
        if let arrItems = orderDetail["line_items"].array {
            var strProductName = ""
            for item in arrItems {
                let strItem = item["name"].stringValue
                if arrItems.first == item {
                    strProductName = String(format: "%@", strItem)
                } else {
                    strProductName = String(format: "%@ & %@", strProductName , strItem)
                }
            }
            self.lblProductName.text = strProductName
        }
        
        let imageUrl = orderDetail["line_items"][0]["product_image"].string
 
        self.imgProduct.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in

            if (image == nil) {
                self.imgProduct.image =  UIImage(named: "noImage")
            } else {
                self.imgProduct.image =  image
            }

        }
        
        self.lblOrderStatus.text = orderDetail["status"].string?.uppercased()
        
        let createdDate = convertStringToDate(strDate: orderDetail["date_created_gmt"].string!, formatter: "")
        if createdDate != nil {
            self.lblOrderDate.text = convertDateToString(date: createdDate!, formatter: "MMM dd, yyyy")
        } else {
            self.lblOrderDate.text = ""
        }
        
        self.lblQuantityValue.text = "\(orderDetail["line_items"].arrayValue.count)"
        self.lblTotalAmountValue.text =  strCurrencySymbol + " " + orderDetail["total"].string!
        self.lblOrderIdValue.text = "#" + orderDetail["id"].stringValue
     
        if orderDetail["status"].string == "any" {
            self.lblOrderMessage.text = getLocalizationString(key: "DeliveredSoon")
            self.lblOrderStatus.textColor = secondaryColor
        } else if orderDetail["status"].string == "pending" {
            self.lblOrderMessage.text = getLocalizationString(key: "OrderPendingState")
            self.lblOrderStatus.textColor = secondaryColor
        } else if orderDetail["status"].string == "processing" {
            self.lblOrderMessage.text = getLocalizationString(key: "OrderUnderProcessing")
            self.lblOrderStatus.textColor = secondaryColor
        }  else if orderDetail["status"].string == "on-hold" {
            self.lblOrderMessage.text = getLocalizationString(key: "OrderOnHold")
            self.lblOrderStatus.textColor = secondaryColor
        } else if orderDetail["status"].string == "completed" {
            
            let completedDate = convertStringToDate(strDate: orderDetail["date_completed"].string!, formatter: "")
            if completedDate != nil {
                self.lblOrderMessage.text =  getLocalizationString(key: "DeliveredOn")  + " " + convertDateToString(date:completedDate!,formatter: "MMM dd, yyyy HH:mm")
            } else {
                self.lblOrderMessage.text =  getLocalizationString(key: "DeliveredOn")  + " "
            }

            self.lblOrderStatus.textColor = .green
        } else if orderDetail["status"].string == "cancelled" {
            self.lblOrderMessage.text = getLocalizationString(key: "OrderCancelled")
            self.lblOrderStatus.textColor = .red
        } else if orderDetail["status"].string == "refunded" {
            self.lblOrderMessage.text = getLocalizationString(key: "RefundedOrder")
            self.lblOrderStatus.textColor = .red
        } else if orderDetail["status"].string == "failed" {
            self.lblOrderMessage.text = getLocalizationString(key: "OrderFailed")
            self.lblOrderStatus.textColor = .red
        } else if orderDetail["status"].string == "shipping" {
            self.lblOrderMessage.text = getLocalizationString(key: "DeliverSoon")
            self.lblOrderStatus.textColor = secondaryColor
        }
        
        self.btnRetry.isHidden = true
        if let orderRepayment = orderDetail["orderRepaymentUrl"].string {
            if orderRepayment != "" {
                self.btnRetry.isHidden = false
            }
        }
       
    }
    
}
