//
//  ForgotPasswordVC.swift
//  CiyaShop
//
//  Created by Apple on 27/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON

class ForgotPasswordVC: UIView {


    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var vwForgotPassword: UIView!
    @IBOutlet weak var vwResetPassword: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblValidationMessage: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var imgEmailIcon: UIImageView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var txtEmail: FloatingTextField!
    
    @IBOutlet weak var btnResetPassword: UIButton!
    
    //For set New password
    
    @IBOutlet weak var lblResetPassword: UILabel!
    @IBOutlet weak var lblPinDescription: UILabel!
    @IBOutlet weak var lblNewPassword: UILabel!
    
    @IBOutlet weak var vwPin: UIView!
    @IBOutlet weak var txtPin: FloatingTextField!
    
    @IBOutlet weak var vwNewPassword: UIView!
    @IBOutlet weak var txtNewPassword: FloatingTextField!
    
    @IBOutlet weak var vwConfirmPassword: UIView!
    @IBOutlet weak var txtConfirmPassword: FloatingTextField!
    
    @IBOutlet weak var btnSetNewPassword: UIButton!
    
    
    var onSetNewPassword : onConfirmBlock?
    
    
    override func awakeFromNib() {
        
        setThemeColors()
    
        initiallizeViews()
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideView))
        blurView.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // MARK: - Themes Methods
    func setThemeColors() {

        self.backgroundColor = .clear
        
        
        
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.text = getLocalizationString(key: "ResetYourWorld")
        lblTitle.textColor = grayTextColor //secondaryColor
        
        lblDescription.font = UIFont.appLightFontName(size: fontSize12)
        lblDescription.text = getLocalizationString(key: "ResetPasswordDescription")
        lblDescription.textColor = grayTextColor //secondaryColor
        
        
        imgEmailIcon.tintColor = secondaryColor
        vwEmail.backgroundColor = textFieldBackgroundColor//primaryColor
        vwEmail.layer.borderWidth = 0.5
        vwEmail.layer.borderColor = secondaryColor.cgColor
        
        txtEmail.textColor = secondaryColor
        txtEmail.font = UIFont.appRegularFontName(size: fontSize14)
        txtEmail.placeholder = getLocalizationString(key: "Email")
        
        lblValidationMessage.textColor = .red
        lblValidationMessage.font = UIFont.appLightFontName(size: fontSize12)
        
        btnResetPassword.tintColor = .white
        btnResetPassword.setTitle(getLocalizationString(key: "RequestPasswordReset").uppercased(), for: .normal)
        btnResetPassword.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnResetPassword.setTitleColor(.white, for: .normal)
        btnResetPassword.backgroundColor = secondaryColor
        btnResetPassword.layer.cornerRadius = btnResetPassword.frame.size.height / 2
        
        
        // For set new password
        lblResetPassword.font = UIFont.appBoldFontName(size: fontSize16)
        lblResetPassword.text = getLocalizationString(key: "ResetYourPassword")
        lblResetPassword.textColor = grayTextColor //secondaryColor
        
        lblPinDescription.font = UIFont.appLightFontName(size: fontSize12)
        lblPinDescription.text = getLocalizationString(key: "EnterPIN")
        lblPinDescription.textColor = grayTextColor //secondaryCol
        
        lblNewPassword.font = UIFont.appLightFontName(size: fontSize12)
        lblNewPassword.text = getLocalizationString(key: "EnterNewPassword")
        lblNewPassword.textColor = grayTextColor //secondaryCol
        
        
        vwPin.backgroundColor = textFieldBackgroundColor//primaryColor
        vwPin.layer.borderWidth = 0.5
        vwPin.layer.borderColor = secondaryColor.cgColor
        
        vwNewPassword.backgroundColor = textFieldBackgroundColor//primaryColor
        vwNewPassword.layer.borderWidth = 0.5
        vwNewPassword.layer.borderColor = secondaryColor.cgColor
        
        vwConfirmPassword.backgroundColor = textFieldBackgroundColor//primaryColor
        vwConfirmPassword.layer.borderWidth = 0.5
        vwConfirmPassword.layer.borderColor = secondaryColor.cgColor
        
        txtPin.textColor = secondaryColor
        txtPin.font = UIFont.appRegularFontName(size: fontSize14)
        txtPin.placeholder = getLocalizationString(key: "Pin")
        
        txtNewPassword.textColor = secondaryColor
        txtNewPassword.font = UIFont.appRegularFontName(size: fontSize14)
        txtNewPassword.placeholder = getLocalizationString(key: "NewPassword")
        
        txtConfirmPassword.textColor = secondaryColor
        txtConfirmPassword.font = UIFont.appRegularFontName(size: fontSize14)
        txtConfirmPassword.placeholder = getLocalizationString(key: "ConfirmPassword")
        
        btnSetNewPassword.tintColor = .white
        btnSetNewPassword.setTitle(getLocalizationString(key: "SetNewPassword").uppercased(), for: .normal)
        btnSetNewPassword.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnSetNewPassword.setTitleColor(.white, for: .normal)
        btnSetNewPassword.backgroundColor = secondaryColor
        btnSetNewPassword.layer.cornerRadius = btnResetPassword.frame.size.height / 2
    }
    
    func initiallizeViews() {
        self.lblValidationMessage.text = ""
        self.vwForgotPassword.isHidden = false
        self.vwResetPassword.isHidden = true
    }
    
    // MARK: - Button Clicked
    @IBAction func btnResetPasswordClicked(_ sender: Any) {
        
        if txtEmail.text!.count > 0 {
            if txtEmail.text!.isValidEmail() {
                
                lblValidationMessage.text = ""
                forgotPassword()
                
            } else {
                lblValidationMessage.text = getLocalizationString(key: "EnterValidEmail")
                return
            }
        } else {
            lblValidationMessage.text = getLocalizationString(key: "EnterEmail")
            return
        }
    }
    
    @IBAction func btnSetNewPasswordClicked(_ sender: Any) {
        
        if txtPin.text!.count == 0 {
            showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "EnterPIN"), vc: self.viewContainingController()!)
            return
        }
        
        if txtPin.text! != getValueFromLocal(key: PIN_KEY) as! String {
            showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "PINIncorrect"), vc: self.viewContainingController()!)
            return
        }
        
        if txtNewPassword.text!.count == 0 {
            showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "EntereNewPassword"), vc: self.viewContainingController()!)
            return
        }
         
        if txtConfirmPassword.text!.count == 0 {
            showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "EnterConfirmPassword"), vc: self.viewContainingController()!)
            return
        }
        
        if txtConfirmPassword.text! != txtNewPassword.text! {
            showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "PasswordNotMatch"), vc: self.viewContainingController()!)
            return
        }
       
        updatePassword()
    }
    
    //  MARK: - API Calling
    
    func forgotPassword() {
        self.endEditing(true)
        
        showLoader(vc: self.viewContainingController())
        
        var params = [AnyHashable : Any]()
        params["email"] = self.txtEmail.text
        print(params)
        
        CiyaShopAPISecurity.forgetPassword(params) { (success, message, responseData) in
            
            hideLoader(vc: self.viewContainingController())
            
            let jsonReponse = JSON(responseData!)
            if success {
                
                print(jsonReponse)
                if jsonReponse["status"] == "success" {
                    
                    setValueToLocal(key:  PIN_KEY, value: jsonReponse["key"].string!)
                    
                    self.vwForgotPassword.isHidden = true
                    self.vwResetPassword.isHidden = false
                    
                    
                } else {
                    self.lblValidationMessage.text = getLocalizationString(key: "EnterValidEmail")
                }
            } else {
                if let message = jsonReponse["message"].string {
                    self.viewContainingController()!.showToast(message: message)

                } else {
                    self.viewContainingController()!.showToast(message: getLocalizationString(key: "technicalIssue"))

                }
            }
        }
    }
    
    func updatePassword() {
        self.endEditing(true)
        
        showLoader(vc: self.viewContainingController())
        
        var params = [AnyHashable : Any]()
        params["email"] = self.txtEmail.text
        params["password"] = self.txtNewPassword.text
        params["key"] = getValueFromLocal(key: PIN_KEY) as! String
        print(params)
        
        CiyaShopAPISecurity.updatePassword(params) { (success, message, responseData) in
            
            hideLoader(vc: self.viewContainingController())
            
            let jsonReponse = JSON(responseData!)
            if success {
                print(jsonReponse)
                if jsonReponse["status"] == "success" {
                    
                    self.hideView()
                    showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "PasswordUpdateSuccess"), vc: self.viewContainingController()!)
                    self.onSetNewPassword!()
                    
                } else {
                    self.viewContainingController()!.showToast(message: getLocalizationString(key: "technicalIssue"))

                }
            } else {
                if let message = jsonReponse["message"].string {
                    self.viewContainingController()!.showToast(message: message)

                } else {
                    self.viewContainingController()!.showToast(message: getLocalizationString(key: "technicalIssue"))

                }
            }
        }
    }
    
    //  MARK: - on Tap gesture
    @objc func hideView() {
        self.transform = .identity
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (animated) in
            self.removeFromSuperview()
        }
    }
    
}
