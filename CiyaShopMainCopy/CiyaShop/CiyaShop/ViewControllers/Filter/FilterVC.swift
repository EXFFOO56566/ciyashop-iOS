//
//  FilterVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 12/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework

enum FilterCellType
{
    case priceRange
    case color
    case size
    case rating
    case other
    
}

protocol FilterProductsDelegate {
    func GetFilterProducts(arrayFilters:[JSON],arrayRatings:[Int],minimumPriceValue:CGFloat,maximumPriceValue:CGFloat)
}

class FilterVC: UIViewController
{
    //MARK:- Outlets

    @IBOutlet weak var tblFilter: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnClearFilter: UIButton!

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDone: UIButton!

    //MARK:- variables
    var arrayFilterCells : [FilterCellType] = []
    var arrayFilterDataIndex : [Int] = []

    var arrayFilterData : [JSON] = []
    var categoryID = 0
    var dictFilterData = JSON()
    var minimumPriceValue : CGFloat = 0.0
    var maximumPriceValue : CGFloat = 0.0
    
    var arraySelectedFilter : [JSON] = []
    var arrSelectedRatingValue : [Int] = []
    var delegateFilter : FilterProductsDelegate?
    //MARK:- Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    //MARK:- UI setup
    func setUpUI()
    {
        
        lblHeading.textColor = secondaryColor
        lblHeading.font = UIFont.appBoldFontName(size: fontSize16)
        lblHeading.text = getLocalizationString(key: "Filter")
        
        //---
       btnClearFilter.setTitle(getLocalizationString(key: "ClearFilter"), for: .normal)
       btnClearFilter.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
       btnClearFilter.backgroundColor = secondaryColor
       btnClearFilter.layer.cornerRadius = btnClearFilter.frame.size.height / 2
       btnClearFilter.setTitleColor(UIColor.white, for: .normal)
        
        //--
        setThemeColors()
        registerDatasourceCell()
        GetFilterData()
    }
    func setThemeColors()
    {
        self.view.setBackgroundColor()
        [btnClearFilter,btnBack,btnDone].forEach { (button) in
            button?.setUpThemeButtonUI()
        }
    }
    
    // MARK: - Cell Register
    func registerDatasourceCell()
    {
        
        tblFilter.delegate = self
        tblFilter.dataSource = self
        
        tblFilter.register(UINib(nibName: "SizeColorTableViewCell", bundle: nil), forCellReuseIdentifier: "SizeColorTableViewCell")
        tblFilter.register(UINib(nibName: "PriceRangeTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceRangeTableViewCell")
        tblFilter.register(UINib(nibName: "CommonTableViewCell", bundle: nil), forCellReuseIdentifier: "CommonTableViewCell")
        

    }
    //MARK:- SteUpFilterCells
    func   SetUpFilterCells(dict:JSON)
    {
        dictFilterData = dict
        arrayFilterData = dict["filters"].arrayValue
        arrayFilterCells = []
        //---For Price range
        if dict["price_filter_status"].stringValue == kEnable
        {
            arrayFilterCells.append(.priceRange)
            arrayFilterDataIndex.append(0)
        }
        
        for i in 0..<arrayFilterData.count
        {
            
            let json = arrayFilterData[i]
            //----For color
            if(json["name"].stringValue == kColor)
            {
                arrayFilterCells.append(.color)
                arrayFilterDataIndex.append(i)
            }
            //----For size
            else if(json["name"].stringValue == kSize)
            {
                arrayFilterCells.append(.size)
                arrayFilterDataIndex.append(i)
            }
            else if(json["name"].stringValue != kSize && json["name"].stringValue != kColor && json["name"].stringValue != kRating)
            {
                arrayFilterCells.append(.other)
                arrayFilterDataIndex.append(i)
            }
            else if(json["name"].stringValue == kRating)
            {
                if json["options"].arrayValue.count > 0
                {
                    arrayFilterCells.append(.rating)
                    arrayFilterDataIndex.append(i)
                }
            }
        }
        
      
        tblFilter.reloadData()
        
    }
    
}
//MARK:-  UITableview Delegate Datasource
extension FilterVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayFilterCells.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellType = arrayFilterCells[indexPath.row]

