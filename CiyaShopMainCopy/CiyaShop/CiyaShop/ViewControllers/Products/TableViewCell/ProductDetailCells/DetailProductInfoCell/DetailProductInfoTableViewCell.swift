//
//  DetailProductInfoTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 13/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailProductInfoTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    //MARK:- Variables
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
        // Initialization code
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwContent.cornerRadius(radius: 5)
        //---
        lblTitle.font = UIFont.appBoldFontName(size: fontSize14)
        lblTitle.textColor = secondaryColor
        
        //--
        lblDescription.font = UIFont.appRegularFontName(size: fontSize12)
        lblDescription.textColor = normalTextColor
        
        
        
    }
    func setUpData()
    {
        lblTitle.text = getLocalizationString(key: "Info")
        
//        lblDescription.font = UIFont.appRegularFontName(size: fontSize12)
        lblDescription.attributedText = dictDetails["addition_info_html"].stringValue.htmlToAttributedString

        lblDescription.font = UIFont.appRegularFontName(size: fontSize12)

        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
