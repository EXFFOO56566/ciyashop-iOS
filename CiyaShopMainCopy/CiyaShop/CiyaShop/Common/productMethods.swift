//
//  StringConstants.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 05/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework

typealias onSuccess = (Bool) -> Void


// MARK: - Add to Cart Button Handle
func onAddtoCartButtonClicked(viewcontroller:UIViewController,product: JSON,collectionView : UICollectionView?, index : Int?) {

    // Facebook Pixel for Add To cart
//    if  getValueFromLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY) as? Bool == true {
//        FacebookHelper.logAddedToCartEvent(contentId: product["id"].stringValue, contentType: product["name"].stringValue, currency: strCurrencySymbol, price: product["price"].double ?? 0)
//    }
    
    if checkItemExistsInCart(product: product) {
        if tabController?.selectedIndex == 1 {
            viewcontroller.navigationController?.popViewController(animated: true)
        } else {
            tabController?.selectedIndex = 1
        }
    } else {
        
        if product["type"].string == "external" {
            openUrl(strUrl: product["external_url"].stringValue)
        } else if product["type"].string == "grouped" {
            //grouped product
            getGroupedProducts(vc: viewcontroller,product : product)
        } else if product["type"].string == "variable" {
            //show variations
            showVariationPopUp(vc: viewcontroller, product: product)
        } else {
            addItemInCart(product: product)
            if collectionView != nil {
                collectionView!.reloadItems(at: createIndexPathArray(row: index!, section: 0))
            }
            viewcontroller.showToast(message: getLocalizationString(key: "ItemAddedCart"))
        }
        
    }
    
}

// MARK:-  Add Cart to Local

func checkItemExistsInCart(product : JSON) -> Bool {
    if arrCart.count > 0 {
        
        for cartProduct in arrCart {
            if cartProduct["id"].stringValue == product["id"].stringValue {
                if product["type"].string == "variable" {
                    if cartProduct["variation_id"].exists() {
                        if cartProduct["variation_id"].intValue == product["variation_id"].intValue {
                            if cartProduct["variations"].exists() {
                                if cartProduct["variations"] == product["variations"] {
                                    return true
                                }
                            }
                        }
                    }
                } else {
                    return true
                }
            }
        }
        
        

    }
    return false
}


func addItemInCart(product : JSON) {
    
    if(checkItemExistsInCart(product: product) == false) {
        var updatedProduct = product
        if !updatedProduct["qty"].exists() {
            updatedProduct["qty"] = 1
        }
        arrCart.append(updatedProduct)
        
    }
    
    if arrCart.count > 0 {
        tabController?.tabBar.items?[1].badgeValue = String(format: "%d", arrCart.count)
    } else {
        tabController?.tabBar.items?[1].badgeValue = nil
    }
    
    storeJSONToLocal(key: CART_KEY, value: arrCart.description as Any)
}

func removeItemFromCart(product : JSON) {
    if(checkItemExistsInCart(product: product) == true) {
        for cartProduct in arrCart {
            if cartProduct["id"].stringValue == product["id"].stringValue {
                
                if product["type"].string == "variable" {
                    if cartProduct["variation_id"].exists() {
                        if cartProduct["variation_id"].intValue == product["variation_id"].intValue {
                            if cartProduct["variations"].exists() {
                                if cartProduct["variations"] == product["variations"] {
                                    arrCart.remove(at: arrCart.firstIndex(of: cartProduct)!)
                                }
                            }
                        }
                    }
                } else {
                    arrCart.remove(at: arrCart.firstIndex(of: cartProduct)!)
                }
            }
        }

        if arrCart.count > 0 {
            tabController?.tabBar.items?[1].badgeValue = String(format: "%d", arrCart.count)
        } else {
            tabController?.tabBar.items?[1].badgeValue = nil
        }
        
        storeJSONToLocal(key: CART_KEY, value: arrCart.description as Any)
        
    }
}

//MARK: - Remove all from Cart

func removeAllFromCart() {
    arrCart.removeAll()
    tabController?.tabBar.items?[1].badgeValue = nil
    storeJSONToLocal(key: CART_KEY, value: arrCart.description as Any)
}

// MARK:-  Api calling for Grouped Product Details

func getGroupedProducts(vc :UIViewController,product : JSON) {
    showLoader(vc: vc)

    var params = [AnyHashable : Any]()
    let arrGroupedProduct: [String] = product["grouped_products"].arrayObject!.compactMap { String(describing: $0) }
    
    params["include"] = arrGroupedProduct.joined(separator: ",")
    
    CiyaShopAPISecurity.productListing(params) { (success, message, responseData) in
        hideLoader(vc: vc)
        let jsonReponse = JSON(responseData!)
        if success {
            
            showGroupProductsPopUp(vc: vc, groupItems: jsonReponse.array!)
            
            return
            
        }
        
        if let message = jsonReponse["message"].string {
            showCustomAlert(title: APP_NAME,message: message, vc: vc)
        } else {
            showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: vc)
        }
        
        
    }
    
    
}


// MARK: - Add to Wishlist Button Handle
func onWishlistButtonClicked(viewcontroller:UIViewController,product: JSON,onSuccess: @escaping onSuccess) {

    // Facebook Pixel for Add to Wishlist
//    if  getValueFromLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY) as? Bool == true {
//        FacebookHelper.logAddedToWishlistEvent(contentId: product["id"].stringValue, contentType: product["name"].stringValue, currency: strCurrencySymbol, price: product["price"].double ?? 0)
//    }
    
    if is_Logged_in {
        //from server
        if(checkItemExistsInWishlist(productId: product["id"].stringValue) == true) {
            removeItemFromWishlist(vc: viewcontroller, product: product,onSuccess: onSuccess)
        } else {
            addItemToWishlist(vc: viewcontroller, product: product,onSuccess: onSuccess)
        }
    } else {
        //from locally
        addRemoveItemFromWishlist(product: product,vc: viewcontroller)
        onSuccess(true)
    }
}

