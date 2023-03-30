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

class MyPointsItemCell: UITableViewCell {

    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    
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
      
        
        self.lblEvent.font = UIFont.appLightFontName(size: fontSize12)
        self.lblEvent.textColor = grayTextColor
        
        self.lblDate.font = UIFont.appLightFontName(size: fontSize12)
        self.lblDate.textColor = grayTextColor
        
        self.lblPoints.font = UIFont.appLightFontName(size: fontSize12)
        self.lblPoints.textColor = grayTextColor
    
        
    }
    
    func setProductData(product : JSON) {
        
        self.layoutIfNeeded()
    }
}
