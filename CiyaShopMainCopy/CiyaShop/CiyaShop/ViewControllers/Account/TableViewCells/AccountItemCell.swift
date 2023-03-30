//
//  AccountItemCell.swift
//  CiyaShop
//
//  Created by Apple on 06/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AccountItemCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var switchNotification: UISwitch!
    
    @IBOutlet weak var imgLeadingContraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgIcon.tintColor = grayTextColor//secondaryColor
        
        self.lblTitle.textColor = grayTextColor//secondaryColor
        
        self.switchNotification.onTintColor =  secondaryColor
        self.switchNotification.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
