//
//  GroupProductTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 20/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
class GroupProductTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var imgvwProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnBag: UIButton!

    //MARK:- variables
    var dictDetails = JSON()
    
    
    //MARK:- Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpUI()
    }
    //MARK:- Setup UI
    func setUpUI()
    {
        //---
        lblProductName.font = UIFont.appRegularFontName(size: fontSize12)
        lblProductName.textColor = grayTextColor
        
        //---
        lblPrice.font = UIFont.appBoldFontName(size: fontSize14)
        lblPrice.textColor = secondaryColor
        
        //--
        self.btnBag.setImage(UIImage(named: "bag-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)

        btnBag.tintColor = .black
        
    }
    func setUpProductData()
    {
        let imageUrl = dictDetails["app_thumbnail"].stringValue

        self.imgvwProduct.sd_setImage(with: imageUrl.encodeURL(), placeholderImage: UIImage(named: "placeholder"))
        
        lblProductName.text = dictDetails["name"].stringValue
        
        //--
        let priceValue = dictDetails["price_html"].stringValue.withoutHtmlString()
        if priceValue == "" {
           self.lblPrice.text = " "
        } else {
            self.lblPrice.setPriceForProductItem(str: dictDetails["price_html"].stringValue, isOnSale: dictDetails["on_sale"].boolValue, product: dictDetails)

        }
        
        //
        btnBag.isHidden = !dictDetails["purchasable"].boolValue
        
        btnBag.isHidden = false
        
        if dictDetails["type"].string == "external"  || dictDetails["type"].string == "grouped" || dictDetails["type"].string == "variable"{
            btnBag.isHidden = true
        } else if dictDetails["type"].string == "simple" {
            if isCatalogMode {
                btnBag.isHidden = true
            } else {
                
                btnBag.isHidden = false
                
                if let inStock = dictDetails["in_stock"].bool {
                    if inStock == true {
                        btnBag.isHidden = false
                    } else {
                        btnBag.isHidden = true
                    }
                } else {
                    btnBag.isHidden = true
                }
                
                if let price = dictDetails["price"].double {
                    if price == 0 {
                        btnBag.isHidden = true
                    } else {
                        btnBag.isHidden = false
                    }
                }
            }
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

