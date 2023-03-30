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

class CartItemCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblVariation: UILabel!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var btnPlusQty: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var btnMinusQty: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    
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
        self.rightView.backgroundColor = .white
        self.rightView.layer.borderWidth = 0.5
        self.rightView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        self.lblProductName.font = UIFont.appRegularFontName(size: fontSize13)
        self.lblProductName.textColor = grayTextColor//secondaryColor.withAlphaComponent(0.8)
        
        self.lblPrice.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblPrice.textColor = grayTextColor//secondaryColor
        
        self.lblVariation.font = UIFont.appRegularFontName(size: fontSize12)
        self.lblVariation.textColor = secondaryColor
        
        
        self.btnDelete.backgroundColor = .clear
        self.btnDelete.tintColor = .red
        self.btnDelete.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        self.btnDelete.setTitle(getLocalizationString(key: "Delete"), for: .normal)
        self.btnDelete.sizeToFit()
        
        self.btnPlusQty.backgroundColor = secondaryColor
        self.btnPlusQty.tintColor = .white
        self.btnPlusQty.layer.cornerRadius = self.btnPlusQty.frame.size.height / 2
        
        self.lblQty.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblQty.textColor = grayTextColor//secondaryColor
        
        self.btnMinusQty.backgroundColor = secondaryColor
        self.btnMinusQty.tintColor = .white
        self.btnMinusQty.layer.cornerRadius = self.btnMinusQty.frame.size.height / 2
        
        if isRTL {
            
            btnDelete.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            btnDelete.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
            
        }
        
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
        
       
        
        if product["qty"].exists() {
            self.lblQty.text = product["qty"].stringValue
        } else {
            self.lblQty.text = "1"
        }
        
        if product["sold_individually"].boolValue {
            self.btnPlusQty.isUserInteractionEnabled = false
            self.btnMinusQty.isUserInteractionEnabled = false
        } else {
            self.btnPlusQty.isUserInteractionEnabled = true
            self.btnMinusQty.isUserInteractionEnabled = true
        }
        lblVariation.isHidden = true
        if product["type"].string == "variable" {
            if product["variation_id"].exists() {
                if product["variations"].exists() {
                    lblVariation.isHidden = false
                    var strVariation = ""
                    var arrKeys = [String]()
                    arrKeys.append(contentsOf: product["variations"].dictionary!.keys)
                    
                    for i in 0...arrKeys.count - 1 {
                        let key = arrKeys[i]
                        if i == 0 {
                            strVariation = String(format: "%@ : %@", arrKeys[i],product["variations"][key].stringValue)
                        } else {
                            strVariation = String(format: "%@, %@ : %@", strVariation,arrKeys[i],product["variations"][key].stringValue)
                        }
                    }
                    lblVariation.text = strVariation
                }
            }
        }
        
                
        self.layoutIfNeeded()
    }
}
