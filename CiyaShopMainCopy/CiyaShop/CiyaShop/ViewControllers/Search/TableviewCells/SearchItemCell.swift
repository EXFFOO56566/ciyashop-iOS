//
//  SearchItemCell.swift
//  CiyaShop
//
//  Created by Apple on 16/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SearchItemCell: UITableViewCell {

    @IBOutlet weak var lblSearchText: UILabel!
    @IBOutlet weak var vwSeprator: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        lblSearchText.font = UIFont.appLightFontName(size: fontSize12)
        lblSearchText.textColor = secondaryColor
        
        vwSeprator.backgroundColor = secondaryColor.withAlphaComponent(0.5)
    }
    
}
