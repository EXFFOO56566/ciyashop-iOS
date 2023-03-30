//
//  ProductDetailVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 13/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SwiftyJSON
import CiyaShopSecurityFramework
enum ProductType : String
{
    case simple = "simple"
    case grouped = "grouped"
    case variable = "variable"
    case external = "external"
}

enum DetailCell
{
    case basicInfoCell
    case detailInfoCell
    case sizeColor
    case sellerInfo
    case overview
    case productDetails
    case ratingReview
    case relatedProducts
    case groupItems
    
}

class ProductDetailVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var tblProductDetail: UITableView!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnOutOfStock: UIButton!
    @IBOutlet weak var btnGoToCart: UIButton!

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var heightConstraintHeader: NSLayoutConstraint!

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnViewBack: UIButton!

    
    //MARK:-Variables
    var arrayDetailCells : [DetailCell] = []
    var isGroupDetail = true
    var dictProductDetail = JSON()
    var page = 1
    var arrayGroupedProducts : [JSON] = []
    var arrayReviews : [JSON] = []
    var arrayRelatedProducts : [JSON] = []
    
    var arrayVariationImages : [JSON] = []
    var selectedVariationJson = JSON()
    var arrayInitialSelectedAttributes : [Any] = []
    var arrAttributes : [JSON] = []
    
    //---Variables for data after variation get
    var strPrice = ""
    var availability = false
    var onSale = false
    var strSalePrice : Float = 0.0
    var strRegularPrice : Float = 0.0
    var OneReviewCount = 0,TwoReviewCount = 0,ThreeReviewCount = 0,FourReviewCount = 0,FiveReviewCount = 0

    //---Pincode check
    var strPincode = ""
    
    //MARK:- Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        registerDatasourceCell()
        setUpDetailData()
        callAPI()
        
        addRemoveItemFromRecentList(product: dictProductDetail)
        
        // Facebook Pixel for Product content view
