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

class ProductItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnAddtoCart: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var vwOffer: UIView!

    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        contentView.setBackgroundColor()
        self.topView.backgroundColor = .white
        self.topView.layer.borderWidth = 0.5
        self.topView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        self.bottomView.backgroundColor = .white
        self.bottomView.layer.borderWidth = 0.5
        self.bottomView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.lblProductName.font = UIFont.appRegularFontName(size: 14)
        self.lblProductName.textColor = grayTextColor//secondaryColor
        
        self.lblPrice.font = UIFont.appBoldFontName(size: fontSize14)
        
        self.btnFavourite.isSelected = false
        self.btnAddtoCart.isSelected = false
    
        self.btnFavourite.backgroundColor = .white
        self.btnFavourite.setImage(UIImage(named: "wishlist-line")?.maskWithColor(color: normalTextColor), for: .normal)
        self.btnFavourite.setImage(UIImage(named: "whishlist-fill")?.maskWithColor(color: secondaryColor), for: .selected)
        self.btnFavourite.layer.cornerRadius = self.btnFavourite.frame.size.height/2
        self.btnFavourite.layer.borderWidth = 0.5
        self.btnFavourite.layer.borderColor = UIColor.lightGray.cgColor
        
        self.btnAddtoCart.backgroundColor = secondaryColor
        self.btnAddtoCart.setImage(UIImage(named: "cart-icon"), for: .normal)
        self.btnAddtoCart.setImage(UIImage(named: "cart-icon"), for: .selected)
        self.btnAddtoCart.layer.cornerRadius = self.btnAddtoCart.frame.size.height/2
        self.btnAddtoCart.layer.borderWidth = 0.5
        self.btnAddtoCart.layer.borderColor = UIColor.lightGray.cgColor
        self.btnAddtoCart.tintColor = .white
        
        
        //---
        
        lblOffer.setUpOfferLabelUI()
        lblOffer.text = "30% " + getLocalizationString(key: "OFF").capitalized
        
        vwOffer.rotateView(degrees: 90)
        
        if(isRTL)
        {
            [lblProductName,lblPrice].forEach { (label) in
                label?.textAlignment = .right
            }
            
            ratingView.rotateView(degrees: 180)
        }
    }
    
    //MARK:- Set Data
    func setProductData(product : JSON) {
        
        if let productTitle = product["name"].string {
            self.lblProductName.text = productTitle
        } else if let productTitle = product["title"].string {
            self.lblProductName.text = productTitle
        } else {
            self.lblProductName.text = " "
        }
        
        
        let imageUrl = product["app_thumbnail"].string
        
//        DispatchQueue.global(qos: .userInitiated).async {
            self.imgProduct.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in
//                DispatchQueue.main.async {
                    if (image == nil) {
                        self.imgProduct.image =  UIImage(named: "noImage")
                    } else {
                        self.imgProduct.image =  image
                    }
//                }
            }
//        }
        
        
        let priceValue = product["price_html"].string!.withoutHtmlString()
        if priceValue == "" {
            self.lblPrice.text = " "
        } else {
//            self.lblPrice.setPriceForItem(product["price_html"].string!)
//            self.lblPrice.setPriceForProduct(str: product["price_html"].stringValue, isOnSale: product["on_sale"].boolValue,product:product)
            self.lblPrice.setPriceForProductItem(str: product["price_html"].stringValue, isOnSale: product["on_sale"].boolValue,product:product)
        }
        

        //----
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
       
        if isWishList {
            if checkItemExistsInWishlist(productId: product["id"].stringValue) {
                self.btnFavourite.isSelected = true
            } else {
                self.btnFavourite.isSelected = false
            }
        } else {
            self.btnFavourite.isSelected = false
            self.btnFavourite.isHidden = true
        }
        
        if isCatalogMode {
            self.btnAddtoCart.isHidden = true
        } else {
            if isAddtoCartEnabled {
                self.btnAddtoCart.isHidden = false
                
                if checkItemExistsInCart(product: product) {
                    if isRTL {
                        self.btnAddtoCart.setImage(UIImage.flipImage(img: UIImage(named: "select-icon")!), for: .selected)
                    } else {
                        self.btnAddtoCart.setImage(UIImage(named: "select-icon"), for: .selected)
                    }
                    self.btnAddtoCart.isSelected = true
                } else {
                    if isRTL {
                        self.btnAddtoCart.setImage(UIImage.flipImage(img: UIImage(named: "cart-icon")!), for: .selected)
                    } else {
                        self.btnAddtoCart.setImage(UIImage(named: "cart-icon"), for: .selected)
                    }
                    self.btnAddtoCart.isSelected = false
                }
                
                if let inStock = product["in_stock"].bool {
                    if inStock == true {
                        self.btnAddtoCart.backgroundColor = secondaryColor
                        self.btnAddtoCart.isUserInteractionEnabled = true
                    } else {
                        self.btnAddtoCart.isUserInteractionEnabled = false
                        self.btnAddtoCart.backgroundColor = .red
                        
                    }
                } else {
                    self.btnAddtoCart.isUserInteractionEnabled = false
                    self.btnAddtoCart.backgroundColor = .red
                }
                
                if let price = product["price"].double {
                    if price == 0 {
                        self.btnAddtoCart.isHidden = true
                    } else {
                        self.btnAddtoCart.isHidden = false
                    }
                }
                
            } else {
                self.btnAddtoCart.isHidden = true
            }
        }
    }
    
    
}
