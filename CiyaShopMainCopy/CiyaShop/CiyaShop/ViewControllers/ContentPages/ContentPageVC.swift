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


class ContentPageVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContentDetails: UILabel!

    @IBOutlet weak var btnBack: UIButton!

    //MARK:- variables
    var pageId : Int?
    var strTitle : String?
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

        lblTitle.text = strTitle
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
          
        btnBack.tintColor =  secondaryColor
        
    }
    
    // MARK: - Get About us details
    func getContentData() {
        
        showLoader()
        var params = [AnyHashable : Any]()
        params["page_id"] = pageId
        
        
        CiyaShopAPISecurity.getInfoPages(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                
                if success {
                    if jsonReponse["status"] == "success" {
                        
                        let htmlString = jsonReponse["data"].stringValue
                        var attributedString : NSMutableAttributedString?
                        do {
                            attributedString = try NSMutableAttributedString(data: htmlString.data(using: .unicode)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                        } catch {
                            attributedString = NSMutableAttributedString()
                        }
                        
                        self.lblContentDetails.attributedText = attributedString
                        self.lblContentDetails.sizeToFit()
                        return
                    }
                }
                
                if let message = jsonReponse["message"].string {
                    showCustomAlert(title: APP_NAME,message: message, vc: self)
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                }
                
            }
        }
        hideLoader()
    }
    
    
}
