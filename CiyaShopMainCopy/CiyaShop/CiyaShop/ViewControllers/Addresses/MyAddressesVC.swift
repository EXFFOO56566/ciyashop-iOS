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


class MyAddressesVC: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tblMyAddresses: UITableView!
    
    
    //MARK: Life cycle method
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setThemeColors()
        registerDatasourceCell()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAddressData), name: NSNotification.Name(rawValue: REFRESH_ADDRESS_DATA), object: nil)

    }
    
    
    //MARK: - Custom Method
    func setThemeColors() {
        
        self.view.setBackgroundColor()
        self.tblMyAddresses.setBackgroundColor()
        
        btnBack.tintColor =  secondaryColor
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "MyAddresses")
        self.lblTitle.textColor = secondaryColor
        
        
    }
    
    func registerDatasourceCell()  {
        
        tblMyAddresses.delegate = self
        tblMyAddresses.dataSource = self
        
        tblMyAddresses.register(UINib(nibName: "MyAddressCell", bundle: nil), forCellReuseIdentifier: "MyAddressCell")
        tblMyAddresses.register(UINib(nibName: "NoAddressesCell", bundle: nil), forCellReuseIdentifier: "NoAddressesCell")
        
        tblMyAddresses.reloadData()
        
        tblMyAddresses.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

    }
    
    @objc func refreshAddressData() {
        tblMyAddresses.reloadData()
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - API Calling
    func removeAddress(params : [AnyHashable : Any]) {
        showLoader()
        
        CiyaShopAPISecurity.updateCustomerAddress(params, userId: (getValueFromLocal(key: USERID_KEY) as! String))  { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {

                dictLoginData = jsonReponse
                self.refreshAddressData()
                
                return
            }
            
            if let message = jsonReponse["message"].string {
                showCustomAlert(title: APP_NAME,message: message, vc: self)
            } else {
                showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
            }
        }
    }
    
    //MARK: - Button Clicked
    
    @IBAction func backButtonClicked(_ sender: Any)  {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyAddressesVC : UITableViewDataSource,UITableViewDelegate {
    //MARK : - Tableview delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // For tableCell Estimated Height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dictLoginData.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoAddressesCell", for: indexPath) as! NoAddressesCell
            cell.setHeaderTitle(indexPath: indexPath)
            cell.btnAdd.tag = indexPath.row
            cell.btnAdd.addTarget(self, action: #selector(btnAddClicked(_:)), for: .touchUpInside)
            return cell
        } else {
            
            if indexPath.row == 0 {
                
                if dictLoginData["billing"]["phone"].string == "" && dictLoginData["billing"]["first_name"].string == "" && dictLoginData["billing"]["last_name"].string == "" && dictLoginData["billing"]["address_1"].string == "" && dictLoginData["shipping"]["company"].string == ""  && dictLoginData["billing"]["address_2"].string == "" && dictLoginData["billing"]["city"].string == "" && dictLoginData["billing"]["state"].string == "" && dictLoginData["billing"]["postcode"].string == "" {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NoAddressesCell", for: indexPath) as! NoAddressesCell
                    cell.setHeaderTitle(indexPath: indexPath)
                    cell.btnAdd.tag = indexPath.row
                    cell.btnAdd.addTarget(self, action: #selector(btnAddClicked(_:)), for: .touchUpInside)
                    return cell
                    
                } else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MyAddressCell", for: indexPath) as! MyAddressCell
                    cell.setBillingAddress()
                    cell.setHeaderTitle(indexPath: indexPath)
                    
                    cell.btnEdit.tag = indexPath.row
                    cell.btnEdit.addTarget(self, action: #selector(btnEditClicked(_:)), for: .touchUpInside)
                    
                    cell.btnRemove.tag = indexPath.row
                    cell.btnRemove.addTarget(self, action: #selector(btnRemoveClicked(_:)), for: .touchUpInside)
                    
                    return cell
                }
                
            } else {
                
                if dictLoginData["shipping"]["first_name"].string == "" && dictLoginData["shipping"]["last_name"].string == "" && dictLoginData["shipping"]["address_1"].string == "" && dictLoginData["shipping"]["address_2"].string == "" && dictLoginData["shipping"]["company"].string == "" && dictLoginData["shipping"]["city"].string == "" && dictLoginData["shipping"]["state"].string == "" && dictLoginData["shipping"]["postcode"].string == "" {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NoAddressesCell", for: indexPath) as! NoAddressesCell
                    cell.setHeaderTitle(indexPath: indexPath)
                    cell.btnAdd.tag = indexPath.row
                    cell.btnAdd.addTarget(self, action: #selector(btnAddClicked(_:)), for: .touchUpInside)
                    return cell
                    
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MyAddressCell", for: indexPath) as! MyAddressCell
                    cell.setShippingAddress()
                    cell.setHeaderTitle(indexPath: indexPath)
                    cell.btnEdit.tag = indexPath.row
                    cell.btnEdit.addTarget(self, action: #selector(btnEditClicked(_:)), for: .touchUpInside)
                    
                    cell.btnRemove.tag = indexPath.row
                    cell.btnRemove.addTarget(self, action: #selector(btnRemoveClicked(_:)), for: .touchUpInside)
                    
                    return cell
                }
            }
            
        }
        

    }
    
    
    //MARK: - Add Button Clicked
    @objc func btnAddClicked(_ sender: Any) {
        let addButton = sender as! UIButton
        
        let addAddressesVC = AddNewAddressVC(nibName: "AddNewAddressVC", bundle: nil)
        addAddressesVC.isBillingAddress = addButton.tag == 0 ? true : false
        addAddressesVC.isEditAddress = false
        self.navigationController?.pushViewController(addAddressesVC, animated: true)
    }
    
    @objc func btnEditClicked(_ sender: Any) {
        let editButton = sender as! UIButton
        
        let addAddressesVC = AddNewAddressVC(nibName: "AddNewAddressVC", bundle: nil)
        addAddressesVC.isBillingAddress = editButton.tag == 0 ? true : false
        addAddressesVC.isEditAddress = true
        self.navigationController?.pushViewController(addAddressesVC, animated: true)
        
    }
    
    @objc func btnRemoveClicked(_ sender: Any) {
        showCustomAlertWithConfirm(title: APP_NAME, message: getLocalizationString(key: "removeAddresss"), vc: self) {
            
            let removeButton = sender as! UIButton
            
            var params = [AnyHashable : Any]()
            var addressParams = [AnyHashable : Any]()
            addressParams["first_name"] = ""
            addressParams["last_name"] = ""
            addressParams["address_1"] = ""
            addressParams["address_2"] = ""
            addressParams["postcode"] = ""
            addressParams["city"] = ""
            addressParams["company"] = ""
            addressParams["state"] = ""
            addressParams["country"] = ""
            
            if removeButton.tag == 0 {
                addressParams["phone"] = ""
                params["billing"] = addressParams
                
            } else {
                params["shipping"] = addressParams
            }
            
            self.removeAddress(params: params)
            
        }
    }
}
