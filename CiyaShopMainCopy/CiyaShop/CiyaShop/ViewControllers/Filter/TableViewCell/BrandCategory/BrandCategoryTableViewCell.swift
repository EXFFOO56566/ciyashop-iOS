//
//  BrandCategoryTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 12/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class BrandCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSelect: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()

        lblName.textColor = grayTextColor
        lblName.font = UIFont.appRegularFontName(size: fontSize12)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
