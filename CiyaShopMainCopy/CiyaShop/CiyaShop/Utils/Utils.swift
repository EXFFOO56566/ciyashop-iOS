//
//  Utils.swift
//  CiyaShop
//
//  Created by Apple on 10/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework

import Firebase

func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
}


// MARK:- View Color

func setBackgroundColorToView(view : UIView){
    view.backgroundColor = headerColor
}

//MARK:- Price Formatter
func priceFormatter(price:NSNumber) -> String
{
    let numberFormatter = NumberFormatter()
    numberFormatter.currencySymbol = strCurrencySymbol
    numberFormatter.minimumFractionDigits = decimalPoints
    numberFormatter.maximumFractionDigits = decimalPoints
    numberFormatter.numberStyle = .currencyAccounting
    numberFormatter.currencyGroupingSeparator = strThousandSeparatore

    return numberFormatter.string(from: price)!
}
//MARK:- Get Base64
func getBase64(string:String) -> String
{
    let encoded = string.data(using: .utf8)?.base64EncodedString()
    return encoded ?? ""
}


// MARK:- NSUserDefault Methods

func setValueToLocal(key : String , value : Any) {
    UserDefaults.standard.set(value, forKey: key)
}

func getValueFromLocal(key : String) -> Any? {
    if let value = UserDefaults.standard.object(forKey: key) {
        return value
    }
    return nil
}

func storeJSONToLocal(key : String , value : Any) {
    UserDefaults.standard.set(value, forKey: key)
}

func getJSONFromLocal(key : String) -> Any? {
    if let jsonObject = UserDefaults.standard.object(forKey: key) as? String {
        let data = jsonObject.data(using: .utf8)!
        if let jsonArray = try! JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
           return jsonArray
        } else {
            return nil
        }
    }
    return nil
}

// MARK:- Localization Methods
func getLocalizationString(key:String) -> String
{
    return MCLocalization.string(for: key) ?? ""
}

// MARK:- Loader Methods
func showLoader(vc: UIViewController? = nil) {
    
    let loaderVC = LoaderVC(nibName: "LoaderVC", bundle: nil)
    loaderVC.view.tag = 123456789
    loaderVC.view.frame = (keyWindow?.rootViewController!.view.bounds)!
    if vc != nil {
        vc?.view.addSubview(loaderVC.view)
        vc?.view.bringSubviewToFront(loaderVC.view)
    } else {
        keyWindow!.rootViewController?.view.addSubview(loaderVC.view)
        keyWindow!.rootViewController?.view.bringSubviewToFront(loaderVC.view)
    }
    
}

func hideLoader(vc: UIViewController? = nil)  {
    
    let arrayViews : [UIView]?
    if vc != nil {
       arrayViews = (vc?.view.subviews)!
    } else {
        arrayViews = (keyWindow?.rootViewController?.view.subviews)!
    }
       
    for subview in arrayViews! {
        if subview.tag == 123456789 {
            subview.removeFromSuperview();
            break;
        }
    }
}

func removeCookies(){
    let cookieJar = HTTPCookieStorage.shared

    for cookie in cookieJar.cookies! {
        cookieJar.deleteCookie(cookie)
    }
}


// MARK:- Change Status bar color
func setStatusBar()  {
    
    if #available(iOS 13.0, *) {
        let statusBar = UIView(frame: (keyWindow?.windowScene?.statusBarManager!.statusBarFrame)!)

        statusBar.backgroundColor = headerColor
        keyWindow!.addSubview(statusBar)
    }
    else
    {
        let statusBar = UIApplication.shared.value(forKeyPath:
            "statusBarWindow.statusBar") as? UIView
        statusBar!.backgroundColor = headerColor
    }
}

// MARK:- Date Methods

func convertCurrencyFormat(value : Double) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.currencySymbol = ""
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    currencyFormatter.minimumFractionDigits = 0
    currencyFormatter.maximumFractionDigits = decimalPoints

    let strValue = currencyFormatter.string(from: NSNumber(value: value))!
    print("Formated value - ",strValue)
    return strValue
}
func priceFormatter(priceValue : Double) -> String
{
    return String(format: "%.*f", decimalPoints,priceValue)
}

