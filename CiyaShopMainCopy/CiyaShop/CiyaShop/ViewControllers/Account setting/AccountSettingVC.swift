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

class AccountSettingVC: UIViewController,UITextFieldDelegate,WWCalendarTimeSelectorProtocol{
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwFirstName: UIView!
    @IBOutlet weak var txtFirstName: FloatingTextField!
    
    @IBOutlet weak var vwLastName: UIView!
    @IBOutlet weak var txtLastName: FloatingTextField!
    
    @IBOutlet weak var vwDateofBirth: UIView!
    @IBOutlet weak var txtDateofBirth: FloatingTextField!
    
    @IBOutlet weak var vwGender: UIView!
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var vwFemale: UIView!
    @IBOutlet weak var vwMale: UIView!
    
    @IBOutlet weak var vwFemaleChecked: UIView!
    @IBOutlet weak var vwMaleChecked: UIView!
    
    @IBOutlet weak var btnSave: UIButton!

    @IBOutlet weak var vwMobileNumber: UIView!
    @IBOutlet weak var txtMobileNumber: FloatingTextField!
    
    @IBOutlet weak var vwEmailId: UIView!
    @IBOutlet weak var txtEmailId: FloatingTextField!

    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnDeactivateAccount: UIButton!
    
    @IBOutlet weak var imgChangePasswordArrow: UIImageView!
    @IBOutlet weak var imgDeactivateAccountArrow: UIImageView!
    
    @IBOutlet weak var imgSelectedFemale: UIImageView!
    @IBOutlet weak var imgSelectedMale: UIImageView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    //MARK: - Variables
    
    var strDob = ""
    var strGender = ""
    
    var selectedDate = Date()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColors()
        initializeData()
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
    
        lblTitle.text = getLocalizationString(key: "AccountSetting")
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
        
        lblGender.text = getLocalizationString(key: "Gender")
        lblGender.font = UIFont.appRegularFontName(size: fontSize14)
        lblGender.textColor = secondaryColor
        
        vwFirstName.backgroundColor = textFieldBackgroundColor//primaryColor
        vwFirstName.layer.borderWidth = 0.5
        vwFirstName.layer.borderColor = secondaryColor.cgColor
        txtFirstName.textColor = secondaryColor
        txtFirstName.font = UIFont.appRegularFontName(size: fontSize14)
        txtFirstName.placeholder = getLocalizationString(key: "FirstName")
        txtFirstName.keyboardType = .default
        
        vwLastName.backgroundColor = textFieldBackgroundColor//primaryColor
        vwLastName.layer.borderWidth = 0.5
        vwLastName.layer.borderColor = secondaryColor.cgColor
        txtLastName.textColor = secondaryColor
        txtLastName.font = UIFont.appRegularFontName(size: fontSize14)
        txtLastName.placeholder = getLocalizationString(key: "LastName")
        txtLastName.keyboardType = .default
        
        vwDateofBirth.backgroundColor = textFieldBackgroundColor//primaryColor
        vwDateofBirth.layer.borderWidth = 0.5
        vwDateofBirth.layer.borderColor = secondaryColor.cgColor
        txtDateofBirth.textColor = secondaryColor
        txtDateofBirth.font = UIFont.appRegularFontName(size: fontSize14)
        txtDateofBirth.placeholder = getLocalizationString(key: "DateofBirth")
        txtDateofBirth.keyboardType = .numberPad
        txtDateofBirth.delegate = self
        
        vwGender.backgroundColor = textFieldBackgroundColor//primaryColor
        vwGender.layer.borderWidth = 0.5
        vwGender.layer.borderColor = secondaryColor.cgColor
     
        vwMobileNumber.backgroundColor = textFieldBackgroundColor//primaryColor
        vwMobileNumber.layer.borderWidth = 0.5
        vwMobileNumber.layer.borderColor = secondaryColor.cgColor
        txtMobileNumber.textColor = secondaryColor
        txtMobileNumber.font = UIFont.appRegularFontName(size: fontSize14)
        txtMobileNumber.placeholder = getLocalizationString(key: "MobileNumber")
        txtMobileNumber.keyboardType = .phonePad
        
        vwEmailId.backgroundColor = textFieldBackgroundColor//primaryColor
        vwEmailId.layer.borderWidth = 0.5
        vwEmailId.layer.borderColor = secondaryColor.cgColor
        txtEmailId.textColor = secondaryColor
        txtEmailId.font = UIFont.appRegularFontName(size: fontSize14)
        txtEmailId.placeholder = getLocalizationString(key: "EmailID")
        txtEmailId.keyboardType = .emailAddress
    
        btnChangePassword.setTitle(getLocalizationString(key: "ChangePassword"), for: .normal)
        btnChangePassword.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnChangePassword.backgroundColor = .clear
        btnChangePassword.tintColor = secondaryColor
        btnChangePassword.setTitleColor(secondaryColor, for: .normal)
        
