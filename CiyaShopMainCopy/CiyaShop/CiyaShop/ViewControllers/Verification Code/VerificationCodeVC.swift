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
import FirebaseAuth

class VerificationCodeVC: UIView {
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var vwVerificationCode: UIView!
    @IBOutlet weak var txtVerificationCode: FloatingTextField!
    
    @IBOutlet weak var btnResendOTP: UIButton!
    @IBOutlet weak var btnValidateOTP: UIButton!
    
    var onValidateOTP : onConfirmBlock?
    
    var verificationId : String?
    var strPhoneNumber : String?
    var strUserId : String?
    
    override func awakeFromNib() {
        
        setThemeColors()
 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // MARK: - Themes Methods
    func setThemeColors() {
        //        self.view.setBackgroundColor()
        self.backgroundColor = .clear
        
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.text = getLocalizationString(key: "VerificationCode")
        lblTitle.textColor = grayTextColor //secondaryColor
        
        lblDescription.font = UIFont.appLightFontName(size: fontSize12)
        lblDescription.text = getLocalizationString(key: "VerificationCodeDescription")
        lblDescription.textColor = grayTextColor //secondaryColor
        
        vwVerificationCode.backgroundColor = textFieldBackgroundColor//primaryColor
        vwVerificationCode.layer.borderWidth = 0.5
        vwVerificationCode.layer.borderColor = secondaryColor.cgColor
        
        txtVerificationCode.textColor = secondaryColor
        txtVerificationCode.font = UIFont.appRegularFontName(size: fontSize14)
        txtVerificationCode.placeholder = getLocalizationString(key: "VerificationCode")
                
        btnResendOTP.tintColor = .white
        btnResendOTP.setTitle(getLocalizationString(key: "ResendOTP").uppercased(), for: .normal)
        btnResendOTP.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnResendOTP.setTitleColor(.white, for: .normal)
        btnResendOTP.backgroundColor = secondaryColor
        btnResendOTP.layer.cornerRadius = btnResendOTP.frame.size.height / 2
        
        
        btnValidateOTP.tintColor = .white
        btnValidateOTP.setTitle(getLocalizationString(key: "ValidateOTP").uppercased(), for: .normal)
        btnValidateOTP.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnValidateOTP.setTitleColor(.white, for: .normal)
        btnValidateOTP.backgroundColor = secondaryColor
        btnValidateOTP.layer.cornerRadius = btnValidateOTP.frame.size.height / 2
        
    }
    
    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        hideView()
    }
    
    @IBAction func btnVerifyOTPClicked(_ sender: Any) {
        
        if txtVerificationCode.text!.count == 0 {
            showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "EnterVerificationCode"), vc: self.viewContainingController()!)
            return
        }
        verifyOTP()
    }
    
    @IBAction func btnResendOTPClicked(_ sender: Any) {
        
        txtVerificationCode.text = ""
        self.sendMessage()
        
    }
    
    //  MARK: - API Calling
    
    func verifyOTP() {
        self.endEditing(true)
        
        showLoader(vc: self.viewContainingController())
        
        let strOTP = self.txtVerificationCode.text?.replacingOccurrences(of: "-", with: "")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId!, verificationCode: strOTP!)
        
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            hideLoader(vc: self.viewContainingController())
            
            if error != nil {
                showCustomAlert(title: APP_NAME, message: error!.localizedDescription, vc: self.viewContainingController()!)
                return
            }
            
            self.onValidateOTP!()
            self.hideView()
        }
    }
    
    func sendMessage() {
        self.endEditing(true)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(strPhoneNumber!, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                showCustomAlert(title: APP_NAME, message: error!.localizedDescription, vc: self.viewContainingController()!)
                return
            }
            self.verificationId = verificationID;
            
            showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "OTPSentAgain"), vc: self.viewContainingController()!)
            return
            
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
