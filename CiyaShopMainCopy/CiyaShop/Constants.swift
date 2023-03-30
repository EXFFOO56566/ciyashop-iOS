//
//  Constants.swift
//  CiyaShop
//
//  Created by Apple on 10/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON

var keyWindow : UIWindow? = nil;

@available(iOS 13.0, *)
let appDelegate = UIApplication.shared.delegate as! AppDelegate

let screenWidth =  UIScreen.main.bounds.width
let screenHeight =  UIScreen.main.bounds.height

let isIPad = UIDevice.current.userInterfaceIdiom == .pad ? true :  false
let isStatusBarDark = false
let APP_NAME = "YOUR_APP_NAME"

var strDeviceToken = ""


// MARK:- API Keys
//=======================================================

let OAUTH_CUSTOMER_KEY : String = ""
let OAUTH_CUSTOMER_SERCET : String = ""
let OAUTH_CONSUMER_KEY_PLUGIN : String = ""
let OAUTH_CONSUMER_SECRET_PLUGIN : String = ""
let OAUTH_TOKEN_PLUGIN : String = ""
let OAUTH_TOKEN_SECRET_PLUGIN : String = ""

let appURL : String = ""
let PATH : String = appURL + ""
let OTHER_API_PATH : String = appURL + ""
let PLUGIN_VERSION : String = ""
let PURCHASEKEY : String = "";

//=======================================================

// MARK:- Deep linking

let DEEP_LINK_DOMAIN : String = ""
let kDeepLinkData : String = "DeepLinkData"
var deepLinkProdcutId : String = ""

let APPLE_APP_STORE_ID : String = ""
let APPLE_APP_VERSION : String = "1.0"

let ANDROID_PACKAGE_NAME : String = ""
let PLAYSTORE_MINIMUM_VERSION : String = "1"

// MARK:- Font Size

var fontSize10 : CGFloat = 10;
var fontSize11 : CGFloat = 11;
var fontSize12 : CGFloat = 12;
var fontSize13 : CGFloat = 13;
var fontSize14 : CGFloat = 14;
var fontSize15 : CGFloat = 15;
var fontSize16 : CGFloat = 16;
var fontSize17 : CGFloat = 17;
var fontSize18 : CGFloat = 18;
var fontSize30 : CGFloat = 30;


// MARK:- Loader
var loaderImages : NSMutableArray = [];

// MARK:- Fonts

var ubuntuMediumFont : String = "Ubuntu-Medium";
var robotoBoldFont : String = "RobotoCondensed-Bold";
var robotoLightFont : String = "RobotoCondensed-Light";
var robotoRegularFont : String = "RobotoCondensed-Regular";


// MARK: - Colors

var headerColor : UIColor = UIColor.hexToColor(hex: "#e3e9ed");   // background color
var primaryColor : UIColor = UIColor.hexToColor(hex:"#6594a0");   //efeae8// tabbar selected
var secondaryColor : UIColor = UIColor.hexToColor(hex:"#1d345f"); //tabbar background

var grayTextColor : UIColor = UIColor.hexToColor(hex: "#6C757D");   // background color
var normalTextColor : UIColor = UIColor.hexToColor(hex: "#323232");   // background color
var grayBackgroundColor : UIColor = UIColor.hexToColor(hex: "#E8E8E8");   // background color
var greenColor : UIColor = UIColor.hexToColor(hex: "#09AC63");
var textFieldBackgroundColor : UIColor = UIColor.hexToColor(hex: "#FFFFFF");// textfield Background color
var tabbarSelectedColor : UIColor = UIColor.hexToColor(hex: "#FFFFFF");

let isServerColor : Bool = true

// MARK: - Facebook pixels

var kNotification : String = "NotificationEnabled"
var kDeviceToken : String = "DeviceToken"
var RELOAD_NOTIFICATION_SWITCH : String = "RefreshNotificaonSwitch"
var receivedNotification : JSON = JSON()

// MARK: - Facebook pixels

let FBSEARCH_CONTENT_TYPE : String = "Shopping"
let kFbAbandonedCartObject : String = "FbAbandoned_cart"
let kFbAbandonedCartTime : String = "FbAbondoned_cart_time"

// MARK: - Keys for Local Storage

let WELCOME_KEY : String = "is_welcome"
let APP_LANGUAGE : String = "app_language"
let LANGUAGE_CHANGED : String = "is_language_change"
let REFRESH_HOME_DATA : String = "refreshHomeData"
let IS_RTL : String = "is_rtl"

let REFRESH_ADDRESS_DATA : String = "refreshAddress"

let UPDATE_CART_BADGE : String = "updateCartBadge"

//MARK:- Local Notification keys
let REFRESH_BASIC_DETAILS : String = "refreshBasicDetails"
let ORDER_SUCCESS : String = "orderSuccess"
let ORDER_FAILURE : String = "orderFaliure"

let REDIRECT_MY_ORDERS : String = "redirectMyOrders"
let REDIRECT_MY_COUPONS : String = "redirectMyCoupons"

//Colors
let PRIMARY_COLOR_KEY : String = "primary_color"
let SECONDARY_COLOR_KEY : String = "secondary_color";
let HEADER_COLOR_KEY : String = "header_color"

//Wishlist
let WISHLIST_KEY : String = "wishlist"
let CART_KEY : String = "cart"
let RECENT_ITEM_KEY : String = "recentItem"

//Search String
let SEARCH_KEY : String = "search"

//MARK:- Login Details

