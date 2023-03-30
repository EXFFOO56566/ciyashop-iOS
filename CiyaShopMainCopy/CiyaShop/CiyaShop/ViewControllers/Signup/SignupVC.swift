//
//  LoginVC.swift
//  CiyaShop
//
//  Created by Apple on 07/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CountryPickerView
import FirebaseAuth
import Firebase
import CiyaShopSecurityFramework
import SwiftyJSON
import GoogleSignIn
import FBSDKLoginKit

class SignupVC: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var imgUserNameIcon: UIImageView!
    @IBOutlet weak var vwUserName: UIView!
    @IBOutlet weak var txtUserName: FloatingTextField!
    
    @IBOutlet weak var imgEmailIcon: UIImageView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var txtEmail: FloatingTextField!
    

    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var imgArrow: UIImageView!
    
    @IBOutlet weak var vwContactNo: UIView!
    @IBOutlet weak var txtContactNo: FloatingTextField!
    
    @IBOutlet weak var imgPasswordIcon: UIImageView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var txtPassword: FloatingTextField!
    
    @IBOutlet weak var imgConfirmPasswordIcon: UIImageView!
    @IBOutlet weak var vwConfirmPassword: UIView!
    @IBOutlet weak var txtConfirmPassword: FloatingTextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    let countryPickerView = CountryPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColors()
        setLogo()
        setupCountryPicker()
        
    }


    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        imgUserNameIcon.tintColor = secondaryColor
        vwUserName.backgroundColor = textFieldBackgroundColor//primaryColor
        vwUserName.layer.borderWidth = 0.5
        vwUserName.layer.borderColor = secondaryColor.cgColor
        txtUserName.textColor = secondaryColor
        txtUserName.font = UIFont.appRegularFontName(size: fontSize14)
        txtUserName.placeholder = getLocalizationString(key: "UserName")
        
        imgEmailIcon.tintColor = secondaryColor
        vwEmail.backgroundColor = textFieldBackgroundColor//primaryColor
        vwEmail.layer.borderWidth = 0.5
        vwEmail.layer.borderColor = secondaryColor.cgColor
        txtEmail.textColor = secondaryColor
        txtEmail.font = UIFont.appRegularFontName(size: fontSize14)
        txtEmail.placeholder = getLocalizationString(key: "EmailID")
        
        lblCountryCode.font = UIFont.appRegularFontName(size: fontSize14)
        lblCountryCode.textColor = secondaryColor
        imgArrow.tintColor = secondaryColor
        
        vwContactNo.backgroundColor = textFieldBackgroundColor//primaryColor
        vwContactNo.layer.borderWidth = 0.5
        vwContactNo.layer.borderColor = secondaryColor.cgColor
        txtContactNo.textColor = secondaryColor
        txtContactNo.font = UIFont.appRegularFontName(size: fontSize14)
        txtContactNo.placeholder = getLocalizationString(key: "ContactNumber")
        
        imgPasswordIcon.tintColor = secondaryColor
        vwPassword.backgroundColor = textFieldBackgroundColor//primaryColor
        vwPassword.layer.borderWidth = 0.5
        vwPassword.layer.borderColor = secondaryColor.cgColor
        txtPassword.textColor = secondaryColor
        txtPassword.font = UIFont.appRegularFontName(size: fontSize14)
        txtPassword.placeholder = getLocalizationString(key: "Password")
     
        imgConfirmPasswordIcon.tintColor = secondaryColor
        vwConfirmPassword.backgroundColor = textFieldBackgroundColor//primaryColor
        vwConfirmPassword.layer.borderWidth = 0.5
        vwConfirmPassword.layer.borderColor = secondaryColor.cgColor
        txtConfirmPassword.textColor = secondaryColor
        txtConfirmPassword.font = UIFont.appRegularFontName(size: fontSize14)
        txtConfirmPassword.placeholder = getLocalizationString(key: "ConfirmPassword")
        
        btnSignup.setTitle(getLocalizationString(key: "SignUp"), for: .normal)
        btnSignup.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnSignup.backgroundColor = secondaryColor
        btnSignup.layer.cornerRadius = btnSignup.frame.size.height / 2
        
        
        btnLogin.setTitle(getLocalizationString(key: "AlreadyHaveAccount"), for: .normal)
        btnLogin.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
        btnLogin.backgroundColor = .clear
        btnLogin.tintColor =  secondaryColor
        
        btnBack.tintColor =  secondaryColor
    }
    
    func setupCountryPicker() {
        
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        
        countryPickerView.showCountryCodeInView = true
        countryPickerView.showPhoneCodeInView = true
        
        let defaultCountry = countryPickerView.getCountryByPhoneCode(MOBILE_COUNTRY_CODE)
        setCounryData(country: defaultCountry)
        countryPickerView.setCountryByPhoneCode(MOBILE_COUNTRY_CODE)
        
    }
    
    func setLogo() {
        if appLogo != "" {
            self.imgLogo.sd_setImage(with: appLogo.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                if (image == nil) {
                    self.imgLogo.image = UIImage(named: "appLogo")
                } else {
                    self.imgLogo.image = image
                }
            }
        } else {
            self.imgLogo.image = UIImage(named: "appLogo")
        }
    }
    
    func setCounryData(country : Country! ) {
        let bundle = Bundle(for: CountryPickerView.self)
        let image = UIImage(named: "CountryPickerView.bundle/Images/" + country!.code, in: bundle, compatibleWith: nil)
        
        self.imgCountry.image = image
        self.lblCountryCode.text = "(\(country!.code)) \(country!.phoneCode)"
    }
    
    
    // MARK: - Firebase OTP verification
    
    func sendMessage()  {
        if isOTPEnabled == false {
            registerUser()
            return
        }
        
        //send sms
        let arrCountryCode = self.lblCountryCode.text?.components(separatedBy: " ")
        let strPhoneNumber = String(format: "%@%@", arrCountryCode![arrCountryCode!.count-1] as String,self.txtContactNo.text! as String)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(strPhoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                showCustomAlert(title: APP_NAME, message: error!.localizedDescription, vc: self)
                return
            }
            
            showVerificationPopUp(vc: self, strVerificationToken: verificationID!, strPhoneNumber: strPhoneNumber, strUserId: "") {
                self.registerUser()
            }
        }
    }
    
    func registerUser() {
        self.view.endEditing(true)
        
        showLoader(vc: self)
        
        let arrCountryCode = self.lblCountryCode.text?.components(separatedBy: " ")
        let strPhoneNumber = String(format: "%@%@", arrCountryCode![arrCountryCode!.count-1] as String,self.txtContactNo.text! as String)
        
        var params = [AnyHashable : Any]()
        
        params["email"] = self.txtEmail.text
        params["username"] = self.txtUserName.text
        params["mobile"] = strPhoneNumber
        params["password"] = self.txtPassword.text
        params["device_token"] = strDeviceToken
        params["device_type"] = "1"
        
        print(params)
        
        CiyaShopAPISecurity.createCustomer(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                print(jsonReponse)
                if jsonReponse["status"] == "success" {
                    
                    setValueToLocal(key: PASSWORD_KEY, value: self.txtPassword.text as Any)
                    setValueToLocal(key: EMAIL_KEY, value: jsonReponse["user"]["email"].stringValue)
                    setValueToLocal(key: USERNAME_KEY, value: jsonReponse["user"]["username"].stringValue)
                    setValueToLocal(key: USERID_KEY, value: jsonReponse["user"]["id"].stringValue)
                    
                    setValueToLocal(key: FB_OR_GOOGLE_KEY, value: false)
                    setValueToLocal(key: LOGIN_KEY, value: true)
                    
                    is_Logged_in = true
                    
                    GIDSignIn.sharedInstance()?.signOut()
                    AccessToken.current = nil
                    
                    if isWishList {
                        if arrWishlist.count > 0 {
                            self.syncWishlist()
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                } else {
                    
                    setValueToLocal(key: FB_OR_GOOGLE_KEY, value: false)
                    setValueToLocal(key: LOGIN_KEY, value: false)
                    is_Logged_in = false
                    
                    if let message = jsonReponse["message"].string {
                        showCustomAlert(title: APP_NAME,message: message.withoutHtmlString(), vc: self)
                    } else {
                        showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                    }
                }
            } else {
                if let message = jsonReponse["message"].string {
                    showCustomAlert(title: APP_NAME,message: message, vc: self)
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                }
            }
            
            hideLoader(vc: self)
        }
    }
    
    func syncWishlist() {
        self.view.endEditing(true)
        
        showLoader(vc: self)
        var params = [AnyHashable : Any]()
        params["user_id"] = getValueFromLocal(key: USERID_KEY)
        
        var arrSyncList = Array<Any>()
        
        for wishlistItem in arrWishlist {
            
            var dictSyncItem = [AnyHashable : Any]()
            dictSyncItem["product_id"] = wishlistItem["id"].stringValue
            dictSyncItem["quantity"] = "1"
            dictSyncItem["wishlist_name"] = ""
            dictSyncItem["user_id"] = getValueFromLocal(key: USERID_KEY)
            
            arrSyncList.append(dictSyncItem)
        }
        params["sync_list"] = arrSyncList
        
        print(params)
        
        CiyaShopAPISecurity.addAllItem(toWishList : params) { (success, message, responseData) in
            let jsonReponse = JSON(responseData!)
            if success {
                
                print(jsonReponse)
                if jsonReponse["status"] == "success" {
                    
                } else if jsonReponse["status"] == "error" {
                    
                } else {
                    
                }
                
            } else {
                if let message = jsonReponse["message"].string {
                    showCustomAlert(title: APP_NAME,message: message, vc: self)
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                }
            }
            hideLoader(vc: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSignupClicked(_ sender: Any) {
        
        if txtUserName.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterUserName"))
            return
        }
        
        if txtEmail.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterEmail"))
            return
        }
        
        if !txtEmail.text!.isValidEmail() {
            showToast(message: getLocalizationString(key: "EnterValidEmail"))
            return
        }
        
        if txtContactNo.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterContactNo"))
            return
        }
        
        if txtPassword.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterPassword"))
            return
        }
        
        if txtConfirmPassword.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterConfirmPassword"))
            return
        }
        
        if txtPassword.text != txtConfirmPassword.text {
            showToast(message: getLocalizationString(key: "ConfirmPasswordMatch"))
            return
            
        }
        sendMessage()
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCountryClick(_ sender: Any) {
        countryPickerView.showCountriesList(from: self)
    }
    
}

extension SignupVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        print(message)
        setCounryData(country: country)
    }
}

extension SignupVC: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        return []
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return nil
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return getLocalizationString(key: "SelectCountry")
    }
        
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .tableViewHeader
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
       return true
    }
    
    func sectionTitleLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont.appBoldFontName(size: fontSize14)
    }
    func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont.appRegularFontName(size: fontSize14)
    }
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        let barButton = UIBarButtonItem(title: getLocalizationString(key: "Close"), style: .plain, target: self, action: nil)
        barButton.tintColor = grayTextColor
        return barButton
    }
}
