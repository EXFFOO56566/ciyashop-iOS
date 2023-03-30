//
//  MyAddressesVC.swift
//  CiyaShop
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON

class MyOrdersVC: UIViewController,OrderDetailDelegate {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var cvMyOrders: UICollectionView!
    
    //For no product
    @IBOutlet weak var vwNoOrderFound: UIView!
    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var lblSimplyBrowse: UILabel!
    @IBOutlet weak var lblNoOrderFound: UILabel!
    
    
    var page : Int?
    
    var loadingView: LoadingReusableView?
    var isLoading = false
    var isNoProductFound = false
    
    var arrMyOrdersData = Array<JSON>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setThemeColors()
        registerDatasourceCell()
        
        page = 1
        getMyOrders()
        
    }
    
    func setThemeColors() {
        
        self.view.setBackgroundColor()
        
        self.cvMyOrders.setBackgroundColor()
        
        btnBack.tintColor =  secondaryColor
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "MyOrders")
        self.lblTitle.textColor = secondaryColor
        
        self.lblNoOrderFound.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblNoOrderFound.text = getLocalizationString(key: "NoOrderYet")
        self.lblNoOrderFound.textColor = secondaryColor
        
        self.lblSimplyBrowse.text = getLocalizationString(key: "NoOrderDescription")
        self.lblSimplyBrowse.textColor = secondaryColor
        self.lblSimplyBrowse.font = UIFont.appLightFontName(size: fontSize11)

        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        self.btnContinueShopping.tintColor = primaryColor
        
    }
    
    
    func registerDatasourceCell()  {
        
        
        cvMyOrders.delegate = self
        cvMyOrders.dataSource = self
        
        cvMyOrders.register(UINib(nibName: "MyOrderCell", bundle: nil), forCellWithReuseIdentifier: "MyOrderCell")
        cvMyOrders.register(UINib(nibName: "LoadingReusableView" ,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingReusableView")
        cvMyOrders.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        

    }
    
    func updateMyOrders() {
        page = 1
        isNoProductFound = false
        arrMyOrdersData.removeAll()
        getMyOrders()
    }
    
    //MARK: - Button Clicked
    
    @IBAction func backButtonClicked(_ sender: Any)  {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueShoppingClicked(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    
    @objc func btnDetailsClicked(_ sender: Any)  {
        
        let detailButton = sender as! UIButton
        let order = arrMyOrdersData[detailButton.tag]
        navigateToOrderDetail(orderDetail: order)
    }
    
    @objc func btnRetryClicked(_ sender: Any)  {
        
    }
    
    func navigateToOrderDetail(orderDetail : JSON) {
        let orderDetailsVC = OrderDetailsVC(nibName: "OrderDetailsVC", bundle: nil)
        orderDetailsVC.orderDetail = orderDetail
        orderDetailsVC.orderDelegate = self
        self.navigationController?.pushViewController(orderDetailsVC, animated: true)
    }
    
    //MARK: - API Calling
    func getMyOrders() {
        
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
        params["customer"] = getValueFromLocal(key: USERID_KEY)
        params["page"] = page
        
        print(params)
        
        CiyaShopAPISecurity.getOrders(params) { (success, message, responseData) in
   
            let jsonReponse = JSON(responseData!)
            if success {
        
//                if(jsonReponse["status"].stringValue != kSuccess){
//                    if self.page == 1 {
//                        hideLoader()
//                        self.vwNoOrderFound.isHidden = false
//                        self.cvMyOrders.isHidden = true
//                        return
//                    }
//
//                }
                
                if self.page == 1 {
                    self.arrMyOrdersData = jsonReponse.array ?? []
                } else {
                    self.arrMyOrdersData.append(contentsOf: jsonReponse.array ?? [])
                }
                
                if (jsonReponse.array?.count ?? 0) < 10 {
                    self.isNoProductFound = true
                }
                
                self.cvMyOrders.reloadData()
                
                if self.page == 1 {
                    hideLoader()
                }
                
                self.loadingView?.isHidden = true
                self.isLoading = false
                
            } else {
                //if(jsonReponse["status"].stringValue == kSuccess){
                    
                    if self.page == 1 {
                        hideLoader()
                        self.vwNoOrderFound.isHidden = false
                        self.cvMyOrders.isHidden = true
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
//                } else{
////                    self.showToast(message: jsonReponse["message"].stringValue)
//
//                    if self.page == 1 {
//                        hideLoader()
//                        self.vwNoOrderFound.isHidden = false
//                        self.cvMyOrders.isHidden = true
//                    }
//                }
                
                
            }
//            hideLoader()
        }
    }
    
    
}


//MARK:-  Collectionview Delegate Datasource
extension MyOrdersVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMyOrdersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == arrMyOrdersData.count - 4 && !self.isLoading  && !self.isNoProductFound {
            page = page! + 1
            getMyOrders()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        cell.setProductData(orderDetail: arrMyOrdersData[indexPath.row])
        
        
        cell.btnDetails.tag = indexPath.item
        cell.btnRetry.tag = indexPath.item
        
        cell.btnDetails.addTarget(self, action: #selector(btnDetailsClicked(_:)), for: .touchUpInside)
        cell.btnRetry.addTarget(self, action: #selector(btnRetryClicked(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: screenWidth , height: 160*screenWidth/375)
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToOrderDetail(orderDetail: arrMyOrdersData[indexPath.item])
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