func getFormattedPrice(regularPrice:Double,salePrice:Double) -> NSAttributedString
{
    var attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: " \(priceFormatter(priceValue: regularPrice)) \(strCurrencySymbol)")
    attributeString.addAttribute(.foregroundColor, value: grayTextColor, range: NSRange(location: 0, length: attributeString.length))
    attributeString = attributeString.string.SetAttributedString(color: grayTextColor, font: UIFont.appBoldFontName(size: fontSize12),strikeThrough:true)

    //-----
    let saleAttributed : NSMutableAttributedString =  NSMutableAttributedString(string: " \(priceFormatter(priceValue: salePrice)) \(strCurrencySymbol)")
    saleAttributed.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: saleAttributed.length))
    saleAttributed.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: saleAttributed.length))

    //--
    let combination = NSMutableAttributedString()
    combination.append(saleAttributed)
    combination.append(attributeString)
    
    return combination
}

func convertStringToDate(strDate : String,formatter : String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formatter == "" ? "yyyy-MM-dd'T'HH:mm:ss" : formatter
    dateFormatter.timeZone = NSTimeZone.local //TimeZone.autoupdatingCurrent
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    guard let date = dateFormatter.date(from: strDate) else {
        return nil
    }
    return date
}

func convertDateToString(date : Date,formatter : String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formatter == "" ? "yyyy-MM-dd'T'HH:mm:ss" : formatter
    dateFormatter.timeZone = NSTimeZone.local //TimeZone.autoupdatingCurrent
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let strDate = dateFormatter.string(from: date)
    return strDate
}


// MARK:-  create IndexPath array
func createIndexPathArray(row: Int , section : Int) -> [IndexPath] {
    var indexPaths: [IndexPath] = []
    indexPaths.append(IndexPath(item: row, section: section))
    return indexPaths
}


// MARK: - Show Custom Alert

func showCustomAlert(title : String, message : String, vc : UIViewController,onConfirm: onConfirmBlock? = nil, cancelButtonTitle: String? = nil)
{
    let customAlert = Bundle.main.loadNibNamed("CustomAlertView", owner: vc, options: nil)?.first as! CustomAlertView
    customAlert.frame = vc.view.bounds
    customAlert.lblTitle.text = title
    customAlert.lblDescription.text = message
    customAlert.vwConfirmation.isHidden = true
    customAlert.setThemeColors()
    customAlert.onConfirm = onConfirm
    
    if cancelButtonTitle != nil {
        customAlert.btnCancel.setTitle(cancelButtonTitle, for: .normal)
    }
    
    vc.view.addSubview(customAlert)
    

    addAlertAnimation(view: customAlert, blurView: customAlert.blurView)
}

func showCustomAlertWithConfirm(title : String, message : String, vc : UIViewController, yesButtonTitle: String? = nil,noButtonTitle: String? = nil, onConfirm: @escaping onConfirmBlock)
{
    let customAlert = Bundle.main.loadNibNamed("CustomAlertView", owner: vc, options: nil)?.first as! CustomAlertView
    customAlert.frame = vc.view.bounds
    customAlert.lblTitle.text = title
    customAlert.lblDescription.text = message
    customAlert.btnCancel.isHidden = true
    customAlert.onConfirm = onConfirm
    customAlert.setThemeColors()
    
    if yesButtonTitle != nil {
        customAlert.btnYes.setTitle(yesButtonTitle, for: .normal)
    }
    if noButtonTitle != nil {
        customAlert.btnNo.setTitle(noButtonTitle, for: .normal)
    }
    
    
    vc.view.addSubview(customAlert)
    

    addAlertAnimation(view: customAlert, blurView: customAlert.blurView)
    
}

func showCustomAlertForClearHistroyWithConfirm(title : String, message : String, vc : UIViewController,onConfirm: @escaping onConfirmBlock)
{
    let customAlert = Bundle.main.loadNibNamed("CustomAlertView", owner: vc, options: nil)?.first as! CustomAlertView
    customAlert.frame = vc.view.bounds
    customAlert.lblTitle.text = title
    customAlert.lblDescription.text = message
    customAlert.btnCancel.isHidden = true
    customAlert.btnNo.setTitle(getLocalizationString(key: "Cancel"), for: .normal)
    customAlert.btnYes.setTitle(getLocalizationString(key: "Clear"), for: .normal)
    customAlert.onConfirm = onConfirm
    customAlert.setThemeColors()
    vc.view.addSubview(customAlert)

    addAlertAnimation(view: customAlert, blurView: customAlert.blurView)
    
}

