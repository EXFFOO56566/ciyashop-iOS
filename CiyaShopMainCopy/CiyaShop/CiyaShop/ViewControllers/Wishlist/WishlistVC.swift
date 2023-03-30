//
//  WishlistVC.swift
//  CiyaShop
//
//  Created by Apple on 12/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON

class WishlistVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var wishlistTableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwCartBadge: UIView!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var cartButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblNoOfItems: UILabel!
    
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    
    //For no product
    @IBOutlet weak var viewNoProductAvailable: UIView!
    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var lblSimplyBrowse: UILabel!
    @IBOutlet weak var lblNpProductAvailable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThemeColors()
        registerDatasourceCell()
        
        updateView()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        updateView()
        wishlistTableView.reloadData()
        
    }
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "Wishlist")
        self.lblTitle.textColor = secondaryColor
        
        self.lblNoOfItems.font = UIFont.appRegularFontName(size: fontSize13)
        self.lblNoOfItems.textColor = secondaryColor
        
        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        
        self.lblSimplyBrowse.font = UIFont.appLightFontName(size: fontSize11)
        self.lblSimplyBrowse.text = getLocalizationString(key: "addToWishlistMessage")
        self.lblSimplyBrowse.textColor = secondaryColor
        
        self.lblNpProductAvailable.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblNpProductAvailable.text = getLocalizationString(key: "NoproductFound")
        self.lblNpProductAvailable.textColor = secondaryColor
        
        self.btnContinueShopping.tintColor = primaryColor
        self.btnMenu.tintColor = secondaryColor
        self.btnCart.tintColor = secondaryColor
        
        vwCartBadge.backgroundColor = secondaryColor
        lblBadge.textColor = primaryColor
    }
    
    func registerDatasourceCell() {
        
        self.wishlistTableView.setBackgroundColor()
        wishlistTableView.delegate = self
        wishlistTableView.dataSource = self
        wishlistTableView.register(UINib(nibName: "WishlistItemCell", bundle: nil), forCellReuseIdentifier: "WishlistItemCell")
        
        wishlistTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        wishlistTableView.estimatedRowHeight = 110
        wishlistTableView.rowHeight = UITableView.automaticDimension
        
        wishlistTableView.reloadData()
    }
    
    func updateView() {
        
        self.lblNoOfItems.text =  String(arrWishlist.count) + " " + getLocalizationString(key: "Items")
        
        if arrWishlist.count == 0  {
            wishlistTableView.isHidden = true
            lblNoOfItems.isHidden = true
            viewNoProductAvailable.isHidden = false
        } else {
            wishlistTableView.isHidden = false
            lblNoOfItems.isHidden = false
            viewNoProductAvailable.isHidden = true
        }
        
        if isCatalogMode {
            cartButtonWidthConstraint.constant = 0
            self.vwCartBadge.isHidden = true
            self.lblBadge.isHidden = true
        } else {
            if arrCart.count == 0 {
                self.vwCartBadge.isHidden = true
            } else {
                self.vwCartBadge.isHidden = false
                self.lblBadge.text = String(format: "%d", arrCart.count)
            }
        }
        wishlistTableView.reloadData()
        
    }
    
    // MARK: - UITableview Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrWishlist.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistItemCell", for: indexPath) as! WishlistItemCell
        
        let product = arrWishlist[indexPath.row]
        cell.setProductData(product: product)
        
        cell.btnMovetoCart.tag = indexPath.row
        cell.btnDelete.tag =  indexPath.row
        
        cell.btnDelete.addTarget(self, action: #selector(btnRemoveClicked(_:)), for: .touchUpInside)
        
        
        if checkItemExistsInCart(product: product ){
            cell.btnMovetoCart.setTitle(getLocalizationString(key: "GoToCart"), for: .normal)
        } else {
            cell.btnMovetoCart.setTitle(getLocalizationString(key: "MovetoBag"), for: .normal)
        }
        
        if product["type"].string == "external" {
            cell.btnMovetoCart.isEnabled = false
        } else {
            cell.btnMovetoCart.isEnabled = true
        }

        cell.btnMovetoCart.addTarget(self, action: #selector(btnMovetoCartClicked(_:)), for: .touchUpInside)

        

        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigateToProductDetails(detailDict: arrWishlist[indexPath.row])
    }
    
    //MARK: - Button Clicked
    
    @IBAction func btnCartClicked(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    @objc func btnRemoveClicked(_ sender: Any) {
        let removeButton = sender as! UIButton
        let product = arrWishlist[removeButton.tag]
        
        showCustomAlertWithConfirm(title: APP_NAME, message: getLocalizationString(key: "RemoveFromWishlist"), vc: self) {
            onWishlistButtonClicked(viewcontroller: self, product: product) { (success) in
                self.wishlistTableView.reloadData()
                self.updateView()
            }
        }
        
    }
    
    @objc func btnMovetoCartClicked(_ sender: Any) {
        let cartButton = sender as! UIButton
        let product = arrWishlist[cartButton.tag]
        
        if product["type"].string == "external" {
            openUrl(strUrl: product["external_url"].stringValue)
            return;
        }
        
        if isAddtoCartEnabled && !isCatalogMode {
            if let inStock = product["in_stock"].bool {
                if inStock == true {
                    onAddtoCartButtonClicked(viewcontroller: self, product: product, collectionView: nil, index: 0)
                    updateView()
                } else {
                    self.showToast(message: getLocalizationString(key: "OutOfStock"))
                }
            } else {
                self.showToast(message: getLocalizationString(key: "OutOfStock"))
            }
        } else {
            getSingleProductDetail(productId: product["id"].stringValue)
        }

    }
    
    @IBAction func btnContinueShoppingClicked(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    
    
    // MARK: - API Calling
    func getWishlistData() {
        
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
    
    
    //for single product
    func getSingleProductDetail(productId : String) {
        showLoader()
        
        var params = [AnyHashable : Any]()
        params["include"] = productId
        
        CiyaShopAPISecurity.productListing(params) { (success, message, responseData) in
            
            hideLoader()
            
            let jsonReponse = JSON(responseData!)
            
            if success {
                
                let selectedWishlistProduct = jsonReponse[0]
                if let inStock = selectedWishlistProduct["in_stock"].bool {
                    if inStock == true {
                        onAddtoCartButtonClicked(viewcontroller: self, product: selectedWishlistProduct, collectionView: nil, index: 0)
                        self.updateView()
                    } else {
                        self.showToast(message: getLocalizationString(key: "OutOfStock"))
                    }
                } else {
                    self.showToast(message: getLocalizationString(key: "OutOfStock"))
                }
                
            } else {
                showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
            }
        }
    }
    
}
