//
//  AccountVC.swift
//  CiyaShop
//
//  Created by Apple on 12/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework
import GoogleSignIn
import FBSDKLoginKit

class AccountVC: UIViewController {

    @IBOutlet weak var tblAccountDetails: UITableView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    
    
    var arrIconData = Array<String>()
    var arrPagesData = Array<Any>()
    
    var selectedCurrency : JSON?
    var selectedLanguage : JSON?
    
    var strWalletBalance = "0.0"
    var strWalletBalanceCurrency = ""
    var dictWallet = JSON()

    // MARK: - Life Cycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThemeColors()
        setHeader()
        setAccountData()
        registerDatasourceCell()
        initialize()

        NotificationCenter.default.addObserver(self, selector: #selector(self.redirectMyOrders), name: NSNotification.Name(rawValue: REDIRECT_MY_ORDERS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.redirectMyCoupons), name: NSNotification.Name(rawValue: REDIRECT_MY_COUPONS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadNotificationSwitch), name: NSNotification.Name(rawValue: RELOAD_NOTIFICATION_SWITCH), object: nil)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        getInfoPages()
        if(is_Logged_in && isTeraWalletActive)
        {
            getWalletBalance()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Themes Methods
    func  initialize() {
        
        for currencyItem in arrCurrency {
            if let currencyText = getValueFromLocal(key: kCurrencyText) as? String {
                if currencyItem["name"].string == currencyText {
                    selectedCurrency = currencyItem
                    break
                }
            }
        }
        
        
    }
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        self.lblHeaderTitle.textColor = secondaryColor
        btnMenu.tintColor =  secondaryColor
    }
    
    func setHeader()  {
        
        self.lblHeaderTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblHeaderTitle.text = getLocalizationString(key: "Account")
    }

    func setAccountData()  {
        arrIconData = Array<String>()
        arrIconData.append(getLocalizationString(key: "Login"))
        if(is_Logged_in && isTeraWalletActive)
        {
            arrIconData.append(getLocalizationString(key: "Wallet"))
            
        }
        
        if isCatalogMode == false {
            arrIconData.append(getLocalizationString(key: "MyOrders"))
        }
        arrIconData.append(getLocalizationString(key: "MyAddresses"))
        if arrCurrency.count > 1 && isCurrencySet {
            arrIconData.append(getLocalizationString(key: "ChooseCurrency"))
        }
        
        if arrWpmlLanguages.count > 1 && isWpmlActive {
            arrIconData.append(getLocalizationString(key: "ChooseLanguage"))
        }
        
        arrPagesData = Array<String>()
        if IS_DOWNLOADABLE {
            arrPagesData.append(getLocalizationString(key: "Download"))
        }
        arrPagesData.append(getLocalizationString(key: "MyCoupons"))
        
        if isMyRewardPointsActive {
            arrPagesData.append(getLocalizationString(key: "MyPoints"))
        }
        
        arrPagesData.append(getLocalizationString(key: "AboutUs"))
        arrPagesData.append(getLocalizationString(key: "Accountsettings"))
        arrPagesData.append(getLocalizationString(key: "Notification"))
        arrPagesData.append(getLocalizationString(key: "ContactUs"))
        arrPagesData.append(getLocalizationString(key: "RatetheApp"))
        arrPagesData.append(getLocalizationString(key: "ClearHistory"))
        
    }
    
    func registerDatasourceCell()  {
        
        tblAccountDetails.delegate = self
        tblAccountDetails.dataSource = self
        
        tblAccountDetails.register(UINib(nibName: "AccountItemCell", bundle: nil), forCellReuseIdentifier: "AccountItemCell")
        tblAccountDetails.register(UINib(nibName: "UserProfileCell", bundle: nil), forCellReuseIdentifier: "UserProfileCell")
        
        
        tblAccountDetails.estimatedRowHeight = 40
        tblAccountDetails.rowHeight = UITableView.automaticDimension
        
        self.tblAccountDetails.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
        self.tblAccountDetails.sectionFooterHeight = 0
        
        self.tblAccountDetails.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.tblAccountDetails.reloadData()
    }
    
    // MARK: - Notification Handling
    @objc func redirectCoupons() {
        
    }
    
    // MARK: - APIs Caling
    
    func getInfoPages() {
        showLoader()
        CiyaShopAPISecurity.getInfoPages(nil) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                //wallet response
                let responsePages  = jsonReponse["data"].arrayObject!
                
                
                
                for pageInfo in responsePages{
                    if let page = pageInfo as? [AnyHashable:Any] {
                        var isPageExists = false
                        for infoPage in self.arrPagesData {
                            if let item = infoPage as? [AnyHashable:Any] {
                                if item["page_id"] as? String == page["page_id"] as? String {
                                    isPageExists = true
                                }
                            }
                        }
                        if isPageExists == false {
                            self.arrPagesData.append(page)
                        }
                    }
                }
                
               
                
            }

            self.tblAccountDetails.reloadData()
            hideLoader()
            
            if is_Logged_in == true && dictLoginData.count == 0 {
                self.getClientInfo()
            }
        }
       
    }
    
    func getClientInfo() {
        showLoader()
        var params = [AnyHashable : Any]()
        params["user_id"] = getValueFromLocal(key: USERID_KEY)
        
        CiyaShopAPISecurity.getCustomerDetail(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                
                dictLoginData = jsonReponse
                self.tblAccountDetails.reloadData()
                                
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
    
    func uploadiImage(selectedImage: UIImage) {
        showLoader()
        
        
        var params = [AnyHashable : Any]()
        params["user_id"] = getValueFromLocal(key: USERID_KEY)
        
    
        let low_bound: Float = 0
        let high_bound: Float = 5000
        let rndValue = (Float(arc4random()) / 0x100000000) * (high_bound - low_bound) + low_bound //image1
        let intRndValue = Int(rndValue + 0.5)
        let image_name = NSNumber(value: intRndValue).stringValue
        
        var profileParams = [AnyHashable : Any]()
        
        let imageData = selectedImage.jpegData(compressionQuality: 0.5) //Data(contentsOf: selectedImage as URL)
        profileParams["name"] = "\(image_name).jpg"
        profileParams["data"] = imageData!.base64EncodedString(options: .lineLength76Characters)
        
        
        params["user_image"] = profileParams
        
        
        CiyaShopAPISecurity.updateCustomerImage(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                
                self.getClientInfo()
                print(jsonReponse)
            } else {
                let jsonReponse = JSON(responseData!)
                if let message = jsonReponse["message"].string {
                    showCustomAlert(title: APP_NAME,message: message, vc: self)
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                }
            }
            
            hideLoader()
        }
        
    }
    
    
    func changeNotification(status: String) {
        showLoader()
        var params = [AnyHashable : Any]()
        params["device_token"] = strDeviceToken
        params["device_type"] = "1"
        params["status"] = status
        
        CiyaShopAPISecurity.changeNotification(params) { (success, message, responseData) in
            hideLoader()
            
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    if status == "1" {
                        setValueToLocal(key: kNotification, value: "On")
                    } else {
                        setValueToLocal(key: kNotification, value: "Off")
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
    func getWalletBalance() {
        showLoader()
        
        
        let url = "\(OTHER_API_PATH)wallet"

        let params : [AnyHashable:Any] = ["user_id": "\(getValueFromLocal(key: USERID_KEY) ?? "")"]

        print("Get wallet balance url - ",url)
        print("params - ",params)
        

        CiyaShopAPISecurity.postAPICall(url, dictParams: params) { (success, message, responseData) in
            
            
            let jsonReponse = JSON(responseData!)
            if success {
                //wallet response
                print("Wallet response - ",jsonReponse)

                let data = jsonReponse
                self.strWalletBalance = data["balance"].stringValue
                self.strWalletBalanceCurrency = data["currency"].stringValue
                self.dictWallet = data
                self.tblAccountDetails.reloadSections(IndexSet(integer: 0), with: .none)

            }
            
            else {
                let jsonReponse = JSON(responseData!)
                if let message = jsonReponse["message"].string {
                    showCustomAlert(title: APP_NAME,message: message, vc: self)
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                }
            }
            
            hideLoader()
        }
        
        
       
       
    }
    // MARK: - profile change icon
    @objc func btnEditProfileImage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: getLocalizationString(key: "Camera"), style: .default) { (action) in
            self.showImagePicker(souceType: .camera)
        }
        
        let gallery = UIAlertAction(title: getLocalizationString(key: "Gallery"), style: .default) { (action) in
            self.showImagePicker(souceType: .photoLibrary)
        }
        let cancel = UIAlertAction(title: getLocalizationString(key: "Cancel"), style: .cancel) { (action) in
            
        }
         
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension AccountVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func showImagePicker(souceType : UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = souceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - UIimagepicker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImg = info[.editedImage] as? UIImage
        
        picker.dismiss(animated: true) {
            self.uploadiImage(selectedImage: selectedImg!)
        }
    }
    
    
}

extension AccountVC : UITableViewDelegate,UITableViewDataSource  {
     
    // MARK: - UITableview Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 1;
        } else if section == 1 {
            return self.arrIconData.count
        } else if section == 2 {
            return self.arrPagesData.count;
        }
        return 0;
    }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
     
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return 100
     }
     
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         if section == 0  {
             return CGFloat.leastNormalMagnitude
         }
         return 16
     }
     
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        borderTableviewSection(tableView: tableView, indexPath: indexPath,cell: cell)
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
            cell.selectionStyle = .none
            
            if is_Logged_in == true {
                cell.imgEdit.isHidden = false
                cell.lblName.text = dictLoginData["first_name"].stringValue + " " +  dictLoginData["last_name"].stringValue
                
                if let metaData = dictLoginData["meta_data"].array {
                    for item in metaData {
                        if item["key"] == "mobile" {
                           cell.lblPhone.text = item["value"].stringValue
                            break
                        }
                    }
                }
                
                cell.lblEmail.text = dictLoginData["email"].stringValue
                
                if(is_Logged_in && isTeraWalletActive)
                {
                    cell.lblWalletBalance.text = MCLocalization.string(for: "WalletBalance")! + " : " + "\(strWalletBalance) \(strWalletBalanceCurrency.htmlEncodedString())"
                    
                    cell.lblWalletBalance.isHidden = false
                }else{
                    cell.lblWalletBalance.isHidden = true
                    cell.constraintHeightWalletBalance.constant = 0
                }
                
                
                if let imageUrl = dictLoginData["pgs_profile_image"].string {
                    cell.imgProfile.sd_setImage(with: imageUrl.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                        if (image == nil) {
                            cell.imgProfile.image = UIImage(named: "imgUserProfile")
                        }
                    }
                }
                
                cell.btnEditProfileImage.addTarget(self, action: #selector(btnEditProfileImage), for: .touchUpInside)

            } else {
                cell.imgEdit.isHidden = true
                cell.lblName.text = ""
                cell.lblPhone.text = ""
                cell.lblEmail.text = ""
                
                cell.imgProfile.image = UIImage(named: "imgUserProfile")
                cell.btnEditProfileImage.removeTarget(self, action: nil, for: .touchUpInside)
            }
            
            
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountItemCell", for: indexPath) as! AccountItemCell
            cell.selectionStyle = .none
            
            if arrIconData[indexPath.row] == getLocalizationString(key: "Login") {
                cell.imgIcon.image = UIImage(named: "login-icon")
            }else if arrIconData[indexPath.row] == getLocalizationString(key: "Wallet") {
                cell.imgIcon.image = UIImage(named: "wallet-icon")
            }
            else if arrIconData[indexPath.row] == getLocalizationString(key: "MyOrders") {
                cell.imgIcon.image = UIImage(named: "cart-icon")
            } else if arrIconData[indexPath.row] == getLocalizationString(key: "MyAddresses") {
                cell.imgIcon.image = UIImage(named: "address-icon")
            } else if arrIconData[indexPath.row] == getLocalizationString(key: "ChooseCurrency") {
                cell.imgIcon.image = UIImage(named: "currancy-icon")
            } else if arrIconData[indexPath.row] == getLocalizationString(key: "ChooseLanguage") {
                cell.imgIcon.image = UIImage(named: "language-icon")
            } else {
                cell.imgIcon.image = UIImage()
            }
            
            if arrIconData[indexPath.row] == getLocalizationString(key: "Login") {
                if is_Logged_in == true {
                    cell.lblTitle.text = getLocalizationString(key: "SignOut")
                }
                else {
                    cell.lblTitle.text = arrIconData[indexPath.row]
                }
            } else {
                cell.lblTitle.text = arrIconData[indexPath.row]
            }
            
            cell.lblTitle.font = UIFont.appBoldFontName(size: fontSize13)
            cell.imgLeadingContraint.constant = 20
            cell.switchNotification.isHidden = true
            return cell
         } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountItemCell", for: indexPath) as! AccountItemCell
            cell.selectionStyle = .none
            
            cell.imgIcon.image = UIImage()
            cell.lblTitle.font = UIFont.appLightFontName(size: fontSize13)
            cell.imgLeadingContraint.constant = -12
            cell.switchNotification.isHidden = true
            
            if let item = arrPagesData[indexPath.row] as? String {
                cell.lblTitle.text = item
                if item == getLocalizationString(key: "Notification") {
                    cell.switchNotification.isHidden = false
                    cell.switchNotification.addTarget(self, action: #selector(switchNotificationChanged(_:)), for: .valueChanged)
                    
                    if let notificationEnabled = getValueFromLocal(key: kNotification) as? String {
                        if notificationEnabled == "On" {
                            cell.switchNotification.setOn(true, animated: false)
                        } else {
                            cell.switchNotification.setOn(false, animated: false)
                        }
                    } else {
                        cell.switchNotification.setOn(false, animated: false)
                    }
                    
                    notificationStatus(completion: { authorized in
                        print("authorized = \(authorized)")
                     
                         if(authorized)
                         {
                            cell.switchNotification.isUserInteractionEnabled = true
                         }else{
                            cell.switchNotification.isUserInteractionEnabled = false
                            cell.switchNotification.setOn(false, animated: false)
                         }
                    }
                 )
                }
            }
            else {
                if let item = arrPagesData[indexPath.row] as? [AnyHashable:Any] {
                    cell.lblTitle.text = item["title"] as? String
                } else {
                    cell.lblTitle.text = ""
                }
            }
            
            
            return cell
         }
         
         
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        if indexPath.section == 0 {
            return;
        }
        
        if indexPath.section == 1 {
            
            if arrIconData[indexPath.row] == getLocalizationString(key: "Login") {
                if is_Logged_in == true {
                    signOut()
                } else {
                    redirectLogin()
                }
            } else if arrIconData[indexPath.row] == getLocalizationString(key: "MyOrders") {
                
                redirectMyOrders()
                
            }
            else if arrIconData[indexPath.row] == getLocalizationString(key: "Wallet") {
                
                redirectToTransactionList()
                
            }
            else if arrIconData[indexPath.row] == getLocalizationString(key: "MyAddresses") {
                
                if is_Logged_in == true {
                    let myAddressesVC = MyAddressesVC(nibName: "MyAddressesVC", bundle: nil)
                    self.navigationController?.pushViewController(myAddressesVC, animated: true)
                } else {
                    redirectLogin()
                }
                
            } else if arrIconData[indexPath.row] == getLocalizationString(key: "ChooseCurrency") {
                
                self.view.endEditing(true)
                
                if arrCurrency.count > 0 {
                    showListView(arrCurrency, title: getLocalizationString(key: "ChooseCurrency"), toView: self, selectedValue: selectedCurrency != nil ? selectedCurrency!["name"].stringValue : "", isCustomKey: true, customKeyName: "name") { (selectedCurrency) in
                        if selectedCurrency == self.selectedCurrency {
                            return;
                        }
                        self.selectedCurrency = selectedCurrency
                        
                        setValueToLocal(key: kCurrency, value: true)
                        setValueToLocal(key: kCurrencyText, value: "?currency=" + selectedCurrency["name"].string!)

                        arrRecentlyViewedItems.removeAll()
                        storeJSONToLocal(key: RECENT_ITEM_KEY, value: arrRecentlyViewedItems.description as Any)
                        
                        removeAllFromCart()
  
                        setOauthData()
                        tabController?.selectedIndex = 2
                        NotificationCenter.default.post(name: Notification.Name(rawValue: REFRESH_HOME_DATA), object: nil)
                    }
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "NoCurrencyFound"), vc: self)
                }
                
                
            } else if arrIconData[indexPath.row] == getLocalizationString(key: "ChooseLanguage") {
                if arrWpmlLanguages.count > 0 {
                    showListView(arrWpmlLanguages, title: getLocalizationString(key: "ChooseLanguage"), toView: self, selectedValue: selectedCurrency != nil ? selectedLanguage!["name"].stringValue : "", isCustomKey: true, customKeyName: "translated_name") { (selectedLanguage) in
                        if selectedLanguage == self.selectedLanguage {
                            return;
                        }
                        self.selectedLanguage = selectedLanguage
                        
                        setValueToLocal(key: kLanguage, value: true)
                        setValueToLocal(key: kLanguageText, value: selectedLanguage["code"].string!)
                        
                        if let is_rtl = selectedLanguage["is_rtl"].bool {
                            isRTL = is_rtl
                        } else {
                            isRTL = false
                        }
                        
                        MCLocalization.sharedInstance.language = selectedLanguage["site_language"].stringValue
                        
                        setOauthData()
                        tabController?.selectedIndex = 2
                        NotificationCenter.default.post(name: Notification.Name(rawValue: REFRESH_HOME_DATA), object: nil)
                        
                    }
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "NoLanguageFound"), vc: self)
                }
            } else {
                
            }
        } else {
            if arrPagesData[indexPath.row] as? String == getLocalizationString(key: "MyCoupons") {
                
                redirectMyCoupons()
                
            } else if arrPagesData[indexPath.row] as? String == getLocalizationString(key: "MyPoints") {
                
                if is_Logged_in == true {
                    let myPointsVC = MyPointsVC(nibName: "MyPointsVC", bundle: nil)
                    self.navigationController?.pushViewController(myPointsVC, animated: true)
                } else {
                    redirectLogin()
                }
                
            } else if arrPagesData[indexPath.row] as? String == getLocalizationString(key: "AboutUs") {
                
                let aboutUsVC = AboutUsVC(nibName: "AboutUsVC", bundle: nil)
                self.navigationController?.pushViewController(aboutUsVC, animated: true)
                
            } else if arrPagesData[indexPath.row] as? String == getLocalizationString(key: "Accountsettings") {
                
                if is_Logged_in == true {
                    let accountSetting = AccountSettingVC(nibName: "AccountSettingVC", bundle: nil)
                    self.navigationController?.pushViewController(accountSetting, animated: true)
                } else {
                    redirectLogin()
                }
                
            }
            else if arrPagesData[indexPath.row] as? String == getLocalizationString(key: "Notification") {
                
                
                notificationStatus(completion: { authorized in
                       print("authorized = \(authorized)")
                    
                        if(authorized)
                        {
                           
                        }else{
                            showCustomAlertWithConfirm(title: APP_NAME, message: getLocalizationString(key: "NotificationPermission"), vc: self, yesButtonTitle: getLocalizationString(key: "Setting"), noButtonTitle: getLocalizationString(key: "Cancel")) {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                   }
                )
                
            }
            else if arrPagesData[indexPath.row] as? String == getLocalizationString(key: "ContactUs") {
                
                let contactUsVC = ContactUsVC(nibName: "ContactUsVC", bundle: nil)
                self.navigationController?.pushViewController(contactUsVC, animated: true)

            }
            else if arrPagesData[indexPath.row] as? String == getLocalizationString(key: "RatetheApp") {
                
                if iosAppUrl != "" {
                    openUrl(strUrl: iosAppUrl)
                }
                else{
                    showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "RatingURLNotAvailable"), vc: self)
                }
            }
            else if arrPagesData[indexPath.row] as? String == getLocalizationString(key: "ClearHistory") {
                
                showCustomAlertForClearHistroyWithConfirm(title: getLocalizationString(key: "ClearHistory"), message: getLocalizationString(key: "ClearHistoryAlert"), vc: self) {
                    
                    arrRecentSearch.removeAll()
                    setValueToLocal(key: SEARCH_KEY, value: arrRecentSearch)
                    
                    arrRecentlyViewedItems.removeAll()
                    storeJSONToLocal(key: RECENT_ITEM_KEY, value: arrRecentlyViewedItems.description as Any)
                    
                    setValueToLocal(key: kLanguage, value: false)
                    setValueToLocal(key: kLanguageText, value: "")
                    
                    setOauthData()

                    tabController?.selectedIndex = 2
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: REFRESH_HOME_DATA), object: nil)
                    
                }
                
            }
            else if arrPagesData[indexPath.row] as? String == getLocalizationString(key: "Download") {
                
                if is_Logged_in == true {
                    let downloadVC = DownloadVC(nibName: "DownloadVC", bundle: nil)
                    self.navigationController?.pushViewController(downloadVC, animated: true)
                } else {
                    redirectLogin()
                }
            }
            else if let dictPage =  arrPagesData[indexPath.row]  as? [AnyHashable:Any]  {
                 let contentPageVC = ContentPageVC(nibName: "ContentPageVC", bundle: nil)
                contentPageVC.pageId = Int(dictPage["page_id"] as! String)
                contentPageVC.strTitle = (dictPage["title"] as! String)
                self.navigationController?.pushViewController(contentPageVC, animated: true)
            }
            else {
                //other
            }
        }
         
     }
    
    // MARK: - Switch notification
    
    @IBAction func switchNotificationChanged(_ sender: Any)  {
        let notificationSwitch = sender as! UISwitch
        
        if notificationSwitch.isOn {
            changeNotification(status: "1")
        } else {
            changeNotification(status: "2")
        }
        
    }
    
    
    // MARK: - Sign Out
    
    func signOut() {
        
        showCustomAlertWithConfirm(title: APP_NAME, message: getLocalizationString(key: "signoutAlert"), vc: self) {
            self.removeLoginData()
        }
    }
    
    func removeLoginData() {
        dictLoginData = JSON()
        GIDSignIn.sharedInstance()?.signOut()
        AccessToken.current = nil
        
        is_Logged_in = false
        setValueToLocal(key: FB_OR_GOOGLE_KEY, value: false)
        setValueToLocal(key: LOGIN_KEY, value: false)
        
        setValueToLocal(key: EMAIL_KEY, value: "")
        setValueToLocal(key: USERNAME_KEY, value: "")
        setValueToLocal(key: USERID_KEY, value: "")
        setValueToLocal(key: USER_FIRST_NAME, value: "")
        setValueToLocal(key: USER_LAST_NAME, value: "")
        
        tblAccountDetails.reloadData()
        
        
        removeAllSearchStringsFromLocal()
        

        removeCookies()
        
        if isLoginScreen {
            redirectLogin()
        }
        
        
    }
    
    // MARK: - Redirect Login
    
    func redirectLogin() {
        DispatchQueue.main.async {
            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
            let loginNavigationController = UINavigationController(rootViewController: loginVC)
            loginNavigationController.navigationBar.isHidden = true
            loginNavigationController.modalPresentationStyle = .fullScreen
            keyWindow?.rootViewController!.present(loginNavigationController, animated: true, completion: nil)
        }
    }
    
    @objc func redirectMyOrders() {
        
        if is_Logged_in == true {
            let myOrdersVC = MyOrdersVC(nibName: "MyOrdersVC", bundle: nil)
            self.navigationController?.pushViewController(myOrdersVC, animated: true)
        } else {
            redirectLogin()
        }
    }
    @objc func redirectToWalletTopUpPage() {
        
        if is_Logged_in == true {
            let webviewVC = WebviewVC(nibName: "WebviewVC", bundle: nil)
            webviewVC.url = dictWallet["topup_page"].stringValue
            self.navigationController?.pushViewController(webviewVC, animated: true)
        } else {
            redirectLogin()
        }
    }
    @objc func redirectToTransactionList() {
        
        if is_Logged_in == true {
            let walletTransactionsVC = WalletTransactionsVC(nibName: "WalletTransactionsVC", bundle: nil)
            walletTransactionsVC.arrayTransactions = dictWallet["transactions"].arrayValue
            walletTransactionsVC.dictWallet = dictWallet
            
            walletTransactionsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(walletTransactionsVC, animated: true)
        } else {
            redirectLogin()
        }
    }
    @objc func redirectMyCoupons() {
        
        let couponsVC = CouponsVC(nibName: "CouponsVC", bundle: nil)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(couponsVC, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
    @objc func reloadNotificationSwitch() {
        self.tblAccountDetails.reloadData()
    }
    
    
}
