//
//  TopCategoryItemCell.swift
//  CiyaShop
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Cosmos

class ProductItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnAddtoCart: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.topView.backgroundColor = .white
        self.topView.layer.borderWidth = 0.5
        self.topView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        self.bottomView.backgroundColor = .white
        self.bottomView.layer.borderWidth = 0.5
        self.bottomView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.lblProductName.font = UIFont.appRegularFontName(size: fontSize13)
        self.lblProductName.textColor = secondaryColor.withAlphaComponent(0.8)
        
        self.lblPrice.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblPrice.textColor = secondaryColor
        
        self.btnFavourite.isSelected = false
        self.btnAddtoCart.isSelected = false
    
        self.btnFavourite.backgroundColor = primaryColor
        self.btnFavourite.setImage(UIImage(named: "wishlist-icon"), for: .normal)
        self.btnFavourite.setImage(UIImage(named: "whishlist-fill"), for: .selected)
        self.btnFavourite.layer.cornerRadius = self.btnFavourite.frame.size.height/2
        self.btnFavourite.layer.borderWidth = 0.5
        self.btnFavourite.layer.borderColor = UIColor.lightGray.cgColor
        self.btnFavourite.tintColor = secondaryColor
        
        self.btnAddtoCart.backgroundColor = secondaryColor
        self.btnAddtoCart.setImage(UIImage(named: "cart-icon"), for: .normal)
        self.btnAddtoCart.setImage(UIImage(named: "cart-icon"), for: .selected)
        self.btnAddtoCart.layer.cornerRadius = self.btnAddtoCart.frame.size.height/2
        self.btnAddtoCart.layer.borderWidth = 0.5
        self.btnAddtoCart.layer.borderColor = UIColor.lightGray.cgColor
        self.btnAddtoCart.tintColor = .white
        
    }

}