func showVariationPopUp(vc : UIViewController,product: JSON)
{
    let customAlert = Bundle.main.loadNibNamed("VariationsVC", owner: vc, options: nil)?.first as! VariationsVC
    customAlert.frame = vc.view.bounds
    customAlert.dictDetail = product
    customAlert.setUpData()
    
    vc.view.addSubview(customAlert)

    addAlertAnimation(view: customAlert, blurView: customAlert.blurView)
    
}

func showGroupProductsPopUp(vc : UIViewController,groupItems : [JSON])
{
    let customAlert = Bundle.main.loadNibNamed("GroupProductsVC", owner: vc, options: nil)?.first as! GroupProductsVC
    customAlert.arrGroupItems = groupItems
    customAlert.frame = vc.view.bounds
    vc.view.addSubview(customAlert)
    
    addAlertAnimation(view: customAlert, blurView: customAlert.blurView)
}


func showForgotPasswordPopUp(vc : UIViewController,onConfirm: @escaping onConfirmBlock)
{
    let customAlert = Bundle.main.loadNibNamed("ForgotPasswordVC", owner: vc, options: nil)?.first as! ForgotPasswordVC
    customAlert.frame = vc.view.bounds
    customAlert.onSetNewPassword = onConfirm;
    vc.view.addSubview(customAlert)
    
    addAlertAnimation(view: customAlert, blurView: customAlert.blurView)
    
}

func showVerificationPopUp(vc : UIViewController,strVerificationToken : String, strPhoneNumber : String, strUserId : String, onConfirm: @escaping onConfirmBlock)
{
    let customAlert = Bundle.main.loadNibNamed("VerificationCodeVC", owner: vc, options: nil)?.first as! VerificationCodeVC
    customAlert.frame = vc.view.bounds
    customAlert.verificationId = strVerificationToken
    customAlert.strPhoneNumber = strPhoneNumber
    customAlert.strUserId = strUserId
    customAlert.onValidateOTP = onConfirm
    vc.view.addSubview(customAlert)
    
    addAlertAnimation(view: customAlert, blurView: customAlert.blurView)
}



func addAlertAnimation(view : UIView, blurView : UIView ) {
    view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
       blurView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
       UIView.animate(withDuration: 0.3, animations: {
           view.transform = .identity
       }) { (animated) in
           blurView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
       }
}


// MARK: - Show Alert List

func showListView(_ listdata : [JSON]  , title : String, toView : UIViewController,selectedValue : String ,completion: @escaping CompletionSingleSelectBlock)
{
    let viewlist = Bundle.main.loadNibNamed("listDataView", owner: toView, options: nil)?.first as! listDataView
    viewlist.completionSingle = completion
    viewlist.selectedValue = selectedValue
    addListView(viewlist, listdata: listdata, title: title, toView: toView)
}

func showListView(_ listdata : [JSON] , title : String, toView : UIViewController,selectedValue : String , isCustomKey:Bool = false, customKeyName:String = "", completion: @escaping CompletionSingleSelectBlock)
{
    let viewlist = Bundle.main.loadNibNamed("listDataView", owner: toView, options: nil)?.first as! listDataView
    viewlist.completionSingle = completion
    viewlist.isCustomKey = isCustomKey
    viewlist.strCustomKeyName = customKeyName
    viewlist.selectedValue = selectedValue
    addListView(viewlist, listdata: listdata, title: title, toView: toView)
}

func addListView(_ viewlist : listDataView, listdata : [JSON] , title : String, toView : UIViewController)  {
    
    viewlist.frame = toView.view.bounds
    viewlist.listData = listdata
    viewlist.titleLabel.text = title
    viewlist.tableview.reloadData()
    viewlist.tableviewHeightConstraint.constant =  CGFloat(listdata.count * (isIPad ? 54 : 44))

    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = viewlist.bounds
    viewlist.blurView.addSubview(blurEffectView)
    toView.view.addSubview(viewlist)
}


// MARK: - Border Tableview Section

