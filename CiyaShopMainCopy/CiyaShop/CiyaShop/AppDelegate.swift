//
//  AppDelegate.swift
//  CiyaShop
//
//  Created by Apple on 09/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift
import GoogleSignIn
import Firebase
import OneSignal
import FBSDKCoreKit
import CiyaShopSecurityFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    // MARK: - Appdelegate Delegate Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        keyWindow = window;
        IQKeyboardManager.shared.enable = true
        
        setupGoogleSignIn()
        
        //facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions:
            launchOptions
        )
        
        if launchOptions?[UIApplication.LaunchOptionsKey.url] == nil {
            AppLinkUtility.fetchDeferredAppLink { (url, error) in
                if (error != nil) {
                    if (url != nil) {
                        openUrl(strUrl: url!.description)
                    }
                } else {
                    print("Received error while fetching deferred app link  : \(error?.localizedDescription ?? "")")
                }
            }
        }
        //onesignal
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "your_one_signal_key", handleNotificationAction: nil, settings: [kOSSettingsKeyAutoPrompt : false])
        OneSignal.inFocusDisplayType = .notification
        OneSignal.promptForPushNotifications { (accepted) in}
        
        registerForRemoteNotifications()
        
        
        var rootVC: UIViewController
//        if(getValueFromLocal(key: WELCOME_KEY) == nil || getValueFromLocal(key: WELCOME_KEY) as? Bool == false ) {
//            rootVC = WelcomeVC(nibName: "WelcomeVC", bundle : nil)
//        } else {
            rootVC = TabbarVC(nibName: "TabbarVC", bundle : nil)
