//
//  TermsAndPolicyVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 20/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON


enum contentType
{
    case privacyPolicy
    case termsCondition
}

class TermsAndPolicyVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContentDetails: UILabel!

    @IBOutlet weak var btnBack: UIButton!

    //MARK:- variables
    var selectedContentType = contentType.termsCondition
    
    //MARK:- Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    //MARK:- Setup UI
    func setUpUI()
    {
        // Initialization code
        setThemeColors()
        getContentData()
    }
  
    func setThemeColors()
    {
        self.view.setBackgroundColor()
      
        if selectedContentType == .privacyPolicy{
            lblTitle.text = getLocalizationString(key: "PrivacyPolicy")
        }else if selectedContentType == .termsCondition{
            lblTitle.text = getLocalizationString(key: "TermsCondition")
        }
        
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
          
        btnBack.tintColor =  secondaryColor
        
    }
    
    // MARK: - Get About us details
    func getContentData() {
        
        showLoader()
        var params = [AnyHashable : Any]()
        if selectedContentType == .termsCondition {
            params["page"] = "terms_of_use"
        } else {
            params["page"] = "privacy_policy"
        }
        
        CiyaShopAPISecurity.getStaticPages(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse.type == .array {
                    
                } else if jsonReponse.type == .dictionary {
                    let htmlString = jsonReponse["data"].stringValue
                    var attributedString : NSMutableAttributedString?
                    do {
                        attributedString = try NSMutableAttributedString(data: htmlString.data(using: .unicode)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                    } catch {
                        attributedString = NSMutableAttributedString()
                    }
                    
                    self.lblContentDetails.attributedText = attributedString
                    self.lblContentDetails.sizeToFit()
                } else {
                    
                }
            }
            hideLoader()
        }
    }
}
