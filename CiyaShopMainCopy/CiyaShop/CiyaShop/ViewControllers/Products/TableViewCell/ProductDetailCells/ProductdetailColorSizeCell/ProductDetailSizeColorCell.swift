//
//  ProductDetailSizeColorCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 14/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProductDetailSizeColorCell: UITableViewCell {

    
    //MARK:- Outlets
    
    @IBOutlet weak var vwContent: UIView!

    @IBOutlet weak var lblDeliveryOption: UILabel!
    @IBOutlet weak var txtPinCode: UITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var vwPinCode: UIView!
    @IBOutlet weak var tblVariation: UITableView!

    @IBOutlet weak var vwDeliveryOption: UIView!

    @IBOutlet weak var constraintVariationTableHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintViewDeliveryHeight: NSLayoutConstraint!


    var arrayVariationData : [JSON] = []

    var handlerSelectedVariation : ()->Void = {}
    var handlerCheckPincode : (String)->Void = {_ in}

    var dictDetail = JSON()
    
    //MARK:- Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpUI()
    }
    //MARK:- Setup UI
    func setUpUI()
    {
        // Initialization code
        RegisterCell()
        //--
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwContent.cornerRadius(radius: 5)
        //---
        
        [lblDeliveryOption].forEach { (label) in
            label?.font = UIFont.appBoldFontName(size: fontSize14)
            label?.textColor = secondaryColor
        }
        //--
//        btnCheck.setTitle(getLocalizationString(key: "ClearFilter"), for: .normal)
        btnCheck.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnCheck.setTitleColor(secondaryColor, for: .normal)
        
        //--
        txtPinCode.textColor = normalTextColor
        txtPinCode.font = UIFont.appRegularFontName(size: fontSize12)
        
        //--
        vwPinCode.layer.cornerRadius = 5
        vwPinCode.layer.borderColor = grayTextColor.cgColor
        vwPinCode.layer.borderWidth = 1
        
        tblVariation.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        setUpText()
    }
    func setUpText()
    {
        lblDeliveryOption.text = getLocalizationString(key: "DeliveryOptions")
        txtPinCode.placeholder = getLocalizationString(key: "EnterYourPinCode")
        btnCheck.setTitle(getLocalizationString(key: "Check"), for: .normal)

    }
    
    func setUpData()
    {
        vwDeliveryOption.isHidden = !IS_PINCODE_ACTIVE
//        vwDeliveryOption.isHidden = false

        if vwDeliveryOption.isHidden{
            constraintViewDeliveryHeight.constant = 0
        }
        
        let arrayAttributes = dictDetail["attributes"].arrayValue
        
        arrayVariationData = arrayAttributes.filter { (json) -> Bool in
            return json["variation"].boolValue
        }
        
        tblVariation.reloadData()
        
        constraintVariationTableHeight.constant = tblVariation.contentSize.height
        self.layoutSubviews()
        self.layoutIfNeeded()
        

        
    }
    //MARK:-Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let obj = object as? UITableView {
            if obj == self.tblVariation && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    print("newSize Review contentsize - ",newSize)

                    constraintVariationTableHeight.constant = newSize.height
                    
                    self.layoutIfNeeded()
                    self.layoutSubviews()
                }
            }
        }
    }
    // MARK: - Configuration
    private func RegisterCell()
    {
        tblVariation.delegate = self
        tblVariation.dataSource = self
//
        tblVariation.register(UINib(nibName: "VariationTableViewCell", bundle: nil), forCellReuseIdentifier: "VariationTableViewCell")

    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//MARK:-  Button Actions
extension ProductDetailSizeColorCell
{
    @IBAction func btnCheckPinCodeClicked(_ sender:UIButton)
    {
        if(txtPinCode.text?.count == 0){
            self.parentContainerViewController()?.showToast(message: getLocalizationString(key: "EnterYourPinCode"))
        }else{
            handlerCheckPincode(txtPinCode.text ?? "")
        }
    }
}


//MARK:-  UITableview Delegate Datasource
extension ProductDetailSizeColorCell : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayVariationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VariationTableViewCell", for: indexPath) as! VariationTableViewCell
        cell.selectionStyle = .none
        
        let dict = arrayVariationData[indexPath.row]
        cell.dictDetails = dict
        cell.arrayVariationData = dict["new_options"].arrayValue
        cell.arrayOptionsData = dict["options"].arrayValue
        cell.attributeIndex = indexPath.row

        cell.handlerCheckSelectedVariation = {
            self.handlerSelectedVariation()
        }
        
        cell.setUpData()
        
        return cell
    }
}
