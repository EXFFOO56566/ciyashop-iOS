//
//  VariationsVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 19/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework

typealias onConfirmDone = () -> Void
typealias onConfirmCancle = () -> Void

class VariationsVC: UIView, UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Outlets
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var tblVariation: UITableView!
    @IBOutlet weak var constraintVariationTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    //MARK:- Variables
    
    var arrAttributes : [JSON] = []
    
    var arrVariations : [JSON] = []
    var arrSelectedVariationOption : [JSON] = []
    
    
    var handlerSelectedVariation : ([JSON])->Void = {_  in}
    
    
    var dictDetail = JSON()
    var page = 1
    var selectedVariationJson = JSON()
    
    var strImageUrl : String = ""
    
    
    //MARK:- Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpUI()
    }
    
    func setUpData() {
        
        arrAttributes = dictDetail["attributes"].array ?? []
        
        setDefautSelection()
        
        arrVariations = []
        getVariations()
    }
    
    func setUpUI() {
        registerCell()
        
        tblVariation.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwContent.cornerRadius(radius: 5)
        
        [btnSave,btnCancel].forEach { (button) in
            button?.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
            button?.setTitleColor(.white, for: .normal)
        }
        
        btnSave.backgroundColor = secondaryColor
        btnCancel.backgroundColor = .lightGray
        
        btnSave.setTitle(getLocalizationString(key: "DONE").uppercased(), for: .normal)
        btnCancel.setTitle(getLocalizationString(key: "Cancel").uppercased(), for: .normal)
        
        doneButtonInStockUI()
        
    }
    
    private func registerCell() {
        tblVariation.delegate = self
        tblVariation.dataSource = self
        tblVariation.register(UINib(nibName: "VariationTableViewCell", bundle: nil), forCellReuseIdentifier: "VariationTableViewCell")
    }
    
    func setDefautSelection() {
        
        arrayAllVariations = arrVariations
        arraySelectedVariationOptions.removeAll()
        
        
        if arrVariations.count > 0 {
            for attribute in arrVariations {
                if let options = attribute["options"].array {
                    if options.count > 0 {
                        arraySelectedVariationOptions.append(options[0])
                    }
                }
            }
        }
    }
    
    func doneButtonInStockUI() {
        btnSave.alpha = 1
        btnSave.isUserInteractionEnabled = true
    }
    
    func doneButtonOutStockUI() {
        btnSave.alpha = 0.45
        btnSave.isUserInteractionEnabled = false
        self.parentContainerViewController()!.showToast(message: getLocalizationString(key: "CombinationNotExists"))
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let obj = object as? UITableView {
            if obj == self.tblVariation && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    print("newSize Review contentsize - ",newSize)
                    
                    if newSize.height >= screenHeight-200{
                        self.constraintVariationTableHeight.constant = screenHeight-200
                        
                    }else{
                        self.constraintVariationTableHeight.constant = newSize.height
                        
                    }
                    
                    
                    self.layoutIfNeeded()
                    self.layoutSubviews()
                }
            }
        }
    }
    
    
    //MARK:- Button action methods
    @IBAction func btnDoneClicked(_ sender: UIButton) {
        
        if btnSave.titleLabel?.text == getLocalizationString(key: "GoToCart").uppercased() {
            dismissView()
            if tabController?.selectedIndex == 1 {
                parentContainerViewController()?.navigationController?.popViewController(animated: true)
            } else {
                tabController?.selectedIndex = 1
            }
        } else {
            let updatedProduct = getUpdatedProductWithVariation()
            
            if updatedProduct != nil {
                if updatedProduct!["manage_stock"].exists() {
                    if updatedProduct!["manage_stock"].boolValue {
                        if updatedProduct!["stock_quantity"].intValue > 0  {
                            if updatedProduct != nil {
                                addItemInCart(product: updatedProduct!)
                                if self.parentContainerViewController()! is HomeVC {
                                    (self.parentContainerViewController() as! HomeVC).updateCartBadge()
                                }
                                if self.parentContainerViewController()! is ProductsVC {
                                    (self.parentContainerViewController() as! ProductsVC).updateCartBadge()
                                }
                                self.parentContainerViewController()!.showToast(message: getLocalizationString(key: "ItemAddedCart"))
                            }
                        }
                    } else {
                        if updatedProduct != nil {
                            addItemInCart(product: updatedProduct!)
                            if self.parentContainerViewController()! is HomeVC {
                                (self.parentContainerViewController() as! HomeVC).updateCartBadge()
                            }
                            if self.parentContainerViewController()! is ProductsVC {
                                (self.parentContainerViewController() as! ProductsVC).updateCartBadge()
                            }
                            self.parentContainerViewController()!.showToast(message: getLocalizationString(key: "ItemAddedCart"))
                        }
                    }
                }
            }
            dismissView()
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        dismissView()
    }
    
    //MARK:-  UITableview Delegate Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VariationTableViewCell", for: indexPath) as! VariationTableViewCell
        cell.selectionStyle = .none
        
        let dict = arrAttributes[indexPath.row]
        
        cell.dictDetails = dict
        
        cell.arrayVariationData = dict["new_options"].arrayValue
        cell.arrayOptionsData = dict["options"].arrayValue
        
        cell.attributeIndex = indexPath.row
        
        cell.setUpData()
        
        cell.handlerCheckSelectedVariation = {
            self.reloadVariations()
        }
        return cell
    }
    
    //MARK:- Dismiss View method
    func dismissView() {
        self.removeFromSuperview()
    }
    
}