//            rootVC = UINavigationController(rootViewController: rootVC)
//            rootVC.navigationBar.isHidden = true
//        }
        
        setAppColors()
        setLoaderImages();
        setLangauages()
        setStatusBar()
        setLoginDetails()
        
        setupOTP()
        
        //add existing wishlist items from local storage
        getWishlistItems()
        geCartItems()
        geSearchItems()
        geRecentItems()
        
        LocationHelper.sharedInstance.updateLocation()
        
        self.window!.rootViewController = rootVC
        self.window!.makeKeyAndVisible()
        

        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: RELOAD_NOTIFICATION_SWITCH), object: nil)
    }
    
    // MARK: - Push Notifiction
    
    func registerForRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { granted, error in
            if error == nil {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        strDeviceToken = tokenString
        print("Device Token:", tokenString)
        if let token = getValueFromLocal(key: kDeviceToken) as? String {
            if token != strDeviceToken {
                registerTokenForNotification()
            }
        } else {
            registerTokenForNotification()
        }
    
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Notification registation failed" + error.localizedDescription)
        
        setValueToLocal(key: kNotification, value: "Off")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification : %@", response.notification.request.content.userInfo)
        
        let notificationContent = JSON(response.notification.request.content.userInfo)

        if tabController == nil {
            receivedNotification = notificationContent
        } else {
            if notificationContent["aps"]["alert"]["not_code"].intValue == 1 {
                tabController?.selectedIndex = 3
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: REDIRECT_MY_COUPONS), object: nil)
                }
            } else if notificationContent["aps"]["alert"]["not_code"].intValue == 2 {
                tabController?.selectedIndex = 3
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: REDIRECT_MY_ORDERS), object: nil)
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification : %@", notification.request.content.userInfo)
        
        completionHandler([.alert, .badge, .sound])
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let notificationContent = JSON(userInfo)
        
        if notificationContent["aps"]["alert"]["not_code"].intValue == 1 {
            tabController?.selectedIndex = 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: REDIRECT_MY_COUPONS), object: nil)
            }
        } else if notificationContent["aps"]["alert"]["not_code"].intValue == 2 {
            tabController?.selectedIndex = 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: REDIRECT_MY_ORDERS), object: nil)
            }
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // MARK: - Setup Google/ FireBase
    func setupGoogleSignIn() {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
         //login success with google
        print(user.description)
     }
    
    
    
    // MARK: - Loading Images
    func setLoaderImages() {
        var images = [UIImage?]();
        for i in 1...32 {
            images.append(UIImage(named: "Layer " + String(i) + ".png"))
        }
        loaderImages = NSMutableArray(array: images as [Any])
    }
    
    func setLangauages() {
        MCLocalization.sharedInstance.addProvider(MCLocalization.JSONProvider(language: "en-US", fileName: "English.json"))
        MCLocalization.sharedInstance.addProvider(MCLocalization.JSONProvider(language: "ru-RU",fileName: "Russian.json"))
        MCLocalization.sharedInstance.addProvider(MCLocalization.JSONProvider(language: "ar",fileName: "Arabic.json"))
        MCLocalization.sharedInstance.addProvider(MCLocalization.JSONProvider(language: "fr-FR",fileName: "French.json"))
        MCLocalization.sharedInstance.addProvider(MCLocalization.JSONProvider(language: "de-DE",fileName: "German.json"))
        MCLocalization.sharedInstance.addProvider(MCLocalization.JSONProvider(language: "ja",fileName: "Japanese.json"))
        MCLocalization.sharedInstance.addProvider(MCLocalization.JSONProvider(language: "pt-PT",fileName: "Portuguese.json"))
        MCLocalization.sharedInstance.addProvider(MCLocalization.JSONProvider(language: "es-ES",fileName: "Spanish.json"))
        MCLocalization.sharedInstance.addProvider(MCLocalization.JSONProvider(language: "sv-SE",fileName: "Swedish.json"))
        MCLocalization.sharedInstance.addProvider(MCLocalization.PlaceholderProvider())

        MCLocalization.sharedInstance.defaultLanguage = "en-US"
        if MCLocalization.sharedInstance.language != (getValueFromLocal(key: APP_LANGUAGE) as? String) {
            MCLocalization.sharedInstance.defaultLanguage = (getValueFromLocal(key: APP_LANGUAGE) as? String)
        }
        
    }
    
    func setLoginDetails() {
        if let isLoggedIn = getValueFromLocal(key: LOGIN_KEY) {
            is_Logged_in = isLoggedIn as! Bool
        }
    }
    
    func setupOTP() {
        if (IS_OTP_ENABLE) {
            isOTPEnabled = true
        } else {
            isOTPEnabled = false
        }
    }
    
    func setAppColors() {
        if let header_color = getValueFromLocal(key: HEADER_COLOR_KEY) {
            headerColor = UIColor.hexToColor(hex:header_color as! String)
        }
        if let primary_color = getValueFromLocal(key: PRIMARY_COLOR_KEY) {
            primaryColor = UIColor.hexToColor(hex:primary_color as! String)
        }
        if let secondary_color = getValueFromLocal(key: SECONDARY_COLOR_KEY) {
            secondaryColor = UIColor.hexToColor(hex:secondary_color as! String)
        }
    }
    
    //Wishlist method
    func getWishlistItems() {
        if let wishlistArray = getJSONFromLocal(key: WISHLIST_KEY) {
            arrWishlist = JSON(wishlistArray).arrayValue
        }
    }
    
    //Cart method
    func geCartItems() {
        if let cartArray = getJSONFromLocal(key: CART_KEY) {
            arrCart = JSON(cartArray).arrayValue
        }
    }
    
    //Search
    func geSearchItems() {
        if let searchArray  = getValueFromLocal(key: SEARCH_KEY) {
            arrRecentSearch = searchArray as! Array<String>
        }
    }
    
    func geRecentItems() {
        if let recentArray  = getJSONFromLocal(key: RECENT_ITEM_KEY) {
            arrRecentlyViewedItems = JSON(recentArray).arrayValue
        }
    }
    
    
    //MARK: - Notification api
    
    func registerTokenForNotification() {
        
        var params = [AnyHashable : Any]()
        if let userId =  getValueFromLocal(key: USERID_KEY) as? String {
            params["user_id"] = userId
        } else {
            params["user_id"] = ""
        }
        params["device_token"] = strDeviceToken
        params["device_type"] = "1"
        
        CiyaShopAPISecurity.addNotification(params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    setValueToLocal(key: strDeviceToken, value: kDeviceToken)
                    setValueToLocal(key: kNotification, value: "On")
                }
            }
        }
    }
    
    
     //MARK: - Firebase Deep-Linking
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let deepLink =  application(app, open: url,
                                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                    annotation: "")
        
        let google = GIDSignIn.sharedInstance().handle(url)
        
        
        let fb = ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        if deepLink == true || google == true || fb == true{
            return true
        }

        return false
        
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      
        var strUrl = appURL.replacingOccurrences(of: "https://", with: "")
        strUrl = strUrl.replacingOccurrences(of: "http://", with: "")
        strUrl = strUrl.replacingOccurrences(of: "www.", with: "")
        strUrl = strUrl.replacingOccurrences(of: "/", with: "")
        
        if url.absoluteString.contains(DEEP_LINK_DOMAIN) || url.absoluteString.contains(strUrl) {
            if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
                if (dynamicLink.url != nil) {
                    showDeeopLinkAler(dynamicUrl: dynamicLink.url!.absoluteString)
                }
            }
            showDeeopLinkAler(dynamicUrl: String(format: "OpenURL:\n%@", url.absoluteString))
            return false
        }
        
        return GIDSignIn.sharedInstance()!.handle(url)
    }
    
    func showDeeopLinkAler(dynamicUrl : String) {
        
        let encodedLink = dynamicUrl
        let decondedUrl = encodedLink.removingPercentEncoding
        let items = decondedUrl?.components(separatedBy: "#")
        
        let productId = items?[items!.count - 1]
        
        if tabController != nil {
            let navigationController = tabController?.viewControllers?.first as! UINavigationController
            navigationController.popToRootViewController(animated: false)
            tabController?.selectedIndex = 2

            let homeVC = ((tabController?.viewControllers![2])! as! UINavigationController).viewControllers[0] as! HomeVC
            homeVC.checkDeepLink(productId!)
        } else {
            deepLinkProdcutId = productId ?? ""
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamicLink, error) in
            self.showDeeopLinkAler(dynamicUrl: dynamicLink!.url!.absoluteString)
        }
//        if handled {
//            showDeeopLinkAler(dynamicUrl: String(format: "ContinueUserActivity webPageUrl:\n%@", userActivity.webpageURL!.absoluteString))
//        }
        return handled
    }
    
}


