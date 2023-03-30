//
//  WalletTransactionsVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 28/09/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON


class WalletTransactionsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var tblTransactionHistory : UITableView!
    @IBOutlet var lblHeader : UILabel!
    @IBOutlet var vwNavigation : UIView!

    @IBOutlet var btnBack : UIButton!

    //MARK:- Variables
    var arrayTransactions : [JSON] = []
    var dictWallet = JSON()
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerDatasourceCell()
        setUpUI()
    }

    // MARK: - Cell Register
    func registerDatasourceCell()  {
        tblTransactionHistory.delegate = self
        tblTransactionHistory.dataSource = self
        
        
        
        tblTransactionHistory.register(UINib(nibName: "WalletTransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletTransactionTableViewCell")
    }
    //MARK:- UI set up
    func setUpUI()
    {
        lblHeader.textColor = secondaryColor
        lblHeader.font =  UIFont.appRegularFontName(size: fontSize12)
  
        
        btnBack.tintColor = secondaryColor
        
        tblTransactionHistory.tableFooterView = UIView()
        
        tblTransactionHistory.reloadData()
    }


}

//MARK:- UItableview delegate datasource methods
extension WalletTransactionsVC : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayTransactions.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTransactionTableViewCell", for: indexPath) as! WalletTransactionTableViewCell
        let dict = arrayTransactions[indexPath.row]
        
        var symbol = ""
        if(dict["type"].stringValue == "credit")
        {
            symbol = "+"
        }else{
            symbol = "-"
        }
        
        cell.lblAmount.text = "\(symbol) " + dict["amount"].stringValue + " \(dict["currency"].stringValue.htmlEncodedString())"
        
        
        cell.lblText.text = dict["details"].stringValue
        cell.lblDate.text = dict["date"].stringValue
        
        
        return cell
            
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        
    }
    
}
//MARK:- Other methods
extension WalletTransactionsVC
{
    @IBAction func btnAddTransactionClicked(_ sender: UIButton)
    {
        redirectToWalletTopUpPage()
        
    }
    @objc func redirectToWalletTopUpPage() {
        
        if(!dictWallet["topup_page"].stringValue.isEmpty)
        {
            let webviewVC = WebviewCheckoutVC(nibName: "WebviewCheckoutVC", bundle: nil)
            webviewVC.url = dictWallet["topup_page"].stringValue
            webviewVC.isFromWallet = true
            self.navigationController?.pushViewController(webviewVC, animated: true)
        }else{
            showToast(message: "Wallet top up link not set")
        }
            
        
    }
}
