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

class CategoryBannerCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var cvTopCategories: UICollectionView!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    
            
    //MARK:- Awake nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setupCollectionView()
    }
    
    // MARK: - Configuration
    private func setupCollectionView() {
        
        cvTopCategories.delegate = self
        cvTopCategories.dataSource = self
        cvTopCategories.setBackgroundColor()
        
        cvWidthConstraint.constant = screenWidth
        
        cvTopCategories.register(UINib(nibName: "CategoryBannerItemCell", bundle: nil), forCellWithReuseIdentifier: "CategoryBannerItemCell")
        
       self.cvTopCategories.reloadData()
            
    }
    
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        
        cvWidthConstraint.constant = screenWidth
        cvHeightConstraint.constant = self.cvTopCategories.contentSize.height
        
        return  CGSize(width: screenWidth, height: self.cvTopCategories.contentSize.height)
    }
    
    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategoryBanners.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryBannerItemCell", for: indexPath) as! CategoryBannerItemCell
        
        
        let imageUrl = arrCategoryBanners[indexPath.row]["cat_banners_image_url"].string
        
        if imageUrl != nil {
            //        DispatchQueue.global(qos: .userInitiated).async {
            cell.imgCategory.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                DispatchQueue.main.async {
                    if (image == nil) {
                        cell.imgCategory.image =  UIImage(named: "noImage")
                        
                    } else {
                        
                        cell.imgCategory.image =  image
                    }
                }
            }
            //        }
        } else {
            cell.imgCategory.image =  nil
        }
        
        cell.lblCategory.text = arrCategoryBanners[indexPath.row]["cat_banners_title"].string
        cell.btnShopNow.tag = indexPath.row
        cell.btnShopNow.addTarget(self, action: #selector(shopNowButtonClicked(_:)), for: .touchUpInside)
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width:  (isIPad ? 160 : 125)*collectionView.frame.size.width/375 , height: (isIPad ? 140 : 125)*collectionView.frame.size.width/375)
        return CGSize(width: 140*screenWidth/375 , height: 125*screenWidth/375)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryBanner = arrCategoryBanners[indexPath.row]
        navigateToProductList(banner: categoryBanner)
    }
    
    //MARK: - Button Clicked
    
    @objc func shopNowButtonClicked(_ sender: Any) {
        let shopNowButton = sender as! UIButton
        let categoryBanner = arrCategoryBanners[shopNowButton.tag]
        navigateToProductList(banner: categoryBanner)
    }
    
    
    func navigateToProductList(banner: JSON) {
        let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
        productsVC.fromCategory = true
        productsVC.categoryID = banner["cat_banners_cat_id"].intValue
        self.parentContainerViewController()?.navigationController?.pushViewController(productsVC, animated: true)
    }
}