        btnDeactivateAccount.setTitle(getLocalizationString(key: "DeactivateAccount"), for: .normal)
        btnDeactivateAccount.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnDeactivateAccount.backgroundColor = .clear
        btnDeactivateAccount.tintColor = secondaryColor
        btnDeactivateAccount.setTitleColor(secondaryColor, for: .normal)
        
        btnBack.tintColor =  secondaryColor
        
        btnSave.setTitle(getLocalizationString(key: "Save"), for: .normal)
        btnSave.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnSave.backgroundColor = secondaryColor
        btnSave.layer.cornerRadius = btnSave.frame.size.height/2
        
        imgChangePasswordArrow.tintColor =  secondaryColor
        imgDeactivateAccountArrow.tintColor =  secondaryColor
        
        imgSelectedFemale.tintColor =  primaryColor
        imgSelectedMale.tintColor =  primaryColor
        
        if isRTL {
            btnChangePassword.contentHorizontalAlignment = .right
            btnDeactivateAccount.contentHorizontalAlignment = .right
        }
    }
    
    func setGender(isFemale : Bool) {
        if isFemale {
            self.vwFemale.backgroundColor = .clear
            self.vwFemaleChecked.isHidden = false
            self.vwMale.backgroundColor =  secondaryColor
            self.vwMaleChecked.isHidden = true
            strGender = "Female"
        } else {
            self.vwMale.backgroundColor = .clear
            self.vwMaleChecked.isHidden = false
            self.vwFemale.backgroundColor =  secondaryColor
            self.vwFemaleChecked.isHidden = true
            strGender = "Male"
        }
        
    }
    
    func initializeData() {
        
        setGender(isFemale: true)
        
        if dictLoginData.count > 0 {
            txtFirstName.text = dictLoginData["first_name"].string!
            txtLastName.text = dictLoginData["last_name"].string!
            txtEmailId.text = dictLoginData["email"].string!
            
            if dictLoginData["meta_data"].exists() {
                
                var strDob = ""
                var strGender = ""
                
                for item in dictLoginData["meta_data"].array! {
                    if item["key"] == "mobile" {
                        txtMobileNumber.text = item["value"].string!
                    } else if item["key"] == "dob" {
                        strDob = item["value"].string!
                        if strDob != "" {
                            selectedDate = convertStringToDate(strDate: strDob, formatter: "MM/dd/yyyy")!
                            txtDateofBirth.text = convertDateToString(date: selectedDate, formatter: "MM/dd/yyyy")
                        }
                        
                    } else if item["key"] == "gender" {
                        strGender = item["value"].string!
                        if strGender.lowercased() == "male" {
                            setGender(isFemale: false)
                        } else {
                            setGender(isFemale: true)
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - API Calling
    
    func updateUserInfo() {
        showLoader()
        var params = dictLoginData.dictionaryObject
        
        params!["user_id"] = getValueFromLocal(key: USERID_KEY)
        params!["first_name"] = txtFirstName.text
        params!["last_name"] = txtLastName.text
        params!["dob"] = txtDateofBirth.text
        params!["mobile"] = txtMobileNumber.text
        params!["gender"] = strGender

        
        CiyaShopAPISecurity.updateCustomer(params) { (success, message, responseData) in
            hideLoader()
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse["status"] == "success" {
                    dictLoginData = jsonReponse
                    showCustomAlert(title: APP_NAME, message: getLocalizationString(key: "InformationUpdatedSuccess"), vc: self)
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
    
    // MARK: - TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDateofBirth {
            showDatePicker()
            return false
        }
        return true
    }
    
    func showDatePicker() {
        let datePicker = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        datePicker.delegate = self
        datePicker.optionButtonShowCancel = true
        datePicker.optionTintColor = secondaryColor
        datePicker.optionCurrentDate = selectedDate
        datePicker.optionStyles.showDateMonth(true)
        datePicker.optionStyles.showMonth(false)
        datePicker.optionStyles.showYear(true)
        datePicker.optionStyles.showTime(false)
        
        present(datePicker, animated: true, completion: nil)
        
    }
    
    // MARK: - WWCalendarTimeSelector delegate
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        selectedDate = date
        txtDateofBirth.text =  convertDateToString(date: selectedDate, formatter: "MM/dd/yyyy")

    }
    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSaveClicked(_ sender: Any) {
        updateUserInfo()
    }
    
    @IBAction func btnFemaleClicked(_ sender: Any) {
        setGender(isFemale: true)
    }
    
    @IBAction func btnMaleClicked(_ sender: Any) {
        setGender(isFemale: false)
    }
    
    @IBAction func btnChangePasswordClicked(_ sender: Any) {
        let changePasswordVC = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    @IBAction func btnDeactivateAccountClicked(_ sender: Any) {
        let deactivateAccountVC = DeactivateAccountVC(nibName: "DeactivateAccountVC", bundle: nil)
        self.navigationController?.pushViewController(deactivateAccountVC, animated: true)
    }
    
    
}
