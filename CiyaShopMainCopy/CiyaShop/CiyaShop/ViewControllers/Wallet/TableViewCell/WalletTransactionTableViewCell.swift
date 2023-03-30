//
//  WalletTransactionTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 29/09/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class WalletTransactionTableViewCell: UITableViewCell {

    //MARK:-
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblText : UILabel!
    @IBOutlet var lblAmount : UILabel!
    @IBOutlet var vwContent : UIView!

    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpUI()
        
    }
    func setUpUI()
    {
        vwContent.cornerRadius(radius: 5)
        
        [lblDate,lblAmount].forEach { label in
            label?.font = UIFont.appRegularFontName(size: fontSize12)
            label?.textColor = normalTextColor
        }
        lblText.font = UIFont.appBoldFontName(size:fontSize14 )
        lblText.textColor = normalTextColor
        
        lblAmount.textColor = greenColor
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
