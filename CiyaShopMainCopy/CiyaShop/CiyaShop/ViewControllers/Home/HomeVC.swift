//
//  HomeVC.swift
//  CiyaShop
//
//  Created by Apple on 11/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SDWebImage
import SwiftyJSON

enum HomeCellType {
    case mainCategory
    case slider
    case categoryBanner
    case specialDeals
    case featureProducts
    case recentProducts
    case topRatedProducts
    case popularProducts
    case customSection
    case bannerAds
    case featureBox
    case recenetViewed
    
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLogo: UIImageView!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cartButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    
    @IBOutlet weak var vwCartBadge: UIView!
    @IBOutlet weak var lblBadge: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrHomeCells : [HomeCellType] = []
    
    var arrFeatureProducts : Array = Array<JSON>()
    var arrRecentProducts : Array = Array<JSON>()
    var arrTopRatedProducts : Array = Array<JSON>()
    var arrPopularProducts : Array = Array<JSON>()
    

    // Infinite Scroll
    @IBOutlet weak var cvTopCategories: UICollectionView!
    @IBOutlet weak var cvProducts: UICollectionView!
    
    var loadingView: LoadingReusableView?
    var isLoading = false
    
    var headerFrame : CGRect = .zero
    var topCollectionFrame : CGRect = .zero
    
    var previousPoint: CGFloat = 0
    var delayBuffer: CGFloat = 0
    
    var maxFollowPoint: CGFloat = -44
    
    let refreshControl = UIRefreshControl()
    // MARK: - Life Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setHeaderImage()
        setupRefreshControl()
        if isInfiniteHomeScreen {
            
        } else {
            setupCollectionCells()
        }
        
        
        registerDatasourceCell()
        setThemeColors()
        
        
        // for deep linking
        if deepLinkProdcutId != "" {
            checkDeepLink(deepLinkProdcutId)
            deepLinkProdcutId = ""
        }
        
