//
//  WishlistVC.swift
//  CiyaShop
//
//  Created by Apple on 12/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//
enum productCheckoutType
{
    case cart
    case buyNow
}


import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework
//import Lottie



class CartVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblNoOfItems: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    //For no product
    @IBOutlet weak var viewNoProductAvailable: UIView!
    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var lblSimplyBrowse: UILabel!
    @IBOutlet weak var lblNpProductAvailable: UILabel!
        
    var  isBuyNow : Bool = false
    var selectedCheckoutType = productCheckoutType.cart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThemeColors()
        registerDatasourceCell()
        
        updateView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.orderSuccess), name: NSNotification.Name(rawValue: ORDER_SUCCESS), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        updateView()
        cartTableView.reloadData()
        
    }
    func setThemeColors() {
        
        self.view.setBackgroundColor()
        self.cartTableView.setBackgroundColor()
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "ShoppingBag")
        self.lblTitle.textColor = secondaryColor
        
        self.lblNoOfItems.font = UIFont.appRegularFontName(size: fontSize13)
        self.lblSimplyBrowse.font = UIFont.appLightFontName(size: fontSize11)
        self.lblNpProductAvailable.font = UIFont.appBoldFontName(size: fontSize14)
        
        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        
        self.lblNoOfItems.textColor = secondaryColor
        
        self.lblSimplyBrowse.text = getLocalizationString(key: "addToCartMessage")
        self.lblSimplyBrowse.textColor = secondaryColor
        
        self.lblNpProductAvailable.text = getLocalizationString(key: "CartIsEmpty")
        self.lblNpProductAvailable.textColor = secondaryColor
        
        self.btnContinueShopping.tintColor = primaryColor
        self.btnMenu.tintColor = secondaryColor
        self.btnBack.tintColor = secondaryColor
        
        if selectedCheckoutType == .buyNow {
            self.btnBack.isHidden = false
        } else {
            self.btnBack.isHidden = true
        }
        
    }
    
    func registerDatasourceCell() {
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: "CartItemCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")
        cartTableView.register(UINib(nibName: "PaymentDetailsItemCell", bundle: nil), forCellReuseIdentifier: "PaymentDetailsItemCell")
        
        cartTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        cartTableView.estimatedRowHeight = 110
        cartTableView.rowHeight = UITableView.automaticDimension
        
        cartTableView.reloadData()
    }
    
    func updateView() {
        
        if(selectedCheckoutType == .cart)
        {
            self.lblNoOfItems.text =  String(arrCart.count) + " " + getLocalizationString(key: "Items")
            
            if arrCart.count == 0  {
                cartTableView.isHidden = true
                lblNoOfItems.isHidden = true
                viewNoProductAvailable.isHidden = false
            } else {
                cartTableView.isHidden = false
                lblNoOfItems.isHidden = false
                viewNoProductAvailable.isHidden = true
            }
        }else{
            self.lblNoOfItems.text =  String(arrBuyNow.count) + " " + getLocalizationString(key: "Items")
            
            if arrBuyNow.count == 0  {
                cartTableView.isHidden = true
                lblNoOfItems.isHidden = true
                viewNoProductAvailable.isHidden = false
            } else {
                cartTableView.isHidden = false
                lblNoOfItems.isHidden = false
                viewNoProductAvailable.isHidden = true
            }
        }
        
        
    }
    
    
    @objc func orderSuccess() {
        //navigate to thank you screen
        
        let thankyouVC = ThankyouVC(nibName: "ThankyouVC", bundle: nil)
        self.navigationController?.pushViewController(thankyouVC, animated: true)
        
    }
    
    // MARK: - Redirect to login
    
    func redirectToLogin() {
        DispatchQueue.main.async {
            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
            let loginNavigationController = UINavigationController(rootViewController: loginVC)
            loginNavigationController.navigationBar.isHidden = true
            loginNavigationController.modalPresentationStyle = .fullScreen
            self.present(loginNavigationController, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableview Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            if(selectedCheckoutType == .cart)
            {
                return arrCart.count;
            }else{
                return arrBuyNow.count;
            }
        }else{
            if(selectedCheckoutType == .cart)
            {
                return arrCart.count > 0  ? 1 : 0
            }else{
                return arrBuyNow.count > 0  ? 1 : 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
            
            if(selectedCheckoutType == .buyNow)
            {
                cell.setProductData(product: arrBuyNow[indexPath.row])

            }else{
                cell.setProductData(product: arrCart[indexPath.row])
            }
            
            cell.btnDelete.tag =  indexPath.row
            cell.btnPlusQty.tag =  indexPath.row
            cell.btnMinusQty.tag =  indexPath.row
            
            cell.btnDelete.addTarget(self, action: #selector(btnRemoveClicked(_:)), for: .touchUpInside)
            cell.btnPlusQty.addTarget(self, action: #selector(btnPlusQtyClicked(_:)), for: .touchUpInside)
            cell.btnMinusQty.addTarget(self, action: #selector(btnMinusQtyClicked(_:)), for: .touchUpInside)
            
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailsItemCell", for: indexPath) as! PaymentDetailsItemCell
            cell.selectedCheckoutType = selectedCheckoutType
            cell.setPaymentDetails()
            
            cell.btnContinueCheckout.addTarget(self, action: #selector(btnContinueToCheckout(_:)), for: .touchUpInside)
            
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            self.navigateToProductDetails(detailDict: arrCart[indexPath.row])
        }
    }
    
    
    
    //MARK: - button Clicked
    
    @objc func btnPlusQtyClicked(_ sender: Any) {
        
        if(selectedCheckoutType == .cart)
        {
            let plusButton = sender as! UIButton
            let product = arrCart[plusButton.tag]
            
            let updatedQty = product["qty"].doubleValue + 1
            var updatedProduct = arrCart[plusButton.tag].dictionaryObject
            updatedProduct!["qty"] = updatedQty
            
            arrCart[plusButton.tag] = JSON(updatedProduct as Any)
            updateQtyAmount(row: plusButton.tag)
        }else{
            let plusButton = sender as! UIButton
            let product = arrBuyNow[plusButton.tag]
            
            let updatedQty = product["qty"].doubleValue + 1
            var updatedProduct = arrBuyNow[plusButton.tag].dictionaryObject
            updatedProduct!["qty"] = updatedQty
            
            arrBuyNow[plusButton.tag] = JSON(updatedProduct as Any)
            updateQtyAmount(row: plusButton.tag)
        }
        
        
    }
    
    @objc func btnMinusQtyClicked(_ sender: Any) {
        
        if(selectedCheckoutType == .cart)
        {
            let minusButton = sender as! UIButton
            let product = arrCart[minusButton.tag]
            
            let updatedQty = product["qty"].doubleValue - 1
            if updatedQty == 0 {
                //remove from cart alert
                return
            }
            var updatedProduct = arrCart[minusButton.tag].dictionaryObject
            updatedProduct!["qty"] = updatedQty
            
            arrCart[minusButton.tag] = JSON(updatedProduct as Any)
            updateQtyAmount(row: minusButton.tag)
        }else{
            let minusButton = sender as! UIButton
            let product = arrBuyNow[minusButton.tag]
            
            let updatedQty = product["qty"].doubleValue - 1
            if updatedQty == 0 {
                //remove from cart alert
                return
            }
            var updatedProduct = arrBuyNow[minusButton.tag].dictionaryObject
            updatedProduct!["qty"] = updatedQty
            
            arrBuyNow[minusButton.tag] = JSON(updatedProduct as Any)
            updateQtyAmount(row: minusButton.tag)
        }
        
    }
    
    @objc func btnRemoveClicked(_ sender: Any) {
        
        if(selectedCheckoutType == .cart)
        {
            let removeButton = sender as! UIButton
            let product = arrCart[removeButton.tag]
            
            showCustomAlertWithConfirm(title: APP_NAME, message: getLocalizationString(key: "RemoveFromCart"), vc: self) {
                removeItemFromCart(product: product)
                self.cartTableView.reloadData()
                self.updateView()
            }
        }else{
            let removeButton = sender as! UIButton
            
            showCustomAlertWithConfirm(title: APP_NAME, message: getLocalizationString(key: "RemoveFromCart"), vc: self)
            {
                arrBuyNow.remove(at: removeButton.tag)
                self.cartTableView.reloadData()
                self.updateView()
                self.tabBarController?.selectedIndex = 2
            }
            
        }
        
    }
    
    
    @objc func btnContinueToCheckout(_ sender: Any) {
        
        if(selectedCheckoutType == .cart)
        {
            if isGuestCheckoutActive {
                addToCartData()
            } else {
                if is_Logged_in {
                    addToCartData()
                } else {
                    redirectToLogin()
                }
            }
        }else{
            if isGuestCheckoutActive {
                addToCartData()
            } else {
                if is_Logged_in {
                    addToCartData()
                } else {
                    redirectToLogin()
                }
            }
        }
        
    }

    
    @IBAction func btnContinueShoppingClicked(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    //MARK:- Methods
    func updateQtyAmount(row : Int)
    {
        
        var indexPaths: [IndexPath] = []
        indexPaths.append(IndexPath(item: row, section: 0))
        indexPaths.append(IndexPath(item: 0, section: 1))
        cartTableView.reloadRows(at: indexPaths, with: .none)
        
    }
    
    // MARK: - API Calling
    
    func addToCartData() {
        showLoader()
        
        var cartParams = [Any]()
        
        var arrayData : [JSON] = []
        
        if(selectedCheckoutType == .cart)
        {
            arrayData = arrCart
        }else{
            arrayData = arrBuyNow
        }
        
        for item in arrayData {
            
            var productParams = [AnyHashable : Any]()
            productParams["product_id"] = item["id"].stringValue
            productParams["quantity"] = item["qty"].int
            if item["variation_id"].exists() {
                productParams["variation_id"] = item["variation_id"].int
            } else {
                productParams["variation_id"] = 0
            }
            if let arrVariations = item["variations"].dictionaryObject {
                productParams["variation"] = arrVariations
            } else {
                productParams["variation"] = ""
            }
            cartParams.append(productParams)
        }
        
        var params = [String : Any]()

        params["user_id"] = getValueFromLocal(key: USERID_KEY)
        params["cart_items"] = cartParams
        
        CiyaShopAPISecurity.add(toCart: params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    
                    
                    //Redirect webview
                    var checkoutUrl : String = ""
                    
                    let webviewVC = WebviewCheckoutVC(nibName: "WebviewCheckoutVC", bundle: nil)
                    webviewVC.dictParams = params
                    webviewVC.isBuyNow = self.isBuyNow
                    
                    checkoutUrl = jsonReponse["checkout_url"].stringValue
                    
                    if let isCurrency = getValueFromLocal(key: kCurrency) as? Bool{
                        if isCurrency == true && getValueFromLocal(key: kCurrencyText) != nil  && getValueFromLocal(key: kCurrencyText) as? String != ""  {
                            checkoutUrl = checkoutUrl + (getValueFromLocal(key: kCurrencyText) as! String)
                        }
                    }
                    
                    webviewVC.url = checkoutUrl
                    
                    
                    //----
                    
                    
                    if jsonReponse["thankyou"].exists() {
                        webviewVC.urlThankyou = jsonReponse["thankyou"].stringValue
                    }
                    
                    if jsonReponse["thankyou_endpoint"].exists() {
                        webviewVC.urlThankYouEndPoint = jsonReponse["thankyou_endpoint"].stringValue
                    }
                    
                    
                    self.navigationController?.pushViewController(webviewVC, animated: true)
                    
                    

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
    
}
