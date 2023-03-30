//
//  LoginVC.swift
//  CiyaShop
//
//  Created by Apple on 07/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblChangePassword: UILabel!
    
    @IBOutlet weak var imgEmailIcon: UIImageView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var txtEmail: FloatingTextField!
    
    @IBOutlet weak var imgOldPasswordIcon: UIImageView!
    @IBOutlet weak var vwOldPassword: UIView!
    @IBOutlet weak var txtOldPassword: FloatingTextField!
    
    @IBOutlet weak var imgNewPasswordIcon: UIImageView!
    @IBOutlet weak var vwNewPassword: UIView!
    @IBOutlet weak var txtNewPassword: FloatingTextField!
    
    @IBOutlet weak var imgRetypePasswordIcon: UIImageView!
    @IBOutlet weak var vwRetypePassword: UIView!
    @IBOutlet weak var txtRetypePassword: FloatingTextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColors()
        // Do any additional setup after loading the view.
    }


    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        btnBack.tintColor =  secondaryColor
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "Accountsettings")
        self.lblTitle.textColor = secondaryColor
        
        
        self.lblChangePassword.font = UIFont.appRegularFontName(size: fontSize14)
        self.lblChangePassword.text = getLocalizationString(key: "ChangePassword")
        self.lblChangePassword.textColor = secondaryColor
        
        
        imgEmailIcon.tintColor = secondaryColor
        vwEmail.backgroundColor = textFieldBackgroundColor//primaryColor
        vwEmail.layer.borderWidth = 0.5
        vwEmail.layer.borderColor = secondaryColor.cgColor
        
        imgOldPasswordIcon.tintColor = secondaryColor
        vwOldPassword.backgroundColor = textFieldBackgroundColor//primaryColor
        vwOldPassword.layer.borderWidth = 0.5
        vwOldPassword.layer.borderColor = secondaryColor.cgColor
        
        imgNewPasswordIcon.tintColor = secondaryColor
        vwNewPassword.backgroundColor = textFieldBackgroundColor//primaryColor
        vwNewPassword.layer.borderWidth = 0.5
        vwNewPassword.layer.borderColor = secondaryColor.cgColor
        
        imgRetypePasswordIcon.tintColor = secondaryColor
        vwRetypePassword.backgroundColor = textFieldBackgroundColor//primaryColor
        vwRetypePassword.layer.borderWidth = 0.5
        vwRetypePassword.layer.borderColor = secondaryColor.cgColor
        
        txtEmail.textColor = secondaryColor
        txtEmail.font = UIFont.appRegularFontName(size: fontSize14)
        txtEmail.placeholder = getLocalizationString(key: "Email")
                
        txtOldPassword.textColor = secondaryColor
        txtOldPassword.font = UIFont.appRegularFontName(size: fontSize14)
        txtOldPassword.placeholder = getLocalizationString(key: "OldPassword")
        
        txtNewPassword.textColor = secondaryColor
        txtNewPassword.font = UIFont.appRegularFontName(size: fontSize14)
        txtNewPassword.placeholder = getLocalizationString(key: "NewPassword")
        
        txtRetypePassword.textColor = secondaryColor
        txtRetypePassword.font = UIFont.appRegularFontName(size: fontSize14)
        txtRetypePassword.placeholder = getLocalizationString(key: "RetypePassword")
        
        btnSave.setTitle(getLocalizationString(key: "Save").uppercased(), for: .normal)
        btnSave.tintColor = .white
        btnSave.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnSave.setTitleColor(.white, for: .normal)
        btnSave.backgroundColor = secondaryColor
        btnSave.layer.cornerRadius = btnSave.frame.size.height / 2
        
        
    }
    
    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        
        if txtEmail.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterEmail"))
            return
        }
        
        if !txtEmail.text!.isValidEmail() {
            showToast(message: getLocalizationString(key: "EnterValidEmail"))
            return
        }
        
        if txtEmail.text != dictLoginData["email"].string {
            showToast(message: getLocalizationString(key: "EnterValidEmail"))
            return
        }
        
        if txtOldPassword.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterCurrentPassword"))
            return
        }
        
        if txtOldPassword.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterCurrentPassword"))
            return
        }
        
        if txtOldPassword.text != (getValueFromLocal(key: PASSWORD_KEY) as! String) {
            showToast(message: getLocalizationString(key: "PasswordNotCorrect"))
            return
        }
        
        if txtNewPassword.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterNewPassword"))
            return
        }
        
        if txtRetypePassword.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterConfirmPassword"))
            return
        }
        
        if txtNewPassword.text != txtRetypePassword.text {
            showToast(message: getLocalizationString(key: "ConfirmPasswordMatch"))
            return
        }
        
        updatePassword()
    }
    
    
    
    // MARK: - API Calling
    
    func updatePassword() {
        showLoader()
        var params = [AnyHashable : Any]()
        
        params["user_id"] = getValueFromLocal(key: USERID_KEY)
        params["password"] = txtNewPassword.text
        
        CiyaShopAPISecurity.resetPassword(params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    
                    setValueToLocal(key: PASSWORD_KEY, value: self.txtNewPassword.text as Any)
                    
                    self.txtEmail.text = ""
                    self.txtOldPassword.text = ""
                    self.txtNewPassword.text = ""
                    self.txtRetypePassword.text = ""
                    
                    showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "PasswordChangedSuccessfully"), vc: self, onConfirm: {
                        self.navigationController?.popViewController(animated: true)
                    }, cancelButtonTitle: nil)
                }
                return
            }
            
            if let message = jsonReponse["message"].string {
                showCustomAlert(title: APP_NAME,message: message, vc: self)
            } else {
                showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
            }
            
            
        }
    }
    
}
