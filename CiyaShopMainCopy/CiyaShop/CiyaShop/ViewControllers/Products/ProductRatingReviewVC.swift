//
//  ProductRatingReviewVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 15/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Cosmos
import CiyaShopSecurityFramework
import SwiftyJSON
class ProductRatingReviewVC: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblProductName: UILabel!

    @IBOutlet weak var imgProduct: UIImageView!

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var txtName: FloatingTextField!
    @IBOutlet weak var txtEmail: FloatingTextField!

    @IBOutlet weak var lblRateProduct: UILabel!
    @IBOutlet weak var txtvwComment: UITextView!
    
    @IBOutlet weak var vwName: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwRate: UIView!
    @IBOutlet weak var vwComment: UIView!

    @IBOutlet weak var vwRating: CosmosView!

    //MARK:- Variable
    var dictDetails = JSON()
    var userRating = 0.0
    
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
        
        
    }
    
    func setThemeColors() {
        self.view.setBackgroundColor()
        
    
        lblTitle.text = getLocalizationString(key: "Review")
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
        
        lblProductName.font = UIFont.appBoldFontName(size: fontSize16)
        lblProductName.textColor = secondaryColor
        
        lblRateProduct.text = getLocalizationString(key: "RateProduct")
        lblRateProduct.font = UIFont.appRegularFontName(size: fontSize14)
        lblRateProduct.textColor = grayTextColor
        
        txtvwComment.font = UIFont.appRegularFontName(size: fontSize14)
        txtvwComment.textColor = secondaryColor
        txtvwComment.delegate = self
        
        
        
        [vwName,vwEmail,vwRate,vwComment].forEach { (view) in
            view?.backgroundColor =   textFieldBackgroundColor//primaryColor
            view?.layer.borderWidth = 0.5
            view?.layer.borderColor = secondaryColor.cgColor
        }
        
        [txtName,txtEmail].forEach { (textfield) in
            textfield?.textColor = secondaryColor
            textfield?.font = UIFont.appRegularFontName(size: fontSize14)
            textfield?.delegate = self
        }
        
        txtName.placeholder = getLocalizationString(key: "Name")
        txtName.keyboardType = .default
        
        txtEmail.placeholder = getLocalizationString(key: "EmailID")
        txtEmail.keyboardType = .emailAddress
    
        btnSubmit.setTitle(getLocalizationString(key: "Submit"), for: .normal)
        btnSubmit.setTitleColor(.white, for: .normal)

        btnSubmit.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnSubmit.backgroundColor = secondaryColor
        btnSubmit.cornerRadius(radius: btnSubmit.frame.size.height/2)
        
        btnBack.tintColor =  secondaryColor
        SetPlaceHolder()
        vwRating.rating = 0
        
        vwRating.didTouchCosmos = { rating in
            self.userRating = rating
        }
        vwRating.didFinishTouchingCosmos = { rating in
            
            self.userRating = rating
        }
        if(isRTL)
        {
            txtvwComment.textAlignment = .right
        }
        setUpData()
    }
    func SetPlaceHolder()
    {
        txtvwComment.textColor = grayTextColor
        txtvwComment.text = getLocalizationString(key: "Comment")
    }
    func setUpData()
    {
        lblProductName.text = dictDetails["name"].stringValue

        let imageUrl = dictDetails["app_thumbnail"].stringValue

        self.imgProduct.sd_setImage(with: imageUrl.encodeURL(), placeholderImage: UIImage(named: "placeholder"))

    }
    //MARK:- Textview delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == grayTextColor {
            textView.text = nil
            textView.textColor = secondaryColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0
        {
            SetPlaceHolder()
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        if(textView.text.count == 0)
        {
            SetPlaceHolder()
        }
        else if textView.textColor == grayTextColor {
            textView.text = nil
            textView.textColor = secondaryColor
        }
        
        
    }

}
//MARK:- Valiadtion
extension ProductRatingReviewVC
{
    func isValidForReview() -> Bool
    {
        if txtName.text!.isEmpty {
            self.showToast(message: getLocalizationString(key: "EnterName"))
            return false
        }
        else if txtEmail.text!.isEmpty {
            self.showToast(message: getLocalizationString(key: "EnterEmail"))
            return false
        }
        else if !txtEmail.text!.isValidEmail() {
            self.showToast(message: getLocalizationString(key: "EnterValidEmail"))
            return false
        }
        else if vwRating.rating == 0 {
            self.showToast(message: getLocalizationString(key: "GiveRating"))
            return false
        }
        else if txtvwComment.text!.isEmpty {
            self.showToast(message: getLocalizationString(key: "EnterMessage"))
            return false
        }
        return true
    }
}
//MARK:- Button Action Methods
extension ProductRatingReviewVC
{
    @IBAction func btnSubmitClicked(_ sender : UIButton)
    {
        if(isValidForReview())
        {
            SubmitReview()
        }
    }
    
}
//MARK:- API call
extension ProductRatingReviewVC
{
    func SubmitReview()
    {
        showLoader()
       
        var params = [AnyHashable : Any]()
        params["product"] = dictDetails["id"].stringValue
        params["comment"] = txtvwComment.text
        params["ratestar"] = "\(userRating)"
        params["namecustomer"] = txtName.text
        params["emailcustomer"] = ""
        params["user_id"] = "\(String(describing: getValueFromLocal(key: USERID_KEY)))"

        //---
        
        print("Param give review - ",params)
        
        CiyaShopAPISecurity.postReview(params) { (success, message, responseData) in
            let jsonReponse = JSON(responseData!)
            if success {
                print("Review submit data - ",jsonReponse)
                self.showToast(message: jsonReponse["message"].stringValue)

                self.navigationController?.popViewController(animated: true)
            } else {
                if let message = jsonReponse["message"].string {
                    showCustomAlert(title: APP_NAME,message: message, vc: self)
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                }
            }
            hideLoader()
        }
        
        
        
    }
}
