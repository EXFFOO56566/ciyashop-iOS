//
//  ReviewTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 14/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
class ReviewTableViewCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var vwRatingCountBack: UIView!

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    //MARK:- Variables
    
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
        //--
        self.vwRatingCountBack.cornerRadius(radius: 3)
        
        //---
        lblName.font = UIFont.appBoldFontName(size: fontSize12)
        lblName.textColor = normalTextColor
        
        //---
        lblReview.font = UIFont.appRegularFontName(size: fontSize12)
        lblReview.textColor = grayTextColor
        
        //---
        lblRatingCount.font = UIFont.appRegularFontName(size: fontSize10)
        lblRatingCount.textColor = .white
        
        //---
        lblDate.font = UIFont.appRegularFontName(size: fontSize10)
        lblDate.textColor = grayTextColor
        
    }

    func setUpReviewData(dict:JSON)
    {
        lblName.text = dict["name"].stringValue
        lblReview.text = dict["review"].stringValue
        lblRatingCount.text = dict["rating"].stringValue
        
        if(dict["rating"].intValue>=3){
            self.vwRatingCountBack.backgroundColor = greenColor
        }else{
            self.vwRatingCountBack.backgroundColor = .red
        }
        //2020-11-09T06:41:09
        //dict["date_created"].stringValue.convertDateFormater(formate: "YYYY-MM-ddTHH:mm:ss", requiredFormate:"MMM dd,yyyy")
        
        lblDate.text = dict["date_created_gmt"].stringValue.convertDateStringToString(originalFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "MMM dd,yyyy")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
