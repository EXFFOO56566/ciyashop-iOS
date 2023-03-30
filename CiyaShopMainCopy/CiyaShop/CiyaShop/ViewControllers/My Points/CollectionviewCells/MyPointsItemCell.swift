//
//  MyPointsItemCell.swift
//  CiyaShop
//
//  Created by Apple on 01/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyPointsItemCell: UICollectionViewCell {

    
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPoints: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblEvent.font = UIFont.appLightFontName(size: fontSize12)
        self.lblEvent.textColor = grayTextColor
        
        self.lblDate.font = UIFont.appLightFontName(size: fontSize12)
        self.lblDate.textColor = grayTextColor
        
        self.lblPoints.font = UIFont.appLightFontName(size: fontSize12)
        self.lblPoints.textColor = grayTextColor
        
    }
    
    func setEventData(event:JSON) {
        self.lblEvent.text = event["description"].string
        self.lblDate.text = event["date_display_human"].string
        self.lblPoints.text = event["points"].string
    }

}