// MARK:-  Add Wishlist to Local

func checkItemExistsInWishlist(productId : String) -> Bool {
    if arrWishlist.count > 0 {
        if arrWishlist.contains(where: { $0["id"].stringValue == productId }) {
            return true
        } else {
            return false
        }
    }
    return false
}

func addRemoveItemFromWishlist(product : JSON,vc  : UIViewController?) {
    
    let productId = product["id"].stringValue
    if(checkItemExistsInWishlist(productId: productId) == true) {
        if let productIndex = arrWishlist.firstIndex(where: {$0["id"].stringValue == productId } ) {
            arrWishlist.remove(at: productIndex)
            if vc != nil {
                vc!.showToast(message: getLocalizationString(key: "ItemRemovedWishList"))
            }
        }
    } else {
        arrWishlist.append(product)
        if vc != nil {
            vc!.showToast(message: getLocalizationString(key: "ItemAddedWishList"))
        }
    }
    
    storeJSONToLocal(key: WISHLIST_KEY, value: arrWishlist.description as Any)
}



// MARK:-  API calling fro Add  & Remove from Wishlist

func addItemToWishlist(vc :UIViewController,product : JSON,onSuccess: @escaping onSuccess) {
    showLoader(vc: vc)

    var params = [AnyHashable : Any]()
    params["user_id"] = getValueFromLocal(key: USERID_KEY)
    params["product_id"] = product["id"].stringValue
    
    CiyaShopAPISecurity.addItemtoWishList(params) { (success, message, responseData) in
        hideLoader(vc: vc)
        let jsonReponse = JSON(responseData!)
        if success {
            if jsonReponse["status"] == "success" {
                addRemoveItemFromWishlist(product: product, vc: vc)
                onSuccess(true)
            }
            
            return
        }
        
        if let message = jsonReponse["message"].string {
            showCustomAlert(title: APP_NAME,message: message, vc: vc)
        } else {
            showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: vc)
        }
    }
    
    
}

func removeItemFromWishlist(vc :UIViewController,product : JSON,onSuccess: @escaping onSuccess) {
    showLoader(vc: vc)

    var params = [AnyHashable : Any]()
    params["user_id"] = getValueFromLocal(key: USERID_KEY)
    params["product_id"] = product["id"].stringValue
    
    CiyaShopAPISecurity.removeItem(fromWishList: params) { (success, message, responseData) in
        hideLoader(vc: vc)
        let jsonReponse = JSON(responseData!)
        if success {
            if jsonReponse["status"] == "success" {
                addRemoveItemFromWishlist(product: product, vc: vc)
                onSuccess(true)
            }
            
            return
            
        }
        
        if let message = jsonReponse["message"].string {
            showCustomAlert(title: APP_NAME,message: message, vc: vc)
        } else {
            showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: vc)
        }
    }
}

//MARK: - Remove all from Wishlist

func removeAllFromWishlist() {
    arrWishlist.removeAll()
    storeJSONToLocal(key: WISHLIST_KEY, value: arrWishlist.description as Any)
}



// MARK:-  Add Recently viewd product to Local

func checkItemExistsInRecentList(productId : String) -> Bool {
    if arrRecentlyViewedItems.count > 0 {
        if arrRecentlyViewedItems.contains(where: { $0["id"].stringValue == productId }) {
            return true
        } else {
            return false
        }
    }
    return false
}

func addRemoveItemFromRecentList(product : JSON) {
    
    let productId = product["id"].stringValue
    if(checkItemExistsInRecentList(productId: productId) == true) {
        if let productIndex = arrRecentlyViewedItems.firstIndex(where: {$0["id"].stringValue == productId } ) {
            arrRecentlyViewedItems.remove(at: productIndex)
            arrRecentlyViewedItems.insert(product, at: 0)
        }
    } else {
        if arrRecentlyViewedItems.count >= 5 {
            arrRecentlyViewedItems.removeLast()
        }
        arrRecentlyViewedItems.insert(product, at: 0)
    }
    
    storeJSONToLocal(key: RECENT_ITEM_KEY, value: arrRecentlyViewedItems.description as Any)
}

func removeAllRecentViewedItems() {
    arrRecentlyViewedItems.removeAll()
    storeJSONToLocal(key: RECENT_ITEM_KEY, value: arrRecentlyViewedItems.description as Any)
}



// MARK:-  Add SearchString to Local

func removeAllSearchStringsFromLocal() {
    arrRecentSearch.removeAll()
    setValueToLocal(key: SEARCH_KEY, value: arrRecentSearch)
}


func addSearchStringToLocal(searchString : String) {
    
    if(checkSearchStringExistsInLocal(searchString: searchString) == true) {
        return;
    } else {
        arrRecentSearch.append(searchString)
    }
    
    setValueToLocal(key: SEARCH_KEY, value: arrRecentSearch)
}

func checkSearchStringExistsInLocal(searchString : String) -> Bool {
    if arrRecentSearch.count > 0 {
        if arrRecentSearch.contains(where: { $0 == searchString }) {
            return true
        } else {
            return false
        }
    }
    return false
}







