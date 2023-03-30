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



// MARK: - Add to Cart Button Handle
func onAddtoCartButtonClicked(viewcontroller:UIViewController,product: JSON,collectionView : UICollectionView, index : Int) {
    if checkItemExistsInCart(productId: product["id"].stringValue) {
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
        } else if product["type"].string == "variable" {
            //show variations
            showVariationPopUp(vc: viewcontroller, product: product)
        } else {
            addRemoveItemFromCart(product: product)
            collectionView.reloadItems(at: createIndexPathArray(row: index, section: 0))
        }
        
    }
    
}

// MARK: - Add to Wishlist Button Handle
func onAddtoWishlistButtonClicked(viewcontroller:UIViewController,product: JSON,collectionView : UICollectionView, index : Int) {
    if checkItemExistsInCart(productId: product["id"].stringValue) {
        if tabController?.selectedIndex == 1 {
            viewcontroller.navigationController?.popViewController(animated: true)
        } else {
            tabController?.selectedIndex = 1
        }
    } else {
        addRemoveItemFromCart(product: product)
        collectionView.reloadItems(at: createIndexPathArray(row: index, section: 0))
    }
}

// MARK:-  Add SearchString to Local

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

func addRemoveItemFromWishlist(product : JSON) {
    
    let productId = product["id"].stringValue
    if(checkItemExistsInWishlist(productId: productId) == true) {
        if let productIndex = arrWishlist.firstIndex(where: {$0["id"].stringValue == productId } ) {
            arrWishlist.remove(at: productIndex)
        }
    } else {
        arrWishlist.append(product)
    }
    
    storeJSONToLocal(key: WISHLIST_KEY, value: arrWishlist.description as Any)
}


// MARK:-  Add Cart to Local

func checkItemExistsInCart(productId : String) -> Bool {
    if arrCart.count > 0 {
        if arrCart.contains(where: { $0["id"].stringValue == productId }) {
            return true
        } else {
            return false
        }
    }
    return false
}

func addRemoveItemFromCart(product : JSON) {
    
    let productId = product["id"].stringValue
    if(checkItemExistsInCart(productId: productId) == true) {
        if let productIndex = arrCart.firstIndex(where: {$0["id"].stringValue == productId } ) {
            arrCart.remove(at: productIndex)
        }
    } else {
        
        var updatedProduct = product
        if !updatedProduct["qty"].exists() {
            updatedProduct["qty"] = 1
        }
        arrCart.append(updatedProduct)
    }
    
    storeJSONToLocal(key: CART_KEY, value: arrCart.description as Any)
}


// MARK:-  get Grouped Product Details



