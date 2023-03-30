//
//  NotificationTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 20/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    @IBOutlet weak var vwContent: UIView!

    //MARK:- variables
    
    //MARK:- Life cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpUI()
    }
    func setUpUI()
    {
        vwContent.cornerRadius(radius: 5)
        
        lblMessage.font = UIFont.appBoldFontName(size: fontSize14)
        lblMessage.textColor = normalTextColor
        
        lblContent.font = UIFont.appRegularFontName(size: fontSize12)
        lblContent.textColor = normalTextColor

        lblDate.font = UIFont.appRegularFontName(size: fontSize10)
        lblDate.textColor = grayTextColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setNotificationData(notification: JSON) {
        lblMessage.text = notification["msg"].stringValue
        lblContent.text = notification["custom_msg"].stringValue
        
        let notificationDate = convertStringToDate(strDate: notification["msg"].stringValue, formatter: "yyyy-MM-dd HH:mm:ss")
        if notificationDate != nil {
            lblDate.text = convertDateToString(date: notificationDate!, formatter: "MMM dd, yyyy")
        } else {
             lblDate.text = ""
        }
    }
}
