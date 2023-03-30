//
//  ProductsVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 24/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework

class ProductsVC: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLogo: UIImageView!
    
    @IBOutlet weak var vwOptions: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    
    @IBOutlet weak var vwCartBadge: UIView!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var cartButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vwItemCount: UIView!
    @IBOutlet weak var vwSortBy: UIView!
    @IBOutlet weak var vwFilter: UIView!
    
    
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var btnList: UIButton!
    
    @IBOutlet weak var btnSortBy: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
        
    @IBOutlet weak var collectionviewProduct: UICollectionView!
    
    //For no product
    @IBOutlet weak var viewNoProductAvailable: UIView!
    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var lblSimplyBrowse: UILabel!
    @IBOutlet weak var lblNoProductAvailable: UILabel!
    
    
    var isGrid = true
    
    var fromSearch : Bool?
    var fromCategory : Bool?
    
    var fromPopularProduct : Bool?
    var fromDealofTheDay : Bool?
    var fromTopRatedProducts : Bool?
    var fromFeaturedProducts : Bool?
    var fromFilter = false

    //--For filter data set
    var minimumPriceValue : CGFloat = 0.0
    var maximumPriceValue : CGFloat = 0.0
    
    var arraySelectedFilter : [JSON] = []
    var arraySelectedRatingValue : [Int] = []
    

    
