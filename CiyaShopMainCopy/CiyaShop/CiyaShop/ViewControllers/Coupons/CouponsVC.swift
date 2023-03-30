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

class CouponsVC: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    @IBOutlet weak var cvCoupons: UICollectionView!
    
    
    
    //Scratch Card
    @IBOutlet weak var scratchMainView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var btnCloseScratchView: UIButton!
    
    @IBOutlet weak var vwCodeMain: UIView!
    @IBOutlet weak var vwCodeDetails: UIView!
    @IBOutlet weak var scratchCard: ScratchCard!
    
    @IBOutlet weak var lblScratchCode: UILabel!
    @IBOutlet weak var lblScratchCodeDetail: UILabel!
    
    @IBOutlet weak var lblScratchHere: UILabel!
    
    //For no Coupons
    @IBOutlet weak var vwNoCouponsFound: UIView!
    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var lblNoCouponFound: UILabel!
    
    
    var isFromTab : Bool = false
    
    var page : Int?
    
    var loadingView: LoadingReusableView?
    var isLoading = false
    var isNoProductFound = false
    
    var arrCoupons = Array<JSON>()
    var selectedIndexCouponForScratch : Int?
    
    var isScratching = false
    
    var gradientColors = [[UIColor.hexToColor(hex:"#ffcb96").cgColor,UIColor.hexToColor(hex:"#ff9d57").cgColor],[UIColor.hexToColor(hex:"#95dff2").cgColor,UIColor.hexToColor(hex:"#49b7f2").cgColor],[UIColor.hexToColor(hex:"#daa0f1").cgColor,UIColor.hexToColor(hex:"#8b6dee").cgColor],[UIColor.hexToColor(hex:"#f4a3b9").cgColor,UIColor.hexToColor(hex:"#f06084").cgColor]]
    
    var backgroundColors = [UIColor.hexToColor(hex:"#ff9d57"),UIColor.hexToColor(hex:"#49b7f2"),UIColor.hexToColor(hex:"#8b6dee"),UIColor.hexToColor(hex:"#f06084")]
    
    
    //  MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setThemeColors()
        registerDatasourceCell()
        
        setupScratchMainView()
        
        page = 1
        getCoupons()
        
        
    }
    
    func setThemeColors() {
        
        self.view.setBackgroundColor()
        self.cvCoupons.setBackgroundColor()
        btnBack.tintColor =  secondaryColor
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "MyCoupons")
        self.lblTitle.textColor = secondaryColor
        
        self.lblScratchHere.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblScratchHere.text = getLocalizationString(key: "ScratchHereCode")
        self.lblScratchHere.textColor = primaryColor
        
        
        self.lblScratchCode.font = UIFont.appRegularFontName(size: fontSize16)
        self.lblScratchCode.textColor = secondaryColor
        
        self.lblScratchCodeDetail.font = UIFont.appLightFontName(size: fontSize12)
        self.lblScratchCodeDetail.textColor = secondaryColor
        
        
        self.lblNoCouponFound.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblNoCouponFound.text = getLocalizationString(key: "NoRewardsYet")
        self.lblNoCouponFound.textColor = secondaryColor
        
        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        self.btnContinueShopping.tintColor = primaryColor
        
        if isFromTab {
            btnBack.isHidden = true
        }
        
    }
    
    
    func registerDatasourceCell()  {
        
        cvCoupons.delegate = self
        cvCoupons.dataSource = self
        
        cvCoupons.register(UINib(nibName: "CouponCell", bundle: nil), forCellWithReuseIdentifier: "CouponCell")
        cvCoupons.register(UINib(nibName: "LoadingReusableView" ,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingReusableView")

    }
    
    func setupScratchMainView() {
        scratchCard.scratchDelegate = self
        scratchMainView.isHidden = true

    }
    
    func hideShowScratchView(ishidden : Bool) {
        UIView.transition(with: scratchMainView, duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.scratchMainView.isHidden = ishidden
        })
    }
    
    
    //MARK: - Button Clicked
    
    @IBAction func backButtonClicked(_ sender: Any)  {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any)  {
        //hide scratch view
        hideShowScratchView(ishidden: true)
    }
    
    @IBAction func btnContinueShoppingClicked(_ sender: Any) {
        tabController?.selectedIndex = 2
    }
    
    
    //MARK: - API Calling
    func getCoupons() {
        
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
        
        if is_Logged_in == true {
            params["user_id"] = getValueFromLocal(key: USERID_KEY)
        }
        
        params["device_token"] = strDeviceToken
        params["page"] = page
        
        print(params)
        
        CiyaShopAPISecurity.getCoupons(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                
                if jsonReponse["data"].exists() && jsonReponse["data"].array!.count > 0 {
                    if self.page == 1 {
                        self.arrCoupons = jsonReponse["data"].array!
                    } else {
                        self.arrCoupons.append(contentsOf: jsonReponse["data"].array!)
                    }
                    
                    if jsonReponse["data"].array!.count < 10 {
                        self.isNoProductFound = true
                    }
                    
                    self.cvCoupons.reloadData()
                    
                    if self.page == 1 {
                        hideLoader()
                    }
                    
                    self.loadingView?.isHidden = true
                    self.isLoading = false
                } else {
                    
                    if self.page == 1 {
                        hideLoader()
                        self.vwNoCouponsFound.isHidden = false
                        self.cvCoupons.isHidden = true
  
                    }
                }
            } else {
                
                if self.page == 1 {
                    hideLoader()
                    self.vwNoCouponsFound.isHidden = false
                    self.cvCoupons.isHidden = true
                }
                
                self.loadingView?.isHidden = true
                self.isLoading = false
                
                self.isNoProductFound = true
                
            }
        }
    }
    
    
    func scratchCoupon() {
        
        
        if isScratching == false {
            
            var selectedCoupon = arrCoupons[selectedIndexCouponForScratch!]
            
            var params = [AnyHashable : Any]()
            params["coupon_id"] = selectedCoupon["id"].stringValue
            params["user_id"] = getValueFromLocal(key: USERID_KEY)
            params["is_coupon_scratched"] = "yes"
            params["device_token"] = strDeviceToken
            
            print(params)
            
            isScratching = true
            CiyaShopAPISecurity.scratchCoupon(params) { (success, message, responseData) in
                
                let jsonReponse = JSON(responseData!)
                if success {
                    if jsonReponse["status"].string == "success" {
                        
                        selectedCoupon["is_coupon_scratched"] = "yes"
                        self.arrCoupons[self.selectedIndexCouponForScratch!] = selectedCoupon
                        
                        self.cvCoupons.reloadData()
                        
                    }
                } else {
                    if let message = jsonReponse["message"].string {
                        showCustomAlert(title: APP_NAME,message: message, vc: self)
                    } else {
                        showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                    }
                }
                self.isScratching = false
            }
        }
    }
    
        
}

