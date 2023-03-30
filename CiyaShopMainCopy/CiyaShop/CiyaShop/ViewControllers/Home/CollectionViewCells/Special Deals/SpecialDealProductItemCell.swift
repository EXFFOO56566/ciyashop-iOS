//
//  TopCategoryItemCell.swift
//  CiyaShop
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON


class SpecialDealProductItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var vwOffer: UIView!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.rightView.backgroundColor = .white
        self.rightView.layer.borderWidth = 0.5
        self.rightView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.lblProductName.font = UIFont.appRegularFontName(size: fontSize13)
        self.lblProductName.textColor = grayTextColor//secondaryColor.withAlphaComponent(0.8)
        
        self.lblPrice.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblPrice.textColor = secondaryColor
        
        self.lblOffer.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblOffer.textColor = .white
        
        self.vwOffer.roundTopLeftBottomRightCorners(radius: 6)
        self.vwOffer.backgroundColor = secondaryColor
        
        self.layoutIfNeeded()
    }
    

    
    func setProductData(product : JSON) {
        
        if let productTitle = product["name"].string {
            self.lblProductName.text = productTitle
        } else if let productTitle = product["title"].string {
            self.lblProductName.text = productTitle
        } else {
            self.lblProductName.text = " "
        }
        
        
        let imageUrl = product["app_thumbnail"].string
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.imgProduct.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                DispatchQueue.main.async {
                    if (image == nil) {
                        self.imgProduct.image =  UIImage(named: "noImage")
                    } else {
                        self.imgProduct.image =  image
                    }
                }
            }
        }
        
        
        let priceValue = product["price_html"].string!.withoutHtmlString()
        if priceValue == "" {
            self.lblPrice.text = " "
        } else {
//            self.lblPrice.setPriceForItem(product["price_html"].string!)
            self.lblPrice.setPriceForProductItem(str: product["price_html"].stringValue, isOnSale: product["on_sale"].boolValue, product: product)

        }
    
        if product["rating"].exists() {
            if product["rating"].stringValue != "" {
                self.ratingView.rating = Double(product["rating"].stringValue)!
            } else {
                self.ratingView.rating = 0
            }
        } else {
            if product["average_rating"].exists() {
                if product["average_rating"].stringValue != "" {
                    self.ratingView.rating = Double(product["average_rating"].stringValue)!
                } else {
                    self.ratingView.rating = 0
                }
            } else {
                self.ratingView.rating = 0
            }
        }
        
        
        if product["on_sale"].exists() && product["on_sale"].bool == true {
            if product["sale_price"].exists() && product["regular_price"].exists() {
                
                if product["regular_price"].floatValue == product["sale_price"].floatValue {
                    self.vwOffer.isHidden = true
                } else {
                    let discount = product["regular_price"].floatValue - product["sale_price"].floatValue
                    let discountPercentage = discount * 100 / product["regular_price"].floatValue
                    var strDiscount = ""
                    
                    if fmod(discountPercentage, 1.0) == 0.0 {
                        strDiscount = String(format: "%d%% %@", Int(discountPercentage) ,getLocalizationString(key: "OFF"))
                        self.lblOffer.text = strDiscount
                    } else {
                        strDiscount = String(format: "%.2f%% %@", discountPercentage ,getLocalizationString(key: "OFF"))
                        self.lblOffer.text = strDiscount
                    }
                    self.vwOffer.isHidden = false
                }
            } else {
                self.vwOffer.isHidden = true
            }
        } else {
            self.vwOffer.isHidden = true
        }
       
    }
    
    
}