// for paging loader
    var loadingView: LoadingReusableView?
    var isLoading = false
    var isNoProductFound = false
    
    var page : Int?
    var categoryID : Int?
    
    var searchString : String?
    
    var arrProductData = Array<JSON>()
    
    var selectedSortOption : JSON?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Lifecycle methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        page = 1
        
        setHeaderImage()
        setUpUI()
        
        initializeData()
        getProductData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartBadge()
    }

    //MARK:- Initialize default data
    func initializeData() {
        selectedSortOption = arrSortOptions[0]
        
        if fromPopularProduct == true {
            selectedSortOption = arrSortOptions[2]
        }
        
        if fromTopRatedProducts == true {
            selectedSortOption = arrSortOptions[1]
        }
        
        
    }
    //MARK:- UI setup
    func setUpUI()
    {
        setThemeColors()
        
        self.registerDatasourceCell()
        
        [btnGrid,btnSortBy,btnFilter,btnList].forEach { (button) in
            button?.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
            button?.setTitleColor(grayTextColor, for: .normal)
            button?.backgroundColor = .clear
        }
        btnGrid.setImage(UIImage(named: "grid-view-icon-gray")?.withRenderingMode(.alwaysTemplate).maskWithColor(color: grayTextColor), for: .normal)
        btnGrid.setImage(UIImage(named: "grid-view-icon")?.withRenderingMode(.alwaysTemplate).maskWithColor(color: secondaryColor), for: .selected)
        
        btnList.setImage(UIImage(named: "list-view-icon-gray")?.withRenderingMode(.alwaysTemplate).maskWithColor(color: grayTextColor), for: .normal)
        btnList.setImage(UIImage(named: "list-view-icon")?.withRenderingMode(.alwaysTemplate).maskWithColor(color: secondaryColor), for: .selected)
        
        SetUpGridListViewButtonUI(sender:btnGrid)
        
        //--
        
        [btnFilter,btnGrid,btnList,btnSortBy,btnMenu,btnSearch,btnCart].forEach { (button) in
            button?.setUpThemeButtonUI()
        }
        
        setUpText()
        setUpUIforRTL()
        
        
    }
    
    func setUpUIforRTL()
    {
        if isRTL {
            
            [btnFilter,btnSortBy].forEach { (button) in
                button?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                button?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
                button?.setTitleColor(secondaryColor, for: .normal)
            }
        }
    }
    
    func setUpText()
    {
        btnFilter.setTitle(getLocalizationString(key: "Filter"), for: .normal)
        btnSortBy.setTitle(getLocalizationString(key: "SortBy").capitalized, for: .normal)
            
    }
    
    // MARK: - Header Image
    func setHeaderImage()
    {
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
        
    }
    
    func setThemeColors()
    {
        self.view.setBackgroundColor()
        self.collectionviewProduct.setBackgroundColor()

        [vwItemCount,vwSortBy,vwFilter].forEach { (view) in
            view?.setBackgroundColor()
        }
        
        
        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        
        self.lblSimplyBrowse.font = UIFont.appLightFontName(size: fontSize11)
        self.lblSimplyBrowse.text = getLocalizationString(key: "BrowseSomeOtherItem")
        self.lblSimplyBrowse.textColor = secondaryColor
        
        self.lblNoProductAvailable.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblNoProductAvailable.text = getLocalizationString(key: "NoproductFound")
        self.lblNoProductAvailable.textColor = secondaryColor
        
        self.btnContinueShopping.tintColor = primaryColor
        self.btnMenu.tintColor = secondaryColor
        self.btnCart.tintColor = secondaryColor
        
        
        vwCartBadge.backgroundColor = secondaryColor
        lblBadge.textColor = primaryColor
        
    }
    
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
    
    func updateNoProductAvailableView(isHide : Bool) {
        if isHide {
            collectionviewProduct.isHidden = false
            vwOptions.isHidden = false
            viewNoProductAvailable.isHidden = true
        } else {
            collectionviewProduct.isHidden = true
            vwOptions.isHidden = true
            viewNoProductAvailable.isHidden = false
        }
    }
    
    
    // MARK: - Cell Register
    func registerDatasourceCell()
    {
        collectionviewProduct.delegate = self
        collectionviewProduct.dataSource = self
        
        collectionviewProduct.register(UINib(nibName: "ProductItemCell", bundle: nil), forCellWithReuseIdentifier: "ProductItemCell")
        collectionviewProduct.register(UINib(nibName: "ProductListItemCell", bundle: nil), forCellWithReuseIdentifier: "ProductListItemCell")
        collectionviewProduct.register(UINib(nibName: "LoadingReusableView" ,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingReusableView")
        collectionviewProduct.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
 
    }
    
    
    //MARK: - Cell Button Clicked
    
    @IBAction func btnCartClicked(_ sender: Any) {
        tabController?.selectedIndex = 1
    }
    
    
    
}
//MARK:- Methods

extension ProductsVC
{
    func SetUpGridListViewButtonUI(sender:UIButton)
    {
        if sender == btnGrid
        {
            btnList.isSelected = false
            btnGrid.isSelected = true
        }else{
            btnList.isSelected = true
            btnGrid.isSelected = false
        }
    }
}

//MARK:- Options Button action methods
extension ProductsVC
{
    @IBAction func btnListViewClicked(_ sender: UIButton)
    {
        
        isGrid = false
        collectionviewProduct.reloadData()
        SetUpGridListViewButtonUI(sender: sender)
    }
    @IBAction func btnGridViewClicked(_ sender: UIButton)
    {
        isGrid = true
        collectionviewProduct.reloadData()
        SetUpGridListViewButtonUI(sender: sender)
    }
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        
        if categoryID == nil {
            let allCategoriesVC = AllCategoriesVC(nibName:"AllCategoriesVC" , bundle: nil)
            allCategoriesVC.isForFilter = true
            allCategoriesVC.delegateFilter = self
            self.navigationController?.pushViewController(allCategoriesVC, animated: true)
        } else {
            let vc = FilterVC(nibName:"FilterVC" , bundle: nil)
            vc.categoryID = categoryID!
            vc.delegateFilter = self
            vc.minimumPriceValue = minimumPriceValue
            vc.maximumPriceValue =  maximumPriceValue
            vc.arrSelectedRatingValue = self.arraySelectedRatingValue
            vc.arraySelectedFilter = self.arraySelectedFilter
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnSortByClicked(_ sender: UIButton)
    {

        if arrSortOptions.count > 0 {
            
            showListView(arrSortOptions, title: getLocalizationString(key: "SortBy"), toView: self, selectedValue: selectedSortOption != nil ? selectedSortOption!.stringValue : "") { (selectedSortOption) in
                if selectedSortOption == self.selectedSortOption {
                    return;
                }
                self.selectedSortOption = selectedSortOption
                
                
                self.arrProductData.removeAll()
                self.isLoading = false
                self.isNoProductFound = false
                self.page = 1
                self.getProductData()
            }
        }
        
    }
    
    @IBAction func btnContinueShoppingClicked(_ sender: UIButton) {
        if tabController?.selectedIndex == 2 {
            self.navigationController?.popViewController(animated: true)
        } else {
            tabController?.selectedIndex = 2
        }
    }
}
//MARK:- Filter delegate methods
extension ProductsVC : FilterProductsDelegate,CategorySelectionDelegate
{
    func GetFilterProducts(arrayFilters: [JSON], arrayRatings: [Int], minimumPriceValue: CGFloat, maximumPriceValue: CGFloat)
    {
        arraySelectedFilter = arrayFilters
        arraySelectedRatingValue = arrayRatings
        self.minimumPriceValue = minimumPriceValue
        self.maximumPriceValue = maximumPriceValue
        self.fromFilter = true
        self.arrProductData.removeAll()
        self.isLoading = false
        self.isNoProductFound = false
        self.page = 1
        self.getProductData()
    }
    
    func selectCategory(categoryId: Int) {
        
        fromCategory = true
        self.categoryID = categoryId
        
        self.arrProductData.removeAll()
        self.isLoading = false
        self.isNoProductFound = false
        
        self.page = 1
        self.getProductData()
    }
    
}
//MARK:- Cell Buttons action methods
extension ProductsVC
{
    @objc func btnFavouriteClicked(_ sender: Any)
    {
        let favouriteButton = sender as! UIButton
        let product = arrProductData[favouriteButton.tag]
        
        onWishlistButtonClicked(viewcontroller: self, product: product) { (success) in
            self.collectionviewProduct.reloadItems(at: createIndexPathArray(row: favouriteButton.tag, section: 0))
        }
    }
    
    @objc func btnAddtoCartClicked(_ sender: Any)
    {
        let cartButton = sender as! UIButton
        let product = arrProductData[cartButton.tag]
        
        onAddtoCartButtonClicked(viewcontroller: self, product: product, collectionView: collectionviewProduct, index: cartButton.tag)
        self.updateCartBadge()
    }
    
}

//MARK:-  Collectionview Delegate Datasource
extension ProductsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == collectionviewProduct {
            if indexPath.row == arrProductData.count - 4 && !self.isLoading  && !self.isNoProductFound {
                page = page! + 1
                getProductData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if isGrid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItemCell", for: indexPath) as! ProductItemCell
            cell.setProductData(product: arrProductData[indexPath.row])
            
            cell.btnFavourite.tag = indexPath.row
            cell.btnAddtoCart.tag = indexPath.row
            
            cell.btnAddtoCart.addTarget(self, action: #selector(btnAddtoCartClicked(_:)), for: .touchUpInside)
            cell.btnFavourite.addTarget(self, action: #selector(btnFavouriteClicked(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListItemCell", for: indexPath) as! ProductListItemCell
            cell.setProductData(product: arrProductData[indexPath.row])
            
            cell.btnFavourite.tag = indexPath.row
            cell.btnAddtoCart.tag = indexPath.row
            
            cell.btnAddtoCart.addTarget(self, action: #selector(btnAddtoCartClicked(_:)), for: .touchUpInside)
            cell.btnFavourite.addTarget(self, action: #selector(btnFavouriteClicked(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isGrid {
            return CGSize(width:  collectionView.frame.size.width/2 - 12 , height: 250*collectionView.frame.size.width/375)
        } else {
            
            return CGSize(width: screenWidth , height: 130*screenWidth/375)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = arrProductData[indexPath.row]
        if dict["type"].string == "external" {
            openUrl(strUrl: dict["external_url"].stringValue)
            return;
        }
        self.navigateToProductDetails(detailDict: dict)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if (self.isLoading  && !self.isNoProductFound) {
            return CGSize.zero
        } else {
            return CGSize(width: screenWidth, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingReusableView", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
        
    }
}
// MARK: - API Calling
extension ProductsVC
{
    func getProductData() {
        
        if !self.isLoading && !isNoProductFound {
            if self.page == 1 {
                showLoader()
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.isLoading = true
                        self.loadingView?.isHidden = false
                    }
                }
            }
            
            var params = [AnyHashable : Any]()
            params["page"] = page
            
            if fromSearch == true {
                params["search"] = searchString
                params["category"] = categoryID
            }
            
            if fromCategory == true {
                params["category"] = categoryID
            }
            
            if fromFeaturedProducts == true {
                params["featured"] = true
            }
            
            if fromFilter {
                
                params["attribute"] = JSON(arraySelectedFilter).arrayObject
                
                if(minimumPriceValue != 0)
                {
                    params["min_price"] = String(format:"%.0f", minimumPriceValue)
                }
                if(maximumPriceValue != 0)
                {
                    params["max_price"] = String(format:"%.0f", maximumPriceValue)
                }
                if (arraySelectedRatingValue.count > 0)
                {
                    let stringArrayRatings = arraySelectedRatingValue.map { (value) -> String in
                        "\(value)"
                    }
                    params["rating_filter"] = stringArrayRatings.joined(separator: ",")
                }
            }
            
            if fromDealofTheDay == true {
                let arrdeals =  arrSpecialDeals.map{$0["id"].stringValue}
                params["include"] = arrdeals.joined(separator: ",")
                print(params)
            }
            
            if arrSortOptions[0] == selectedSortOption {
                // newest default
            } else if arrSortOptions[1] == selectedSortOption {
                params["order_by"] = "rating"
            } else if arrSortOptions[2] == selectedSortOption {
                params["order_by"] = "popularity"
            } else if arrSortOptions[3] == selectedSortOption {
                params["order_by"] = "price"
            } else if arrSortOptions[4] == selectedSortOption {
                params["order_by"] = "price-desc"
            }
           
            print("params - ",params)
            
        CiyaShopAPISecurity.productListing(params) { (success, message, responseData) in
            let jsonReponse = JSON(responseData!)
            print("products - ",jsonReponse)

            if success {
                
                print("product data count - ",jsonReponse.count)
                if self.page == 1 {
                    self.arrProductData = jsonReponse.array!
                } else {
                    self.arrProductData.append(contentsOf: jsonReponse.array!)
                }
                
                if jsonReponse.array!.count < 10 {
                    self.isNoProductFound = true
                }
                                
                self.collectionviewProduct.reloadData()
                
                if self.page == 1 {
                    hideLoader()
                }
                
                self.loadingView?.isHidden = true
                self.isLoading = false
                
                self.updateNoProductAvailableView(isHide: true)
                
            } else {
                
                if self.page == 1 {
                    hideLoader()
                    self.updateNoProductAvailableView(isHide: false)
                    
                }
                
                if self.page == 1 {
                    
                }
                //                    else {
                
                self.loadingView?.isHidden = true
                self.isLoading = false
                //                    }
                
                self.isNoProductFound = true
                
                
            }
            
            }
        }
    }
}
