//
//  SearchVC.swift
//  CiyaShop
//
//  Created by Apple on 12/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class AllCategoriesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var cvCategories: UICollectionView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    
    @IBOutlet weak var vwCartBadge: UIView!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var cartButtonWidthConstraint: NSLayoutConstraint!
    
//    Variables
    var isForFilter : Bool = false
    var delegateFilter : CategorySelectionDelegate?
    
    var arrCategories : Array = Array<JSON>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrCategories =  arrAllCategories.filter({$0["parent"].stringValue ==  "0"})

        setThemeColors()
        setHeader()
        registerDatasourceCell()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartBadge()
    }
    
    func registerDatasourceCell()  {
        
        cvCategories.delegate = self
        cvCategories.dataSource = self
        
        cvCategories.register(UINib(nibName: "CategoryItemCell", bundle: nil), forCellWithReuseIdentifier: "CategoryItemCell")
        
        self.cvCategories.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.cvCategories.reloadData()
    }
    
    func setHeader()  {
        
        self.lblHeaderTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblHeaderTitle.text = getLocalizationString(key: "AllCategory")
    }
    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        self.lblHeaderTitle.textColor = secondaryColor
        
        vwCartBadge.backgroundColor = secondaryColor
        lblBadge.textColor = primaryColor
        
        btnBack.tintColor =  secondaryColor
        btnMenu.tintColor =  secondaryColor
        btnSearch.tintColor =  secondaryColor
        btnCart.tintColor = secondaryColor
        
        if isForFilter {
            btnBack.isHidden = false
        } else {
            btnBack.isHidden = true
        }
    
    }
    
    // MARK: - update badge
    
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
    
    // MARK: - Button Clicked
    @IBAction func btnCartClicked(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    
    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItemCell", for: indexPath) as! CategoryItemCell
        
        
        let imageUrl = arrCategories[indexPath.row]["image"]["src"].stringValue
        
        if imageUrl == "" {
            cell.imgCategory.image =  UIImage()
            cell.imgCategory.backgroundColor = secondaryColor
        } else {
            //        DispatchQueue.global(qos: .userInitiated).async {
            cell.imgCategory.sd_setImage(with: imageUrl.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                //                DispatchQueue.main.async {
                if (image == nil) {
                    cell.imgCategory.image =  UIImage()
                    cell.imgCategory.backgroundColor = secondaryColor
                } else {
                    cell.imgCategory.image =  image
                    cell.imgCategory.backgroundColor = .clear
                }
                //                }
                //            }
            }
        }
        
        
        
        
        if let productTitle = arrCategories[indexPath.row]["name"].string {
            cell.lblCategory.text = productTitle
        } else {
            cell.lblCategory.text = " "
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:  screenWidth/3 - 20, height: screenWidth/3 - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = arrCategories[indexPath.row]
        
        
        if isForFilter {
            delegateFilter?.selectCategory(categoryId: category["id"].intValue)
            self.navigationController?.popViewController(animated: true)
        } else {
            let subcategories =  arrAllCategories.filter({$0["parent"].stringValue == category["id"].stringValue})
            
            if subcategories.count > 0 {
                print(category)
                let subCategoryVC = SubCategoryVC(nibName: "SubCategoryVC", bundle: nil)
                subCategoryVC.arrSubcategories = subcategories
                self.navigationController?.pushViewController(subCategoryVC, animated: true)
                
            } else {
                let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
                productsVC.fromCategory = true
                productsVC.categoryID = category["id"].intValue
                self.navigationController?.pushViewController(productsVC, animated: true)
            }
            
        }
    }
    
    
    
}
