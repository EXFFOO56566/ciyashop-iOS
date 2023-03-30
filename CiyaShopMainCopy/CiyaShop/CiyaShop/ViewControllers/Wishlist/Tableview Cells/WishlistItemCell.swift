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

class WishlistItemCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMovetoCart: UIButton!
    
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
        self.lblProductName.textColor = grayTextColor
        
        self.lblPrice.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblPrice.textColor = secondaryColor
        
        self.btnDelete.backgroundColor = .clear
        self.btnDelete.tintColor = .red
        self.btnDelete.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        self.btnDelete.setTitle(getLocalizationString(key: "Remove"), for: .normal)
        
        self.btnMovetoCart.backgroundColor = .clear
        self.btnMovetoCart.tintColor = normalTextColor
        self.btnMovetoCart.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        self.btnMovetoCart.setTitle(getLocalizationString(key: "MovetoBag"), for: .normal)
        self.btnMovetoCart.setTitleColor(normalTextColor, for: .normal)
        
        if isRTL {
            
            btnDelete.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            btnMovetoCart.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            btnDelete.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            btnMovetoCart.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            
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
        
        if let inStock = product["in_stock"].bool {
            if inStock == true {
                btnMovetoCart.setTitle(getLocalizationString(key: "MovetoBag"), for: .normal)
            } else {
                btnMovetoCart.setTitle(getLocalizationString(key: "OutOfStock"), for: .normal)
            }
        }
        
        if isCatalogMode {
            self.btnMovetoCart.isHidden = true
        } else {
            self.btnMovetoCart.isHidden = false
        }
        
                
        self.layoutIfNeeded()
    }
}