let LOGIN_KEY : String = "is_Logged_in"
var PASSWORD_KEY : String = "Password"
var EMAIL_KEY : String = "Email"
var USERNAME_KEY : String = "Username"
var USERID_KEY : String = "UserID";
var USER_FIRST_NAME : String = "firstname";
var USER_LAST_NAME : String = "lastname";

var FB_OR_GOOGLE_KEY : String = "FBorGoogle";
var PIN_KEY : String = "Pin"

//MARK:- Data tracking key
let IS_DATA_TRACKING_AUTHORIZED_KEY = "isDataTrackingAuthorized"
//MARK: - Currency & Language

var kCurrency : String = "currency"
var kCurrencyText : String = "CurrencyText"

var kLanguage : String = "language"
var kLanguageText : String = "LanguageText"


//Login Data
var is_Logged_in : Bool = false
var dictLoginData : JSON = JSON()

//============================================
//MARK:- Geo-Fencing
var isNotifyForGeoFence = false
let strGeoFencingMessage = "You have entered in our shop region"
let storeLocationLatitude = 21.2478925
let storeLocationLongitude = 72.791003
let DistanceForLocationUpdate = 500 //minimum distance in meters


//============================================

// MARK:- Default Setting options

let MOBILE_COUNTRY_CODE : String = "+91" //REPLACE WITH YOUR COUNTRY CODE

let IS_FROM_STATIC_DATA : Bool = false

let IS_INFINITE_SCROLL : Bool = true
let IS_INTRO_SLIDER : Bool = true
let IS_LOGIN : Bool = true
let IS_ADD_TO_CART : Bool = true
let IS_CATALOG_MODE : Bool = true

let IS_DOWNLOADABLE : Bool = false

let IS_OTP_ENABLE : Bool = false

//============================================
//MARK:- Pincode Objects
var objPincodeData = PincodeData()
var IS_PINCODE_ACTIVE = false

//MARK:- Product Details
var arrayRelatedProducts : Array = Array<JSON>()

// MARK: - Home API Data

var iosAppUrl : String = ""
var appLogo : String = ""
var appLogoLight : String = ""

var isReviewEnabled : Bool = false
var isReviewLoginEnabled : Bool = false

var arrAllCategories : Array = Array<JSON>()

var arrHeaderCategories : Array = Array<JSON>()
var arrSliders : Array = Array<JSON>()
var arrCategoryBanners : Array = Array<JSON>()
var arrSpecialDeals : Array = Array<JSON>()
var arrBannersAd : Array = Array<JSON>()
var arrCustomSection : Array = Array<JSON>()
var dictProductCarousel : Dictionary = Dictionary<AnyHashable, Any>()

var arrProductViewOrder : Array = Array<Any>()

var arrReasonToBuy : Array = Array<JSON>()

var arraySelectedVariationOptions : Array = Array<JSON>()
var arrayAllVariations : Array = Array<JSON>()

var isFeatureEnabled : Bool = false

var dictSocialData = [String : JSON]()
var strReasonsToBuy : String = ""
var strProductBannerTitle : String = ""

//price Format
var strCurrencySymbolPosition : String = ""
var strCurrencySymbol : String = ""
var decimalPoints : Int = 2
var strThousandSeparatore : String = ""
var strDecimalSeparatore : String = ""

var isShowSalePriceLeft = false

//contact info
var strContactUsEmail : String = ""
var strContactUsPhoneNumber : String = ""
var strContactUsAddress : String = ""
var strWhatsAppNumber : String = ""
var strWebsite : String = "" //Enter your website URL
var isWhatsAppFloatingEnabled : Bool = false

var arrCart : Array = Array<JSON>()
var arrBuyNow : Array = Array<JSON>()

var arrWishlist : Array = Array<JSON>()
var isWishList : Bool = false


var arrSortOptions : Array = JSON([getLocalizationString(key: "NewestFirst"),
                              getLocalizationString(key: "Rating"),
                              getLocalizationString(key: "Popularity"),
                              getLocalizationString(key: "PriceLowToHigh"),
    getLocalizationString(key: "PriceHighToLow")]).array!

//Search String
var arrRecentSearch : [String] = Array<String>()
var arrRecentlyViewedItems : Array = Array<JSON>()

//currency
var isCurrencySet : Bool = false
var isOrderTrackingActive : Bool = false
var isMyRewardPointsActive : Bool = false
var isTeraWalletActive : Bool = false

var arrCurrency : Array = Array<JSON>()

var isGuestCheckoutActive : Bool = false
var isWpmlActive : Bool = false
var isYithVideoEnabled : Bool = false

//Currency
var isCurrencyChange : Bool = false


//Langauage
var languageCode : String = "en" //DEFAULT LANGUAGE CODE
var isLanguageChange : Bool = false
var isRTL : Bool = false

var arrWpmlLanguages : Array = Array<JSON>()
var arrFromWebView : Array = Array<Any>()

// infinite home screen
var isInfiniteHomeScreen : Bool = false
var arrRadomProducts : Array = Array<JSON>()

var isLoginScreen : Bool = false
var isSliderScreen : Bool = true
var isAddtoCartEnabled : Bool = true
var isCatalogMode : Bool = false

var isOTPEnabled : Bool = true


var arrCheckoutOptions : Array = Array<JSON>()

//Deal of the Day
var saleHours : Int = 0
var saleMinute : Int = 0
var saleSeconds : Int = 0
var saleTimer : Timer? = nil



