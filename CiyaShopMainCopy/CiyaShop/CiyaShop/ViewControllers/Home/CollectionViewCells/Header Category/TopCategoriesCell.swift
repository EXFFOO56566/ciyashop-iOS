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

class TopCategoriesCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var cvTopCategories: UICollectionView!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    
    //MARK:- variables
    
    

    //MARK:- Awake from nib

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }
    
    // MARK: - Configuration
    private func setupCollectionView() {
        
        contentView.setBackgroundColor()
        cvTopCategories.delegate = self
        cvTopCategories.dataSource = self
        cvTopCategories.setBackgroundColor()
        cvWidthConstraint.constant = screenWidth
        
        cvTopCategories.register(UINib(nibName: "TopCategoryItemCell", bundle: nil), forCellWithReuseIdentifier: "TopCategoryItemCell")
        
        self.cvTopCategories.reloadData()
    }
    
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        
        cvWidthConstraint.constant = screenWidth
        cvHeightConstraint.constant = self.cvTopCategories.contentSize.height

        return  CGSize(width: self.cvTopCategories.contentSize.width, height: self.cvTopCategories.contentSize.height+8)
    }
    
    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrHeaderCategories.count == 0 {
            return 0
        } else if arrHeaderCategories.count > 5 {
            return 6
        }
        return arrHeaderCategories.count + 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCategoryItemCell", for: indexPath) as! TopCategoryItemCell
        
        if arrHeaderCategories.count > 5 && indexPath.row == 5 {
            cell.imgCategory.image = UIImage(named: "more-icon")
            cell.imgCategory.tintColor = primaryColor
            cell.lblCategory.text = getLocalizationString(key: "More")
            cell.imgCategory.backgroundColor = secondaryColor
            cell.imgCategory.contentMode = .center
            
        } else if indexPath.row == arrHeaderCategories.count {
            cell.imgCategory.image = UIImage(named: "more-icon")
            cell.imgCategory.tintColor = primaryColor
            cell.lblCategory.text = getLocalizationString(key: "More")
            cell.imgCategory.backgroundColor = secondaryColor
            cell.imgCategory.contentMode = .center
            
        } else {
            let imageUrl = arrHeaderCategories[indexPath.row]["main_cat_image"].string
            if imageUrl != nil && imageUrl != "" {

                DispatchQueue.global(qos: .userInitiated).async {
                    cell.imgCategory.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                        DispatchQueue.main.async {
                            if (image == nil) {
                                cell.imgCategory.image =  UIImage(named: "noImage")
                                
                            } else {
                                
                                cell.imgCategory.image =  image
                            }
                        }
                    }
                }
            } else {
                cell.imgCategory.image =  nil
            }
            
            cell.lblCategory.text = arrHeaderCategories[indexPath.row]["main_cat_name"].string
            cell.imgCategory.contentMode = .scaleAspectFit
            cell.imgCategory.backgroundColor = secondaryColor

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/5 , height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if arrHeaderCategories.count > 5 && indexPath.row == 5 {
            redirectCategoryTab()
        } else if indexPath.row == arrHeaderCategories.count {
            redirectCategoryTab()
        } else {
            redirectProductList(category: arrHeaderCategories[indexPath.row])
        }
    }
    
    //Redirect to Category page
    func redirectCategoryTab() {
        let navigationController = tabController?.viewControllers?.first as! UINavigationController
        navigationController.popToRootViewController(animated: false)
        tabController?.selectedIndex = 0
    }
    
    func redirectProductList(category : JSON) {
        
        let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
        productsVC.fromCategory = true
        productsVC.categoryID = category["main_cat_id"].intValue
        self.parentContainerViewController()?.navigationController?.pushViewController(productsVC, animated: true)
    }
}
