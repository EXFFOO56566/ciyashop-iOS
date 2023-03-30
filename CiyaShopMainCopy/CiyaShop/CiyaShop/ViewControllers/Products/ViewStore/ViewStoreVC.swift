//
//  ViewStoreVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 16/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework
class ViewStoreVC: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    //MARK:-Outlets
    @IBOutlet weak var cvStoreProducts: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!

    //MARK:- Variables
    var dictDetail = JSON()
    var page = 0
    var arrayProducts : [JSON] = []
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

     
        setUpUI()
        RegisterCell()
        setUpData()
    }
    //MARK:- UI setup
    func setUpUI()
    {
        btnBack.tintColor =  secondaryColor

    }
    //MARK:- Register cell
    func RegisterCell()
    {
        cvStoreProducts.setBackgroundColor()
        
        cvStoreProducts.register(UINib(nibName: "ProductItemCell", bundle: nil), forCellWithReuseIdentifier: "ProductItemCell")
        cvStoreProducts.register(UINib(nibName: "ViewStoresCollectionReusableView" ,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ViewStoresCollectionReusableView")
    }
    func setUpData()
    {
        getSellerData()
    }

     // MARK: - UICollection Delegate methods
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return arrayProducts.count
        }
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
        {
            let aHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ViewStoresCollectionReusableView", for: indexPath) as! ViewStoresCollectionReusableView
            
            aHeaderView.lblStoreDescription.attributedText = dictDetail["seller_info"]["store_description"].stringValue.htmlToAttributedString
            aHeaderView.lblStoreDescription.textAlignment = .center
            aHeaderView.lblStoreDescription.font = UIFont.appRegularFontName(size: fontSize12)
            
            aHeaderView.lblStoreLocation.attributedText = dictDetail["seller_info"]["seller_address"].stringValue.htmlToAttributedString
            aHeaderView.lblStoreLocation.textAlignment = .center
            aHeaderView.lblStoreLocation.font = UIFont.appRegularFontName(size: fontSize12)

            aHeaderView.lblRatingCount.text = String(format: "%.1f", dictDetail["seller_info"]["seller_rating"]["rating"].doubleValue)
            
            if(!dictDetail["seller_info"]["banner_url"].stringValue.isEmpty){
                aHeaderView.imgProduct.sd_setImage(with: dictDetail["seller_info"]["banner_url"].stringValue.encodeURL(), placeholderImage: UIImage(named: "placeholder"))

            }
            if(!dictDetail["seller_info"]["avatar"].stringValue.isEmpty)
            {
                aHeaderView.imgStore.sd_setImage(with: dictDetail["seller_info"]["avatar"].stringValue.encodeURL(), placeholderImage: UIImage(named: "placeholder"))

            }
 
                aHeaderView.lblVendorName.text = dictDetail["seller_info"]["store_name"].stringValue

            
            aHeaderView.btnContactSeller.addTarget(self, action: #selector(btnContactSellerClicked(_:)), for: .touchUpInside)
            
            if dictDetail["seller_info"]["contact_seller"].boolValue == true {
                aHeaderView.btnContactSeller.isHidden = false
                aHeaderView.btnContactSellerHeightConstraint.constant = 30
            } else {
                aHeaderView.btnContactSeller.isHidden = true
                aHeaderView.btnContactSellerHeightConstraint.constant = 0
            }
            
            
            return aHeaderView
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ViewStoresCollectionReusableView", for: IndexPath(row: 0, section: 0)) as? ViewStoresCollectionReusableView {
            headerView.layoutIfNeeded()
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
            return CGSize(width: collectionView.frame.width, height: height)
        }
        return CGSize(width: screenWidth, height: 390)
    }
    
      
        internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItemCell", for: indexPath) as! ProductItemCell
            cell.setProductData(product: arrayProducts[indexPath.row])

            cell.btnFavourite.tag = indexPath.row
            cell.btnAddtoCart.tag = indexPath.row
            
            cell.btnFavourite.addTarget(self, action: #selector(btnFavouriteClicked(_:)), for: .touchUpInside)
            cell.btnAddtoCart.addTarget(self, action: #selector(btnAddtoCartClicked(_:)), for: .touchUpInside)
            
            cell.layoutIfNeeded()
            cell.layoutSubviews()

            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(width:  collectionView.frame.size.width/2 - 12 , height: 250*collectionView.frame.size.width/375)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            if arrayProducts[indexPath.row]["type"].string == "external" {
                openUrl(strUrl: arrayProducts[indexPath.row]["external_url"].stringValue)
                return;
            }
            self.navigateToProductDetails(detailDict: arrayProducts[indexPath.row])
    }
    
    //MARK: - Button Clicked
    
    @objc func btnFavouriteClicked(_ sender: Any) {
        let favouriteButton = sender as! UIButton
        let product = arrayProducts[favouriteButton.tag]
        
        onWishlistButtonClicked(viewcontroller: self, product: product) { (success) in
            self.cvStoreProducts.reloadItems(at: createIndexPathArray(row: favouriteButton.tag, section: 0))
        }
    }
    
    @objc func btnAddtoCartClicked(_ sender: Any) {
        let cartButton = sender as! UIButton
        let product = arrayProducts[cartButton.tag]
        
        onAddtoCartButtonClicked(viewcontroller: self, product: product, collectionView: cvStoreProducts, index: cartButton.tag)
        
    }
    
    @objc func btnContactSellerClicked(_ sender: Any)
    {
        let vc = ContactSellerVC(nibName: "ContactSellerVC", bundle: nil)
        vc.dictDetail = dictDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK:- API calling
extension ViewStoreVC
{
    func getSellerData()
    {
        showLoader()
        var params = [AnyHashable : Any]()
        params["seller_id"] = dictDetail["seller_info"]["seller_id"].stringValue
        params["page"] = "\(page)"
        
        CiyaShopAPISecurity.getSellerDetail(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                print("seller data - ",jsonReponse)
                self.arrayProducts = jsonReponse["products"].arrayValue
                self.dictDetail = jsonReponse
                self.cvStoreProducts.reloadData()
                
            } else
            {
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
