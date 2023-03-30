//
//  ContactSellerVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 19/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework
class ContactSellerVC: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!


    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var txtName: FloatingTextField!
    @IBOutlet weak var txtEmail: FloatingTextField!

    @IBOutlet weak var txtvwMessage: UITextView!
    
    @IBOutlet weak var vwName: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwComment: UIView!

    
    //MARK:- Variable
    var dictDetail = JSON()

    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setThemeColors()
        setDefaultData()

    }
    //MARK:- Setup UI
    func setDefaultData() {
        if is_Logged_in {
            txtName.text =  "\(getValueFromLocal(key: USER_FIRST_NAME) as? String ?? "")" + " " + "\(getValueFromLocal(key: USER_LAST_NAME) as? String ?? "")"
            txtEmail.text = getValueFromLocal(key: EMAIL_KEY) as? String ?? ""
        }
    }
    
    func setThemeColors() {
        self.view.setBackgroundColor()
        
    
        lblTitle.text = getLocalizationString(key: "ContactSeller").capitalized
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
        
        txtvwMessage.font = UIFont.appRegularFontName(size: fontSize14)
        txtvwMessage.textColor = secondaryColor
        txtvwMessage.delegate = self
        
        [vwName,vwEmail,vwComment].forEach { (view) in
            view?.backgroundColor =  .white
            view?.layer.borderWidth = 0.5
            view?.layer.borderColor = secondaryColor.cgColor
        }
        
        [txtName,txtEmail].forEach { (textfield) in
            textfield?.textColor = secondaryColor
            textfield?.font = UIFont.appRegularFontName(size: fontSize14)
        }
        
        
    
        btnSend.setTitle(getLocalizationString(key: "Send"), for: .normal)
        btnSend.setTitleColor(.white, for: .normal)

        btnSend.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnSend.backgroundColor = secondaryColor
        btnSend.cornerRadius(radius: btnSend.frame.size.height/2)
        
        btnBack.tintColor =  secondaryColor
        setPlaceHolder()
        
        if(isRTL)
        {
            txtvwMessage.textAlignment = .right
        }
    }
    
    
    func setPlaceHolder()
    {
        txtName.placeholder = getLocalizationString(key: "Name")
        txtEmail.placeholder = getLocalizationString(key: "EmailID")
        
        txtvwMessage.textColor = grayTextColor
        txtvwMessage.text = getLocalizationString(key: "Message")
    }
    
    //MARK:- Textview delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == grayTextColor {
            textView.text = nil
            textView.textColor = secondaryColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            setPlaceHolder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if(textView.text.count == 0) {
            setPlaceHolder()
        } else if textView.textColor == grayTextColor {
            textView.text = nil
            textView.textColor = secondaryColor
        }
    }
}

//MARK:- Validation
extension ContactSellerVC
{
    func isValidateContactSeller() -> Bool
    {
        if txtName.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterName"))
            return false
        }
        else if txtEmail.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterEmail"))
            return false
        }
        else if !txtEmail.text!.isValidEmail() {
            showToast(message: getLocalizationString(key: "EnterValidEmail"))
            return false
        }
        
        else if txtvwMessage.text!.isEmpty || txtvwMessage.text == getLocalizationString(key: "Message")  {
            showToast(message: getLocalizationString(key: "EnterMessage"))
            return false
        }
        return true
    }
}

//MARK:- Button Action
extension ContactSellerVC
{
    @IBAction func btnContactSellerClicked(_ sender:UIButton)
    {
        self.view.endEditing(true)
        if(isValidateContactSeller()){
            contactSeller()
        }
        
    }
}

//MARK:- API calling
extension ContactSellerVC
{
    func contactSeller()
    {
        showLoader()
        var params = [AnyHashable : Any]()
        params["seller_id"] = dictDetail["seller_info"]["seller_id"].stringValue
        params["name"] = "\(txtName.text ?? "")"
        params["email"] = "\(txtEmail.text ?? "")"
        params["message"] = "\(txtvwMessage.text ?? "")"
        params["product_id"] = dictDetail["id"].stringValue
        
        
        CiyaShopAPISecurity.contactSeller(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                self.txtvwMessage.text = getLocalizationString(key: "Message")
                self.showToast(message: jsonReponse["message"].stringValue)
            } else
            {
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
