//
//  SellerInfoTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 14/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
class SellerInfoTableViewCell: UITableViewCell {

    
   //MARK:- Outlets
    
    @IBOutlet weak var vwContent: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSoldBy: UILabel!
    @IBOutlet weak var btnContactSeller: UIButton!
    @IBOutlet weak var btnViewStore: UIButton!

    @IBOutlet weak var vwSellerInfo: UIView!
    @IBOutlet weak var lblSellerInfo: UILabel!
    @IBOutlet weak var btnViewMore: UIButton!


    
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
        //--
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwContent.cornerRadius(radius: 5)
        //---
        lblTitle.font = UIFont.appBoldFontName(size: fontSize14)
        lblTitle.textColor = secondaryColor
      
        //---
        //---
        lblSellerInfo.font = UIFont.appRegularFontName(size: fontSize12)
        lblSellerInfo.textColor = grayTextColor
        
        //---
        btnViewMore.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
        btnViewMore.setTitleColor(secondaryColor, for: .normal)
        
        //--
        [btnViewStore,btnContactSeller].forEach { (button) in
            button?.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
            button?.layer.cornerRadius = (button?.frame.size.height)! / 2
            button?.setTitleColor(.white, for: .normal)
            button?.isHidden = true
        }
        btnContactSeller.backgroundColor = secondaryColor
        btnViewStore.backgroundColor = grayTextColor
        setUpText()
    }
    func setUpText()
    {
        lblTitle.text = getLocalizationString(key: "SellerInformation")
        
        btnContactSeller.setTitle(getLocalizationString(key: "ContactSeller"), for: .normal)
        btnViewStore.setTitle(getLocalizationString(key: "ViewStore"), for: .normal)
        
    }
    func setUpData()
    {
        if dictDetails["seller_info"]["sold_by"].boolValue
        {
            lblSoldBy.isHidden = !dictDetails["seller_info"]["sold_by"].boolValue
            
            lblSoldBy.attributedText = lblSoldBy.setUpMultiUILabel(color1: grayTextColor, color2: secondaryColor, str1: "\(getLocalizationString(key: "SoldBy")): ", str2: "\(dictDetails["seller_info"]["store_name"].stringValue)",font1: UIFont.appRegularFontName(size: 12),font2: UIFont.appBoldFontName(size: 12))

        }
        else{
            lblSoldBy.isHidden = true
        }
        //---
        if dictDetails["seller_info"]["store_tnc"].stringValue.isEmpty
        {
            vwSellerInfo.isHidden = true
        }else{
            vwSellerInfo.isHidden = false
            
            lblSellerInfo.attributedText = dictDetails["seller_info"]["store_tnc"].stringValue.htmlToAttributedString
            
            lblSellerInfo.font = UIFont.appRegularFontName(size: fontSize12)
            lblSellerInfo.textColor = grayTextColor
            
        }
        
        //--
        
        if dictDetails["seller_info"]["is_seller"].boolValue
        {
            btnViewStore.isHidden = !dictDetails["seller_info"]["is_seller"].boolValue
        }
        if dictDetails["seller_info"]["contact_seller"].boolValue
        {
            btnContactSeller.isHidden = !dictDetails["seller_info"]["is_seller"].boolValue
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//MARK:- Button action
extension SellerInfoTableViewCell
{
    @IBAction func btnMoreClicked(_ sender : UIButton)
    {

    }
    @IBAction func btnContactSellerClicked(_ sender : UIButton)
    {
        let vc = ContactSellerVC(nibName: "ContactSellerVC", bundle: nil)
        vc.dictDetail = dictDetails
        self.parentContainerViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnViewStoreClicked(_ sender : UIButton)
    {
        let vc = ViewStoreVC(nibName: "ViewStoreVC", bundle: nil)
        vc.dictDetail = dictDetails
        self.parentContainerViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