//        if  getValueFromLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY) as? Bool == true {
//            FacebookHelper.logViewedContentEvent(contentType: dictProductDetail["name"].stringValue, contentId: dictProductDetail["id"].stringValue, currency: strCurrencySymbol, price: dictProductDetail["price"].double ?? 0)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCartButton(dictproduct: dictProductDetail)
    }
    //MARK:- Call API
    func callAPI()
    {
        if(dictProductDetail["type"].stringValue == ProductType.variable.rawValue)
        {
            GetVariations()
        }
        if dictProductDetail["type"].stringValue == ProductType.grouped.rawValue
        {
            GetGroupedProducts()
        }
        GetAllReviews()
        GetRelatedProducts()

    }
    //MARK:- Setup UI
    func setUpUI()
    {
        // Initialization code
        setThemeColors()
        
        [btnBuyNow,btnAddToCart,btnOutOfStock,btnGoToCart].forEach { (button) in
             button?.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
            button?.setTitleColor(.white, for: .normal)
        }
        btnBuyNow.backgroundColor = secondaryColor
        btnAddToCart.backgroundColor = grayTextColor
        btnGoToCart.backgroundColor = grayTextColor

        btnBuyNow.setTitle(getLocalizationString(key: "BuyNow"), for: .normal)
        btnAddToCart.setTitle(getLocalizationString(key: "AddToCart"), for: .normal)
        btnGoToCart.setTitle(getLocalizationString(key: "GoToCart"), for: .normal)

        btnBuyNow.setImage(UIImage(named:"cart-icon")?.maskWithColor(color: UIColor.white), for: .normal)
        btnAddToCart.setImage(UIImage(named:"bag-icon")?.maskWithColor(color: UIColor.white), for: .normal)
        btnGoToCart.setImage(UIImage(named:"bag-icon")?.maskWithColor(color: UIColor.white), for: .normal)

        //---
        lblProductName.font = UIFont.appBoldFontName(size: fontSize14)
        lblProductName.textColor = secondaryColor
        //
        vwHeader.backgroundColor = headerColor
        self.heightConstraintHeader.constant = 0
        
        btnOutOfStock.backgroundColor = UIColor.red
        btnOutOfStock.setTitle(getLocalizationString(key: "OutOfStock"), for: .normal)
        btnOutOfStock.isUserInteractionEnabled = false
        btnOutOfStock.isHidden = true
        
        //----
        if isRTL {
            
            [btnAddToCart,btnBuyNow,btnGoToCart].forEach { (button) in
                button?.tintColor = .white
                button?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                button?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -12)
            }
        }
        
        SetUpDetailCells()
    }
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        [btnBack,btnViewBack].forEach { (button) in
            button?.tintColor = secondaryColor
               }
    }
    
    
    //MARK:- Set up API data
    func setUpDetailData()
    {
        print("Product Detail dict - ",dictProductDetail)
        arrayAllVariations = []
        arraySelectedVariationOptions = []

        lblProductName.text = dictProductDetail["name"].stringValue
         
        //----
        onSale = dictProductDetail["on_sale"].boolValue
        strRegularPrice = dictProductDetail["regular_price"].floatValue
        strSalePrice = dictProductDetail["sale_price"].floatValue
        strPrice = dictProductDetail["price_html"].stringValue
        availability = dictProductDetail["in_stock"].boolValue
        arrAttributes = dictProductDetail["attributes"].array ?? []

        setUpCartBuyNowButton(dictproduct:dictProductDetail)
    }
    // MARK: - Cell Register
    func registerDatasourceCell()
    {
        tblProductDetail.delegate = self
        tblProductDetail.dataSource = self
        
        tblProductDetail.setBackgroundColor()
        
        tblProductDetail.register(UINib(nibName: "BasicProductInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicProductInfoTableViewCell")
        tblProductDetail.register(UINib(nibName: "DetailProductInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailProductInfoTableViewCell")
        tblProductDetail.register(UINib(nibName: "SellerInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerInfoTableViewCell")
        tblProductDetail.register(UINib(nibName: "ProductOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductOverviewTableViewCell")
        tblProductDetail.register(UINib(nibName: "RatingReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingReviewTableViewCell")
        tblProductDetail.register(UINib(nibName: "RecentProductCell", bundle: nil), forCellReuseIdentifier: "RecentProductCell")
        tblProductDetail.register(UINib(nibName: "ProductDetailSizeColorCell", bundle: nil), forCellReuseIdentifier: "ProductDetailSizeColorCell")
        tblProductDetail.register(UINib(nibName: "RelatedProductTableViewCell", bundle: nil), forCellReuseIdentifier: "RelatedProductTableViewCell")
        tblProductDetail.register(UINib(nibName: "GroupItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupItemsTableViewCell")
        
    }
    //MARK:- SteUpFilterCells
    func SetUpDetailCells()
    {
        arrayDetailCells = []
        arrayDetailCells.append(.basicInfoCell)
        
        if dictProductDetail["grouped_products"].arrayValue.count > 0{
            arrayDetailCells.append(.groupItems)
        }
        if dictProductDetail["addition_info_html"].stringValue.count > 0{
            arrayDetailCells.append(.detailInfoCell)
        }
        
        if (dictProductDetail["attributes"].arrayValue.count>0 && dictProductDetail["type"].stringValue == ProductType.variable.rawValue && arrayAllVariations.count>0)
        {
            arrayDetailCells.append(.sizeColor)
        } else {
            if IS_PINCODE_ACTIVE {
                arrayDetailCells.append(.sizeColor)
            }
        }

        if dictProductDetail["seller_info"]["is_seller"].boolValue
        {
            arrayDetailCells.append(.sellerInfo)
        }
        if dictProductDetail["short_description"].stringValue.count != 0
        {
            arrayDetailCells.append(.overview)
        }
        if dictProductDetail["description"].stringValue.count != 0
        {
            arrayDetailCells.append(.productDetails)
        }
        arrayDetailCells.append(.ratingReview)
        arrayDetailCells.append(.relatedProducts)
        tblProductDetail.reloadData()
    }
 

}


//MARK:- Other methods
extension ProductDetailVC 
{
    
    func showHeaderView()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.heightConstraintHeader.constant = 50
            self.view.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
        })
    }
    func hideHeaderView()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.heightConstraintHeader.constant = 0
            self.view.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
        })
    }
    
}
//MARK:-  UITableview Delegate Datasource
extension ProductDetailVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDetailCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = arrayDetailCells[indexPath.row]
        
        if(cell == .basicInfoCell)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicProductInfoTableViewCell", for: indexPath) as! BasicProductInfoTableViewCell
            cell.dictDetails = dictProductDetail
            cell.onSale = onSale
            cell.strPrice = strPrice
            cell.availability = availability
            cell.strRegularPrice = strRegularPrice
            cell.btnWishList.addTarget(self, action: #selector(btnFavouriteClicked(_:)), for: .touchUpInside)
            cell.btnShare.addTarget(self, action: #selector(btnShareClicked(_:)), for: .touchUpInside)


            cell.strSalePrice = strSalePrice
            if (dictProductDetail["type"].stringValue == ProductType.variable.rawValue)
            {
                if(arrayAllVariations.count == 0)
                {
                    cell.arrayImages = dictProductDetail["images"].arrayValue
                }else{
                    cell.arrayImages = self.arrayVariationImages
                }
            }else{
                cell.arrayImages = dictProductDetail["images"].arrayValue
            }
            
            if let dictVideo = dictProductDetail["featured_video"].dictionary {
                cell.dictVideo = dictVideo
            }
            
            cell.RegisterNotification()
            
            cell.setUpData()

            return cell
        }
        else if(cell == .groupItems)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupItemsTableViewCell", for: indexPath) as! GroupItemsTableViewCell
            cell.dictDetails = dictProductDetail
            cell.arrayProducts = arrayGroupedProducts
            cell.setUpData()
            return cell
        }
        else if(cell == .detailInfoCell)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProductInfoTableViewCell", for: indexPath) as! DetailProductInfoTableViewCell
            cell.dictDetails = dictProductDetail
            cell.setUpData()
            return cell
        }
        else if(cell == .sizeColor)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailSizeColorCell", for: indexPath) as! ProductDetailSizeColorCell
            
            cell.dictDetail = dictProductDetail
            
            
            cell.setUpData()
            cell.tblVariation.reloadData()
            cell.handlerSelectedVariation = {
                self.reloadVariations()
            }
            
            cell.handlerCheckPincode = { pincode in
                
                self.strPincode = pincode
                self.CheckPinCode()
            }
            
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            
            return cell
        }
        else if(cell == .sellerInfo)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerInfoTableViewCell", for: indexPath) as! SellerInfoTableViewCell
            cell.dictDetails = dictProductDetail
            cell.setUpData()
            return cell
        }
        else if(cell == .overview)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductOverviewTableViewCell", for: indexPath) as! ProductOverviewTableViewCell
            cell.selectedCellType = .overview
            cell.dictDetails = dictProductDetail
            cell.setUpData()
            
            return cell
        }
        else if(cell == .productDetails)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductOverviewTableViewCell", for: indexPath) as! ProductOverviewTableViewCell
            
            cell.selectedCellType = .productDetails
            cell.dictDetails = dictProductDetail
            cell.setUpData()
            
            
            return cell
        }
        else if(cell == .ratingReview)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingReviewTableViewCell", for: indexPath) as! RatingReviewTableViewCell
            cell.dictDetails = dictProductDetail
            cell.setUpData()
            cell.setUpAPIData(arrayReviewsLocal: self.arrayReviews,oneCount:OneReviewCount,twoCount:TwoReviewCount,threeCount:ThreeReviewCount,fourCount:FourReviewCount,fiveCount:FiveReviewCount)
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            
            return cell
        }
        else if(cell == .relatedProducts)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedProductTableViewCell", for: indexPath) as! RelatedProductTableViewCell
            cell.setupCellHeader(strTitle: getLocalizationString(key: "RelatedProducts"))
            cell.dictDetails = dictProductDetail
            cell.setUpData(arrayProductsLocal: arrayRelatedProducts)
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- Button Action
extension ProductDetailVC
{
    @objc func btnFavouriteClicked(_ sender: UIButton)
    {
        onWishlistButtonClicked(viewcontroller: self, product: dictProductDetail) { (success) in
            
            self.tblProductDetail.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    @objc func btnShareClicked(_ sender: UIButton)
    {
        if DEEP_LINK_DOMAIN == "" {
            shareUrl(shortUrl: dictProductDetail["permalink"].stringValue, productd: dictProductDetail["id"].stringValue, vc: self)
        } else {
            generateDeepLink(product: dictProductDetail, viewcontroller: self)
        }
        
    }
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.BackNavigate()
    }
    @IBAction func btnAddToCartClicked(_ sender: UIButton)
    {
        if(dictProductDetail["type"].stringValue == ProductType.grouped.rawValue) {
            
            var isStock = false
            for groupProduct in arrayGroupedProducts {
                if let inStock = groupProduct["in_stock"].bool {
                    if inStock == true {
                        isStock = true
                        addItemInCart(product: groupProduct)
                    }
                }
            }
            if isStock {
               showToast(message: getLocalizationString(key: "ItemAddedCart"))
            }
            setUpCartButton(dictproduct: dictProductDetail)
        } else {
            if(dictProductDetail["type"].stringValue == ProductType.variable.rawValue)
            {
                let updatedProduct = getUpdatedProductWithVariation()
                if updatedProduct != nil {
                    if updatedProduct!["manage_stock"].exists() {
                        if updatedProduct!["manage_stock"].boolValue {
                            if updatedProduct!["stock_quantity"].intValue > 0  {
                                if updatedProduct != nil {
                                    addItemInCart(product: updatedProduct!)
                                    showToast(message: getLocalizationString(key: "ItemAddedCart"))
                                }
                            }
                        } else {
                            if updatedProduct != nil {
                                addItemInCart(product: updatedProduct!)
                                showToast(message: getLocalizationString(key: "ItemAddedCart"))
                            }
                        }
                        checkInCartData()
                    }
                }
            }else{
                addItemInCart(product:dictProductDetail)
                setUpCartBuyNowButton(dictproduct: dictProductDetail)
            }
        }
        
    }
    @IBAction func btnGoToCartClicked(_ sender: UIButton)
    {
        tabController?.selectedIndex = 1
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func btnBuyNowClicked(_ sender: UIButton)
    {
        if(dictProductDetail["type"].stringValue == ProductType.grouped.rawValue) {
            arrBuyNow.removeAll()
            
            var isStock = false
            for groupProduct in arrayGroupedProducts {
                if let inStock = groupProduct["in_stock"].bool {
                    if inStock == true {
                        isStock = true
                        var updatedProduct = groupProduct
                        if !updatedProduct["qty"].exists() {
                            updatedProduct["qty"] = 1
                        }
                        arrBuyNow.append(updatedProduct)
                    }
                }
            }
            if isStock {
                let vc = CartVC(nibName: "CartVC", bundle: nil)
                vc.selectedCheckoutType = .buyNow
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if(dictProductDetail["type"].stringValue == ProductType.variable.rawValue)
            {
                if(arrayAllVariations.count > 0)
                {
                    let product = getUpdatedProductWithVariation()
                    addItemForbuyNow(product: product ?? JSON())
                }else{
                    addItemForbuyNow(product: dictProductDetail)
                }
                
            }else{
                addItemForbuyNow(product: dictProductDetail)
            }
        }
        
    }
}
//MARK:- Buy now
extension ProductDetailVC
{
    func addItemForbuyNow(product: JSON)
    {
        arrBuyNow.removeAll()
        var updatedProduct = product
        if !updatedProduct["qty"].exists() {
            updatedProduct["qty"] = 1
        }
        arrBuyNow.append(updatedProduct)
        let vc = CartVC(nibName: "CartVC", bundle: nil)
        vc.selectedCheckoutType = .buyNow
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:- Variation set up
extension ProductDetailVC
{
    func reloadVariations() {
        let res = self.checkVariationAvailability()
        print(res ?? false)
        self.checkInCartData()
        
        strPrice = selectedVariationJson["price_html"].stringValue
//        availability = selectedVariationJson["in_stock"].boolValue
        onSale = selectedVariationJson["on_sale"].boolValue
        strRegularPrice = selectedVariationJson["regular_price"].floatValue
        strSalePrice = selectedVariationJson["sale_price"].floatValue
        
        let dictImage = selectedVariationJson["image"]
        var arrayImages : [JSON] = []
        arrayImages.append(dictImage)
        arrayVariationImages = arrayImages
        
        
        if arraySelectedVariationOptions.description == arrayInitialSelectedAttributes.description
        {
            arrayVariationImages = dictProductDetail["images"].arrayValue
        }else{
            arrayVariationImages = arrayImages
        }
        UIView.setAnimationsEnabled(false)

        tblProductDetail.reloadData()

    }
    func setDefautSelection()
    {
        
        arraySelectedVariationOptions.removeAll()
        
        if arrayAllVariations.count > 0 {
            for attribute in arrayAllVariations {
                if let options = attribute["options"].array {
                    if options.count > 0 {
                        arraySelectedVariationOptions.append(options[0])
                    }
                }
            }
        }
    }
    func checkSelectedVariation()
    {
       setDefautSelection()
       if arrayAllVariations.count > 0 && arrAttributes.count > 0 {
           if arrAttributes[0]["options"].arrayValue.count > 0 {
               arraySelectedVariationOptions.append(arrAttributes[0]["options"][0])
           }
       }
       
        
       if arrayAllVariations.count > 0 && arrAttributes.count > 0 {
           for variation in arrayAllVariations {
               var flag = false
               if let attributes = variation["attributes"].array {
                   
                   if arrAttributes.count > 0 {
                       if let options = arrAttributes[0]["options"].array {
                           if options.count > 0 {
                               if variation["attributes"].arrayValue.count > 0 && options[0] == attributes[0]["option"] {
                                if (attributes.count - 1) > 1 {
                                    for i in 1..<attributes.count {
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
           
           for i in 0..<arrAttributes.count {
               var flag = false
               for j in 0..<arrAttributes[i]["options"].arrayValue.count {
                   if arraySelectedVariationOptions.contains(arrAttributes[i]["options"][j]) {
                       flag = true
                       break
                   }
               }
               
               if flag == false {
                   if let options = arrAttributes[i]["options"].array {
                       if options.count > 0  && arraySelectedVariationOptions.count == i {
                           var pos : Int = 0
                           for k in 0..<arrayAllVariations.count {
                               var count : Int = 0
                               let attributes = arrayAllVariations[k]["attributes"].arrayValue
                               
                               if attributes.count > arraySelectedVariationOptions.count{
                                   for m in 0..<attributes.count {
                                       
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
                               let arr = arrayAllVariations[pos]["attributes"].arrayValue
                               let arrAttr = arrAttributes[i]["options"].arrayValue
                               
                               var posNew : Int = 0
                               for k in 0..<arr.count {
                                   
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


       if arraySelectedVariationOptions.count != arrAttributes.count {
           for i in 0..<arrAttributes.count {
               var flag = false
               for j in 0..<arrAttributes[i]["options"].arrayValue.count {
                   if arraySelectedVariationOptions.contains(arrAttributes[i]["options"][j]) {
                       flag = true
                       break
                   }
               }
               if flag == false && arrAttributes[i]["options"].arrayValue.count != 0 {
//                   arraySelectedVariationOptions.insert(arrAttributes[i]["options"][0], at: i)
                arraySelectedVariationOptions.append(arrAttributes[i]["options"][0])
               }
           }
       }
        arrayInitialSelectedAttributes = []
        arrayInitialSelectedAttributes = arraySelectedVariationOptions
    }
    func getUpdatedProductWithVariation() -> JSON?
    {
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
        var strImageUrl = ""

        
        var dictSelectedVariation = [String : JSON]()
        
        if arraySelectedVariationOptions.count > 0 {
            for i in 0..<arraySelectedVariationOptions.count {
                dictSelectedVariation[arrAttributes[i]["name"].stringValue] = arraySelectedVariationOptions[i]
            }
        }
        
        for i in 0..<arrayAllVariations.count {
            let arrAttrb = arrayAllVariations[i]["attributes"].arrayValue
            var flag : Int = 0
            if arrAttrb.count > 0 {
                for j in 0..<arrAttrb.count {
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
            }
            if flag == arrAttributes.count {
                selectedVariationJson = arrayAllVariations[i]
                
                print("selectedVariationJson stock check - 1 ",selectedVariationJson)
                variationId = arrayAllVariations[i]["id"].intValue
                inStock = arrayAllVariations[i]["in_stock"].boolValue
                
                strImageUrl = arrayAllVariations[i]["image"]["src"].stringValue
                if dictProductDetail["manageStock"].boolValue {
                    manageStock = dictProductDetail["manageStock"].boolValue
                    stockQuantity = arrayAllVariations[i]["stock_quantity"].intValue
                }else {
                    if arrayAllVariations[i]["manage_stock"].exists() {
                        if arrayAllVariations[i]["manage_stock"].boolValue {
                    
                            manageStock = arrayAllVariations[i]["manage_stock"].boolValue
                            stockQuantity = arrayAllVariations[i]["stock_quantity"].intValue

                        } else {
                            manageStock = false
                            stockQuantity = 0
                        }
                    } else {
                        manageStock = arrayAllVariations[i]["manage_stock"].boolValue
                        stockQuantity = 0
                    }
                }
                strHtmlPrice = arrayAllVariations[i]["price_html"].stringValue
                price = arrayAllVariations[i]["price"].doubleValue
                break
            } else if arrAttrb.count == 0 {
                selectedVariationJson = arrayAllVariations[i]
                print("selectedVariationJson stock check - 2 ",selectedVariationJson)

                variationId = arrayAllVariations[i]["id"].intValue
                inStock = arrayAllVariations[i]["in_stock"].boolValue
                
                if dictProductDetail["manageStock"].boolValue {
                    manageStock = dictProductDetail["manageStock"].boolValue
                    stockQuantity = arrayAllVariations[i]["stock_quantity"].intValue
                }else {
                    if arrayAllVariations[i]["manage_stock"].exists() {
                        if arrayAllVariations[i]["manage_stock"].boolValue {
                    
                            manageStock = arrayAllVariations[i]["manage_stock"].boolValue
                            stockQuantity = arrayAllVariations[i]["stock_quantity"].intValue

                        } else {
                            manageStock = false
                            stockQuantity = 0
                        }
                    } else {
                        manageStock = arrayAllVariations[i]["manage_stock"].boolValue
                        stockQuantity = 0
                    }
                }
                strImageUrl = arrayAllVariations[i]["image"]["src"].stringValue
                strHtmlPrice = arrayAllVariations[i]["price_html"].stringValue
                price = arrayAllVariations[i]["price"].doubleValue
                break
            }
            
            
        }
        if inStock == false {
            return nil
        }
        print("selectedVariationJson stock check - 3",selectedVariationJson)

        var updatedProduct = dictProductDetail
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
    func checkVariationAvailability()  -> Bool?
    {
        var available : Int = 0
        var selectedVariation : Int = -1
        var inStock = false
        
        for i in 0..<arrayAllVariations.count {
            available = 0
            var attributes  : [JSON]  = []
            if arrayAllVariations[i]["attributes"].arrayValue.count > 0 {
                for k in 0..<arrayAllVariations[i]["attributes"].arrayValue.count {
                    attributes.append(arrayAllVariations[i]["attributes"][k]["option"])
                }
            }
            if arraySelectedVariationOptions.count > 0 {
                for j in 0..<arraySelectedVariationOptions.count {
                    
                    if attributes.contains(arraySelectedVariationOptions[j]) {
                        available = available + 1
                    }
                    if available == arraySelectedVariationOptions.count {
                        break
                    }
                }
            }
            
            if attributes.count < arraySelectedVariationOptions.count {
                if available == attributes.count || available > attributes.count {
                    selectedVariation = i
                    selectedVariationJson = arrayAllVariations[i]
                    
                    if dictProductDetail["manageStock"].boolValue {
                        if arrayAllVariations[i]["stock_quantity"].intValue > 0 {
                            inStock = true
                        }
                    }else {
                        if arrayAllVariations[i]["manage_stock"].exists() {
                            if arrayAllVariations[i]["manage_stock"].boolValue {
                                if arrayAllVariations[i]["stock_quantity"].intValue > 0  {
                                    inStock = true
                                }
                            } else {
                                inStock = true
                            }
                        } else {
                            inStock = arrayAllVariations[i]["in_stock"].boolValue
                        }
                    }
                    available = arraySelectedVariationOptions.count
                    break
                }
            }
            
            if available == arraySelectedVariationOptions.count {
                 inStock = arrayAllVariations[i]["in_stock"].boolValue
                selectedVariation = i
                selectedVariationJson = arrayAllVariations[i]
                break
            }
        }
        
        if available < arraySelectedVariationOptions.count {
            //doneButtonOutStockUI()
            self.btnAddToCart.isEnabled = false
            self.btnGoToCart.isEnabled = false
            self.btnBuyNow.isEnabled = false
            availability = false
            showToast(message: getLocalizationString(key: "CombinationNotExists"))
            return false
        } else if available == arraySelectedVariationOptions.count {
            
            if !inStock {
                //doneButtonOutStockUI()
                self.btnAddToCart.isEnabled = false
                self.btnGoToCart.isEnabled = false
                self.btnBuyNow.isEnabled = false
                availability = false
                return false
            }
            if selectedVariation == -1 {
                if dictProductDetail["images"].arrayValue.count > 0 {
                    //strImageUrl = dictProductDetail["images"][0]["src"].stringValue
                } else {
                    //strImageUrl = ""
                }
            } else {
                if arrayAllVariations[selectedVariation]["image"]["src"].stringValue.contains("placeholder") {
                    if dictProductDetail["images"].arrayValue.count > 0 {
                        //strImageUrl = dictProductDetail["images"][0]["src"].stringValue
                    } else {
                        //strImageUrl = ""
                    }
                } else {
                    //strImageUrl = arrayAllVariations[selectedVariation]["image"]["src"].stringValue
                }
            }
            
            self.btnAddToCart.isEnabled = true
            self.btnGoToCart.isEnabled = true
            self.btnBuyNow.isEnabled = true
            availability = true
            return true
        }
        
        return false
    }
    func checkInCartData()
    {
        let updatedProduct = getUpdatedProductWithVariation()
        
        if updatedProduct != nil {
            let isExists = checkProductExistsInCart(updatedProduct: updatedProduct!)
            if isExists {
                setUpCartButton(dictproduct: updatedProduct!)
            } else {
                setUpCartButton(dictproduct: selectedVariationJson)

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
}
//MARK:- Variation data set
extension ProductDetailVC
{
    func setUpVariationData(jsonResponse:JSON)
    {
        
       if(jsonResponse.arrayValue.count > 0) {
           arrayAllVariations.append(contentsOf: jsonResponse.arrayValue)
           
           if(arrayAllVariations.count>=100) {
               self.page+=1
               self.GetVariations()
           } else {
               self.tblProductDetail.reloadData()
           }
            self.checkSelectedVariation()
            self.reloadVariations()
       }
       
            
    }
    
    func setUpCartBuyNowButton(dictproduct:JSON)
    {
        if dictproduct["type"].string == "grouped" {
            setUpCartButton(dictproduct: dictproduct)
        } else {
            if(dictProductDetail["in_stock"].boolValue)
            {
                btnOutOfStock.isHidden = true
                setUpCartButton(dictproduct:dictproduct)
                
            }else
            {
                btnOutOfStock.isHidden = false
                btnBuyNow.isHidden = true
                btnAddToCart.isHidden = true
                btnGoToCart.isHidden = true
            }
        }
        
       
    }
    
    func setUpCartButton(dictproduct:JSON)
    {
        if isCatalogMode {
            self.btnAddToCart.isHidden = true
            self.btnGoToCart.isHidden = true
            self.btnBuyNow.isHidden = true
            self.btnOutOfStock.isHidden = true
        } else {
            if dictproduct["type"].string == "external" {
                self.btnAddToCart.isHidden = true
                self.btnGoToCart.isHidden = true
                self.btnBuyNow.isHidden = true
                self.btnOutOfStock.isHidden = true
            } else if dictproduct["type"].string == "grouped" {
                //grouped product
                var isStock = false
                for groupProduct in arrayGroupedProducts {
                    if let inStock = groupProduct["in_stock"].bool {
                        if inStock == true {
                            isStock = true
                            break
                        }
                    }
                }
                if isStock {
                    self.btnAddToCart.isHidden = false
                    self.btnBuyNow.isHidden = false
                    self.btnGoToCart.isHidden = true
                    self.btnOutOfStock.isHidden = true
                } else {
                    self.btnAddToCart.isHidden = true
                    self.btnBuyNow.isHidden = true
                    self.btnGoToCart.isHidden = true
                    self.btnOutOfStock.isHidden = false
                }
                
                var isGroupItemsInCart = true
                for groupProduct in arrayGroupedProducts {
                    if let inStock = groupProduct["in_stock"].bool {
                        if inStock == true {
                            if checkItemExistsInCart(product: groupProduct) {
                               isGroupItemsInCart = true
                            } else {
                               isGroupItemsInCart = false
                                break
                            }
                        }
                    }
                }
                
                if isGroupItemsInCart {
                    self.btnGoToCart.isHidden = false
                    self.btnAddToCart.isHidden = true
                }
                
            }  else {
//                if isAddtoCartEnabled {
                    
                    if checkItemExistsInCart(product: dictproduct)
                    {
                        self.btnAddToCart.isHidden = true
                        self.btnGoToCart.isHidden = false
                    } else {
                        self.btnAddToCart.isHidden = false
                        self.btnGoToCart.isHidden = true
                    }
                    
                    if(dictProductDetail["in_stock"].boolValue) {
                        btnOutOfStock.isHidden = true
                    } else {
                        btnOutOfStock.isHidden = false
                        btnBuyNow.isHidden = true
                        btnAddToCart.isHidden = true
                        btnGoToCart.isHidden = true
                    }
                    
                    if let price = dictProductDetail["price"].double {
                        if price == 0 {
                            self.btnAddToCart.isHidden = true
                            self.btnGoToCart.isHidden = true
                            self.btnBuyNow.isHidden = true
                        } else {
//                            self.btnAddToCart.isHidden = false
//                            self.btnGoToCart.isHidden = false
                            self.btnBuyNow.isHidden = false
                        }
                    }
            }
        }
    }
    
}
//MARK:- Other methods
extension ProductDetailVC
{
    func NavigateToVariationView(dictDetail:JSON)
    {
        showVariationPopUp(vc: self, product: dictDetail)
    }
    func setUpReviewAPIData()
    {
        OneReviewCount = 0
        TwoReviewCount = 0
        ThreeReviewCount = 0
        FourReviewCount = 0
        FiveReviewCount = 0
        
        
        arrayReviews.forEach { (json) in
            if json["rating"].stringValue == "1"{
                OneReviewCount+=1
            }
            else if json["rating"].stringValue == "2"{
                TwoReviewCount+=1
            }
            else if json["rating"].stringValue == "3"{
                ThreeReviewCount+=1
            }
            else if json["rating"].stringValue == "4"{
                FourReviewCount+=1
            }
            else if json["rating"].stringValue == "5"{
                FiveReviewCount+=1
            }
        }
        
       
    }
}

//MARK:- API calling
extension ProductDetailVC
{
    func GetVariations()
    {
        showLoader()
        var params = [AnyHashable : Any]()
        params["per_page"] = "100"
        params["page"] = "\(page)"
        
        print("product id - ",dictProductDetail["id"].stringValue)
        
        CiyaShopAPISecurity.getVariations(params, productid: dictProductDetail["id"].int32Value) { (success, message, responseData) in
            let jsonReponse = JSON(responseData as Any)
            if success {
                print("Variation data - ",jsonReponse)
                self.setUpVariationData(jsonResponse: jsonReponse)
                self.SetUpDetailCells()

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
    func GetGroupedProducts()
    {
        showLoader()
        
        let arrayRelatedIds = dictProductDetail["grouped_products"].arrayObject

        var arrayStringIds : [String] = []
        
        arrayRelatedIds?.forEach({ (str) in
            arrayStringIds.append("\(str as! Int32)")
        })
        
        let strIds = arrayStringIds.joined(separator: ",")

        var params = [AnyHashable : Any]()
        params["include"] = strIds
        
        CiyaShopAPISecurity.productListing(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData as Any)
            if success {
                print("grouped products data - ",jsonReponse)
                
                self.arrayGroupedProducts = jsonReponse.arrayValue
                self.setUpCartButton(dictproduct: self.dictProductDetail)
                self.tblProductDetail.reloadData()
                
                
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
    func GetAllReviews()
    {
        showLoader()
        
        print("Product id - ",dictProductDetail["id"].int32Value)
        
        CiyaShopAPISecurity.getReviews(dictProductDetail["id"].int32Value) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData as Any)
            if success {
                print("review data - ",jsonReponse)
                self.arrayReviews = []
                self.arrayReviews = jsonReponse.arrayValue
                self.setUpReviewAPIData()
                self.tblProductDetail.reloadData()
                
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
    func CheckPinCode()
    {
        self.view.endEditing(true)
        showLoader()
        var params = [AnyHashable : Any]()
        params["pincode"] = strPincode
        params["product_id"] = dictProductDetail["id"].stringValue
        
        print("params - ",params)
        
        
    }
    func GetRelatedProducts()
    {
        showLoader()
        
        let arrayRelatedIds = dictProductDetail["related_ids"].arrayObject

        var arrayStringIds : [String] = []
        
        arrayRelatedIds?.forEach({ (str) in
            arrayStringIds.append("\(str as! Int32)")
        })
        
        let strIds = arrayStringIds.joined(separator: ",")

        var params = [AnyHashable : Any]()
        params["include"] = strIds
        params["page"] = page
        
        CiyaShopAPISecurity.productListing(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData as Any)
            if success {
                print("related products data - ",jsonReponse)
                
                self.arrayRelatedProducts = []
                self.arrayRelatedProducts = jsonReponse.arrayValue
            
                
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
}
extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
