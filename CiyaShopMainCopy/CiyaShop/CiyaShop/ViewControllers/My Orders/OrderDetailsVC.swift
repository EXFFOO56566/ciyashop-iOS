//
//  LoginVC.swift
//  CiyaShop
//
//  Created by Apple on 07/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework



class OrderDetailsVC: UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblOrderIdTitle: UILabel!
    @IBOutlet weak var lblOrderIdValue: UILabel!
    
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderMessage: UILabel!
    
    @IBOutlet weak var btnTrackingDetail: UIButton!
    @IBOutlet weak var lblTrackingMessage: UILabel!
    
    @IBOutlet weak var vwOrderStatus: UIView!

    @IBOutlet weak var lblPaymentMethodTitle: UILabel!
    @IBOutlet weak var lblPaymentMethodValue: UILabel!
    
    @IBOutlet weak var lblPaymentDetails: UILabel!
    
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblSubTotalValue: UILabel!
    
    @IBOutlet weak var lblShippingTitle: UILabel!
    @IBOutlet weak var lblShippingValue: UILabel!
    
    @IBOutlet weak var lblTotalAmountTitle: UILabel!
    @IBOutlet weak var lblTotalAmountValue: UILabel!
    
    @IBOutlet weak var lblBillingAddressTitle: UILabel!
    @IBOutlet weak var lblBillingAddressDetails: UILabel!
    @IBOutlet weak var lblBillingAddressName: UILabel!
    @IBOutlet weak var lblBillingAddressPhone: UILabel!
    @IBOutlet weak var lblBillingAddressEmail: UILabel!
    
    @IBOutlet weak var lblShippingAddressTitle: UILabel!
    @IBOutlet weak var lblShippingAddressDetails: UILabel!
    @IBOutlet weak var lblShippingAddressName: UILabel!
    @IBOutlet weak var lblShippingAddressPhone: UILabel!
    @IBOutlet weak var lblShippingAddressEmail: UILabel!
    
    @IBOutlet weak var imgBillingAddressDetails: UIImageView!
    @IBOutlet weak var imgBillingAddressName: UIImageView!
    @IBOutlet weak var imgBillingAddressPhone: UIImageView!
    @IBOutlet weak var imgBillingAddressEmail: UIImageView!
    
    @IBOutlet weak var imgShippingAddressDetails: UIImageView!
    @IBOutlet weak var imgShippingAddressName: UIImageView!
    @IBOutlet weak var imgShippingAddressPhone: UIImageView!
    @IBOutlet weak var imgShippingAddressEmail: UIImageView!
    
    
    @IBOutlet weak var vwOrderDetails: UIView!
    @IBOutlet weak var vwPaymentDetails: UIView!
    @IBOutlet weak var vwBillingAddress: UIView!
    @IBOutlet weak var vwShippingAddress: UIView!
    
    @IBOutlet weak var btnCancelOrder: UIButton!
    
    @IBOutlet weak var trackingTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var tblviewHeightConstraint: NSLayoutConstraint!
    
    //variables
    
    var orderDetail : JSON?
    var orderDelegate : OrderDetailDelegate?
    var trackUrl = ""
    
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
        setOrderData()
        registerDatasourceCell()
    }


    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
    
        lblTitle.text = getLocalizationString(key: "OrderDetails")
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
        
        btnBack.tintColor =  secondaryColor
        
        
        self.lblOrderIdTitle.font = UIFont.appRegularFontName(size: fontSize12)
        self.lblOrderIdTitle.text = getLocalizationString(key: "OrderId")
        self.lblOrderIdTitle.textColor = primaryColor
        
        self.lblOrderIdValue.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblOrderIdValue.textColor = primaryColor
        
        self.lblOrderMessage.font = UIFont.appRegularFontName(size: fontSize12)
        self.lblOrderMessage.textColor = primaryColor
        
        self.lblOrderStatus.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblOrderStatus.textColor = .white
        
        btnTrackingDetail.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        btnTrackingDetail.backgroundColor = .clear
        btnTrackingDetail.setTitleColor(grayTextColor, for: .normal)
        
        self.lblTrackingMessage.font = UIFont.appRegularFontName(size: fontSize12)
        self.lblTrackingMessage.textColor = grayTextColor
        

        self.lblPaymentMethodTitle.font = UIFont.appLightFontName(size: fontSize12)
        self.lblPaymentMethodTitle.text = getLocalizationString(key: "PaymentMethod")
        self.lblPaymentMethodTitle.textColor = grayTextColor
        
        self.lblPaymentMethodValue.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblPaymentMethodValue.textColor = secondaryColor
        
        self.lblPaymentDetails.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblPaymentDetails.text = getLocalizationString(key: "PaymentDetails")
        self.lblPaymentDetails.textColor = secondaryColor
        
        self.lblSubTotalTitle.font = UIFont.appLightFontName(size: fontSize12)
        self.lblSubTotalTitle.text = getLocalizationString(key: "SubTotal")
        self.lblSubTotalTitle.textColor = grayTextColor
        
        self.lblSubTotalValue.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblSubTotalValue.textColor = grayTextColor
        
        self.lblShippingTitle.font = UIFont.appLightFontName(size: fontSize12)
        self.lblShippingTitle.text = getLocalizationString(key: "Shipping")
        self.lblShippingTitle.textColor = grayTextColor
        
        self.lblShippingValue.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblShippingValue.textColor = grayTextColor
        
        self.lblTotalAmountTitle.font = UIFont.appRegularFontName(size: fontSize14)
        self.lblTotalAmountTitle.text = getLocalizationString(key: "TotalAmount")
        self.lblTotalAmountTitle.textColor = grayTextColor
        
        self.lblTotalAmountValue.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblTotalAmountValue.textColor = grayTextColor
        
        self.lblBillingAddressTitle.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblBillingAddressTitle.text = getLocalizationString(key: "BillingAddress")
        self.lblBillingAddressTitle.textColor = secondaryColor
        
        self.lblBillingAddressDetails.font = UIFont.appLightFontName(size: fontSize12)
        self.lblBillingAddressDetails.textColor = grayTextColor
        
        self.lblBillingAddressName.font = UIFont.appLightFontName(size: fontSize12)
        self.lblBillingAddressName.textColor = grayTextColor
        
        self.lblBillingAddressPhone.font = UIFont.appLightFontName(size: fontSize12)
        self.lblBillingAddressPhone.textColor = grayTextColor
        
        self.lblBillingAddressEmail.font = UIFont.appLightFontName(size: fontSize12)
        self.lblBillingAddressEmail.textColor = grayTextColor
        
        
        self.lblShippingAddressTitle.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblShippingAddressTitle.text = getLocalizationString(key: "ShippingAddress")
        self.lblShippingAddressTitle.textColor = secondaryColor
        
        self.lblShippingAddressDetails.font = UIFont.appLightFontName(size: fontSize12)
        self.lblShippingAddressDetails.textColor = grayTextColor
        
        self.lblShippingAddressName.font = UIFont.appLightFontName(size: fontSize12)
        self.lblShippingAddressName.textColor = grayTextColor
        
        self.lblShippingAddressPhone.font = UIFont.appLightFontName(size: fontSize12)
        self.lblShippingAddressPhone.textColor = grayTextColor
        
        self.lblShippingAddressEmail.font = UIFont.appLightFontName(size: fontSize12)
        self.lblShippingAddressEmail.textColor = grayTextColor
        
        
        imgBillingAddressDetails.tintColor = grayTextColor
        imgBillingAddressName.tintColor = grayTextColor
        imgBillingAddressPhone.tintColor = grayTextColor
        imgBillingAddressEmail.tintColor = grayTextColor
        
        imgShippingAddressDetails.tintColor = grayTextColor
        imgShippingAddressName.tintColor = grayTextColor
        imgShippingAddressPhone.tintColor = grayTextColor
        imgShippingAddressEmail.tintColor = grayTextColor
        
        
        vwOrderDetails.backgroundColor = secondaryColor
        
        vwPaymentDetails.layer.borderColor = UIColor.hexToColor(hex: "#E3E4E6").cgColor
        vwPaymentDetails.layer.borderWidth = 0.5
        vwPaymentDetails.layer.cornerRadius = 5
        
        vwBillingAddress.layer.borderColor = UIColor.hexToColor(hex: "#E3E4E6").cgColor
        vwBillingAddress.layer.borderWidth = 0.5
        vwBillingAddress.layer.cornerRadius = 5
        
        vwShippingAddress.layer.borderColor = UIColor.hexToColor(hex: "#E3E4E6").cgColor
        vwShippingAddress.layer.borderWidth = 0.5
        vwShippingAddress.layer.cornerRadius = 5
        
        btnCancelOrder.setTitle(getLocalizationString(key: "CancelOrder"), for: .normal)
        btnCancelOrder.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnCancelOrder.backgroundColor = secondaryColor
        btnCancelOrder.setTitleColor(.white, for: .normal)
        btnCancelOrder.layer.cornerRadius = btnCancelOrder.frame.size.height/2
        
        if isRTL {
            btnTrackingDetail.contentHorizontalAlignment = .right
        }
    }
    
    func registerDatasourceCell()  {
        
        tblItems.tableFooterView = UIView(frame: .zero)
        
        tblItems.delegate = self
        tblItems.dataSource = self
        tblItems.register(UINib(nibName: "OrdersItemCell", bundle: nil), forCellReuseIdentifier: "OrdersItemCell")
        tblItems.reloadData()
        
        DispatchQueue.main.async {
            self.tblviewHeightConstraint.constant = self.tblItems.contentSize.height
        }
        
    }
    
    // MARK: - set Order Details
    func setOrderData() {
        
        self.lblOrderIdValue.text = "#" + orderDetail!["id"].stringValue
        self.lblOrderStatus.text = orderDetail!["status"].string?.uppercased()
        
        var strOrderDate = ""
        let orderDate = convertStringToDate(strDate: orderDetail!["date_created_gmt"].string!, formatter: "")
        if orderDate != nil {
            strOrderDate = convertDateToString(date: orderDate!, formatter: "MMM dd, yyyy")
        }
        
        self.lblOrderMessage.text = getLocalizationString(key: "Order" ) + " #" + orderDetail!["id"].stringValue + " " + getLocalizationString(key: "WasPlaced") + " " + strOrderDate + " " + getLocalizationString(key: "AndCurrently") + " "  + orderDetail!["status"].string!.camelCase()
        
        var subTotal : Double = 0.00
        if let arrItems = orderDetail!["line_items"].array {
            var strProductName = ""
            for item in arrItems {
                let strItem = item["name"].stringValue
                if arrItems.first == item {
                    strProductName = String(format: "%@", strItem)
                } else {
                    strProductName = String(format: "%@ & %@", strProductName , strItem)
                }
                
                subTotal = subTotal + Double(item["total"].floatValue).roundToDecimal()
            }
        }
        
        self.lblPaymentMethodValue.text = orderDetail!["payment_method_title"].string
        
        self.lblSubTotalValue.text = strCurrencySymbol + " " + String(format: "%.*f",decimalPoints ,subTotal)
        self.lblShippingValue.text = strCurrencySymbol + " " + orderDetail!["shipping_total"].string!
        self.lblTotalAmountValue.text =  strCurrencySymbol + " " + orderDetail!["total"].string!
        
        //Tracking details
        if isOrderTrackingActive == true &&  orderDetail!["order_tracking_data"].arrayValue.count > 0 {
            
            for trackDetail in orderDetail!["order_tracking_data"].arrayValue {
                self.lblTrackingMessage.text = trackDetail["track_message_1"].stringValue
                self.btnTrackingDetail.setTitle(getLocalizationString(key: "TrackingNumberIs") + " " + trackDetail["track_message_2"].stringValue, for: .normal)
                if trackDetail["use_track_button"].bool == true {
                    trackUrl = trackDetail["order_tracking_link"].stringValue
                }
                trackingTopConstraint.constant = 0
            }
            
        } else {
            trackingTopConstraint.constant = -16
            self.lblTrackingMessage.text = ""
            self.btnTrackingDetail.setTitle("", for: .normal)
        }
        
        
        //Billing address
        
        self.lblBillingAddressDetails.text = orderDetail!["billing"]["address_1"].string! + " " + orderDetail!["billing"]["address_2"].string! + "," + orderDetail!["billing"]["city"].string! + " " + orderDetail!["billing"]["postcode"].string!
        self.lblBillingAddressName.text = orderDetail!["billing"]["first_name"].string! + " " + orderDetail!["billing"]["last_name"].string!
        self.lblBillingAddressPhone.text = orderDetail!["billing"]["phone"].string!
        self.lblBillingAddressEmail.text = orderDetail!["billing"]["email"].string!
        
        
        //Shiipping address
        
        self.lblShippingAddressDetails.text = orderDetail!["shipping"]["address_1"].string! + " " + orderDetail!["shipping"]["address_2"].string! + "" + orderDetail!["shipping"]["city"].string! + " " + orderDetail!["shipping"]["postcode"].string!
        self.lblShippingAddressName.text = orderDetail!["shipping"]["first_name"].string! + " " + orderDetail!["shipping"]["last_name"].string!
        
        if let shippingPhone = orderDetail!["billing"]["phone"].string {
            self.lblShippingAddressPhone.text = shippingPhone
        } else {
            self.lblShippingAddressPhone.text = "-"
        }
        
        if let shippingEmail = orderDetail!["billing"]["email"].string {
            self.lblShippingAddressEmail.text = shippingEmail
        } else {
            self.lblShippingAddressEmail.text = "-"
        }
        
        if orderDetail!["status"].string == "any" {
            self.vwOrderStatus.backgroundColor = .systemGreen
        } else if orderDetail!["status"].string == "pending" {
            self.vwOrderStatus.backgroundColor = .systemGreen
        } else if orderDetail!["status"].string == "processing" {
            self.vwOrderStatus.backgroundColor = .systemGreen
        }  else if orderDetail!["status"].string == "on-hold" {
            self.vwOrderStatus.backgroundColor = .systemGreen
        } else if orderDetail!["status"].string == "completed" {

            self.vwOrderStatus.backgroundColor = .systemGreen
        } else if orderDetail!["status"].string == "cancelled" {
            self.vwOrderStatus.backgroundColor = .red
        } else if orderDetail!["status"].string == "refunded" {
            self.vwOrderStatus.backgroundColor = .red
        } else if orderDetail!["status"].string == "failed" {
            self.vwOrderStatus.backgroundColor = .red
        } else if orderDetail!["status"].string == "shipping" {
            self.vwOrderStatus.backgroundColor = .systemGreen
        }
        
        if orderDetail!["status"].string == "pending" || orderDetail!["status"].string == "on-hold" {
            self.btnCancelOrder.alpha = 1
        } else {
            self.btnCancelOrder.alpha = 0.3
            self.btnCancelOrder.removeTarget(self, action: nil, for: .touchUpInside)
        }
    }
    
    // MARK: - API Calling
    func cancelOrder() {
        showLoader()
        
        var params = [AnyHashable : Any]()
        params["order"] = orderDetail!["id"].stringValue
        
        CiyaShopAPISecurity.cancelOrder(params) { (success, message, responseData) in
            
            hideLoader()
            
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["result"] == "fail" {
                    if let message = jsonReponse["message"].string {
                        showCustomAlert(title: APP_NAME,message: message, vc: self)
                    }
                } else {
                    if (self.orderDelegate != nil) {
                        self.orderDelegate?.updateMyOrders()
                    }
                    self.navigationController?.popViewController(animated: true, completion: {
                        showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "OrderCancelledSuccess"), vc: self)
                    })
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
    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnTrackDeliveryClicked(_ sender: Any) {
        openUrl(strUrl: trackUrl)
    }
    
    @IBAction func btnCancelOrderClicked(_ sender: Any) {
        cancelOrder()
    }
}


extension OrderDetailsVC : UITableViewDelegate,UITableViewDataSource {
    
    //MARK : - Tableview delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return orderDetail!["line_items"].arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // For tableCell Estimated Height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersItemCell", for: indexPath) as! OrdersItemCell
        cell.setupData(item: orderDetail!["line_items"].arrayValue[indexPath.row])
        cell.layoutIfNeeded()
        return cell
    }
    
}
