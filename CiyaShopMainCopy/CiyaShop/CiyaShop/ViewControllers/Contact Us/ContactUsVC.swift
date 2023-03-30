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
import MessageUI

class ContactUsVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwName: UIView!
    @IBOutlet weak var txtName: FloatingTextField!
    
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var txtEmail: FloatingTextField!
    
    @IBOutlet weak var vwContactNumber: UIView!
    @IBOutlet weak var txtContactNumber: FloatingTextField!
    
    @IBOutlet weak var vwSubject: UIView!
    @IBOutlet weak var txtSubject: FloatingTextField!
    
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var txtMessage: FloatingTextField!

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var btnPhoneNumber: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnWebsite: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    
    @IBOutlet weak var lblFollowUS: UILabel!
    @IBOutlet weak var cvSocialData: UICollectionView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    var arrSocial = [JSON]()
    
    //MARK: - Life Cycle methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColors()
        setLogo()
        setContactData()
        setSocialData()
    }

    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
    
        lblTitle.text = getLocalizationString(key: "ContactUs")
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
        
        vwName.backgroundColor = textFieldBackgroundColor//primaryColor
        vwName.layer.borderWidth = 0.5
        vwName.layer.borderColor = secondaryColor.cgColor
        txtName.textColor = secondaryColor
        txtName.font = UIFont.appRegularFontName(size: fontSize14)
        txtName.placeholder = getLocalizationString(key: "Name")
        txtName.keyboardType = .default
        
        vwEmail.backgroundColor = textFieldBackgroundColor//primaryColor
        vwEmail.layer.borderWidth = 0.5
        vwEmail.layer.borderColor = secondaryColor.cgColor
        txtEmail.textColor = secondaryColor
        txtEmail.font = UIFont.appRegularFontName(size: fontSize14)
        txtEmail.placeholder = getLocalizationString(key: "Email")
        txtEmail.keyboardType = .emailAddress
        
        vwContactNumber.backgroundColor = textFieldBackgroundColor//primaryColor
        vwContactNumber.layer.borderWidth = 0.5
        vwContactNumber.layer.borderColor = secondaryColor.cgColor
        txtContactNumber.textColor = secondaryColor
        txtContactNumber.font = UIFont.appRegularFontName(size: fontSize14)
        txtContactNumber.placeholder = getLocalizationString(key: "ContactNumber")
        txtContactNumber.keyboardType = .phonePad
        
        vwSubject.backgroundColor = textFieldBackgroundColor//primaryColor
        vwSubject.layer.borderWidth = 0.5
        vwSubject.layer.borderColor = secondaryColor.cgColor
        txtSubject.textColor = secondaryColor
        txtSubject.font = UIFont.appRegularFontName(size: fontSize14)
        txtSubject.placeholder = getLocalizationString(key: "Subject")
        txtSubject.keyboardType = .default
        
        vwMessage.backgroundColor = textFieldBackgroundColor//primaryColor
        vwMessage.layer.borderWidth = 0.5
        vwMessage.layer.borderColor = secondaryColor.cgColor
        txtMessage.textColor = secondaryColor
        txtMessage.font = UIFont.appRegularFontName(size: fontSize14)
        txtMessage.placeholder = getLocalizationString(key: "Message")
        txtMessage.keyboardType = .default
        

        btnBack.tintColor =  secondaryColor
        
        btnSend.setTitle(getLocalizationString(key: "Send"), for: .normal)
        btnSend.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnSend.backgroundColor = secondaryColor
        btnSend.layer.cornerRadius = btnSend.frame.size.height/2
        
        btnPhoneNumber.setTitle("1234567890", for: .normal)
        btnPhoneNumber.titleLabel?.font = UIFont.appLightFontName(size: fontSize12)
        btnPhoneNumber.setTitleColor(secondaryColor, for: .normal)
        btnPhoneNumber.backgroundColor = .clear
        btnPhoneNumber.tintColor = secondaryColor
        
        btnEmail.setTitle("Contactus@ciyashop.com", for: .normal)
        btnEmail.titleLabel?.font = UIFont.appLightFontName(size: fontSize12)
        btnEmail.setTitleColor(secondaryColor, for: .normal)
        btnEmail.backgroundColor = .clear
        btnEmail.tintColor = secondaryColor
        
        btnWebsite.setTitle("www.ciyashop.com", for: .normal)
        btnWebsite.titleLabel?.font = UIFont.appLightFontName(size: fontSize12)
        btnWebsite.setTitleColor(secondaryColor, for: .normal)
        btnWebsite.backgroundColor = .clear
        btnWebsite.tintColor = secondaryColor
        
        btnAddress.setTitle("Address line 1, Address line 2", for: .normal)
        btnAddress.titleLabel?.font = UIFont.appLightFontName(size: fontSize12)
        btnAddress.setTitleColor(secondaryColor, for: .normal)
        btnAddress.backgroundColor = .clear
        btnAddress.tintColor = secondaryColor
        
        lblFollowUS.text = getLocalizationString(key: "FollowUs")
        lblFollowUS.font = UIFont.appRegularFontName(size: fontSize12)
        lblFollowUS.textColor =  secondaryColor.withAlphaComponent(0.5)
        
        if isRTL {
            
            btnEmail.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            btnPhoneNumber.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            btnWebsite.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            btnAddress.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            
            btnEmail.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            btnPhoneNumber.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            btnWebsite.imageEdgeInsets = UIEdgeInsets(top: 0, left:10, bottom: 0, right: 0)
            btnAddress.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
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
    
    func setContactData() {
        
        btnPhoneNumber.setTitle(strContactUsPhoneNumber, for: .normal)
        btnEmail.setTitle(strContactUsEmail, for: .normal)
        btnWebsite.setTitle(strWebsite, for: .normal)
        btnAddress.setTitle(strContactUsAddress, for: .normal)
    }
    
    
    
    func setSocialData() {
        for socialItem in dictSocialData {
            
            if socialItem.value != "" {
                var socialDict = [String : String]()
                socialDict["socialName"] = socialItem.key
                socialDict["socialLink"] = socialItem.value.stringValue
                arrSocial.append(JSON(socialDict))
            }
        }
        
        cvSocialData.dataSource = self
        cvSocialData.delegate = self
        
        cvSocialData.register(UINib(nibName: "SocialCell", bundle: nil), forCellWithReuseIdentifier: "SocialCell")
        cvSocialData.reloadData()
    }
    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSendClicked(_ sender: Any) {
        
        if txtName.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterName"))
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
        
        if txtSubject.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterSubject"))
            return
        }
        
        if txtMessage.text!.isEmpty {
            showToast(message: getLocalizationString(key: "EnterMessage"))
            return
        }

        sendMessage()
    }
   
    
    @IBAction func btnPhoneNumberClicked(_ sender: Any) {
        let strNumber = "tel://\(strContactUsPhoneNumber)"
        if let url = URL(string: strNumber) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber]];
            } else {
                print("Phone Number not valid")
            }
        }
    }
    
    @IBAction func btnEmailAddressClicked(_ sender: Any) {
        if strContactUsEmail == "" {
            return
        }
        let emailTitle = APP_NAME
        // Email Content
        let messageBody = "Contact us"
        // To address
        let toRecipents = [strContactUsEmail]

        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        present(mc, animated: true)
    }
    
    @IBAction func btnWebsiteClicked(_ sender: Any) {
        if let url = URL(string: strWebsite) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber]];
            } else {
                print("Website not valid")
                showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "WebSiteNotValid"), vc: self)

            }
        }
    }
    
    @IBAction func btnAddressClicked(_ sender: Any) {
        
    }
    
    
    
    // MARK: - API Calling
    
    func sendMessage() {
        showLoader()
        var params = [AnyHashable : Any]()
        
        params["user_id"] = getValueFromLocal(key: USERID_KEY)
        params["name"] = txtName.text
        params["email"] = txtEmail.text
        params["subject"] = txtSubject.text
        params["contact_no"] = txtContactNumber.text
        params["message"] = txtMessage.text
        
        CiyaShopAPISecurity.contactUs(params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    
                    self.txtName.text = ""
                    self.txtEmail.text = ""
                    self.txtSubject.text = ""
                    self.txtContactNumber.text = ""
                    self.txtMessage.text = ""
                    
                    if let message = jsonReponse["message"].string {
                        showCustomAlert(title: APP_NAME,message: message, vc: self)
                    } else {
                        showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "MessageSent"), vc: self)
                    }
                    
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
    
    
    //MARK: - Mail Composer method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription ?? "")")
        default:
            break
        }
        
        dismiss(animated: true)
    }

    
    
}


extension ContactUsVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSocial.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialCell", for: indexPath) as! SocialCell
        
        let socialItem = arrSocial[indexPath.row]
        
        if "facebook" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "facebook-icon")
        } else if "twitter" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "twitter-icon")
        }  else if "linkedin" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "linkedin-icon")
        }  else if "google_plus" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "googleplus-icon")
        }  else if "pinterest" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "pinterest-icon")
        }  else if "instagram" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "instagram-icon")
        } else {
            cell.imgSocialLogo.image = UIImage(named: "website-icon")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30 , height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalCellWidth = 30 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)

        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let socialItem = arrSocial[indexPath.row]
        let url =  socialItem["socialLink"].stringValue
        openUrl(strUrl: url)
    }
    
}