//MARK:- API calling
extension VariationsVC {
    
    func reloadVariations() {
       let res = self.checkVariationAvailability()
        print(res ?? false)
        self.checkInCartData()
        
    }
    
    func getVariations() {
        showLoader()
        
        var params = [AnyHashable : Any]()
        params["per_page"] = "100"
        params["page"] = "\(page)"
        
        print("product id - ",dictDetail["id"].stringValue)
        
        CiyaShopAPISecurity.getVariations(params, productid: dictDetail["id"].int32Value) { (success, message, responseData) in
            
            hideLoader()
            
            let jsonResponse = JSON(responseData as Any)
            if success {
                print("Variation data - ",jsonResponse)
                
                if(jsonResponse.arrayValue.count > 0) {
                    self.arrVariations.append(contentsOf: jsonResponse.arrayValue)
                    
                    if(self.arrVariations.count>=100) {
                        self.page+=1
                        self.getVariations()
                    } else {
                        self.tblVariation.reloadData()
                    }
                }
                if self.arrVariations.count == 0 {
                    self.dismissView()
                }
                self.checkSelectedVariation()
                let res = self.checkVariationAvailability()
                print(res ?? false)
                self.checkInCartData()
            }
                
            else {
                if let message = jsonResponse["message"].string {
                    showCustomAlert(title: APP_NAME,message: message, vc: self.parentContainerViewController()!)
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self.parentContainerViewController()!)
                }
                if self.arrVariations.count == 0 {
                    self.dismissView()
                }
                
            }
        }
    }
        
    func checkSelectedVariation() {
        
        setDefautSelection()
        if arrVariations.count > 0 && arrAttributes.count > 0 {
            if arrAttributes[0]["options"].arrayValue.count > 0 {
                arraySelectedVariationOptions.append(arrAttributes[0]["options"][0])
            }
        }
        
        
        if arrVariations.count > 0 && arrAttributes.count > 0 {
            for variation in arrVariations {
                var flag = false
                if let attributes = variation["attributes"].array {
                    
                    if arrAttributes.count > 0 {
                        if let options = arrAttributes[0]["options"].array {
                            if options.count > 0 {
                                if variation["attributes"].arrayValue.count > 0 && options[0] == attributes[0]["option"] {
                                    if (attributes.count - 1) > 1 {
                                        for i in 1...(attributes.count - 1) {
                                            arraySelectedVariationOptions.append(attributes[i]["option"])
                                            flag = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if flag {
                        break
                    }
                }
            }
        }
        
        if arraySelectedVariationOptions.count != arrAttributes.count {
            
            for i in 0...(arrAttributes.count - 1) {
                var flag = false
                for j in 0...(arrAttributes[i]["options"].arrayValue.count - 1) {
                    if arraySelectedVariationOptions.contains(arrAttributes[i]["options"][j]) {
                        flag = true
                        break
                    }
                }
                
                if flag == false {
                    if arrVariations.count > 0 {
                        if let options = arrAttributes[i]["options"].array {
                            if options.count > 0  && arraySelectedVariationOptions.count == i {
                                var pos : Int = 0
                                
                                for k in 0...(arrVariations.count - 1) {
                                    var count : Int = 0
                                    let attributes = arrVariations[k]["attributes"].arrayValue
                                    
                                    if attributes.count > arraySelectedVariationOptions.count{
                                        for m in 0...(attributes.count - 1) {
                                            
                                            if arraySelectedVariationOptions.contains(attributes[m]["option"]) {
                                                count = count + 1
                                            }
                                            
                                            if count == arraySelectedVariationOptions.count {
                                                pos = k
                                                break
                                            }
                                        }
                                    }
                                }
                                
                                
                                if arrAttributes.count > 0 && arrAttributes.count > 0 {
                                    let arr = arrVariations[pos]["attributes"].arrayValue
                                    let arrAttr = arrAttributes[i]["options"].arrayValue
                                    
                                    var posNew : Int = 0
                                    for k in 0...(arr.count - 1) {
                                        
                                        if arrAttr.contains(arr[k]["option"]) {
                                            posNew = arrAttr.firstIndex(of: arr[k]["option"])!
                                            break
                                        }
                                    }
                                    arraySelectedVariationOptions.insert(arrAttributes[i]["options"][posNew], at: i)
                                }
                            }
                        }
                    }
                }
            }
        }


        if arraySelectedVariationOptions.count != arrAttributes.count {
            for i in 0...(arrAttributes.count - 1) {
                var flag = false
                for j in 0...(arrAttributes[i]["options"].arrayValue.count - 1) {
                    if arraySelectedVariationOptions.contains(arrAttributes[i]["options"][j]) {
                        flag = true
                        break
                    }
                }
                if flag == false && arrAttributes[i]["options"].arrayValue.count != 0 {
                    arraySelectedVariationOptions.insert(arrAttributes[i]["options"][0], at: i)
                }
            }
        }
        arrSelectedVariationOption = arraySelectedVariationOptions
    }
    
    func checkVariationAvailability() -> Bool? {
    
        var available : Int = 0
        var selectedVariation : Int = -1
        var inStock = false
        
        if arrayAllVariations.count > 0 {
            for i in 0...(arrayAllVariations.count - 1) {
                available = 0
                var attributes  : [JSON]  = []
                
                for k in 0...(arrayAllVariations[i]["attributes"].arrayValue.count - 1) {
                    attributes.append(arrayAllVariations[i]["attributes"][k]["option"])
                }
                
                for j in 0...(arraySelectedVariationOptions.count - 1) {
                    
                    if attributes.contains(arraySelectedVariationOptions[j]) {
                        available = available + 1
                    }
                    if available == arraySelectedVariationOptions.count {
                        break
                    }
                }
                
                if attributes.count < arraySelectedVariationOptions.count {
                    if available == attributes.count || available > attributes.count {
                        selectedVariation = i
                        
                        if dictDetail["manageStock"].boolValue {
                            if arrVariations[i]["stock_quantity"].intValue > 0 {
                                inStock = true
                            }
                        }else {
                            if arrVariations[i]["manage_stock"].exists() {
                                if arrVariations[i]["manage_stock"].boolValue {
                                    if arrVariations[i]["stock_quantity"].intValue > 0  {
                                        inStock = true
                                    }
                                } else {
                                    inStock = true
                                }
                            } else {
                                inStock = arrVariations[i]["in_stock"].boolValue
                            }
                        }
                        available = arraySelectedVariationOptions.count
                        break
                    }
                }
                
                if available == arraySelectedVariationOptions.count {
                    inStock = arrVariations[i]["in_stock"].boolValue
                    selectedVariation = i
                    break
                }
            }
            
            if available < arraySelectedVariationOptions.count {
                doneButtonOutStockUI()
                return false
            } else if available == arraySelectedVariationOptions.count {
                
                if !inStock {
                    doneButtonOutStockUI()
                    return false
                }
                if selectedVariation == -1 {
                    if dictDetail["images"].arrayValue.count > 0 {
                        strImageUrl = dictDetail["images"][0]["src"].stringValue
                    } else {
                        strImageUrl = ""
                    }
                } else {
                    if arrVariations[selectedVariation]["image"]["src"].stringValue.contains("placeholder") {
                        if dictDetail["images"].arrayValue.count > 0 {
                            strImageUrl = dictDetail["images"][0]["src"].stringValue
                        } else {
                            strImageUrl = ""
                        }
                    } else {
                        strImageUrl = arrVariations[selectedVariation]["image"]["src"].stringValue
                    }
                }
                arrSelectedVariationOption = arraySelectedVariationOptions
                
                doneButtonInStockUI()
                return true
            }
        }
        return false
        
        

    }
    
    func checkInCartData() {
        let updatedProduct = getUpdatedProductWithVariation()
        
        if updatedProduct != nil {
            let isExists = checkProductExistsInCart(updatedProduct: updatedProduct!)
            if isExists {
                btnSave.setTitle(getLocalizationString(key: "GoToCart").uppercased(), for: .normal)
            } else {
                btnSave.setTitle(getLocalizationString(key: "DONE").uppercased(), for: .normal)
            }
        
        }
    }
    
    func checkProductExistsInCart(updatedProduct : JSON) -> Bool {
        
        if updatedProduct["manageStock"].boolValue {
            if updatedProduct["manageStock"].intValue == 0 {
                return false
            }
        }
        
        for product in arrCart {
            if product["id"].stringValue == updatedProduct["id"].stringValue {
                if product["variation_id"].exists() {
                    if product["variation_id"].intValue == updatedProduct["variation_id"].intValue {
                        if product["variations"].exists() {
                            if product["variations"] == updatedProduct["variations"] {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    
    func getUpdatedProductWithVariation() -> JSON? {
        let isVariationAvailable = checkVariationAvailability()
        
        if isVariationAvailable == false {
            return nil
        }
        
        var variationId : Int = 0
        var stockQuantity : Int = 0
        var price : Double = 0
        var inStock : Bool = false
        var manageStock : Bool = false
        
        var strHtmlPrice = ""
        
        
        var dictSelectedVariation = [String : JSON]()
        
        for i in 0...(arraySelectedVariationOptions.count - 1) {
            dictSelectedVariation[arrAttributes[i]["name"].stringValue] = arraySelectedVariationOptions[i]
        }
        
        for i in 0...(arrVariations.count - 1) {
            let arrAttrb = arrVariations[i]["attributes"].arrayValue
            var flag : Int = 0
            
            for j in 0...(arrAttrb.count - 1) {
                if arraySelectedVariationOptions.contains(arrAttrb[j]["option"]) {
                    if arrAttrb.count < arrAttributes.count {
                        flag = flag + 1
                        if flag == arrAttrb.count {
                            flag = arrAttributes.count
                            break
                        }
                    } else {
                        flag = flag + 1
                    }
                    if flag == arrAttributes.count {
                        break
                    }
                }
            }
            if flag == arrAttributes.count {
                variationId = arrVariations[i]["id"].intValue
                inStock = arrVariations[i]["in_stock"].boolValue
                
                
                if dictDetail["manageStock"].boolValue {
                    manageStock = dictDetail["manageStock"].boolValue
                    stockQuantity = arrVariations[i]["stock_quantity"].intValue
                }else {
                    if arrVariations[i]["manage_stock"].exists() {
                        if arrVariations[i]["manage_stock"].boolValue {
                    
                            manageStock = arrVariations[i]["manage_stock"].boolValue
                            stockQuantity = arrVariations[i]["stock_quantity"].intValue

                        } else {
                            manageStock = false
                            stockQuantity = 0
                        }
                    } else {
                        manageStock = arrVariations[i]["manage_stock"].boolValue
                        stockQuantity = 0
                    }
                }
                strHtmlPrice = arrVariations[i]["price_html"].stringValue
                price = arrVariations[i]["price"].doubleValue
                break
            } else if arrAttrb.count == 0 {
                variationId = arrVariations[i]["id"].intValue
                inStock = arrVariations[i]["in_stock"].boolValue
                
                if dictDetail["manageStock"].boolValue {
                    manageStock = dictDetail["manageStock"].boolValue
                    stockQuantity = arrVariations[i]["stock_quantity"].intValue
                }else {
                    if arrVariations[i]["manage_stock"].exists() {
                        if arrVariations[i]["manage_stock"].boolValue {
                    
                            manageStock = arrVariations[i]["manage_stock"].boolValue
                            stockQuantity = arrVariations[i]["stock_quantity"].intValue

                        } else {
                            manageStock = false
                            stockQuantity = 0
                        }
                    } else {
                        manageStock = arrVariations[i]["manage_stock"].boolValue
                        stockQuantity = 0
                    }
                }
                strHtmlPrice = arrVariations[i]["price_html"].stringValue
                price = arrVariations[i]["price"].doubleValue
                break
            }
            
            
        }
        if inStock == false {
            return nil
        }
        
        var updatedProduct = dictDetail
        updatedProduct["app_thumbnail"] = JSON(strImageUrl)
        updatedProduct["qty"] = 1
        updatedProduct["price_html"] = JSON(strHtmlPrice)
        updatedProduct["variation_id"] = JSON(variationId)
        updatedProduct["price"] = JSON(price)
        updatedProduct["variations"] = JSON(dictSelectedVariation)
        updatedProduct["manageStock"] = JSON(manageStock)
        updatedProduct["stockQuantity"] = JSON(stockQuantity)
        
        return updatedProduct
    }
    
}
