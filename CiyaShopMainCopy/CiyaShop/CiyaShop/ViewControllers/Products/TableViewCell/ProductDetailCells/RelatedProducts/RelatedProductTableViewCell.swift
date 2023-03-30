//
//  RelatedProductTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 19/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework
class RelatedProductTableViewCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var cvRelatedProducts: UICollectionView!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblSmallTitle: UILabel!
    @IBOutlet weak var lblBigTitle: UILabel!
        
    var arrProducts : [JSON] = []
    var dictDetails = JSON()
    var page = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        
    }
    func setUpData(arrayProductsLocal:[JSON])
    {
        arrProducts = arrayProductsLocal
        cvRelatedProducts.reloadData()
    }
   
    
    // MARK: - Configuration
    private func setupCollectionView() {
        
        setupCell()
        
        cvRelatedProducts.delegate = self
        cvRelatedProducts.dataSource = self
        cvRelatedProducts.setBackgroundColor()
        
        cvWidthConstraint.constant = screenWidth
        
        cvRelatedProducts.register(UINib(nibName: "ProductItemCell", bundle: nil), forCellWithReuseIdentifier: "ProductItemCell")
        
        //        self.cvRelatedProducts.reloadData()
        if isRTL {
            cvRelatedProducts.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    func setupCell(){

        contentView.setBackgroundColor()
        self.lblSmallTitle.font = UIFont.appLightFontName(size: fontSize11)
        self.lblSmallTitle.textColor = secondaryColor
        
        self.lblBigTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblBigTitle.textColor = secondaryColor
        
        self.btnViewAll.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        self.btnViewAll.backgroundColor = .clear
        self.btnViewAll.setTitle(getLocalizationString(key: "viewAll"), for: .normal)
        self.btnViewAll.setTitleColor(secondaryColor, for: .normal)
        

    }
    
    func setupCellHeader(strTitle : String){
        
        let headerStrings = strTitle.components(separatedBy: " ")
        if headerStrings.count > 2 {
            self.lblSmallTitle.text = headerStrings[0].uppercased() + " " + headerStrings[1].uppercased()
            self.lblBigTitle.text = headerStrings[2].uppercased()
        } else {
            self.lblSmallTitle.text = headerStrings[0].uppercased()
            if headerStrings.count > 1 {
                self.lblBigTitle.text = headerStrings[1].uppercased()
            } else {
                self.lblBigTitle.text = ""
            }
        }
    }
    
    func reloadCollectionData() {
//        DispatchQueue.main.async {
            self.cvRelatedProducts.reloadData()
//        }
    }

    
    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return arrProducts.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItemCell", for: indexPath) as! ProductItemCell
        
        let dict = arrProducts[indexPath.row]
        
        cell.setProductData(product: dict)
        
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

        return CGSize(width:  collectionView.frame.size.width/2.1 - 12 , height: 267)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.parentContainerViewController()!.navigateToProductDetails(detailDict: arrProducts[indexPath.row])
    }
    
    //MARK: - Button Clicked
    
    @objc func btnFavouriteClicked(_ sender: Any) {
        let favouriteButton = sender as! UIButton
        let product = arrProducts[favouriteButton.tag]
        
        onWishlistButtonClicked(viewcontroller: self.viewContainingController()!, product: product) { (success) in
            self.cvRelatedProducts.reloadItems(at: createIndexPathArray(row: favouriteButton.tag, section: 0))
        }
    }
    
    @objc func btnAddtoCartClicked(_ sender: Any) {
        let cartButton = sender as! UIButton
        let product = arrProducts[cartButton.tag]
  
        onAddtoCartButtonClicked(viewcontroller: self.viewContainingController()!, product: product, collectionView: cvRelatedProducts, index: cartButton.tag)
        
        
    }
    
}