extension CouponsVC : ScratchDelegate {
    func scratch(percentage value: Int) {
        if value >= 85 {
            self.hideShowScratchView(ishidden: true)
            self.scratchCoupon()
        }
    }
}

//MARK:-  Collectionview Delegate Datasource
extension CouponsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCoupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == arrCoupons.count - 2 && !self.isLoading  && !self.isNoProductFound {
            page = page! + 1
            getCoupons()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath) as! CouponCell
//        cell.setGradienColors(colors: gradientColors[indexPath.row%4])
        cell.setBackground(color: backgroundColors[indexPath.row%4])
        cell.setCouponDetails(couponDetail: arrCoupons[indexPath.item])
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: screenWidth , height: 100*screenWidth/375)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if arrCoupons[indexPath.item]["is_coupon_scratched"] == "no"  {
            selectedIndexCouponForScratch = indexPath.item
            
            lblScratchCode.text = arrCoupons[indexPath.item]["code"].string?.uppercased()
            lblScratchCodeDetail.text = arrCoupons[indexPath.item]["description"].string
            
            scratchCard.reset()
            hideShowScratchView(ishidden: false)
        } else {
            let pasteboard = UIPasteboard.general
            pasteboard.string = arrCoupons[indexPath.item]["code"].string
            
            showToast(message: getLocalizationString(key: "CouponCodeCopied"))
        }
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
