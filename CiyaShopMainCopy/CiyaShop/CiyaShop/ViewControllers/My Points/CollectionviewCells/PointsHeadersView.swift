//
//  PointsHeadersView.swift
//  CiyaShop
//
//  Created by Apple on 04/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class PointsHeadersView: UICollectionReusableView {

    
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblEvent.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblEvent.textColor = secondaryColor
        self.lblEvent.text = getLocalizationString(key: "Event")
        
        self.lblDate.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblDate.textColor = secondaryColor
        self.lblDate.text = getLocalizationString(key: "Date")
        
        self.lblPoints.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblPoints.textColor = secondaryColor
        self.lblPoints.text = getLocalizationString(key: "Points")

    }
    
}
