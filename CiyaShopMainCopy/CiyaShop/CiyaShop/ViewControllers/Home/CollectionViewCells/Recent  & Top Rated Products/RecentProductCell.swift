//
//  TopCategoriesCell.swift
//  CiyaShop
//
//  Created by Apple on 22/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class RecentProductCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var cvRecentProducts: UICollectionView!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblSmallTitle: UILabel!
    @IBOutlet weak var lblBigTitle: UILabel!
        
    //MARK:- variables
    var arrProducts : Array<JSON>!
    var viewAllButtonAction : (() -> ())?
    //MARK:- Awake nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }
    
    // MARK: - Configuration
    private func setupCollectionView() {
        setThemeColors()
        
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
        self.contentView.translatesAutoresizingMaskIntoConstraints = true;

        cvRecentProducts.delegate = self
        cvRecentProducts.dataSource = self
        cvRecentProducts.setBackgroundColor()
        
        contentView.setBackgroundColor()
        
        cvWidthConstraint.constant = screenWidth
        cvHeightConstraint.constant = 240*screenWidth/375
        
        cvRecentProducts.register(UINib(nibName: "ProductItemCell", bundle: nil), forCellWithReuseIdentifier: "ProductItemCell")
        
        if isRTL {
            cvRecentProducts.semanticContentAttribute = .forceRightToLeft
        }
        
    }
    
    
    func setThemeColors(){

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
//            self.lblBigTitle.text = headerStrings[2].uppercased()
            self.lblBigTitle.text = ""
            for i in 2...headerStrings.count - 1 {
                self.lblBigTitle.text = self.lblBigTitle.text! + headerStrings[i].uppercased() + " "
            }
        } else {
            self.lblSmallTitle.text = headerStrings[0].uppercased()
            if headerStrings.count > 1 {
                self.lblBigTitle.text = headerStrings[1].uppercased()
            } else {
                self.lblBigTitle.text = ""
            }
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
//        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        
        cvWidthConstraint.constant = screenWidth
        cvHeightConstraint.constant = self.cvRecentProducts.contentSize.height
        return  CGSize(width: self.cvRecentProducts.contentSize.width, height: 240*screenWidth/375 + 54)
    }
    
    func reloadCollectionData() {
        DispatchQueue.main.async {
            self.cvRecentProducts.reloadData()
        }
    }
    
    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrProducts.count > 4 {
            return 4
        }
        
        return arrProducts.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItemCell", for: indexPath) as! ProductItemCell
        
        cell.setProductData(product: arrProducts[indexPath.row])

        cell.btnFavourite.tag = indexPath.row
        cell.btnAddtoCart.tag = indexPath.row
        
        cell.btnFavourite.addTarget(self, action: #selector(btnFavouriteClicked(_:)), for: .touchUpInside)
        cell.btnAddtoCart.addTarget(self, action: #selector(btnAddtoCartClicked(_:)), for: .touchUpInside)
     
        
        
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  (collectionView.frame.size.width/2.2) - 12 , height:  240*collectionView.frame.size.width/375)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.parentContainerViewController()?.navigateToProductDetails(detailDict: arrProducts[indexPath.row])
    }
    
    //MARK: - Button Clicked
    
    @objc func btnFavouriteClicked(_ sender: Any) {
        let favouriteButton = sender as! UIButton
        let product = arrProducts[favouriteButton.tag]
        
        onWishlistButtonClicked(viewcontroller: viewContainingController()!, product: product) { (success) in
            self.cvRecentProducts.reloadItems(at: createIndexPathArray(row: favouriteButton.tag, section: 0))
        }
        
    }
    
    @objc func btnAddtoCartClicked(_ sender: Any) {
        let cartButton = sender as! UIButton
        let product = arrProducts[cartButton.tag]
    
        onAddtoCartButtonClicked(viewcontroller: self.viewContainingController()!, product: product, collectionView: cvRecentProducts, index: cartButton.tag)
        if self.viewContainingController()! is HomeVC {
            (self.viewContainingController() as! HomeVC).updateCartBadge()
        }
//        delegateVariationPopUp?.ShowVariationView(productDetailDict: featureProduct)
        
    }
    //MARK:- Button Action
    @IBAction func btnViewAllClicked(_ sender: UIButton)
    {
        viewAllButtonAction?()
    }
}
//MARK:- Other methods
extension RecentProductCell
{
    func NavigateToVariationView(dictDetail:JSON)
    {
        showVariationPopUp(vc: self.viewContainingController()!, product: dictDetail)
    }
   
}
