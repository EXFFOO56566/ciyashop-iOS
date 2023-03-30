//
//  LoginVC.swift
//  CiyaShop
//
//  Created by Apple on 07/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON


class AddNewAddressVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblheaderTitle: UILabel!
    
    @IBOutlet weak var vwFirstName: UIView!
    @IBOutlet weak var txtFirstName: FloatingTextField!
    
    @IBOutlet weak var vwLastName: UIView!
    @IBOutlet weak var txtLastName: FloatingTextField!
    
    @IBOutlet weak var vwPincode: UIView!
    @IBOutlet weak var txtPincode: FloatingTextField!
    
    @IBOutlet weak var vwAddress1: UIView!
    @IBOutlet weak var txtAddress1: FloatingTextField!
    
    @IBOutlet weak var vwAddress2: UIView!
    @IBOutlet weak var txtAddress2: FloatingTextField!
    
    @IBOutlet weak var vwCityTown: UIView!
    @IBOutlet weak var txtCityTown: FloatingTextField!
    
    @IBOutlet weak var vwCompany: UIView!
    @IBOutlet weak var txtCompany: FloatingTextField!
    
    @IBOutlet weak var vwPhoneNumber: UIView!
    @IBOutlet weak var txtPhoneNumber: FloatingTextField!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var vwPhoneNumberTopConstrait: NSLayoutConstraint!
    
    var isBillingAddress : Bool?
    var isEditAddress : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColors()
        if isEditAddress! == true {
            updateData()
        }
    }

    
    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
    
        lblTitle.text = getLocalizationString(key: "AddAddress")
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
        
        if isBillingAddress!  {
            lblheaderTitle.text = getLocalizationString(key: "AddBillingAddress")
        } else {
            lblheaderTitle.text = getLocalizationString(key: "AddShippingAddress")
            vwPhoneNumberTopConstrait.constant = -(self.vwPhoneNumber.frame.height + 16)
            vwPhoneNumber.isHidden = true
        }
        
        lblheaderTitle.font = UIFont.appBoldFontName(size: fontSize14)
        lblheaderTitle.textColor = secondaryColor
        
        vwFirstName.backgroundColor =  primaryColor
        vwFirstName.layer.borderWidth = 0.5
        vwFirstName.backgroundColor = textFieldBackgroundColor
        vwFirstName.layer.borderColor = secondaryColor.cgColor
        txtFirstName.textColor = secondaryColor
        txtFirstName.font = UIFont.appRegularFontName(size: fontSize14)
        txtFirstName.placeholder = getLocalizationString(key: "FirstName")
        
        vwLastName.backgroundColor =  primaryColor
        vwLastName.layer.borderWidth = 0.5
        vwLastName.layer.borderColor = secondaryColor.cgColor
        vwLastName.backgroundColor = textFieldBackgroundColor
        txtLastName.textColor = secondaryColor
        txtLastName.font = UIFont.appRegularFontName(size: fontSize14)
        txtLastName.placeholder = getLocalizationString(key: "LastName")
        
        vwPincode.backgroundColor =  primaryColor
        vwPincode.layer.borderWidth = 0.5
        vwPincode.layer.borderColor = secondaryColor.cgColor
        vwPincode.backgroundColor = textFieldBackgroundColor
        txtPincode.textColor = secondaryColor
        txtPincode.font = UIFont.appRegularFontName(size: fontSize14)
        txtPincode.placeholder = getLocalizationString(key: "Pincode")
        
        vwAddress1.backgroundColor =  primaryColor
        vwAddress1.layer.borderWidth = 0.5
        vwAddress1.layer.borderColor = secondaryColor.cgColor
        vwAddress1.backgroundColor = textFieldBackgroundColor
        txtAddress1.textColor = secondaryColor
        txtAddress1.font = UIFont.appRegularFontName(size: fontSize14)
        txtAddress1.placeholder = getLocalizationString(key: "Address1")
     
        vwAddress2.backgroundColor =  primaryColor
        vwAddress2.layer.borderWidth = 0.5
        vwAddress2.layer.borderColor = secondaryColor.cgColor
        vwAddress2.backgroundColor = textFieldBackgroundColor
        txtAddress2.textColor = secondaryColor
        txtAddress2.font = UIFont.appRegularFontName(size: fontSize14)
        txtAddress2.placeholder = getLocalizationString(key: "Address2")
        
        vwCityTown.backgroundColor =  primaryColor
        vwCityTown.layer.borderWidth = 0.5
        vwCityTown.layer.borderColor = secondaryColor.cgColor
        vwCityTown.backgroundColor = textFieldBackgroundColor
        txtCityTown.textColor = secondaryColor
        txtCityTown.font = UIFont.appRegularFontName(size: fontSize14)
        txtCityTown.placeholder = getLocalizationString(key: "CityTown")

        vwCompany.backgroundColor =  primaryColor
        vwCompany.layer.borderWidth = 0.5
        vwCompany.layer.borderColor = secondaryColor.cgColor
        vwCompany.backgroundColor = textFieldBackgroundColor
        txtCompany.textColor = secondaryColor
        txtCompany.font = UIFont.appRegularFontName(size: fontSize14)
        txtCompany.placeholder = getLocalizationString(key: "Company")
        
        vwPhoneNumber.backgroundColor =  primaryColor
        vwPhoneNumber.layer.borderWidth = 0.5
        vwPhoneNumber.layer.borderColor = secondaryColor.cgColor
        vwPhoneNumber.backgroundColor = textFieldBackgroundColor
        txtPhoneNumber.textColor = secondaryColor
        txtPhoneNumber.font = UIFont.appRegularFontName(size: fontSize14)
        txtPhoneNumber.placeholder = getLocalizationString(key: "PhoneNumber")
        
        btnCancel.setTitle(getLocalizationString(key: "Cancel"), for: .normal)
        btnCancel.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnCancel.backgroundColor = secondaryColor
        btnCancel.layer.cornerRadius = btnCancel.frame.size.height / 2
        
        btnSave.setTitle(getLocalizationString(key: "Save"), for: .normal)
        btnSave.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnSave.backgroundColor = secondaryColor
        btnSave.layer.cornerRadius = btnSave.frame.size.height / 2
        
        
        
        btnBack.tintColor =  secondaryColor
        
        view.layoutSubviews()
        view.layoutIfNeeded()
    }
    
    // MARK: - update Data
    func updateData() {
        
        if isBillingAddress!  && isEditAddress! {
            txtFirstName.text = dictLoginData["billing"]["first_name"].string!
            txtLastName.text = dictLoginData["billing"]["last_name"].string!
            txtAddress1.text = dictLoginData["billing"]["address_1"].string!
            txtAddress2.text = dictLoginData["billing"]["address_2"].string!
            txtCityTown.text = dictLoginData["billing"]["city"].string!
            txtPincode.text = dictLoginData["billing"]["postcode"].string!
            txtCompany.text = dictLoginData["billing"]["company"].string!
            txtPhoneNumber.text = dictLoginData["billing"]["phone"].string!
        }
       
        
        if !isBillingAddress!  && isEditAddress! {
            txtFirstName.text = dictLoginData["shipping"]["first_name"].string!
            txtLastName.text = dictLoginData["shipping"]["last_name"].string!
            txtAddress1.text = dictLoginData["shipping"]["address_1"].string!
            txtAddress2.text = dictLoginData["shipping"]["address_2"].string!
            txtCityTown.text = dictLoginData["shipping"]["city"].string!
            txtPincode.text = dictLoginData["shipping"]["postcode"].string!
            txtCompany.text = dictLoginData["shipping"]["company"].string!
            txtPhoneNumber.text = ""
        }
        
    }
    
    // MARK: - API Calling
    
    func updateUserAddresses() {
        showLoader()
        var params = dictLoginData.dictionaryObject
        
        params!["user_id"] = getValueFromLocal(key: USERID_KEY)
        
        var addressParams = [String : Any]()
        
        addressParams["first_name"] = txtFirstName.text
        addressParams["last_name"] = txtLastName.text
        addressParams["postcode"] = txtPincode.text
        addressParams["address_1"] = txtAddress1.text
        addressParams["address_2"] = txtAddress2.text
        addressParams["city"] = txtCityTown.text
        addressParams["company"] = txtCompany.text
        
        if isBillingAddress == true {

            addressParams["phone"] = txtPhoneNumber.text

            
            params!["billing"] = addressParams
            
        } else {

            
            params!["shipping"] = addressParams
        }
        

        
        CiyaShopAPISecurity.updateCustomer(params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    dictLoginData = jsonReponse
                    NotificationCenter.default.post(name: Notification.Name(rawValue: REFRESH_ADDRESS_DATA), object: nil)
                    self.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSaveClicked(_ sender: Any) {
        
        if(txtFirstName.text?.count == 0)
        {
            showToast(message: getLocalizationString(key: "EnterFirstName"))
            return
        }
        else if(txtLastName.text?.count == 0)
        {
            showToast(message: getLocalizationString(key: "EnterLastName"))
            return
        }
        else if(txtPincode.text?.count == 0)
        {
            showToast(message: getLocalizationString(key: "EnterPinCode"))
            return
        }
        else if(txtAddress1.text?.count == 0)
        {
            showToast(message: getLocalizationString(key: "EnterAddress1"))
            return
        }
        else if(txtAddress2.text?.count == 0)
        {
            showToast(message: getLocalizationString(key: "EnterAddress2"))
            return
        }
        else if(txtCityTown.text?.count == 0)
        {
            showToast(message: getLocalizationString(key: "EnterPhoneNumber"))
            return
        }
        else if(txtCompany.text?.count == 0)
        {
            showToast(message: getLocalizationString(key: "EnterCompany"))
            return
        }
        updateUserAddresses()
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
