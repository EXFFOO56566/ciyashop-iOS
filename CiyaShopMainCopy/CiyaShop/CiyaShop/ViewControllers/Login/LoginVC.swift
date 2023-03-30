//
//  LoginVC.swift
//  CiyaShop
//
//  Created by Apple on 07/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework

import Firebase
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

class LoginVC: UIViewController,GIDSignInDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var imgLoginIcon: UIImageView!
    @IBOutlet weak var vwLogin: UIView!
    @IBOutlet weak var txtLogin: FloatingTextField!
    
    @IBOutlet weak var imgPasswordIcon: UIImageView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var txtPassword: FloatingTextField!
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblOR: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeValues()
        setThemeColors()
        setLogo()

    }
    
    // MARK: - Initialize
    func initializeValues() {
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        if appURL.contains("jewellery") {
            imgBackground.image = UIImage(named: "background-shapes-jwellery")
        } else {
            imgBackground.image = UIImage(named: "background-shapes")
        }
        
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
        txtLogin.placeholder = getLocalizationString(key: "Email")

        
        txtPassword.textColor = secondaryColor
        txtPassword.font = UIFont.appRegularFontName(size: fontSize14)
        txtPassword.placeholder = getLocalizationString(key: "Password")

        btnForgotPassword.setTitle(getLocalizationString(key: "ForgotPassword"), for: .normal)
        btnForgotPassword.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnForgotPassword.tintColor =  secondaryColor
        
        btnLogin.setTitle(getLocalizationString(key: "Login"), for: .normal)
        btnLogin.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnLogin.backgroundColor = secondaryColor
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height / 2
        btnBack.tintColor =  secondaryColor
        
        lblOR.textColor = secondaryColor
        lblOR.font = UIFont.appRegularFontName(size: fontSize14)
        lblOR.text = getLocalizationString(key: "OR")
        btnSignup.setTitle(getLocalizationString(key: "DontHaveAccount"), for: .normal)
        btnSignup.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
        btnSignup.backgroundColor = .clear
        btnSignup.tintColor =  secondaryColor
        
        
        if isLoginScreen == true {
            btnBack.isHidden = true
        }
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: "13.0") {
            btnApple.isHidden = false
        } else {
            btnApple.isHidden = true
        }
        
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
    
    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        

        showForgotPasswordPopUp(vc: self) {
            //on Reset PasswordP
        }
        
        
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        if txtLogin.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterEmail"))
            return
        }
        
        if !txtLogin.text!.isValidEmail() {
            showToast(message: getLocalizationString(key: "EnterValidEmail"))
            return
        }
        
        if txtPassword.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterPassword"))
            return
        }
        doLogin()
    }
    
    @IBAction func btnFacebookClicked(_ sender: Any) {
        FacebookHelper.shared().getFacebookDetails(vc: self) { (isSuccess,response) in
            
            if isSuccess == false {
                if (response!["error"] as! String) == "1" || (response!["error"] as! String) == "2" || (response!["error"] as! String) == "3" {
                    //do nothing
                    AccessToken.current = nil
                }
            } else {
                if response!["email"] == nil || (response!["email"] as! String) == "" {
                    showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "ProvideEmailToFacebook"), vc: self)
                    AccessToken.current = nil
                } else {
                    
                    let user = JSON(response ?? "")
                    var params = [AnyHashable : Any]()
                    
                    params["email"] = user["email"].string
                    params["social_id"] = user["id"].string
                    params["gender"] = user["gender"].string
                    params["dob"] = user["birthday"].string
                    params["first_name"] = user["first_name"].string
                    params["last_name"] = user["last_name"].string
                    params["device_token"] = strDeviceToken
                    params["device_type"] = "1"
                    
                    if let userProfileUrl = user["picture"]["data"]["url"].string {
                        if userProfileUrl != "" {
                            var profileParams = [AnyHashable : Any]()
                            
                            let imageUrl = userProfileUrl.encodeURL()
                            
                            do {
                                let imageData = try Data(contentsOf: imageUrl)
                                profileParams["name"] = "\(0).jpg"
                                profileParams["data"] = imageData.base64EncodedString(options: .endLineWithLineFeed)
                                
                                params["user_image"] = profileParams
                            } catch {
                                print("Unable to load data: \(error)")
                            }
                        }
                    }
                    
                    self.socialLogin(params: params)
                }
            }
        }
    }
    
    @IBAction func btnGoogleClicked(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self//keyWindow?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
        
        
    }
    
    @available(iOS 13.0, *)
    @IBAction func btnAppleClicked(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func btnSignupClicked(_ sender: Any) {
        let signupVC = SignupVC(nibName: "SignupVC", bundle: nil)
        self.navigationController?.pushViewController(signupVC, animated: true)
        
    }
    
    // MARK: - API Calling
    
    func doLogin() {
        self.view.endEditing(true)
        
        showLoader(vc: self)
        var params = [AnyHashable : Any]()
        params["email"] = self.txtLogin.text
        params["password"] = self.txtPassword.text
        params["device_token"] = strDeviceToken
        params["device_type"] = "1"
        
        CiyaShopAPISecurity.loginCustomer(params) { (success, message, responseData) in
            let jsonReponse = JSON(responseData!)
            if success {
                
                print(jsonReponse)
                if jsonReponse["status"] == "success" {
                    
                    setValueToLocal(key: PASSWORD_KEY, value: self.txtPassword.text as Any)
                    setValueToLocal(key: EMAIL_KEY, value: jsonReponse["user"]["email"].stringValue)
                    setValueToLocal(key: USERNAME_KEY, value: jsonReponse["user"]["username"].stringValue)
                    setValueToLocal(key: USERID_KEY, value: jsonReponse["user"]["id"].stringValue)
                    
                    setValueToLocal(key: USER_FIRST_NAME, value: jsonReponse["user"]["firstname"].stringValue)
                    setValueToLocal(key: USER_LAST_NAME, value: jsonReponse["user"]["lastname"].stringValue)
                    
                    setValueToLocal(key: FB_OR_GOOGLE_KEY, value: false)
                    setValueToLocal(key: LOGIN_KEY, value: true)
                    
                    is_Logged_in = true
                    
                    //sync wishlist
                    
                    if isWishList {
                        if isWishList {
                            self.syncWishlist()
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                } else if jsonReponse["status"] == "error" {
                    is_Logged_in = false
                } else {
                    is_Logged_in = false
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
        
        var arrSyncList = [[AnyHashable : Any]]()
        
        for wishlistItem in arrWishlist {
            
            var dictSyncItem = [AnyHashable : Any]()
            dictSyncItem["product_id"] = wishlistItem["id"].stringValue
            dictSyncItem["quantity"] = "1"
            dictSyncItem["wishlist_name"] = ""
            dictSyncItem["user_id"] = getValueFromLocal(key: USERID_KEY)
            
            arrSyncList.append(dictSyncItem)
        }
        if arrWishlist.count > 0 {
            params["sync_list"] = arrSyncList
        } else {
            params["sync_list"] = []
        }
        
        print(params)
        
        CiyaShopAPISecurity.addAllItem(toWishList : params) { (success, message, responseData) in
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    if let synclist = jsonReponse["sync_list"].array {
                        if synclist.count == 0 {
                            removeAllFromWishlist()
                        }
                    } else {
                        removeAllFromWishlist()
                    }
                } else {
                    removeAllFromWishlist()
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
    
    func socialLogin(params  : [AnyHashable : Any]) {
        showLoader(vc: self)
        
        print(params)
        
        CiyaShopAPISecurity.socialLoginCustomer(params) { (success, message, responseData) in
            let jsonReponse = JSON(responseData!)
            if success {
                
                print(jsonReponse)
                if jsonReponse["status"] == "success" {
                    
                    setValueToLocal(key: EMAIL_KEY, value: jsonReponse["user"]["email"].stringValue)
                    setValueToLocal(key: USERNAME_KEY, value: jsonReponse["user"]["username"].stringValue)
                    setValueToLocal(key: USERID_KEY, value: jsonReponse["user"]["id"].stringValue)
                    
                    setValueToLocal(key: FB_OR_GOOGLE_KEY, value: true)
                    setValueToLocal(key: LOGIN_KEY, value: true)
                    
                    is_Logged_in = true
                    
                    if isWishList {
                        if arrWishlist.count > 0 {
                            self.syncWishlist()
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                } else if jsonReponse["status"] == "error" {
                    is_Logged_in = false
                } else {
                    is_Logged_in = false
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
    
    
    // MARK: - Google Delegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        var params = [AnyHashable : Any]()
        
        params["email"] = user.profile.email
        params["social_id"] = user.userID
        params["gender"] = "-"
        params["dob"] = "-"
        params["first_name"] = user.profile.givenName
        params["last_name"] = user.profile.familyName
        params["device_token"] = strDeviceToken
        params["device_type"] = "1"
        
        if user.profile.hasImage
        {
            var profileParams = [AnyHashable : Any]()
            
            let imageUrl = user.profile.imageURL(withDimension: 100)
            
            do {
                let imageData = try Data(contentsOf: imageUrl! as URL)
                profileParams["name"] = "\(0).jpg"
                profileParams["data"] = imageData.base64EncodedString(options: .endLineWithLineFeed)
                
                params["user_image"] = profileParams
            } catch {
                print("Unable to load data: \(error)")
            }
            
        }
        socialLogin(params: params)
        
    }
}


@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print(error.localizedDescription)
        
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account as per your requirement
            
            let appleId = appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            let appleUserLastName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            
            
            
            var params = [AnyHashable : Any]()
            
            params["email"] = appleUserEmail
            params["social_id"] = appleId
            params["gender"] = "-"
            params["dob"] = "-"
            params["first_name"] = appleUserFirstName
            params["last_name"] = appleUserLastName
            params["device_token"] = strDeviceToken
            params["device_type"] = "1"
            
            socialLogin(params: params)
        }
        
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
        
    }
}