        if cellType == .priceRange
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceRangeTableViewCell", for: indexPath) as! PriceRangeTableViewCell
            
            if(dictFilterData["price_filter"]["min_price"].exists())
            {
                cell.minPrice = CGFloat(dictFilterData["price_filter"]["min_price"].floatValue)
                cell.maxPrice = CGFloat(dictFilterData["price_filter"]["max_price"].floatValue)
                if(minimumPriceValue != 0 || maximumPriceValue != 0){
                    cell.selectedMinPrice = minimumPriceValue
                    cell.selectedMaxPrice = maximumPriceValue
                }else{
                    cell.selectedMinPrice = CGFloat(dictFilterData["price_filter"]["min_price"].floatValue)
                    cell.selectedMaxPrice = CGFloat(dictFilterData["price_filter"]["max_price"].floatValue)
                }
                
                cell.strPriceCurrencySymbol = dictFilterData["price_filter"]["currency_symbol"].stringValue

            }
            
            cell.setUpData()
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            cell.handlerSliderValue = {[weak self] minValue,maxValue in
                
                print("minValue - ",minValue)
                print("maxValue - ",maxValue)
                
                self?.minimumPriceValue = minValue
                self?.maximumPriceValue = maxValue

            }
            
            return cell
        }
        else if cellType == .color
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SizeColorTableViewCell", for: indexPath) as! SizeColorTableViewCell
            
            cell.selectedCollectionType = .color
            cell.SetUpTitle()
            var dictColor = JSON()
            let arrayColor = arrayFilterData.filter { (json) -> Bool in
                if(json["name"].stringValue == kColor){
                    dictColor = json
                    return true
                }
                return false
            }
            if arrayColor.count > 0{
                let arrayColors = arrayColor[0]["options"].arrayValue
                var arrayNewColors : [JSON] = []
                arrayColors.forEach { (json) in
                    var dict = JSON()
                    dict["variation_name"] = json["color_name"]
                    
                    if(arraySelectedFilter.contains { (checkJson) -> Bool in
                        
                        if(checkJson["name"].stringValue == kColor){
                            let strArray = checkJson["options"].arrayObject as? [String] ?? []
                            if(strArray.contains(json["color_name"].stringValue)){
                                return true
                            }
                            return false
                        }
                        return false
                        
                    }){
                        dict["isSelected"] = "1"
                    }else{
                       dict["isSelected"] = "0"
                    }
                    
                    
                    dict["color"].stringValue = json["color_code"].stringValue.replacingOccurrences(of: "#", with: "")
                    arrayNewColors.append(dict)
                }
                
                cell.arraySizeColor = arrayNewColors
            }
            cell.cvSizeColor.reloadData()
            cell.handlerSelectedAttribute = { arraySelectedAttribute in
                
                let array = arraySelectedAttribute.filter { (json) -> Bool in
                    if(json["isSelected"].stringValue == "1")
                    {
                        return true
                    }
                    return false
                }
                
                let colorArray = array.map { (json) -> String in
                    json["variation_name"].stringValue
                }
                print("dictColor id -",dictColor["id"].stringValue)
                print("dictColor name -",dictColor["name"].stringValue)
                print("color attributes -",colorArray)
                var filterJson = JSON()
                filterJson["id"] = dictColor["id"]
                filterJson["name"] = dictColor["name"]
                filterJson["options"] = JSON(colorArray)
                var index = -1
                if self.arraySelectedFilter.contains(where: { (json) -> Bool in
                    index+=1
                    if(json["name"].stringValue == kColor)
                    {
                        return true
                    }
                    return false
                }){
                    self.arraySelectedFilter[index] = filterJson
                }else{
                    self.arraySelectedFilter.append(filterJson)
                }
                print("arraySelectedFilter -",self.arraySelectedFilter)

            }
            return cell
        }
        else if cellType == .size
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SizeColorTableViewCell", for: indexPath) as! SizeColorTableViewCell
            cell.selectedCollectionType = .size
            cell.SetUpTitle()
            var dictSize = JSON()

            let arraySize = arrayFilterData.filter { (json) -> Bool in
                if(json["name"].stringValue == kSize){
                    dictSize = json
                    return true
                }
                return false
            }
            if arraySize.count > 0{
                
                let arraySizes = arraySize[0]["options"].arrayObject as? [String] ?? []
                var arrayNewSize : [JSON] = []
                
                arraySizes.forEach { (str) in
                    var dict = JSON()
                    
                    if(arraySelectedFilter.contains { (checkJson) -> Bool in
                        
                        if(checkJson["name"].stringValue == kSize){
                            let strArray = checkJson["options"].arrayObject as? [String] ?? []
                            if(strArray.contains(str)){
                                return true
                            }
                            return false
                        }
                        return false
                        
                    }){
                        dict["isSelected"] = "1"
                    }else{
                       dict["isSelected"] = "0"
                    }
                    
                    dict["size"].stringValue = str
                    arrayNewSize.append(dict)
                }
                cell.arraySizeColor = arrayNewSize
            }
            cell.handlerSelectedAttribute = { arraySelectedAttribute in
                
                let array = arraySelectedAttribute.filter { (json) -> Bool in
                    if(json["isSelected"].stringValue == "1")
                    {
                        return true
                    }
                    return false
                }
                let sizeArray = array.map { (json) -> String in
                    json["size"].stringValue
                }

                var filterJson = JSON()
                filterJson["id"] = dictSize["id"]
                filterJson["name"] = dictSize["name"]
                filterJson["options"] = JSON(sizeArray)
                var index = -1
                if self.arraySelectedFilter.contains(where: { (json) -> Bool in
                    index+=1
                    if(json["name"].stringValue == kSize)
                    {
                        return true
                    }
                    return false
                }){
                    self.arraySelectedFilter[index] = filterJson
                }else{
                    self.arraySelectedFilter.append(filterJson)
                }
                print("arraySelectedFilter -",self.arraySelectedFilter)
            }
            cell.cvSizeColor.reloadData()
            return cell
        }
        else if cellType == .rating
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCell", for: indexPath) as! CommonTableViewCell

            cell.selectedCellType = .rating
            let arrayRating = arrayFilterData.filter { (json) -> Bool in
                if(json["name"].stringValue == kRating){
                    return true
                }
                return false
            }
           // var dataArray : [Int] = []
            if arrayRating.count > 0{
                let data = arrayRating[0]["options"].arrayObject as? [Int] ?? []
               // dataArray = data
                cell.arrayData = data.map({ (value) -> String in
                    return "\(value)"
                })
                cell.arraySelect = self.arrSelectedRatingValue
            }
            if(cell.arraySelect.count > 0)
            {
                if(cell.arraySelect.count == cell.arrayData.count)
                {
                    cell.btnSelectAll.isSelected = true
                }else{
                    cell.btnSelectAll.isSelected = false
                }
                
            }else{
                cell.btnSelectAll.isSelected = false
            }
            
            cell.SetUpTypeUI()
            cell.setSelectAllTitle()
            cell.handler = {
                cell.layoutIfNeeded()
                cell.layoutSubviews()
            }
            cell.handlerSelectedRating = { arraySelected in
                
                print("filterArrayRating - ",arraySelected)
                self.arrSelectedRatingValue = arraySelected
                self.tblFilter.reloadData()
            }
            
           return cell
        }
        else if cellType == .other
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCell", for: indexPath) as! CommonTableViewCell
           cell.selectedCellType = .category
            
            var dict = arrayFilterData[arrayFilterDataIndex[indexPath.row]]
            let arrayOptions = dict["options"].arrayObject as? [String] ?? []
            var arrayLocalSelectedValues : [String] = []
            arrayOptions.forEach { (str) in
            
            if(arraySelectedFilter.contains { (checkJson) -> Bool in
                
                if(checkJson["name"].stringValue == dict["name"].stringValue){
                    let strArray = checkJson["options"].arrayObject as? [String] ?? []
                    if(strArray.contains(str)){
                        arrayLocalSelectedValues.append(str)
                        return true
                    }
                    return false
                }
                return false
            }){
                
            }
            
            }
            
            cell.arrayData = arrayOptions
            cell.arrSelectedFilters = arrayLocalSelectedValues
            if(cell.arrSelectedFilters.count > 0)
            {
                if(cell.arrSelectedFilters.count == cell.arrayData.count)
                {
                    cell.btnSelectAll.isSelected = true
                }else{
                    cell.btnSelectAll.isSelected = false
                }
                
            }else{
                cell.btnSelectAll.isSelected = false
            }
            
            cell.SetUpTypeUI()
            cell.lblTitle.text = dict["name"].stringValue
            cell.setSelectAllTitle()
            cell.handlerSelectedOptions = { arraySelected in
                
                print("arraySelected - ",arraySelected)
                dict["selectedOptions"].arrayObject = arraySelected
                self.arrayFilterData[self.arrayFilterDataIndex[indexPath.row]] = dict
                print("arrayFilterData - ",self.arrayFilterData)
                
                var filterJson = JSON()
                filterJson["id"] = dict["id"]
                filterJson["name"] = dict["name"]
                filterJson["options"] = JSON(arraySelected)
                var index = -1
                if self.arraySelectedFilter.contains(where: { (json) -> Bool in
                    index+=1
                    if(json["name"].stringValue == dict["name"].stringValue)
                    {
                        return true
                    }
                    return false
                }){
                    self.arraySelectedFilter[index] = filterJson
                }else{
                    self.arraySelectedFilter.append(filterJson)
                }
                
                
                self.tblFilter.reloadData()
            }
            
            cell.layoutIfNeeded()
            cell.layoutSubviews()
           return cell
        }
        
        return UITableViewCell()
    }
    
    
}
//MARK:- Methods
extension FilterVC
{
    func ResetFilter()
    {
        arraySelectedFilter = []
        arrSelectedRatingValue = []
        minimumPriceValue = 0
        maximumPriceValue = 0
        tblFilter.reloadData()
    }
}
//MARK:- Button Action
extension FilterVC
{
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDoneClicked(_ sender: UIButton)
    {
        print("arraySelectedFilter for filter - ",arraySelectedFilter)
        if dictFilterData["price_filter_status"].stringValue == kEnable
        {
            delegateFilter?.GetFilterProducts(arrayFilters: arraySelectedFilter, arrayRatings: arrSelectedRatingValue, minimumPriceValue: minimumPriceValue, maximumPriceValue: maximumPriceValue)
        }else{
            delegateFilter?.GetFilterProducts(arrayFilters: arraySelectedFilter, arrayRatings: arrSelectedRatingValue, minimumPriceValue: 0, maximumPriceValue: 0)

        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnClearFilterClicked(_ sender: UIButton)
    {
        ResetFilter()
    }
}
//MARK:- API calling
extension FilterVC
{
    func GetFilterData()
    {
        showLoader()
        var params = [AnyHashable : Any]()
        params["category"] = "\(categoryID)"
        
        CiyaShopAPISecurity.getAttributes(params) { (success, message, responseData) in
            let jsonReponse = JSON(responseData!)
            if success {
                print("filter data - ",jsonReponse)
                self.SetUpFilterCells(dict:jsonReponse)
                
            } else {
                if let message = jsonReponse["message"].string {
                    showCustomAlert(title: APP_NAME,message: message, vc: self)
                } else {
                    showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
                }
            }
            hideLoader()
            
        }
        
    }
    
}
