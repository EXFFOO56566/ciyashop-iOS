//
//  NotificationsVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 20/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON


class NotificationsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblNotification: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnRemoveAll: UIButton!
    
    //For no product
    @IBOutlet weak var viewNoProductAvailable: UIView!
    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var lblSimplyBrowse: UILabel!
    @IBOutlet weak var lblNoProductAvailable: UILabel!
    
    //Variables
    var arrNotifications : Array = Array<JSON>()
    
    //MARK:- Life cycle methods
    
    
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
        getNotification()
    }
    //MARK:- UI setup
    func setThemeColors() {
        
        registerDatasourceCell()
        self.view.setBackgroundColor()
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "Notifications")
        self.lblTitle.textColor = secondaryColor

        self.btnContinueShopping.tintColor = primaryColor
        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        
        self.lblSimplyBrowse.font = UIFont.appLightFontName(size: fontSize11)
        self.lblSimplyBrowse.text = getLocalizationString(key: "NoOrderDescription")
        self.lblSimplyBrowse.textColor = secondaryColor
        
        self.lblNoProductAvailable.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblNoProductAvailable.text = getLocalizationString(key: "NoNotificationYet")
        self.lblNoProductAvailable.textColor = secondaryColor
        
        
        self.btnBack.tintColor = secondaryColor
        
        self.btnRemoveAll.backgroundColor = .clear
        self.btnRemoveAll.tintColor = .red
        self.btnRemoveAll.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
        self.btnRemoveAll.setTitle(getLocalizationString(key: "RemoveAll"), for: .normal)
        
        if isRTL {
            
            btnRemoveAll.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            btnRemoveAll.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            
        }
    }
    
    func registerDatasourceCell() {
        
        tblNotification.delegate = self
        tblNotification.dataSource = self
        tblNotification.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        tblNotification.reloadData()
    }
    
    func updateViews() {
        if arrNotifications.count == 0 {
            viewNoProductAvailable.isHidden = false
            tblNotification.isHidden = true
            btnRemoveAll.isHidden = true
        } else {
            viewNoProductAvailable.isHidden = true
            tblNotification.isHidden = false
            btnRemoveAll.isHidden = false
        }
    }
    //MARK: - Notification api Calling
    
    func getNotification() {
        showLoader()
        
        var params = [AnyHashable : Any]()
        params["device_token"] = strDeviceToken
        params["device_type"] = "1"
        
        CiyaShopAPISecurity.getAllNotifications(params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    self.arrNotifications = jsonReponse["data"].array!
                    self.tblNotification.reloadData()
                }
            }
            
            self.updateViews()
        }
    }
    
    func deleteNotification(index : Int) {
        showLoader()
        
        var params = [AnyHashable : Any]()
        params["push_meta_id"] = [arrNotifications[index]["push_meta_id"].stringValue]
        
        CiyaShopAPISecurity.deleteNotification(params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    
                    if self.arrNotifications[index]["not_code"].stringValue == "1" {
                        //redirect coupon page
                    } else if self.arrNotifications[index]["not_code"].stringValue == "2" {
                        //redirect my order page
                    }
                    
                    self.arrNotifications.remove(at: index)
                    
                    self.tblNotification.beginUpdates()
                    self.tblNotification.deleteRows(at: createIndexPathArray(row: index, section: 0), with: .right)
                    self.tblNotification.endUpdates()
                    
                    return
                }
            }
            
            if let message = jsonReponse["message"].string {
                showCustomAlert(title: APP_NAME,message: message, vc: self)
            } else {
                showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
            }
        }
    }
    
    func deleteAllNotification() {
        showLoader()
        
        var params = [AnyHashable : Any]()
        var arrPushIds = Array<String>()
        for notification in arrNotifications {
            arrPushIds.append(notification["push_meta_id"].stringValue)
        }
        params["push_meta_id"] = arrPushIds
        
        CiyaShopAPISecurity.deleteNotification(params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    self.arrNotifications.removeAll()
                    self.tblNotification.reloadData()
                    self.updateViews()
                }
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
    @IBAction func btnContinueShoppingClicked(_ sender: UIButton) {
        if tabController?.selectedIndex == 2 {
            self.navigationController?.popToRootViewController(animated: true)
        }
        self.navigationController?.popToRootViewController(animated: true)
        tabController?.selectedIndex = 2
    }
    
    @IBAction func btnRemoveAllNotificationClicked(_ sender: UIButton) {
        showCustomAlertWithConfirm(title: APP_NAME, message: getLocalizationString(key: "RemoveAllMessage"), vc: self) {
            self.deleteAllNotification()
        }
    }
    
    
    func redirectMyOrders() {
        
        let myOrdersVC = MyOrdersVC(nibName: "MyOrdersVC", bundle: nil)
        self.navigationController?.pushViewController(myOrdersVC, animated: true)
    }
    
    func redirectMyCoupons() {
        
        let couponsVC = CouponsVC(nibName: "CouponsVC", bundle: nil)
        self.navigationController?.pushViewController(couponsVC, animated: true)
    }
    
    func redirectLogin() {
        DispatchQueue.main.async {
            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
            let loginNavigationController = UINavigationController(rootViewController: loginVC)
            loginNavigationController.navigationBar.isHidden = true
            loginNavigationController.modalPresentationStyle = .fullScreen
            self.present(loginNavigationController, animated: true, completion: nil)
        }
    }
    
    
}

extension NotificationsVC : UITableViewDelegate,UITableViewDataSource
{
    // MARK: - UITableview Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.setNotificationData(notification: arrNotifications[indexPath.row])
        
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if is_Logged_in == true {
            deleteNotification(index: indexPath.row)
        } else {
            redirectLogin()
        }
    }
}