func borderTableviewSection(tableView: UITableView, indexPath : IndexPath, cell : UITableViewCell)  {
    let cornerRadius: CGFloat = 8.0
    cell.backgroundColor = UIColor.clear
    let layer: CAShapeLayer = CAShapeLayer()
    let pathRef: CGMutablePath = CGMutablePath()
    let bounds: CGRect = cell.bounds.insetBy(dx: 10, dy: 0)
    var addLine: Bool = false

    if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
        pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
    } else if indexPath.row == 0 {
        pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
        pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
        pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        addLine = true
    } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
        pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
        pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
        pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        addLine = true
    } else {
        pathRef.addRect(bounds)
        addLine = true
    }

    layer.path = pathRef
    layer.strokeColor = UIColor.lightGray.cgColor
    layer.lineWidth = 0.25
    layer.fillColor = UIColor(white: 1, alpha: 1.0).cgColor

    if addLine == true {
        let lineLayer: CALayer = CALayer()
        let lineHeight: CGFloat = (0.25 / UIScreen.main.scale)
        lineLayer.frame = CGRect(x: bounds.minX, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
        lineLayer.backgroundColor = tableView.separatorColor!.cgColor
        layer.addSublayer(lineLayer)
    }

    let backgroundView: UIView = UIView(frame: bounds)
    backgroundView.layer.insertSublayer(layer, at: 0)
    backgroundView.backgroundColor = UIColor.clear
    cell.backgroundView = backgroundView
}

// MARK: - Notification Check
func notificationServicesEnabled(completion: @escaping (Bool) -> Void)  {
 
    
    var isEnabled = false
    
   /* if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
            if setttings.authorizationStatus == .authorized{
                isEnabled = true
            }
            else{
                isEnabled = false
            }
        }
    } else {
        guard let isNotificationEnabled = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) else { return false }
        if isNotificationEnabled{
             isEnabled = true
        }else{
            isEnabled = false
        }
    }
    */
    
    /*let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { permission in
                switch permission.authorizationStatus  {
                case .authorized:
                    print("User granted permission for notification")
                    isEnabled = true
                case .denied:
                    print("User denied notification permission")
                case .notDetermined:
                    print("Notification permission haven't been asked yet")
                case .provisional:
                    // @available(iOS 12.0, *)
                    print("The application is authorized to post non-interruptive user notifications.")
                case .ephemeral:
                    // @available(iOS 14.0, *)
                    print("The application is temporarily authorized to post notifications. Only available to app clips.")
                @unknown default:
                    print("Unknow Status")
                }
            })
//    this code will work till iOS 9, for iOS 10 use the above code snippet.

//    let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
//    if isRegisteredForRemoteNotifications {
//         // User is registered for notification
//        isEnabled = true
//
//    } else {
//         // Show alert user is not registered for notification
//    }*/
    
    notificationStatus(completion: { authorized in
           print("authorized = \(authorized)")
        
            if(authorized)
            {
                isEnabled = true
                completion(true)
            }else{
                completion(false)
            }
       }
    )
    
   
    
}
func notificationStatus( completion: @escaping (Bool) -> Void) {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { (settings) in
        
        if(settings.authorizationStatus == .authorized)
        {
            let authorized = settings.authorizationStatus == .authorized
            completion(authorized)
            
            switch settings.authorizationStatus  {
            case .authorized:
                print("User granted permission for notification")
                completion(true)
            case .denied:
                print("User denied notification permission")
                completion(false)
            case .notDetermined:
                print("Notification permission haven't been asked yet")
                completion(false)
            case .provisional:
                // @available(iOS 12.0, *)
                print("The application is authorized to post non-interruptive user notifications.")
                completion(false)
            case .ephemeral:
                // @available(iOS 14.0, *)
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
                completion(true)
            @unknown default:
                print("Unknow Status")
                completion(false)
            }
            
        }else{
            completion(false)
        }
        
        
        
    }
}
// MARK: - Set Oauth Data
func setOauthData() {
    
    let dictOAuthParams = NSMutableDictionary()
    
    dictOAuthParams.setValue(appURL, forKey: "appURL")
    dictOAuthParams.setValue(PATH, forKey: "PATH")
    dictOAuthParams.setValue(OTHER_API_PATH, forKey: "OTHER_API_PATH")
//    dictOAuthParams.setValue(AUTHENTICATION_TOKEN, forKey: "AUTHENTICATION_TOKEN")

    dictOAuthParams.setValue(OAUTH_CUSTOMER_KEY, forKey: "OAUTH_CUSTOMER_KEY")
    dictOAuthParams.setValue(OAUTH_CUSTOMER_SERCET, forKey: "OAUTH_CUSTOMER_SERCET")

    dictOAuthParams.setValue(OAUTH_CONSUMER_KEY_PLUGIN, forKey: "OAUTH_CONSUMER_KEY_PLUGIN")
    dictOAuthParams.setValue(OAUTH_CONSUMER_SECRET_PLUGIN, forKey: "OAUTH_CONSUMER_SECRET_PLUGIN")

    dictOAuthParams.setValue(OAUTH_TOKEN_PLUGIN, forKey: "OAUTH_TOKEN_PLUGIN")
    dictOAuthParams.setValue(OAUTH_TOKEN_SECRET_PLUGIN, forKey: "OAUTH_TOKEN_SECRET_PLUGIN")
////
    if let isCurrency = getValueFromLocal(key: kCurrency) as? Bool{
        if isCurrency == true && getValueFromLocal(key: kCurrencyText) != nil  && getValueFromLocal(key: kCurrencyText) as? String != ""  {
            dictOAuthParams.setValue(1, forKey: "currency")
            dictOAuthParams.setValue(getValueFromLocal(key: kCurrencyText) as! String, forKey: "currency_value")
            
        } else {
            dictOAuthParams.setValue(0, forKey: "currency")
            dictOAuthParams.setValue("", forKey: "currency_value")
        }
    } else {
        dictOAuthParams.setValue(0, forKey: "currency")
        dictOAuthParams.setValue("", forKey: "currency_value")
    }
    
    if let isLanguage = getValueFromLocal(key: kLanguage) as? Bool {
        if isLanguage == true && getValueFromLocal(key: kLanguageText) != nil  && getValueFromLocal(key: kLanguageText) as? String != ""  {
            dictOAuthParams.setValue(1, forKey: "language")
            dictOAuthParams.setValue(getValueFromLocal(key: kLanguageText) as! String, forKey: "language_value")
        } else {
            dictOAuthParams.setValue(0, forKey: "language")
            dictOAuthParams.setValue("", forKey: "language_value")
        }
    } else {
        dictOAuthParams.setValue(0, forKey: "language")
        dictOAuthParams.setValue("", forKey: "language_value")
    }
    
    CiyaShopAPISecurity.setOauthData((dictOAuthParams as! [AnyHashable : Any]))
}

