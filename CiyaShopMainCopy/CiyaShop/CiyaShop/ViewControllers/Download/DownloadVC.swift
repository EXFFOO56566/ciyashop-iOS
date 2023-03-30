//
//  DownloadVC.swift
//  CiyaShop
//
//  Created by Apple on 04/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON

class DownloadVC: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tblDownload: UITableView!
    
    //For no product
    @IBOutlet weak var vwNoProductFound: UIView!
    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var lblSimplyBrowse: UILabel!
    @IBOutlet weak var lblNoProductFound: UILabel!
    
    
    var arrDownloadProducts = Array<JSON>()
    
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
        getDownloadProducts()
    }
    
    func setThemeColors() {
        
        self.view.setBackgroundColor()
        self.tblDownload.setBackgroundColor()
        
        btnBack.tintColor =  secondaryColor
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.text = getLocalizationString(key: "Download")
        self.lblTitle.textColor = secondaryColor
        
        self.lblNoProductFound.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblNoProductFound.text = getLocalizationString(key: "NoproductFound")
        self.lblNoProductFound.textColor = secondaryColor
        
        self.lblSimplyBrowse.text = getLocalizationString(key: "BrowseSomeOtherItem")
        self.lblSimplyBrowse.textColor = secondaryColor
        self.lblSimplyBrowse.font = UIFont.appLightFontName(size: fontSize11)

        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        self.btnContinueShopping.tintColor = primaryColor
        
    }
    
    func registerDatasourceCell()  {
        
        tblDownload.delegate = self
        tblDownload.dataSource = self
        
        tblDownload.register(UINib(nibName: "DownloadCell", bundle: nil), forCellReuseIdentifier: "DownloadCell")

        tblDownload.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

    }
    
    
    //MARK: - API Calling
    
    func getDownloadProducts() {
        showLoader()
        
        CiyaShopAPISecurity.getDownloadProducts((getValueFromLocal(key: USERID_KEY) as! NSString).intValue)  { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                
                if let downloadProducts = jsonReponse.array {
                    if downloadProducts.count > 0  {
                        self.arrDownloadProducts = downloadProducts
                        self.tblDownload.reloadData()
                        
                        self.vwNoProductFound.isHidden = true
                        self.tblDownload.isHidden = false
                    } else {
                        self.vwNoProductFound.isHidden = false
                        self.tblDownload.isHidden = true
                    }
                } else {
                    self.vwNoProductFound.isHidden = false
                    self.tblDownload.isHidden = true
                }
            } else {
                if let message = jsonReponse["message"].string {
                    showCustomAlert(title: APP_NAME,message: message, vc: self)
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                }
            }
            
        }
    }
    
    //MARK: - Button Clicked
    
    @IBAction func backButtonClicked(_ sender: Any)  {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnContinueShoppingClicked(_ sender: Any)  {
        tabController?.selectedIndex = 2
    }
    
    
}

extension DownloadVC : UITableViewDataSource,UITableViewDelegate {
    //MARK : - Tableview delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrDownloadProducts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // For tableCell Estimated Height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell", for: indexPath) as! DownloadCell
        
        cell.setProductData(product: arrDownloadProducts[indexPath.row])
        cell.btnDownload.tag = indexPath.row
        cell.btnDownload.addTarget(self, action: #selector(btnDownloadClicked(_:)), for: .touchUpInside)

        return cell
        
    }
    
    @objc func btnDownloadClicked(_ sender: Any)  {
        
        let detailButton = sender as! UIButton
        let product = arrDownloadProducts[detailButton.tag]

        if let url = URL(string: product["download_url"].string!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}

    

