//
//  GroupItemsTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 20/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroupItemsTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var heightGroupItemTableConstraint: NSLayoutConstraint!

    //MARK:- Variables
    var arrayProducts : [JSON] = []
    var dictDetails = JSON()
    
    //MARK:-Life cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpUI()
    }
    //MARK:- Setup UI
    func setUpUI()
    {
        // Initialization code
        //--
        registerDatasourceCell()
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwContent.cornerRadius(radius: 5)
        //---
        
    }
    func setUpData()
    {
        tblItems.reloadData()
    }
    // MARK: - Cell Register
    func registerDatasourceCell()
    {
         tblItems.register(UINib(nibName: "GroupProductTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupProductTableViewCell")
        tblItems.delegate = self
        tblItems.dataSource = self
        tblItems.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblItems.tableFooterView = UIView()
        
       
        
        tblItems.reloadData()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:-
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let obj = object as? UITableView {
            if obj == self.tblItems && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    print("newSize Review contentsize - ",newSize)

                    heightGroupItemTableConstraint.constant = CGFloat(arrayProducts.count * 91)
                    self.contentView.layoutIfNeeded()
                    self.contentView.layoutSubviews()
                }
            }
        }
    }
}
//MARK:-  UITableview Delegate Datasource
extension GroupItemsTableViewCell : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayProducts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupProductTableViewCell", for: indexPath) as! GroupProductTableViewCell
        let dict = arrayProducts[indexPath.row]
        cell.dictDetails = dict
        cell.setUpProductData()
        cell.btnBag.tag = indexPath.row
        cell.btnBag.addTarget(self, action: #selector(btnBagClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = arrayProducts[indexPath.row]
        if dict["type"].string == "external" {
            openUrl(strUrl: dict["external_url"].stringValue)
            return;
        }
        self.parentContainerViewController()?.navigateToProductDetails(detailDict: dict)
    }
}
//MARK:- Button action
extension GroupItemsTableViewCell
{
    @objc func btnBagClicked(_ sender: UIButton)
    {
        let product = arrayProducts[sender.tag]

        if checkItemExistsInCart(product: product) {
            tabController?.selectedIndex = 1
            self.parentContainerViewController()!.navigationController?.popToRootViewController(animated: true)
        } else {
            addItemInCart(product: product)
            self.parentContainerViewController()!.showToast(message: getLocalizationString(key: "ItemAddedCart"))
        }
        
    }
}
