//
//  TabbarVC.swift
//  CiyaShop
//
//  Created by Apple on 11/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON
import AppTrackingTransparency
import AdSupport

var tabController : UITabBarController?

class TabbarVC: BaseViewController,UITabBarControllerDelegate {
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermission()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHomeData), name: NSNotification.Name(rawValue: REFRESH_HOME_DATA), object: nil)
        
        tabController?.delegate = self
        setOauthData()
        setHomeData()
    }
    //MARK:- Permission
    func requestPermission() {
            
        
        if #available(iOS 14, *) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                ATTrackingManager.requestTrackingAuthorization { status in
                        switch status {
                        case .authorized:
                            // Tracking authorization dialog was shown
                            // and we are authorized
                            print("Authorized")
                            setValueToLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY, value: true)
                            // Now that we are authorized we can get the IDFA
                        print(ASIdentifierManager.shared().advertisingIdentifier)
                        case .denied:
                           // Tracking authorization dialog was
                           // shown and permission is denied
                             print("Denied")
                            setValueToLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY, value: false)
                        case .notDetermined:
                                // Tracking authorization dialog has not been shown
                                print("Not Determined")
                            setValueToLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY, value: false)
                        case .restricted:
                                print("Restricted")
                            setValueToLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY, value: false)
                        @unknown default:
                                print("Unknown")
                            setValueToLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY, value: false)
                        }
                    }
                })
            }
    }
    // MARK: - Home API Calling
    func setHomeData() {
        
        if (IS_FROM_STATIC_DATA) {
            if (IS_INFINITE_SCROLL){
                getHomeScrollingData()
            } else {
                getHomeData()
            }
        } else {
            getHomeScrollingData()
        }
    }
    
    // MARK: - APIs Caling
    
    func getHomeScrollingData() {
        showLoader()
        var params = [AnyHashable : Any]()
        params["app-ver"] = PLUGIN_VERSION

        CiyaShopAPISecurity.homeScrolling(params) { (success, message, responseData) in
            let jsonReponse = JSON(responseData!)
            if success {
                self.setHomeScrollingAPIData(jsonReponse: jsonReponse)
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
    
    func getHomeData() {
        showLoader()
        var params = [AnyHashable : Any]()
        params["app-ver"] = PLUGIN_VERSION
        
        CiyaShopAPISecurity.homeData(params) { (success, message, responseData) in
            let jsonReponse = JSON(responseData!)
            print("Home data - ",jsonReponse)
            if success && (responseData! as AnyObject).count > 0 {
                
                
                self.setCommonHomeAPIData(jsonReponse: jsonReponse)
                self.setHomeAPIData(jsonReponse: jsonReponse)
                self.createTabbar()
                self.setThemeColors()
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
    
    // MARK: - Handle APIs Reponse
    func setHomeScrollingAPIData(jsonReponse : JSON) {
        if (IS_FROM_STATIC_DATA) {
            if (IS_INFINITE_SCROLL){
                isInfiniteHomeScreen = true

                self.setCommonHomeAPIData(jsonReponse: jsonReponse)
                self.setProductsData(jsonReponse: jsonReponse)
                self.createTabbar()
                self.setThemeColors()
                
                //call product method
            } else {
                isInfiniteHomeScreen = false
                getHomeData()
            }
        } else {
            if let infiniteEnabled = jsonReponse["pgs_woo_api_home_layout"].string {
                if infiniteEnabled == "scroll" {
                    isInfiniteHomeScreen = true
                    self.setCommonHomeAPIData(jsonReponse: jsonReponse)
                    self.setProductsData(jsonReponse: jsonReponse)
                    self.createTabbar()
                    self.setThemeColors()
                    
                    //call product method
                } else {
                    isInfiniteHomeScreen = false
                    getHomeData()
                }
            } else {
                isInfiniteHomeScreen = false
                getHomeData()
            }
        }
    }

    func setCommonHomeAPIData(jsonReponse : JSON) {
        
        if let appUrl = jsonReponse["ios_app_url"].string {
            iosAppUrl = appUrl
        }
       
        if let applogo = jsonReponse["app_logo"].string {
            appLogo = applogo
        } else {
            appLogo = ""
        }
        
        if let applogoLight = jsonReponse["app_logo_light"].string {
            appLogoLight = applogoLight
        } else {
            appLogoLight = ""
        }
        
        
        // for infinite scroll
        if (IS_FROM_STATIC_DATA) {
            isInfiniteHomeScreen = IS_INFINITE_SCROLL
        } else {
            if let infiniteEnabled = jsonReponse["pgs_woo_api_home_layout"].string {
                if infiniteEnabled == "scroll" {
                    isInfiniteHomeScreen = true
                } else {
                    isInfiniteHomeScreen = false
                }
            }
        }
        
        
        
        
        // for add to cart
        if (IS_FROM_STATIC_DATA) {
            isAddtoCartEnabled = IS_ADD_TO_CART
        } else {
            if let addCartOption = jsonReponse["pgs_woo_api_add_to_cart_option"].string {
                if addCartOption == "enable" {
                    isAddtoCartEnabled = true
                } else {
                    isAddtoCartEnabled = false
                }
            } else {
                isAddtoCartEnabled = false
            }
        }
        
        if let headerCategories = jsonReponse["main_category"].array {
            arrHeaderCategories = headerCategories
        } else {
            arrHeaderCategories = Array<JSON>()
        }
        
        if let sliders = jsonReponse["main_slider"].array {
            arrSliders = sliders
        } else {
            arrSliders = Array<JSON>()
        }
        
        
        if let socialData = jsonReponse["pgs_app_social_links"].dictionary {
            dictSocialData = socialData
        } else {
            dictSocialData = [String : JSON]()
        }
        
        if let allCategories = jsonReponse["all_categories"].array {
            arrAllCategories = allCategories
        } else {
            arrAllCategories = Array<JSON>()
        }
        
        if let priceFormatData : Dictionary<String,JSON> = jsonReponse["price_formate_options"].dictionary {
            strCurrencySymbolPosition = priceFormatData["currency_pos"]!.string!
            strCurrencySymbol = priceFormatData["currency_symbol"]!.string!.htmlEncodedString()
            decimalPoints = priceFormatData["decimals"]!.int!
            strThousandSeparatore = priceFormatData["thousand_separator"]!.string!
            strDecimalSeparatore = priceFormatData["decimal_separator"]!.string!
        } else {
            strCurrencySymbolPosition = ""
            strCurrencySymbol = ""
            decimalPoints = 2
            strThousandSeparatore = ""
            strDecimalSeparatore = ""
        }
        
        if let contactData : Dictionary<String,JSON> = jsonReponse["pgs_app_contact_info"].dictionary {
            strContactUsEmail = contactData["email"]!.string!
            strContactUsPhoneNumber = contactData["phone"]!.string!
            let contactAddress = contactData["address_line_1"]!.string! + "\n" + contactData["address_line_2"]!.string!
            strContactUsAddress = contactAddress
            strWhatsAppNumber = contactData["whatsapp_no"]!.string!
            
            if let whatsappEnabled = contactData["whatsapp_floating_button"]?.string {
                if whatsappEnabled == "enable" {
                    isWhatsAppFloatingEnabled = true
                } else {
                    isWhatsAppFloatingEnabled = false
                }
                
            } else {
                isWhatsAppFloatingEnabled = false
            }
        } else {
            strContactUsEmail = ""
            strContactUsPhoneNumber = ""
            strContactUsAddress = ""
            strWhatsAppNumber = ""
            isWhatsAppFloatingEnabled = false
        }
        
        
        if let wishlistActive = jsonReponse["is_wishlist_active"].bool {
            isWishList = wishlistActive
        } else {
            isWishList = false
        }
        
        if let currencyActive = jsonReponse["is_currency_switcher_active"].bool {
            isCurrencySet = currencyActive
        } else {
            isCurrencySet = false
        }
        
        if let trackingActive = jsonReponse["is_order_tracking_active"].bool {
            isOrderTrackingActive = trackingActive
        } else {
            isOrderTrackingActive = false
        }
        
        if let rewardActive = jsonReponse["is_reward_points_active"].bool {
            isMyRewardPointsActive = rewardActive
        } else {
            isMyRewardPointsActive = false
        }
        if let teraWalletActive = jsonReponse["is_terawallet_active"].bool {
            isTeraWalletActive = teraWalletActive

        } else {
            isMyRewardPointsActive = false
        }
        
        
        if let guestCheckoutActive = jsonReponse["is_guest_checkout_active"].bool {
            isGuestCheckoutActive = guestCheckoutActive
        } else {
            isGuestCheckoutActive = false
        }
        
        if let wpmlActive = jsonReponse["is_wpml_active"].bool {
            isWpmlActive = wpmlActive
        } else {
            isWpmlActive = false
        }
        
        if let videoActive = jsonReponse["is_yith_featured_video_active"].bool {
            isYithVideoEnabled = videoActive
        } else {
            isYithVideoEnabled = false
        }
        
        
        if((getValueFromLocal(key: APP_LANGUAGE) as? String) !=  jsonReponse["site_language"].stringValue) {
            if MCLocalization.sharedInstance.language == jsonReponse["site_language"].stringValue {
                //Remove all recent items
                isLanguageChange = true
            } else {
                isLanguageChange = false
            }
            
        } else {
            isLanguageChange = false
        }
        
        if let wmplLanguages = jsonReponse["wpml_languages"].array {
            arrWpmlLanguages = wmplLanguages
        } else {
            arrWpmlLanguages = Array<JSON>()
        }
        
        if let webviewPages = jsonReponse["pgs_woo_api_web_view_pages"].array {
            arrFromWebView = webviewPages
        } else {
            arrFromWebView = Array<Any>()
        }
        
        //set language //code is remaining for language
        setValueToLocal(key: APP_LANGUAGE, value: jsonReponse["site_language"].stringValue)
        MCLocalization.sharedInstance.language = jsonReponse["site_language"].stringValue
        
        
        if let is_rtl = jsonReponse["is_rtl"].bool {
            isRTL = is_rtl
        } else {
            isRTL = false
        }
        
        
        if isWpmlActive {
            for language in arrWpmlLanguages {
                if language["site_language"] == jsonReponse["site_language"] {
                    languageCode = language["code"].string!
                    isLanguageChange = true
                    setOauthData()
                    break;
                }
            }
        }

        // for welcome screen
        if (IS_FROM_STATIC_DATA) {
            isSliderScreen = IS_INTRO_SLIDER
        } else {
            if let isWelcome = jsonReponse["is_slider"].bool {
                isSliderScreen = isWelcome
            } else if let strSlider = jsonReponse["pgs_woo_api_scroll_is_slider"].string {
                if strSlider == "enable" {
                    isSliderScreen = true
                } else {
                    isSliderScreen = false
                }
            }
        }
        
        
        //for login screen
        if (IS_FROM_STATIC_DATA) {
            isLoginScreen = IS_LOGIN
        } else {
            if let isLogin = jsonReponse["is_login"].bool {
                isLoginScreen = isLogin
            } else if let strLogin = jsonReponse["pgs_woo_api_scroll_is_login"].string {
                if strLogin == "enable" {
                    isLoginScreen = true
                } else {
                    isLoginScreen = false
                }
            }
        }
        
        // for Catalogue mode
        if (IS_FROM_STATIC_DATA) {
            isCatalogMode = IS_CATALOG_MODE
        } else {
            if let strCatalogue = jsonReponse["pgs_woo_api_catalog_mode_option"].string {
                if strCatalogue == "enable" {
                    isCatalogMode = true
                } else {
                    isCatalogMode = false
                }
            }
        }
        
        // for Currency
        if let dictCurrency = jsonReponse["currency_switcher"].dictionary {
            arrCurrency = Array<JSON>()
            for itemCurrency in dictCurrency {
                arrCurrency.append(itemCurrency.value)
            }
        }
        
        if let checkOutOptions = jsonReponse["checkout_redirect_url"].array {
            arrCheckoutOptions = checkOutOptions
        } else {
            arrCheckoutOptions = Array()
        }
        
        //Set up Pincode data
        if jsonReponse["pgs_woo_api_deliver_pincode"].exists()
        {
            if(jsonReponse["pgs_woo_api_deliver_pincode"]["status"].stringValue == kEnable)
            {
                IS_PINCODE_ACTIVE = true
                if(jsonReponse["pgs_woo_api_deliver_pincode"]["setting_options"].exists())
                {
                    let dictSettingOptions = jsonReponse["pgs_woo_api_deliver_pincode"]["setting_options"]
                    objPincodeData = PincodeData()
                    objPincodeData.availableat_text = dictSettingOptions["availableat_text"].stringValue
                    objPincodeData.cod_available_msg = dictSettingOptions["cod_available_msg"].stringValue
                    objPincodeData.cod_data_label = dictSettingOptions["cod_data_label"].stringValue
                    objPincodeData.cod_help_text = dictSettingOptions["cod_help_text"].stringValue
                    objPincodeData.cod_not_available_msg = dictSettingOptions["cod_not_available_msg"].stringValue
                    objPincodeData.del_data_label = dictSettingOptions["del_data_label"].stringValue
                    objPincodeData.del_help_text = dictSettingOptions["del_help_text"].stringValue
                    
                    objPincodeData.del_saturday = dictSettingOptions["del_saturday"].boolValue
                    objPincodeData.del_sunday = dictSettingOptions["del_sunday"].boolValue
                    
                    
                    objPincodeData.error_msg_blank = dictSettingOptions["error_msg_blank"].stringValue
                    objPincodeData.error_msg_check_pincode = dictSettingOptions["error_msg_check_pincode"].stringValue
                    
                    objPincodeData.pincode_placeholder_txt = dictSettingOptions["pincode_placeholder_txt"].stringValue
                    
                    objPincodeData.show_city_on_product = dictSettingOptions["show_city_on_product"].boolValue
                    
                    objPincodeData.show_cod_on_product = dictSettingOptions["show_cod_on_product"].boolValue
                    objPincodeData.show_estimate_on_product = dictSettingOptions["show_estimate_on_product"].boolValue
                    objPincodeData.show_product_page = dictSettingOptions["show_product_page"].boolValue
                    objPincodeData.show_state_on_product = dictSettingOptions["show_state_on_product"].boolValue
                }else{
                    objPincodeData = PincodeData()
                    objPincodeData.availableat_text = getLocalizationString(key: "AvailableAt")
                    objPincodeData.cod_available_msg = getLocalizationString(key: "Available")
                    objPincodeData.cod_data_label = getLocalizationString(key: "CashOnDelivery")
                    objPincodeData.cod_help_text = getLocalizationString(key: "CashOnDelivery")
                    objPincodeData.cod_not_available_msg = getLocalizationString(key: "NotAvailable")
                    objPincodeData.del_data_label = getLocalizationString(key: "CashOnDelivery")
                    objPincodeData.del_help_text = getLocalizationString(key: "DeliveryDataHelpText")
                    
                    objPincodeData.del_saturday = true
                    objPincodeData.del_sunday = true
                    
                    
                    objPincodeData.error_msg_blank = getLocalizationString(key: "PincodeNotBlank")
                    objPincodeData.error_msg_check_pincode = getLocalizationString(key: "EnterValidPincode")
                    objPincodeData.pincode_placeholder_txt = getLocalizationString(key: "EnterYourPincode")
                    
                    objPincodeData.show_city_on_product = true
                    objPincodeData.show_cod_on_product = true
                    objPincodeData.show_estimate_on_product = true
                    objPincodeData.show_product_page = true
                    objPincodeData.show_state_on_product = true
                }
                
            }else{
                IS_PINCODE_ACTIVE = false
            }
            
        }
        
        
        // Set App Colors
        if let serverColors = jsonReponse["app_color"].dictionary {
            self.setColors(colors: serverColors)
        }
        
        if let reviewEnabled = jsonReponse["woocommerce_enable_reviews"].string {
            if reviewEnabled == "yes" {
                isReviewEnabled = true
            } else {
                isReviewEnabled = false
            }
        } else {
            isReviewEnabled = false
        }
        
        if let reviewLoginEnabled = jsonReponse["woocommerce_review_rating_verification_required"].string {
            if reviewLoginEnabled == "yes" {
                isReviewLoginEnabled = true
            } else {
                isReviewLoginEnabled = false
            }
        } else {
            isReviewLoginEnabled = false
        }
        
        
        //show welcome screen or login screen
        if isSliderScreen && (getValueFromLocal(key: WELCOME_KEY) == nil ) {
            let welcomeVC = WelcomeVC(nibName: "WelcomeVC", bundle : nil)
            welcomeVC.modalPresentationStyle = .fullScreen
            self.present(welcomeVC, animated: false, completion: nil)
        } else if (isLoginScreen) {
            if is_Logged_in == false {
                self.dismiss(animated: true) {
                    DispatchQueue.main.async {
                        let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
                        let loginNavigationController = UINavigationController(rootViewController: loginVC)
                        loginNavigationController.navigationBar.isHidden = true
                        loginNavigationController.modalPresentationStyle = .fullScreen
                        
                        keyWindow?.rootViewController!.present(loginNavigationController, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    func setHomeAPIData(jsonReponse : JSON) {
        
        if let banners = jsonReponse["category_banners"].array {
            arrCategoryBanners = banners
        } else {
            arrCategoryBanners = Array<JSON>()
        }
        
        if let productData = jsonReponse["products_carousel"].dictionary {
            dictProductCarousel = productData
        } else {
            dictProductCarousel = Dictionary<AnyHashable, Any>()
        }
        
        if let productViewOrders = jsonReponse["products_view_orders"].array {
            arrProductViewOrder = productViewOrders
        } else {
            arrProductViewOrder = Array<Any>()
        }
        
        if let ads = jsonReponse["banner_ad"].array {
            arrBannersAd = ads
        } else {
            arrBannersAd = Array<JSON>()
        }
        
        if let customSectionTitle = jsonReponse["product_banners_title"].string {
            strProductBannerTitle = customSectionTitle
        } else {
            strProductBannerTitle = ""
        }
        
        
        if let customSections = jsonReponse["custom_section"].array {
            arrCustomSection = customSections
        } else {
            arrCustomSection = Array<JSON>()
        }
        
        if let featureEnabled = jsonReponse["feature_box_status"].string {
            if featureEnabled == "enable" {
                isFeatureEnabled = true
            } else {
                isFeatureEnabled = false
            }
        } else {
            isFeatureEnabled = false
        }
        
        if let featureList = jsonReponse["feature_box"].array {
            arrReasonToBuy = featureList
            if arrReasonToBuy.count > 0 {
                isFeatureEnabled = true
            } else {
                isFeatureEnabled = false
            }
        } else {
            isFeatureEnabled = false
        }
        
        if let reasonToBuy = jsonReponse["feature_box_heading"].string {
            strReasonsToBuy = reasonToBuy
        } else {
            strReasonsToBuy = ""
        }
        
        
        
        
        
//        print(jsonReponse)
    }
    
    func setProductsData(jsonReponse : JSON) {
        
        if let products = jsonReponse["products_random"].array {
            arrRadomProducts = products
        } else {
            arrRadomProducts = Array<JSON>()
        }
    }
    
    func setColors(colors:[String : JSON])  {
        if isServerColor {
            if let primary_color = colors["primary_color"]?.string {
                primaryColor = UIColor.hexToColor(hex:primary_color)
                setValueToLocal(key: PRIMARY_COLOR_KEY, value: primary_color)
            }
            
            if let secondary_color = colors["secondary_color"]?.string {
                secondaryColor = UIColor.hexToColor(hex:secondary_color)
                setValueToLocal(key: SECONDARY_COLOR_KEY, value: secondary_color)
            }
            
            if let header_color = colors["header_color"]?.string {
                headerColor = UIColor.hexToColor(hex:header_color)
                setValueToLocal(key: HEADER_COLOR_KEY, value: header_color)
            }
        }
        setStatusBar()
    }
    
    // MARK: - Other Methods
    
    func setThemeColors() {
        self.view.setBackgroundColor()
        tabController!.tabBar.isOpaque = true
        tabController!.tabBar.backgroundColor = secondaryColor
        tabController!.tabBar.barTintColor = secondaryColor
        tabController!.tabBar.tintColor = tabbarSelectedColor
        
        if #available(iOS 10.0, *) {
            tabController!.tabBar.unselectedItemTintColor = primaryColor
            if #available(iOS 13.0, *) {
                tabController!.tabBar.standardAppearance.selectionIndicatorTintColor = tabbarSelectedColor
            } else {
                
            }
        } else {
            
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : primaryColor], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : tabbarSelectedColor], for: .selected)
            tabController!.tabBar.tintColor = .white
            
            for item in tabController!.tabBar.items! {
                item.image = item.image!.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    
    @objc func refreshHomeData() {
        setHomeData()
    }
    
    func localizeStrings() {
        
        if(isRTL == true) {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
            
            self.tabBarController?.tabBar.semanticContentAttribute = .forceRightToLeft
            
            navigationController?.view.semanticContentAttribute = .forceRightToLeft
            navigationController?.navigationBar.semanticContentAttribute =  .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
            
            tabBarController?.tabBar.semanticContentAttribute = .forceLeftToRight
            
            navigationController?.view.semanticContentAttribute = .forceLeftToRight
            navigationController?.navigationBar.semanticContentAttribute =  .forceLeftToRight
            
        }
    }
    
    // MARK: - Tabbar Methods
    private func createTabbar()
    {
        localizeStrings()

        tabController = UITabBarController()
        tabController?.delegate = self

        
        
        let allCategoriesVC = AllCategoriesVC(nibName: "AllCategoriesVC", bundle : nil)
        let searchNavigationController = UINavigationController(rootViewController: allCategoriesVC)
        searchNavigationController.navigationBar.isHidden = true
        
        let cartVC = CartVC(nibName: "CartVC", bundle : nil)
        let cartNavigatonController = UINavigationController(rootViewController: cartVC)
        cartNavigatonController.navigationBar.isHidden = true
        
        let couponVC = CouponsVC(nibName: "CouponsVC", bundle : nil)
        couponVC.isFromTab = true
        let couponNavigatonController = UINavigationController(rootViewController: couponVC)
        couponNavigatonController.navigationBar.isHidden = true
        
        let homeVC = HomeVC(nibName: "HomeVC", bundle : nil)
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        homeNavigationController.navigationBar.isHidden = true
        //        setupTabItem(navigationVC: homeNavigationController, title: "Search", image: UIImage(named: "home"), tag: 3)
        
        let accountVC = AccountVC(nibName: "AccountVC", bundle : nil)
        let accountNavigationController = UINavigationController(rootViewController: accountVC)
        accountNavigationController.navigationBar.isHidden = true
        
        
        let wishlistVC = WishlistVC(nibName: "WishlistVC", bundle : nil)
        let wishListNavigationController = UINavigationController(rootViewController: wishlistVC)
        wishListNavigationController.navigationBar.isHidden = true
        
        tabController!.viewControllers = [searchNavigationController, isCatalogMode ? couponNavigatonController : cartNavigatonController, homeNavigationController, accountNavigationController, wishListNavigationController]
        tabController!.selectedIndex = 2
        tabController!.tabBar.isTranslucent = false
        
        

        setupTabItem(navigationVC: searchNavigationController, title: getLocalizationString(key: "Search"), image: UIImage(named: "search-icon"), tag: 1)
        if isCatalogMode {
            setupTabItem(navigationVC: couponNavigatonController, title: getLocalizationString(key: "Coupons"), image: UIImage(named: "coupon-icon"), tag: 2)
        } else {
            setupTabItem(navigationVC: cartNavigatonController, title: getLocalizationString(key: "Cart"), image: UIImage(named: "cart-icon"), tag: 2)
        }
        
//        setupTabItem(navigationVC: homeNavigationController, title: "", image: UIImage(named: "home"), tag: 3)
        setupHomeButton()
        setupTabItem(navigationVC: accountNavigationController, title: getLocalizationString(key: "Account"), image: UIImage(named: "profile-icon"), tag: 4)
        setupTabItem(navigationVC: wishListNavigationController, title:getLocalizationString(key: "Wishlist"), image: UIImage(named: "wishlist-icon"), tag: 5)
        
//        self.view.layoutIfNeeded()
        
        if(tabController != nil) {
            tabController!.view.removeFromSuperview()
        }
        self.view.addSubview(tabController!.view)
        if isWhatsAppFloatingEnabled == true {
            setWhatsappButton()
        }
        
        tabController?.tabBar.items![1].badgeColor = primaryColor
        tabController?.tabBar.items![1].setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: secondaryColor,NSAttributedString.Key.font:UIFont.appLightFontName(size: fontSize12)], for: .normal)
        
        if isCatalogMode {
            tabController?.tabBar.items?[1].badgeValue = nil
        } else {
            if arrCart.count > 0 {
                tabController?.tabBar.items?[1].badgeValue = String(format: "%d", arrCart.count)
            } else {
                tabController?.tabBar.items?[1].badgeValue = nil
            }
        }
    }
    
    private func setupTabItem(navigationVC: UINavigationController, title : String , image : UIImage!, tag : Int) {
        
        navigationVC.navigationBar.isHidden = true
        let tabItem = UITabBarItem( title: title, image: image, tag: tag)
        
        tabItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: robotoRegularFont, size: 11) as Any ], for: .normal)
        navigationVC.tabBarItem = tabItem
    }
    
    func setupHomeButton() {
        
        let homeView = UIView(frame: CGRect(x: (tabController!.tabBar.bounds.width / 2)-(70/2), y: -20, width: 70, height: 70))
        homeView.backgroundColor = secondaryColor
        homeView.layer.cornerRadius = homeView.frame.size.width / 2.0
        
        let centerButton = UIButton(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        
        centerButton.layer.cornerRadius = centerButton.frame.size.width / 2.0
        centerButton.setImage(UIImage(named: "home-icon"), for: .normal)
        centerButton.backgroundColor = primaryColor
        centerButton.tintColor = secondaryColor
        homeView.addSubview(centerButton)
        tabController!.tabBar.addSubview(homeView)
        tabController!.tabBar.bringSubviewToFront(centerButton)
        
        centerButton.addTarget(self, action: #selector(self.homeButtonClicked), for: .touchUpInside)
        view.layoutIfNeeded()
    }
    
    
    @objc func homeButtonClicked(sender: UIButton) {
        
        if tabController?.selectedIndex == 2 {
            self.navigationController?.popViewController(animated: true)
        } else {
            tabController?.selectedIndex = 2
        }
    }
    
    
    func setWhatsappButton() {
        if let vw = keyWindow?.viewWithTag(98795) {
            vw.removeFromSuperview()
        }
        let assistiveTouch = AssistiveTouch(frame: CGRect(x:screenWidth-56, y: screenHeight - tabController!.tabBar.frame.size.height - 56, width: 56, height: 56))
        assistiveTouch.backgroundColor = .white //primaryColor
        assistiveTouch.tintColor = secondaryColor
        assistiveTouch.addShadow()
        assistiveTouch.layer.cornerRadius = 8
        assistiveTouch.addTarget(self, action: #selector(onWhatasppClicked(sender:)), for: .touchUpInside)
        assistiveTouch.setImage(UIImage(named: "whatsapp-icon"), for: .normal)
        assistiveTouch.tag = 98795
        keyWindow!.addSubview(assistiveTouch)
    }

    @objc func onWhatasppClicked(sender: UIButton) {
        if strWhatsAppNumber == "" {
            return
        }
            
        var whatsappUrl1 = strWhatsAppNumber
        if !strWhatsAppNumber.contains("+") {
            whatsappUrl1 = "\(MOBILE_COUNTRY_CODE)\(strWhatsAppNumber)"
        }
        
        if whatsappUrl1 == "" {
            return
        }
        
        let whatsappUrl2 = "&text="
        let formattedString = "whatsapp://send?phone=\(whatsappUrl1)\(whatsappUrl2)\(appURL)"
        print("\(formattedString)")

        let whatsappURL = URL(string: formattedString)
        if whatsappURL == nil {
            showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "InvalidContactNo"), vc: self)
        } else if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
        } else {
            showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "WhatsappNotInstalled"), vc: self)
        }

    }
    
    
}
//MARK:- Tabbar delegate methods
extension TabbarVC : UITabBarDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        if let vc = viewController as? UINavigationController {
            vc.popViewController(animated: false);
        }
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
        let vc = self.tabBarController?.viewControllers![self.tabBarController!.selectedIndex] as! UINavigationController
            vc.popToRootViewController(animated: false)
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
         // Call Abandoned Cart Method For Facebook Pixel
        if viewController.children[0].isKind(of: MyOrdersVC.self) {
            if is_Logged_in == false {
                DispatchQueue.main.async {
                    let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
                    let loginNavigationController = UINavigationController(rootViewController: loginVC)
                    loginNavigationController.navigationBar.isHidden = true
                    loginNavigationController.modalPresentationStyle = .fullScreen
                    keyWindow?.rootViewController!.present(loginNavigationController, animated: true, completion: nil)
                }
                return false
            }
        }
        
//        if  getValueFromLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY) as? Bool == true {
//            FacebookHelper.checkForAbandonedCart()
//        }
        
        return true
    }
    // UITabBarControllerDelegate
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("Selected view controller")
        if let vc = viewController as? UINavigationController {
            vc.popViewController(animated: false);
        }
    }
}


class DynamicHeightCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {    
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
