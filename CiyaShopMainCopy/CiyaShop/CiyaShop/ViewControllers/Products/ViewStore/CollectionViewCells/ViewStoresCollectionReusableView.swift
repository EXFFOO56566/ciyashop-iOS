//
//  ViewStoresCollectionReusableView.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 16/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ViewStoresCollectionReusableView: UICollectionReusableView {

    //MARK:- Outlets
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var imgStore: UIImageView!

    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblStoreDescription: UILabel!
    @IBOutlet weak var lblStoreLocation: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var vwRatingCountBack: UIView!
    
    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var btnContactSeller: UIButton!
    
    @IBOutlet weak var btnContactSellerHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpUI()
    }
    //MARK:- Setup UI
    func setUpUI()
    {
        // Initialization code
        //--
        self.vwRatingCountBack.backgroundColor = greenColor
        self.vwRatingCountBack.cornerRadius(radius: 3)
        
        //---
        lblStoreLocation.font = UIFont.appRegularFontName(size: fontSize12)
        lblStoreLocation.textColor = secondaryColor
        
        //---
        lblHeading.font = UIFont.appBoldFontName(size: fontSize12)
        lblHeading.textColor = secondaryColor
        lblHeading.text = getLocalizationString(key: "OtherProductsVendor")
        //---
        lblRatingCount.font = UIFont.appRegularFontName(size: fontSize10)
        lblRatingCount.textColor = .white
        
        //---
        imgStore.layer.cornerRadius = imgStore.frame.size.height / 2
        imgStore.layer.masksToBounds = true
        imgStore.layer.borderWidth = 1
        imgStore.layer.borderColor = secondaryColor.cgColor
        
        lblVendorName.font = UIFont.appBoldFontName(size: fontSize12)
        lblVendorName.textColor = grayTextColor
        
        btnContactSeller.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        btnContactSeller.layer.cornerRadius = (btnContactSeller.frame.size.height) / 2
        btnContactSeller.setTitleColor(.white, for: .normal)
        btnContactSeller.isHidden = true
        btnContactSeller.backgroundColor = secondaryColor
    
    }

}
