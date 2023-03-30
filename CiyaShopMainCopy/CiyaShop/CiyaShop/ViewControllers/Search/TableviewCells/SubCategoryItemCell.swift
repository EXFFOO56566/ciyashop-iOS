//
//  SubCategoryItemCell.swift
//  CiyaShop
//
//  Created by Apple on 09/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubCategoryItemCell: UITableViewCell {

    
    @IBOutlet weak var lblSubcategory: UILabel!
    @IBOutlet weak var imgSubcategory: UIImageView!
    @IBOutlet weak var imgRightArrow: UIImageView!
    
    @IBOutlet weak var vwSeparatorLine: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        contentView.setBackgroundColor()
        
        lblSubcategory.font = UIFont.appRegularFontName(size: fontSize12)
        lblSubcategory.textColor = secondaryColor
        
        imgRightArrow.tintColor = secondaryColor
        
        vwSeparatorLine.backgroundColor = secondaryColor.withAlphaComponent(0.5)
    }
    
    func setSubcategory(subCategory : JSON) {
        let imageUrl = subCategory["image"]["src"].stringValue
        
        if imageUrl == "" {
            imgSubcategory.image =  UIImage()
            imgSubcategory.backgroundColor = secondaryColor
        } else {
            //        DispatchQueue.global(qos: .userInitiated).async {
            imgSubcategory.sd_setImage(with: imageUrl.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                //                DispatchQueue.main.async {
                if (image == nil) {
                    self.imgSubcategory.image =  UIImage()
                    self.imgSubcategory.backgroundColor = secondaryColor
                } else {
                    self.imgSubcategory.image =  image
                    self.imgSubcategory.backgroundColor = .clear
                }
                //                }
                //            }
            }
        }
        
        if let productTitle = subCategory["name"].string {
            lblSubcategory.text = productTitle
        } else {
            lblSubcategory.text = " "
        }
    }
    
}
