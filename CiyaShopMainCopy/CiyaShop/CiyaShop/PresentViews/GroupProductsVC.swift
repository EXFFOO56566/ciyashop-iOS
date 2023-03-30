//
//  VariationsVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 19/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroupProductsVC: UIView {
    
    //MARK:- Outlets
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var tblGroupProducts: UITableView!
    @IBOutlet weak var constraintVariationTableHeight: NSLayoutConstraint!

    //MARK:- Variables
    var arrGroupItems : [JSON] = []
    
    //MARK:- Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    //MARK:- Setup UI
    func setUpUI()
    {
        // Initialization code
        registerCell()
        
        tblGroupProducts.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        //--
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwContent.cornerRadius(radius: 5)
        //---
        
  
        tblGroupProducts.reloadData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideView))
        blurView.addGestureRecognizer(tap)
        
    }
    
    //MARK:-Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let obj = object as? UITableView {
            if obj == self.tblGroupProducts && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    print("newSize Review contentsize - ",newSize)
                    
                    if newSize.height >= screenHeight-200{
                        self.constraintVariationTableHeight.constant = screenHeight-200
                        
                    }else{
                        self.constraintVariationTableHeight.constant = newSize.height
                        
                    }

                }
            }
        }
    }
    
    // MARK: - Configuration
    private func registerCell()
    {
        tblGroupProducts.delegate = self
        tblGroupProducts.dataSource = self
        tblGroupProducts.register(UINib(nibName: "GroupProductTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupProductTableViewCell")
        
    }
    
    //  MARK: - on Tap gesture
    @objc func hideView() {
        self.transform = .identity
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (animated) in
            self.removeFromSuperview()
        }
    }
    
    
}
//MARK:- Other methods
extension GroupProductsVC
{
    func dismissView()
    {
        self.removeFromSuperview()
    }
}
//MARK:- Button action methods
extension  GroupProductsVC
{
    @IBAction func btnDoneClicked(_ sender: UIButton)
    {
        dismissView()
    }
    @IBAction func btnCancelClicked(_ sender: UIButton)
    {
        dismissView()
    }
}
//MARK:-  UITableview Delegate Datasource
extension GroupProductsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrGroupItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupProductTableViewCell", for: indexPath) as! GroupProductTableViewCell
        
        let product = arrGroupItems[indexPath.row]
        cell.dictDetails = product
        cell.setUpProductData()
        
        cell.btnBag.tag = indexPath.row
        cell.btnBag.addTarget(self, action: #selector(btnCartClicked(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.parentContainerViewController()!.navigateToProductDetails(detailDict: arrGroupItems[indexPath.row])
        dismissView()
    }
    
    @objc func btnCartClicked(_ sender: Any) {
        
        let favouriteButton = sender as! UIButton
        let product = arrGroupItems[favouriteButton.tag]

        onAddtoCartButtonClicked(viewcontroller: self.viewContainingController()!, product: product, collectionView: nil, index: 0)
        
        if self.parentContainerViewController()! is HomeVC {
            (self.parentContainerViewController() as! HomeVC).updateCartBadge()
        }
        if self.parentContainerViewController()! is ProductsVC {
            (self.parentContainerViewController() as! ProductsVC).updateCartBadge()
        }
        
    }
    
}