// MARK: - Open url
func openUrl(strUrl : String) {
    if strUrl == "" {
        return
    }
    
    let url = strUrl.encodeURL()
    if UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}



// MARK: - Generate Deep link
func generateDeepLink(product: JSON, viewcontroller :UIViewController) {
    showLoader(vc: viewcontroller)
    
    let longUrl = String(format: "%@#%@", product["permalink"].stringValue,product["id"].stringValue)
    guard let link = URL(string: longUrl) else { return }
    
    let dynamicDomain = DEEP_LINK_DOMAIN
    
    let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicDomain)!
    linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: Bundle.main.bundleIdentifier!)
    
    linkBuilder.iOSParameters?.appStoreID = APPLE_APP_STORE_ID
    linkBuilder.iOSParameters?.minimumAppVersion = APPLE_APP_VERSION
    
    linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: ANDROID_PACKAGE_NAME)
    linkBuilder.androidParameters?.minimumVersion = Int(PLAYSTORE_MINIMUM_VERSION)!
    
    
    var description = ""
    if product["description"].string!.count > 300  {
        description = String(product["description"].string!.prefix(300))
    } else {
        description = product["description"].string!
    }
    
    linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
    linkBuilder.socialMetaTagParameters!.title =  product["name"].string
    linkBuilder.socialMetaTagParameters!.descriptionText = description
    linkBuilder.socialMetaTagParameters!.imageURL = URL(string: (product["images"].arrayValue)[0]["src"].stringValue)

    
    linkBuilder.shorten { (shortUrl, warnings, error) in
        
        hideLoader(vc:viewcontroller)
        
        if error != nil || shortUrl == nil {
            print("Error : \(error!.localizedDescription)")
            return
        }
        
        print("Short URL : \(shortUrl!.absoluteString)")
        
        shareUrl(shortUrl: shortUrl!.absoluteString, productd: product["id"].stringValue, vc: viewcontroller)
    }
}

func shareUrl(shortUrl : String,productd: String,vc : UIViewController) {
    var items = Array<Any>()
    let shareUrl = String(format: "%@#%@", shortUrl, productd)
    items = [URL(string: shareUrl)!]
    
    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        ac.popoverPresentationController?.sourceView = vc.view
        ac.popoverPresentationController?.sourceRect = CGRect(x: vc.view.bounds.size.width/2, y: vc.view.bounds.size.height/4, width: 0, height: 0)
    }
    vc.present(ac, animated: true)
}

