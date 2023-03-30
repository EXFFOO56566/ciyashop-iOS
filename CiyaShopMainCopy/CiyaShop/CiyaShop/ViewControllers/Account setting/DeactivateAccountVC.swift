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
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class DeactivateAccountVC: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDeactivateAccount: UILabel!
    
    @IBOutlet weak var imgLoginIcon: UIImageView!
    @IBOutlet weak var vwLogin: UIView!
    @IBOutlet weak var txtLogin: FloatingTextField!
    
    @IBOutlet weak var imgPasswordIcon: UIImageView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var txtPassword: FloatingTextField!
    
    @IBOutlet weak var btnDeactivate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeValues()
        setThemeColors()
        // Do any additional setup after loading the view.
    }

    // MARK: - Initialize
    func initializeValues() {
        if getValueFromLocal(key: FB_OR_GOOGLE_KEY) as! Bool == true {
            vwLogin.isHidden = true
        } else {
            vwLogin.isHidden = false
        }
    }
    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        btnBack.tintColor =  secondaryColor
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "Accountsettings")
        self.lblTitle.textColor = secondaryColor
    
        self.lblDeactivateAccount.font = UIFont.appRegularFontName(size: fontSize14)
        self.lblDeactivateAccount.text = getLocalizationString(key: "DeactivateAccount")
        self.lblDeactivateAccount.textColor = secondaryColor
        
        imgLoginIcon.tintColor = secondaryColor
        vwLogin.backgroundColor = textFieldBackgroundColor//primaryColor
        vwLogin.layer.borderWidth = 0.5
        vwLogin.layer.borderColor = secondaryColor.cgColor
        
        imgPasswordIcon.tintColor = secondaryColor
        vwPassword.backgroundColor = textFieldBackgroundColor//primaryColor
        vwPassword.layer.borderWidth = 0.5
        vwPassword.layer.borderColor = secondaryColor.cgColor
        
        txtLogin.textColor = secondaryColor
        txtLogin.font = UIFont.appRegularFontName(size: fontSize14)
        
        txtPassword.textColor = secondaryColor
        txtPassword.font = UIFont.appRegularFontName(size: fontSize14)
        
        txtLogin.placeholder = getLocalizationString(key: "Email")
        txtPassword.placeholder = getLocalizationString(key: "Password")
        
        btnDeactivate.tintColor = .white
        btnDeactivate.setTitle(getLocalizationString(key: "ConfirmDeactivation").uppercased(), for: .normal)
        btnDeactivate.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnDeactivate.setTitleColor(.white, for: .normal)
        btnDeactivate.backgroundColor = secondaryColor
        btnDeactivate.layer.cornerRadius = btnDeactivate.frame.size.height / 2
       
    }
    
    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDeActivateAccountClicked(_ sender: Any) {
        
        if txtLogin.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterEmail"))
            return
        }
        
        if !txtLogin.text!.isValidEmail() {
            showToast(message: getLocalizationString(key: "EnterValidEmail"))
            return
        }
        
        if txtLogin.text != dictLoginData["email"].string {
            showToast(message: getLocalizationString(key: "EnterValidEmail"))
            return
        }
        
        if getValueFromLocal(key: FB_OR_GOOGLE_KEY) as! Bool == true {
            showConfirmDeactivateAccount()
            return
            
        } else {
            if txtPassword.text!.isEmpty {
                showToast(message: getLocalizationString(key: "EnterPassword"))
                return
            }
            

            
            showConfirmDeactivateAccount()
        }
        
    }
    
    
    func showConfirmDeactivateAccount() {
        showCustomAlertWithConfirm(title: APP_NAME, message: getLocalizationString(key: "ConfirmDeactivate"), vc: self) {
            self.deactivateAccount()
        }
    }
    
    // MARK: - API Calling
    
    func deactivateAccount() {
        showLoader()
        var params = [AnyHashable : Any]()
        
        params["user_id"] = getValueFromLocal(key: USERID_KEY)
        params["email"] = txtLogin.text
        params["password"] = txtPassword.text
        params["disable_user"] = "1"
        
        if getValueFromLocal(key: FB_OR_GOOGLE_KEY) as! Bool == true {
            params["social_user"] = "yes"
        }
        
        CiyaShopAPISecurity.deactivateUser(params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    
                    dictLoginData = JSON()
                    GIDSignIn.sharedInstance()?.signOut()
                    AccessToken.current = nil
                    
                    is_Logged_in = false
                    setValueToLocal(key: FB_OR_GOOGLE_KEY, value: false)
                    setValueToLocal(key: LOGIN_KEY, value: false)
                    
                    removeAllFromWishlist()
                    removeAllFromCart()
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "DeactivatedSuccess"), vc: self)
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
    
    
}