        // for Notification
        if receivedNotification.count > 0 {
            checkNotificationReceived()
            receivedNotification = JSON()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartBadge()
        
        if isInfiniteHomeScreen {
            let visibleItems =  cvProducts.indexPathsForVisibleItems
            cvProducts.reloadItems(at: visibleItems)
        } else {
            guard let visibleRows =  tableView.indexPathsForVisibleRows else { return }
            
            var visibleIndexPaths = [IndexPath]()
            
            for indexpath in visibleRows {
                if arrHomeCells[indexpath.row] == .recentProducts || arrHomeCells[indexpath.row] == .topRatedProducts || arrHomeCells[indexpath.row] == .featureProducts || arrHomeCells[indexpath.row] == .popularProducts || arrHomeCells[indexpath.row] == .customSection {
                    
                    visibleIndexPaths.append(IndexPath(item: indexpath.row, section: indexpath.section))
                }
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: visibleIndexPaths, with: .none)
            tableView.endUpdates()
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.headerFrame = self.headerView.frame
        self.topCollectionFrame = self.cvTopCategories.frame
    }
    
    @objc func changeSaleTimer() {
        
        saleSeconds = saleSeconds - 1;
        if (saleMinute == 0 && saleHours == 0 && saleSeconds == 0) {
            //remove data of the table
        }
        else {
            if (saleSeconds == -1) {
                saleSeconds = 59;
                saleMinute = saleMinute - 1;
                if(saleMinute == -1) {
                    saleMinute = 59;
                    saleHours = saleHours - 1;
                    if (saleHours == -1) {
                        saleHours = 0;
                    }
                }
            }
        }
    }
    
    // MARK: - Check Deep linking
    func checkDeepLink(_ productId: String) {
                self.getSingleProduct(productId: productId)
    }
    
    func checkNotificationReceived() {
        if receivedNotification["aps"]["alert"]["not_code"].intValue == 1 {
            tabController?.selectedIndex = 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: REDIRECT_MY_COUPONS), object: nil)
            }
        } else if receivedNotification["aps"]["alert"]["not_code"].intValue == 2 {
            tabController?.selectedIndex = 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: REDIRECT_MY_ORDERS), object: nil)
            }
        }
    }
    // MARK: - Update cart badge
    
    func updateCartBadge() {
        
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
    }
    
    // MARK: - Dyanmic Collection view cells setup
    func setupCollectionCells()  {
        arrHomeCells = []
        arrHomeCells.append(.mainCategory)
        if arrSliders.count > 0 {
            arrHomeCells.append(.slider)
        }
        
        if dictProductCarousel.count > 0 {
            if let recentProducts = (dictProductCarousel["recent_products"] as! JSON)["products"].array {
                if recentProducts.count > 0  && (dictProductCarousel["recent_products"] as! JSON)["status"].string != "disable" {
                    arrHomeCells.append(.recentProducts)
                    arrRecentProducts = recentProducts
                }
            }
        }
        
        
        
        if arrCategoryBanners.count > 0 {
            arrHomeCells.append(.categoryBanner)
        }
        
        for productViewOrder in arrProductViewOrder {
            let productOrder = productViewOrder as! JSON
            if "special_deal_products" == productOrder["name"] {
                if let specialProducts = (dictProductCarousel["special_deal_products"] as! JSON)["products"].array {
                    if specialProducts.count > 0 && (dictProductCarousel["special_deal_products"] as! JSON)["status"].string != "disable" {
                        arrHomeCells.append(.specialDeals)
                        arrSpecialDeals = specialProducts
                        
                        saleHours = Int(specialProducts[0]["deal_life"]["hours"].string!)!
                        saleMinute = Int(specialProducts[0]["deal_life"]["minutes"].string!)!
                        saleSeconds = Int(specialProducts[0]["deal_life"]["seconds"].string!)!
                        
                        saleTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeSaleTimer), userInfo: nil, repeats: true)
                        
                    }
                }
            } else if "feature_products" == productOrder["name"] {
                if let featureProducts = (dictProductCarousel["feature_products"] as! JSON)["products"].array {
                    if featureProducts.count > 0 && (dictProductCarousel["feature_products"] as! JSON)["status"].string != "disable"{
                        arrHomeCells.append(.featureProducts)
                        arrFeatureProducts = featureProducts
                    }
                }
                if arrBannersAd.count > 0 {
                    arrHomeCells.append(.bannerAds)
                }
            }

            else if "top_rated_products" == productOrder["name"] {
                if let topRatedProducts = (dictProductCarousel["top_rated_products"] as! JSON)["products"].array {
                    if topRatedProducts.count > 0 && (dictProductCarousel["top_rated_products"] as! JSON)["status"].string != "disable" {
                        arrHomeCells.append(.topRatedProducts)
                        arrTopRatedProducts = topRatedProducts
                    }
                }
            } else if "popular_products" == productOrder["name"] {
                if let popularProducts = (dictProductCarousel["popular_products"] as! JSON)["products"].array {
                    if popularProducts.count > 0 && (dictProductCarousel["popular_products"] as! JSON)["status"].string != "disable"{
                        arrHomeCells.append(.popularProducts)
                        arrPopularProducts = popularProducts
                    }
                }
            }
        }
        
        if arrCustomSection.count > 0 {
            arrHomeCells.append(.customSection)
        }
        
        if isFeatureEnabled {
            if arrReasonToBuy.count > 0 {
                arrHomeCells.append(.featureBox)
            }
        }
        if arrRecentlyViewedItems.count > 0 {
            arrHomeCells.append(.recenetViewed)
        }
        
        
    }
    
    // MARK: - Header Image
    func setHeaderImage()  {
        if appLogoLight != "" {
            self.headerLogo.sd_setImage(with: appLogoLight.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                if (image == nil) {
                    self.headerLogo.image = UIImage(named: "appLogo")
                } else {
                    self.headerLogo.image = image
                }
            }
        } else {
            self.headerLogo.image = UIImage(named: "appLogo")
        }
        btnMenu.tintColor =  secondaryColor
        btnSearch.tintColor =  secondaryColor
        btnCart.tintColor =  secondaryColor
        btnNotification.tintColor =  secondaryColor
        
        vwCartBadge.backgroundColor = secondaryColor
        lblBadge.textColor = primaryColor
    }
    
    // MARK: - Cell Register
    func registerDatasourceCell()  {
        
        if isInfiniteHomeScreen {
            
            maxFollowPoint = -(self.headerView.frame.size.height + cvTopCategories.frame.size.height)
            
            self.cvTopCategories.isHidden = false
            self.cvProducts.isHidden = false
            self.tableView.isHidden = true
            
            cvTopCategories.delegate = self
            cvTopCategories.dataSource = self
            cvTopCategories.register(UINib(nibName: "TopCategoryItemCell", bundle: nil), forCellWithReuseIdentifier: "TopCategoryItemCell")
            
            cvProducts.delegate = self
            cvProducts.dataSource = self
        
            cvProducts.register(UINib(nibName: "ProductItemCell", bundle: nil), forCellWithReuseIdentifier: "ProductItemCell")
            cvProducts.register(UINib(nibName: "LoadingReusableView" ,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingReusableView")
            
//            cvProducts.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
            
        } else {
            
            maxFollowPoint = -self.headerView.frame.size.height
            
            self.cvTopCategories.isHidden = true
            self.cvProducts.isHidden = true
            self.tableView.isHidden = false
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "TopCategoriesCell", bundle: nil), forCellReuseIdentifier: "TopCategoriesCell")
            tableView.register(UINib(nibName: "SliderBannersCell", bundle: nil), forCellReuseIdentifier: "SliderBannersCell")
            tableView.register(UINib(nibName: "CategoryBannerCell", bundle: nil), forCellReuseIdentifier: "CategoryBannerCell")
            tableView.register(UINib(nibName: "SpecialDealProductCell", bundle: nil), forCellReuseIdentifier: "SpecialDealProductCell")
            tableView.register(UINib(nibName: "FeatureProductCell", bundle: nil), forCellReuseIdentifier: "FeatureProductCell")
            tableView.register(UINib(nibName: "RecentProductCell", bundle: nil), forCellReuseIdentifier: "RecentProductCell")
            tableView.register(UINib(nibName: "BannersAdsCell", bundle: nil), forCellReuseIdentifier: "BannersAdsCell")
            tableView.register(UINib(nibName: "FeatureBoxCell", bundle: nil), forCellReuseIdentifier: "FeatureBoxCell")
            tableView.register(UINib(nibName: "RecentViewedProductCell", bundle: nil), forCellReuseIdentifier: "RecentViewedProductCell")
            
            
            tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 100
            self.tableView.separatorColor = UIColor.clear
            tableView.backgroundView?.backgroundColor = .clear
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        }
    }
    
    // MARK: - Setup refresh control
    func setupRefreshControl()  {
        
        if isInfiniteHomeScreen {
            
            refreshControl.addTarget(self, action: #selector(reloadHomeData), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = secondaryColor
            if #available(iOS 10.0, *) {
                cvProducts.refreshControl = refreshControl
            } else {
                // Fallback on earlier versions
                cvProducts.addSubview(refreshControl)
            }
        } else {
            refreshControl.addTarget(self, action: #selector(reloadHomeData), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = secondaryColor
            if #available(iOS 10.0, *) {
                tableView.refreshControl = refreshControl
            } else {
                // Fallback on earlier versions
                tableView.addSubview(refreshControl)
            }
        }
    }
    
    @objc func reloadHomeData() {
        tableView.endEditing(true)
        refreshControl.endRefreshing()
        NotificationCenter.default.post(name: Notification.Name(rawValue: REFRESH_HOME_DATA), object: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Get product api
    func getRadomProduct() {
        
        //for call apis
        if !self.isLoading {
            self.isLoading = true
            loadingView?.isHidden = false
        
            var params = [AnyHashable : Any]()
            params["product-per-page"] = 10
            if arrRadomProducts.count > 0 {
                let ids = arrRadomProducts.map { $0["id"].stringValue }
                if ids.count > 0 {
                    params["loaded"] = ids
                }
            } else {
                params["loaded"] = []
            }
            
            CiyaShopAPISecurity.productRandom(params) { (success, message, responseData) in
                
                let jsonReponse = JSON(responseData!)
                
                if success {
                    if let productArray = jsonReponse.array {
                        if productArray.count > 0 {
                            arrRadomProducts += productArray
                        }

                            self.cvProducts.reloadData()
                            self.loadingView?.isHidden = true
                            self.isLoading = false
                    }
                } else {
                   
                        self.loadingView?.isHidden = true
                        self.isLoading = false
                }
            }
        }
    }
    

    
    //MARK: - Cell Button Clicked
    
    @IBAction func btnCartClicked(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    
    
    @IBAction func btnNotificationClicked(_ sender: Any) {
        let notificationsVC = NotificationsVC(nibName: "NotificationsVC", bundle: nil)
        self.navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        self.tableView.setBackgroundColor()
        self.cvProducts.setBackgroundColor()
    }
    
    //MARK: - Cell Button Clicked
    @objc func btnFavouriteClicked(_ sender: Any) {
        let favouriteButton = sender as! UIButton
        let product = arrRadomProducts[favouriteButton.tag]
        
        if checkItemExistsInWishlist(productId: product["id"].stringValue) {
            addRemoveItemFromWishlist(product: product, vc: self)
        }
        
        cvProducts.reloadItems(at: createIndexPathArray(row: favouriteButton.tag, section:0))
    }
    
    @objc func btnAddtoCartClicked(_ sender: Any) {
        let cartButton = sender as! UIButton
        let product = arrRadomProducts[cartButton.tag]

        onAddtoCartButtonClicked(viewcontroller: self, product: product, collectionView: cvProducts, index: cartButton.tag)
        self.updateCartBadge()
    }
    
    func redirectProductList(type : HomeCellType) {
        let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
        
        if type == .featureProducts { //Feature products
            productsVC.fromFeaturedProducts = true
        } else if type == .specialDeals { //Special deals products
            productsVC.fromDealofTheDay = true
        } else if type == .topRatedProducts { //Top Rated products
            productsVC.fromTopRatedProducts = true
        } else if type == .recentProducts { //Recent products
            
        } else if type == .popularProducts { //Popular products
            productsVC.fromPopularProduct = true
        } else if type == .customSection { //Custom Section
            
        }
        
        self.navigationController?.pushViewController(productsVC, animated: true)
    }
    
}


extension HomeVC: UITableViewDataSource,UITableViewDelegate {
    // MARK: - UITableview Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrHomeCells.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // For tableCell Estimated Height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellType = arrHomeCells[indexPath.row]
        if let featureCell = cell as? FeatureProductCell {
            if  cellType == .featureProducts {
                featureCell.arrProducts = self.arrFeatureProducts
                
                DispatchQueue.global(qos: .default).async {
                    featureCell.reloadCollectionData()
                }
                
                
            } else if  cellType == .popularProducts {
                featureCell.arrProducts = self.arrPopularProducts
                DispatchQueue.global(qos: .default).async {
                        featureCell.reloadCollectionData()
                }
            } else if  cellType == .customSection {
                featureCell.arrProducts = arrCustomSection
                
            
                DispatchQueue.global(qos: .default).async {
                        featureCell.reloadCollectionData()
                }
            }
        } else if let recentCell = cell as? RecentProductCell {
            if  cellType == .recentProducts {
                recentCell.arrProducts = self.arrRecentProducts
                DispatchQueue.global(qos: .default).async {
                        recentCell.reloadCollectionData()
                }
            } else if  cellType == .topRatedProducts {
                recentCell.arrProducts = self.arrTopRatedProducts
                DispatchQueue.global(qos: .default).async {
                        recentCell.reloadCollectionData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = arrHomeCells[indexPath.row]
        
        if cellType == .mainCategory {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCategoriesCell", for: indexPath) as! TopCategoriesCell
            return cell
            
        } else if cellType == .slider {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SliderBannersCell", for: indexPath) as! SliderBannersCell
            return cell
            
        } else if cellType == .categoryBanner {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryBannerCell", for: indexPath) as! CategoryBannerCell
            return cell
            
        } else if cellType == .featureProducts {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureProductCell", for: indexPath) as! FeatureProductCell
            arrayRelatedProducts = self.arrFeatureProducts
            cell.arrProducts = self.arrFeatureProducts
            cell.setupCellHeader(strTitle: (dictProductCarousel["feature_products"] as! JSON)["title"].string!)
            
            cell.viewAllButtonAction = { [unowned self] in
                self.redirectProductList(type: .featureProducts)
            }
            cell.cellType = .featureProducts
            cell.btnViewAll.isHidden = false
            cell.layoutIfNeeded()
            return cell
            
        } else if cellType == .specialDeals {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialDealProductCell", for: indexPath) as! SpecialDealProductCell
            cell.arrProducts = arrSpecialDeals
            cell.setupCellHeader(strTitle: (dictProductCarousel["special_deal_products"] as! JSON)["title"].string!)
            
            cell.viewAllButtonAction = { [unowned self] in
                self.redirectProductList(type: .specialDeals)
            }
            
            return cell
            
        } else if cellType == .recentProducts {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentProductCell", for: indexPath) as! RecentProductCell
            cell.arrProducts = self.arrRecentProducts
            cell.setupCellHeader(strTitle: (dictProductCarousel["recent_products"] as! JSON)["title"].string!)
            
            cell.viewAllButtonAction = { [unowned self] in
                self.redirectProductList(type: .recentProducts)
            }
            
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            return cell
            
        } else if cellType == .topRatedProducts {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentProductCell", for: indexPath) as! RecentProductCell
            cell.arrProducts = self.arrTopRatedProducts
            cell.setupCellHeader(strTitle: (dictProductCarousel["top_rated_products"] as! JSON)["title"].string!)
            
            cell.viewAllButtonAction = { [unowned self] in
                self.redirectProductList(type: .topRatedProducts)
            }
            
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            return cell
            
        }  else if cellType == .popularProducts {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureProductCell", for: indexPath) as! FeatureProductCell
            cell.arrProducts = self.arrPopularProducts
            cell.setupCellHeader(strTitle: (dictProductCarousel["popular_products"] as! JSON)["title"].string!)
            
            cell.viewAllButtonAction = { [unowned self] in
                self.redirectProductList(type: .popularProducts)
            }
            cell.cellType = .popularProducts
            cell.btnViewAll.isHidden = false
            cell.layoutIfNeeded()
            return cell
            
        } else if cellType == .customSection {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureProductCell", for: indexPath) as! FeatureProductCell
            cell.arrProducts = arrCustomSection
            cell.setupCellHeader(strTitle: strProductBannerTitle)
            
            cell.viewAllButtonAction = { [unowned self] in
                self.redirectProductList(type: .customSection)
            }
            cell.cellType = .customSection
            cell.btnViewAll.isHidden = true
            
            cell.layoutIfNeeded()
            return cell
            
        } else if cellType == .bannerAds {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannersAdsCell", for: indexPath) as! BannersAdsCell
            return cell
            
        } else if cellType == .featureBox {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureBoxCell", for: indexPath) as! FeatureBoxCell
            cell.arrProducts = arrReasonToBuy
            cell.setupCellHeader(strTitle: strReasonsToBuy)
            return cell
            
        } else if cellType == .recenetViewed {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentViewedProductCell", for: indexPath) as! RecentViewedProductCell
            cell.arrProducts = arrRecentlyViewedItems
            cell.setupCellHeader(strTitle: getLocalizationString(key: "RecentlyViewedProduct"))
            cell.cvRecentViewedProducts.reloadData()
            return cell
            
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}


extension HomeVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvTopCategories {
            if arrHeaderCategories.count == 0 {
                return 0
            } else if arrHeaderCategories.count > 5 {
                return 6
            }
            return arrHeaderCategories.count + 1
        }
        else //if collectionView == cvProducts
        {
            return arrRadomProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == cvProducts {
            if indexPath.row == arrRadomProducts.count - 5 && !self.isLoading {
                getRadomProduct()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvTopCategories {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCategoryItemCell", for: indexPath) as! TopCategoryItemCell
            
            if arrHeaderCategories.count > 5 && indexPath.row == 5 {
                cell.imgCategory.image = UIImage(named: "more-icon")
                cell.imgCategory.tintColor = primaryColor
                cell.lblCategory.text = "More.."
                cell.imgCategory.backgroundColor = secondaryColor
                cell.imgCategory.contentMode = .center
                
            } else if indexPath.row == arrHeaderCategories.count {
                cell.imgCategory.image = UIImage(named: "more-icon")
                cell.imgCategory.tintColor = primaryColor
                cell.lblCategory.text = "More.."
                cell.imgCategory.backgroundColor = secondaryColor
                cell.imgCategory.contentMode = .center
                
            } else {
                let imageUrl = arrHeaderCategories[indexPath.row]["main_cat_image"].string
                
                    cell.imgCategory.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                            if (image == nil) {
                                cell.imgCategory.image =  UIImage(named: "noImage")
                                
                            } else {
                                
                                cell.imgCategory.image =  image
                            }
                    }
                
                cell.lblCategory.text = arrHeaderCategories[indexPath.row]["main_cat_name"].string
                cell.imgCategory.contentMode = .scaleAspectFit
            }
            
            return cell
        }else 
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItemCell", for: indexPath) as! ProductItemCell
            
            cell.setProductData(product: arrRadomProducts[indexPath.row])
            cell.btnFavourite.tag = indexPath.row
            cell.btnAddtoCart.tag = indexPath.row
            
            cell.btnFavourite.addTarget(self, action: #selector(btnFavouriteClicked(_:)), for: .touchUpInside)
            cell.btnAddtoCart.addTarget(self, action: #selector(btnAddtoCartClicked(_:)), for: .touchUpInside)
            
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvTopCategories {
            return CGSize(width: screenWidth/5 , height: 85)
        } else {
            return CGSize(width:  screenWidth/2 - 12 , height: 250*screenWidth/375)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvTopCategories {
            if (arrHeaderCategories.count > 5 && indexPath.row == 5) || indexPath.row == arrHeaderCategories.count {
                let navigationController = tabController?.viewControllers?.first as! UINavigationController
                navigationController.popToRootViewController(animated: false)
                tabController?.selectedIndex = 0
            } else {
                let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
                productsVC.fromCategory = true
                productsVC.categoryID = arrHeaderCategories[indexPath.row]["main_cat_id"].intValue
                self.navigationController?.pushViewController(productsVC, animated: true)
            }
        } else {
            let dict = arrRadomProducts[indexPath.row]
            if dict["type"].string == "external" {
                openUrl(strUrl: dict["external_url"].stringValue)
                return;
            }
            self.navigateToProductDetails(detailDict: dict)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == cvProducts {
            if self.isLoading {
                return CGSize.zero
            } else {
                return CGSize(width: screenWidth, height: 40)
            }
        }
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == cvProducts {
            if kind == UICollectionView.elementKindSectionFooter {
                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingReusableView", for: indexPath) as! LoadingReusableView
                loadingView = aFooterView
                loadingView?.backgroundColor = UIColor.clear
                return aFooterView
            }
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if collectionView == cvProducts {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.loadingView?.activityIndicator.startAnimating()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if collectionView == cvProducts {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.loadingView?.activityIndicator.stopAnimating()
            }
        }
    }
}

extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       if scrollView.tag == 8888 || scrollView.tag == 9999 {
            // for infinite scroll
            
            let currentPoint = -scrollView.contentOffset.y
            let differencePoint = currentPoint - previousPoint
            let nextPoint = self.headerTopConstraint.constant + differencePoint
            let nextDelayBuffer = delayBuffer + differencePoint
            
            if isTopOrBottomEdge(scrollView) { return }
            
            if 0 < nextDelayBuffer && 0 > nextDelayBuffer {
                if nextDelayBuffer < 0 {
                    delayBuffer = 0
                } else if nextDelayBuffer > 0 {
                    delayBuffer = 0
                } else {
                    delayBuffer += differencePoint
                }
            } else {
                if nextPoint < maxFollowPoint {
                    self.headerTopConstraint.constant = maxFollowPoint
                } else if nextPoint > 0 {
                    self.headerTopConstraint.constant = 0
                } else {
                    self.headerTopConstraint.constant += differencePoint
                }
            }
        
            self.headerView.layoutIfNeeded()
            previousPoint = currentPoint
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showOrHideIfNeeded()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            showOrHideIfNeeded()
        }
    }
    
    // MARK: - Methods
    private func isTopOrBottomEdge(_ scrollView: UIScrollView) -> Bool {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height || scrollView.contentOffset.y <= 0 {
            return true
        }
        
        return false
    }
    
    private func showOrHideIfNeeded() {
        if self.headerTopConstraint.constant < self.maxFollowPoint - self.maxFollowPoint/2 {
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2) {
                self.headerTopConstraint.constant = self.maxFollowPoint
            }
            self.view.layoutIfNeeded()
            
        } else {
            UIView.animate(withDuration: 0.2) {
                self.headerTopConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        }
    }
}
