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

class MyPointsVC: UIViewController {
    
    @IBOutlet weak var cvMyPoints: UICollectionView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblNoPoints: UILabel!
    @IBOutlet weak var lblNoPointsValue: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    @IBOutlet weak var vwTableHeader: UIView!
    
    //For no product
    @IBOutlet weak var viewNoPointsAvailable: UIView!
    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var lblSimplyBrowse: UILabel!
    @IBOutlet weak var lblNoPointsAvailable: UILabel!
    
    
    
    var page : Int?
    
    var loadingView: LoadingReusableView?
    var isLoading = false
    var isNoProductFound = false
    
    
    var arrPoints =  Array<JSON>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThemeColors()
        registerDatasourceCell()
        
        page = 1
        getMyPoints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
                
    }
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "MyPoints")
        self.lblTitle.textColor = secondaryColor
        
        self.lblNoPoints.font = UIFont.appRegularFontName(size: fontSize13)
        self.lblNoPoints.text = getLocalizationString(key: "YouHavePoints")

        self.lblNoPoints.textColor = secondaryColor
        
        self.lblNoPointsValue.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblNoPointsValue.textColor = secondaryColor
        
        self.lblNoPointsAvailable.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblNoPointsAvailable.text = getLocalizationString(key: "NoPointsEarned")
        self.lblNoPointsAvailable.textColor = secondaryColor
        
        self.lblSimplyBrowse.text = getLocalizationString(key: "PurchaseProductEarnPoints")
        self.lblSimplyBrowse.textColor = secondaryColor
        self.lblSimplyBrowse.font = UIFont.appLightFontName(size: fontSize11)
        
        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        self.btnContinueShopping.tintColor = primaryColor
        
        
        
        self.cvMyPoints.layer.borderColor = UIColor.hexToColor(hex: "#E3E4E6").cgColor//UIColor.lightGray.cgColor

        self.cvMyPoints.layer.cornerRadius = 5

        
        self.btnBack.tintColor = secondaryColor
    }
    
    func registerDatasourceCell() {
        
        
        cvMyPoints.delegate = self
        cvMyPoints.dataSource = self
        
        cvMyPoints.register(UINib(nibName: "MyPointsItemCell", bundle: nil), forCellWithReuseIdentifier: "MyPointsItemCell")
        cvMyPoints.register(UINib(nibName: "LoadingReusableView" ,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingReusableView")
        
        cvMyPoints.register(UINib(nibName: "PointsHeadersView" ,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PointsHeadersView")
        
        
        if let flowLayout = cvMyPoints?.collectionViewLayout as? UICollectionViewFlowLayout {
          flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        cvMyPoints.reloadData()
    }
    
    
    //MARK: - API Calling
    func getMyPoints() {
        
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
        params["user_id"] = getValueFromLocal(key: USERID_KEY)
        params["page"] = page
        
        print(params)
        
        CiyaShopAPISecurity.getRewardPoints(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    if jsonReponse["data"]["events"].exists() {
                        if self.page == 1 {
                            self.arrPoints = jsonReponse["data"]["events"].array!
                        } else {
                            self.arrPoints.append(contentsOf: jsonReponse["data"]["events"].array!)
                        }
                        
                        if jsonReponse["data"]["events"].array!.count < 5 {
                            self.isNoProductFound = true
                        }
                        
                        self.lblNoPointsValue.text = jsonReponse["data"]["points_balance"].stringValue
                        self.cvMyPoints.reloadData()
                        
                        if self.page == 1 {
                            hideLoader()
                        }
                        self.lblNoPoints.isHidden = false
                        self.lblNoPointsValue.isHidden = false
                        self.loadingView?.isHidden = true
                        self.isLoading = false
                        
                    } else {
                        if self.page == 1 {
                            hideLoader()
                            self.lblNoPoints.isHidden = true
                            self.lblNoPointsValue.isHidden = true
                            self.viewNoPointsAvailable.isHidden = false
                            self.cvMyPoints.isHidden = true
                        }
                    }
                } else {
                    
                    if self.page == 1 {
                        hideLoader()
                        self.lblNoPoints.isHidden = true
                        self.lblNoPointsValue.isHidden = true
                        self.viewNoPointsAvailable.isHidden = false
                        self.cvMyPoints.isHidden = true
                    }
                    
                    self.loadingView?.isHidden = true
                    self.isLoading = false
                    
                    self.isNoProductFound = true
                    
                    if self.page == 1 {
                        if let message = jsonReponse["message"].string {
                            showCustomAlert(title: APP_NAME,message: message, vc: self)
                        } else {
                            showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueShoppingClicked(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    
}



//MARK:-  Collectionview Delegate Datasource
extension MyPointsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPoints.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == arrPoints.count - 2 && !self.isLoading  && !self.isNoProductFound {
            page = page! + 1
            getMyPoints()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPointsItemCell", for: indexPath) as! MyPointsItemCell
        cell.setEventData(event: arrPoints[indexPath.row])
        cell.layoutSubviews()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: screenWidth , height: 100*screenWidth/375)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if (self.isLoading  && !self.isNoProductFound) {
            return CGSize.zero
        } else {
            return CGSize(width: screenWidth, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PointsHeadersView", for: indexPath) as! PointsHeadersView
            
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
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
