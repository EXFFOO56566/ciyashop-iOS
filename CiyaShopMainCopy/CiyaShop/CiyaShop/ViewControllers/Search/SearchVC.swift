//
//  SearchVC.swift
//  CiyaShop
//
//  Created by Apple on 12/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework
import FBSDKCoreKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var tblSearch: UITableView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //For no product
    @IBOutlet weak var viewNoSearchAvailable: UIView!
    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var lblBrowseStore: UILabel!
    @IBOutlet weak var lblSearchListEmpty: UILabel!
    
    //Table Header view
    
    @IBOutlet weak var vwHorizontalLine: UIView!
    
    @IBOutlet weak var vwTableHeader: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    
    var arrSearch = Array<JSON>()
    
    var searchText = ""
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThemeColors()
        updateView()
        registerDatasourceCell()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        arrRecentSearch = ["Mens's wear","Women's Wear","Jackets","Hoodles"]
        
        if arrSearch.count == 0 && searchText.count > 0 {
            tblSearch.reloadData()
        }
    }

    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        self.tblSearch.setBackgroundColor()
    
        self.lblBrowseStore.font = UIFont.appLightFontName(size: fontSize11)
        self.lblSearchListEmpty.font = UIFont.appBoldFontName(size: fontSize14)
        
        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        self.btnContinueShopping.tintColor = primaryColor

        self.lblBrowseStore.text = getLocalizationString(key: "BrowseOurStore")
        self.lblBrowseStore.textColor = secondaryColor
        
        self.lblSearchListEmpty.text = getLocalizationString(key: "SearchListEmpty")
        self.lblSearchListEmpty.textColor = secondaryColor
    
        vwHorizontalLine.backgroundColor = secondaryColor
        
        lblHeaderTitle.font = UIFont.appBoldFontName(size: fontSize14)
        lblHeaderTitle.textColor = secondaryColor
        
        
        btnBack.tintColor =  secondaryColor
        
        txtSearch.textColor = secondaryColor
        txtSearch.font = UIFont.appLightFontName(size: fontSize12)
        txtSearch.attributedPlaceholder = NSAttributedString(string: getLocalizationString(key: "SearchHere"), attributes: [NSAttributedString.Key.foregroundColor: secondaryColor.withAlphaComponent(0.5)])
        txtSearch.delegate = self
        
        activityIndicator.color =  secondaryColor
        
        if(isRTL)
        {
            txtSearch.textAlignment = .right
        }
    }
    
    func updateView() {
                
        if arrRecentSearch.count == 0 && arrSearch.count == 0{
            tblSearch.isHidden = true
            viewNoSearchAvailable.isHidden = false
        }
        
        if searchText.count > 0 && arrSearch.count == 0 {
            tblSearch.isHidden = true
            viewNoSearchAvailable.isHidden = false
        }
        
        if searchText.count > 0 && arrSearch.count > 0 {
            tblSearch.isHidden = false
            viewNoSearchAvailable.isHidden = true
        }
        
        if searchText.count <= 3 && arrRecentSearch.count > 0 {
            tblSearch.isHidden = false
            viewNoSearchAvailable.isHidden = true
        }

        
        if searchText.count == 0 {
            arrSearch.removeAll()
            tblSearch.reloadData()
        }

    }
    
    func registerDatasourceCell()  {
        
        tblSearch.delegate = self
        tblSearch.dataSource = self
        tblSearch.register(UINib(nibName: "SearchItemCell", bundle: nil), forCellReuseIdentifier: "SearchItemCell")
        
        self.tblSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.tblSearch.reloadData()
    }
    
    //MARK: - Button Clicked    
    @IBAction func btnContinueShoppingClicked(_ sender: Any) {
        navigationController?.popViewController {
          tabController?.selectedIndex = 2
        }
    }
    
    
    // MARK: - Get product api
    func getSearchProduct() {
        
        self.activityIndicator.startAnimating()
        
        var params = [AnyHashable : Any]()
        params["search"] = searchText
        
        
        CiyaShopAPISecurity.liveSearch(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            print(jsonReponse)
            
            if success {
                if let arrLiveSearch = jsonReponse.array {
                    self.arrSearch = arrLiveSearch
                    self.tblSearch.reloadData()
                    
                    self.updateView()
                }
            } else {
                
                self.arrSearch = []
                self.tblSearch.reloadData()
                
                self.updateView()
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    func getSingleProduct(product : JSON) {
        showLoader()
        
        var params = [AnyHashable : Any]()
        params["include"] = product["id"].stringValue
        
        CiyaShopAPISecurity.productListing(params) { (success, message, responseData) in
            
            hideLoader()
            
            let jsonReponse = JSON(responseData!)
            
            if success {
                if jsonReponse[0]["type"].string == "external" {
                    openUrl(strUrl: jsonReponse[0]["external_url"].stringValue)
                    return;
                }
                self.navigateToProductDetails(detailDict: jsonReponse[0])
            } else {
                showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
            }
            
            
        }
    }
    
}

extension SearchVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateView()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            searchText = updatedText
            
            if searchText.count >= 3 {
                getSearchProduct()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if searchText.count >= 3 {
            
            
            let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
            productsVC.fromSearch = true
            productsVC.searchString = searchText
            self.navigationController?.pushViewController(productsVC, animated: true)
            
            saveSearchtoLocal()
            self.txtSearch.text = ""
            searchText = ""
            arrSearch.removeAll()
            updateView()
            
        }
        return true
    }
}

extension SearchVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if arrSearch.count > 0 {
            return arrSearch.count;
        }
        return arrRecentSearch.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCell", for: indexPath) as! SearchItemCell
        
        if arrSearch.count > 0 {
            cell.lblSearchText.text = arrSearch[indexPath.row]["name"].string
            
        } else {
            cell.lblSearchText.text = arrRecentSearch[indexPath.row]
        }
        
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if arrSearch.count > 0 {
            saveSearchtoLocal()
            getSingleProduct(product: arrSearch[indexPath.row])
        } else if arrRecentSearch.count > 0 {
            
//            if  getValueFromLocal(key: IS_DATA_TRACKING_AUTHORIZED_KEY) as? Bool == true {
//                FacebookHelper.logSearchedEvent(contentType: FBSEARCH_CONTENT_TYPE, searchString: arrRecentSearch[indexPath.row], success: true)
//            }
            
            let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
            productsVC.fromSearch = true
            productsVC.searchString = arrRecentSearch[indexPath.row]
            self.navigationController?.pushViewController(productsVC, animated: true)
        }
    }
    
    
    //Save Search String to local
    func saveSearchtoLocal()  {
        if !self.txtSearch.text!.isEmpty {
            addSearchStringToLocal(searchString: self.txtSearch.text!)
        }
    }
}
