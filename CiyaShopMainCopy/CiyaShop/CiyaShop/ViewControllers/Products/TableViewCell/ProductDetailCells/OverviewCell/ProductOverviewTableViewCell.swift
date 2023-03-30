//
//  ProductOverviewTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 14/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
enum DetailscellType
{
    case overview
    case productDetails
}
class ProductOverviewTableViewCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var vwContent: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnMore: UIButton!

    //MARK:- Variables
    var selectedCellType = DetailscellType.overview
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
        //--
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwContent.cornerRadius(radius: 5)
        //---
        lblTitle.font = UIFont.appBoldFontName(size: fontSize14)
        lblTitle.textColor = secondaryColor
      
        //---
        lblDescription.font = UIFont.appRegularFontName(size: fontSize12)
        lblDescription.textColor = grayTextColor
        
        //--
        btnMore.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
        btnMore.setTitleColor(secondaryColor, for: .normal)
        
        
    }
    func setUpData()
    {
        
        if selectedCellType == .overview
        {
            lblTitle.text = getLocalizationString(key: "QuickOverview")
            lblDescription.attributedText = dictDetails["short_description"].stringValue.htmlToAttributedString
        }else{
            lblTitle.text = getLocalizationString(key: "ProductDetails")
            lblDescription.attributedText = dictDetails["description"].stringValue.htmlToAttributedString
        }
        lblDescription.font = UIFont.appRegularFontName(size: fontSize12)
        lblDescription.textColor = grayTextColor

        btnMore.setTitle(getLocalizationString(key: "More"), for: .normal)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//MARK:- Button action
extension ProductOverviewTableViewCell
{
    @IBAction func btnMoreClicked(_ sender : UIButton)
    {
        
        let vc = ViewAllDetailsVC(nibName: "ViewAllDetailsVC", bundle: nil)
        vc.selectedDetailType = selectedCellType
        vc.dictDetails = dictDetails
        self.parentContainerViewController()?.navigationController?.pushToViewController(vc, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                vc.lblHeading.text = self.lblTitle.text
                vc.lblTitle.text = self.lblTitle.text
            }
        })
    }
    
}
