//
//  SubCategoryVC.swift
//  CiyaShop
//
//  Created by Apple on 09/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubCategoryVC: UIViewController {
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    
    @IBOutlet weak var vwCartBadge: UIView!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var cartButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tblSubCategory: UITableView!
    
    var arrSubcategories = Array<JSON>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThemeColors()
        setHeader()
        registerDatasourceCell()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartBadge()
    }
    
    func registerDatasourceCell()  {
        
        tblSubCategory.delegate = self
        tblSubCategory.dataSource = self
        
        tblSubCategory.register(UINib(nibName: "SubCategoryItemCell", bundle: nil), forCellReuseIdentifier: "SubCategoryItemCell")
        
        
        tblSubCategory.estimatedRowHeight = 40
        tblSubCategory.rowHeight = UITableView.automaticDimension
        
        tblSubCategory.tableFooterView = UIView()
        
        self.tblSubCategory.reloadData()
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
        btnSearch.tintColor =  secondaryColor
        btnCart.tintColor =  secondaryColor
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
    
    
}

extension SubCategoryVC : UITableViewDelegate,UITableViewDataSource  {
    
    // MARK: - UITableview Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if arrSubcategories.count > 0 {
            return self.arrSubcategories.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        borderTableviewSection(tableView: tableView, indexPath: indexPath,cell: cell)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryItemCell", for: indexPath) as! SubCategoryItemCell
        cell.setSubcategory(subCategory: arrSubcategories[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subCategory = arrSubcategories[indexPath.row]
        
        
        let subcategories =  arrAllCategories.filter({$0["parent"].stringValue == subCategory["id"].stringValue})
        
        if subcategories.count > 0 {
            let subCategoryVC = SubCategoryVC(nibName: "SubCategoryVC", bundle: nil)
            subCategoryVC.arrSubcategories = subcategories
            self.navigationController?.pushViewController(subCategoryVC, animated: true)
            
        } else {
            let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
            productsVC.fromCategory = true
            productsVC.categoryID = subCategory["id"].intValue
            self.navigationController?.pushViewController(productsVC, animated: true)
        }
    }
    
}
