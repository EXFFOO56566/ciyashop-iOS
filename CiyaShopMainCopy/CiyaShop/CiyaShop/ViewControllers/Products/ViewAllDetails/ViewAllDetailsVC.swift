//
//  ViewAllDetailsVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 16/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import WebKit
class ViewAllDetailsVC: UIViewController,UITextViewDelegate {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var txtvwDetails: UITextView!

    @IBOutlet weak var webView: WKWebView!


    //MARK:- Variables
    var selectedDetailType = DetailscellType.overview
    var dictDetails = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }

    //MARK:- Setup UI
    func setUpUI()
    {
        // Initialization code
        
        self.view.setBackgroundColor()
            
        btnBack.tintColor =  secondaryColor
        
        lblTitle.text = ""
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
        //--
        
        lblHeading.text = ""
        lblHeading.font = UIFont.appBoldFontName(size: fontSize16)
        lblHeading.textColor = secondaryColor
        
        txtvwDetails.font = UIFont.appBoldFontName(size: fontSize16)
        txtvwDetails.textColor = .black
        setUpData()
        
    }
    func setUpData()
    {

        let imageUrl = dictDetails["app_thumbnail"].stringValue

        self.imgProduct.sd_setImage(with: imageUrl.encodeURL(), placeholderImage: UIImage(named: "placeholder"))

        if selectedDetailType == .overview
        {
            txtvwDetails.attributedText = dictDetails["short_description"].stringValue.convertToAttributedFromHTML()
            
            webView.loadHTMLString(dictDetails["short_description"].stringValue, baseURL: nil)


        }else if selectedDetailType == .productDetails
        {
            txtvwDetails.attributedText = dictDetails["description"].stringValue.convertToAttributedFromHTML()
            
            webView.loadHTMLString(dictDetails["description"].stringValue, baseURL: nil)

        }
        txtvwDetails.font =  UIFont.appRegularFontName(size: fontSize12)
        txtvwDetails.zoomScale = 3
        txtvwDetails.alwaysBounceHorizontal = true
        
    }

}
