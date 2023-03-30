//
//  CommonTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 12/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
enum CommonCellType
{
    case rating
    case category
    case brand
    case other
}

class CommonTableViewCell: UITableViewCell
{
    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var tblFilterOptions: UITableView!
    @IBOutlet weak var heightTablefilterOption: NSLayoutConstraint!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var btnExpand: UIButton!

    //MARK:- Variables
    var selectedCellType = CommonCellType.rating
    var arrayData : [String] = []
    var handler : ()->Void = {}
    var arraySelect : [Int] = []
    
    var arrSelectedFilters : [String] = []
    
    var handlerSelectedRating : ([Int])->Void = {_ in}
    var handlerSelectedOptions : ([String])->Void = {_ in}

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        //---
        lblTitle.textColor = secondaryColor
        lblTitle.font = UIFont.appBoldFontName(size: fontSize14)
        //--
        registerDatasourceCell()
        //--
        btnExpand.tintColor = grayTextColor
        btnExpand.isSelected = false
        //---
        btnSelectAll.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        btnSelectAll.setTitleColor(grayTextColor, for: .normal)
        //--
        setSelectAllTitle()
        tblFilterOptions.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        [btnSelectAll,btnExpand].forEach { (button) in
            button?.isHidden = true
        }

    }

    func SetUpTypeUI()
    {
        if selectedCellType == .category
        {
            lblTitle.text = getLocalizationString(key: "Category")
            setCategoryBrandUI()
        }else if selectedCellType == .rating
        {
            lblTitle.text = getLocalizationString(key: "Rating")
        }
        else if selectedCellType == .brand
        {
            lblTitle.text = getLocalizationString(key: "Brand")
            setCategoryBrandUI()
        }
        tblFilterOptions.reloadData()

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let obj = object as? UITableView {
            if obj == self.tblFilterOptions && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    print("newSize Review contentsize - ",newSize)

                    if selectedCellType == .rating
                    {
                            heightTablefilterOption.constant = 150
                    }
                    else{
                        heightTablefilterOption.constant = CGFloat(arrayData.count * 30)
                    }
                    self.handler()
                    self.layoutIfNeeded()
                    self.layoutSubviews()
                }
            }
        }
    }
    func setRatingUI()
    {
        btnSelectAll.isHidden = true
        btnExpand.isHidden = false
        ViewCollapseRating()
    }
    func setCategoryBrandUI()
    {
        btnSelectAll.isHidden = false
        btnExpand.isHidden = true
        
    }
    func ViewExpandRating()
    {
        heightTablefilterOption.constant = 150
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    func ViewCollapseRating()
    {
        heightTablefilterOption.constant = 0
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    func setSelectAllTitle()
    {
        if(btnSelectAll.isSelected)
        {
            btnSelectAll.setTitle(getLocalizationString(key: "UnselectAll"), for: .normal)
        }else{
            btnSelectAll.setTitle(getLocalizationString(key: "SelectAll"), for: .normal)
        }
    }
    // MARK: - Cell Register
    func registerDatasourceCell()
    {
        tblFilterOptions.delegate = self
        tblFilterOptions.dataSource = self
        
        tblFilterOptions.register(UINib(nibName: "RatingTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingTableViewCell")
        tblFilterOptions.register(UINib(nibName: "BrandCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "BrandCategoryTableViewCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
//MARK:- Button Action
extension CommonTableViewCell
{
    @IBAction func btnExpandClicked(_ sender: UIButton)
    {
        btnExpand.isSelected = !btnExpand.isSelected
        if btnExpand.isSelected
        {
            ViewExpandRating()
        }else{
            ViewCollapseRating()
        }
    }
    @objc func btnSelectClicked(_ sender: UIButton)
    {
        if(selectedCellType == .rating) {
            let strRating = arrayData[sender.tag]
            
            if(arraySelect.contains(Int(strRating) ?? 0))
            {
                arraySelect.removeAll { $0 == Int(strRating)! }
            }else{
                arraySelect.append(Int(strRating) ?? 0)
            }
            handlerSelectedRating(arraySelect)
        } else {
            let strRating = arrayData[sender.tag]
            
            if(arrSelectedFilters.contains(strRating))
            {
                arrSelectedFilters.removeAll { $0 == strRating }
            }else{
                arrSelectedFilters.append(strRating)
            }
            handlerSelectedOptions(arrSelectedFilters)
        }
        
       // tblFilterOptions.reloadData()
    }
    @IBAction func btnSelectAllClicked(_ sender: UIButton)
    {
        
        if(!sender.isSelected)
        {
            for item in arrayData {
                if(selectedCellType == .rating) {
                    let strRating = item
                    
                    if(arraySelect.contains(Int(strRating) ?? 0))
                    {
                    }else{
                        arraySelect.append(Int(strRating) ?? 0)
                    }
                } else {
                    let strRating = item
                    
                    if(arrSelectedFilters.contains(strRating))
                    {
                    }else{
                        arrSelectedFilters.append(strRating)
                    }
                }
            }
        }else{
            if(selectedCellType == .rating) {
                arraySelect.removeAll()
            }else{
                arrSelectedFilters.removeAll()
            }
            
        }
        
        if(selectedCellType == .rating) {
            handlerSelectedRating(arraySelect)
        }else{
            handlerSelectedOptions(arrSelectedFilters)
        }
        
        
       // sender.isSelected = !sender.isSelected
        tblFilterOptions.reloadData()
        setSelectAllTitle()
    }
}
// MARK: - UITableview Delegate methods
extension CommonTableViewCell: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrayData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // For tableCell Estimated Height
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if(selectedCellType == .rating)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell", for: indexPath) as! RatingTableViewCell
            cell.selectionStyle = .none
            let strRating = arrayData[indexPath.row]
            cell.vwRating.rating = Double(strRating) ?? 0
            cell.btnSelect.tag = indexPath.row
            cell.btnSelect.addTarget(self, action: #selector(btnSelectClicked(_:)), for: .touchUpInside)
            if(arraySelect.contains(Int(strRating) ?? 0))
            {
                cell.btnSelect.isSelected = true
            }else{
                cell.btnSelect.isSelected = false
            }
            
            
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCategoryTableViewCell", for: indexPath) as! BrandCategoryTableViewCell
            cell.lblName.text = arrayData[indexPath.row]
            cell.selectionStyle = .none
            let selected = arrSelectedFilters.contains(arrayData[indexPath.row])
            if selected{
                cell.lblName.textColor = secondaryColor
                cell.lblName.font = UIFont.appBoldFontName(size: fontSize12)
                cell.btnSelect.isSelected = true
            }else{
                cell.lblName.textColor = grayTextColor
                cell.lblName.font = UIFont.appRegularFontName(size: fontSize12)
                cell.btnSelect.isSelected = false
            }
            
            
            cell.btnSelect.tag = indexPath.row
            cell.btnSelect.addTarget(self, action: #selector(btnSelectClicked(_:)), for: .touchUpInside)
            return cell

        }
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(selectedCellType == .rating) {
            let strRating = arrayData[indexPath.row]
            
            if(arraySelect.contains(Int(strRating) ?? 0))
            {
                arraySelect.removeAll { $0 == Int(strRating)! }
            }else{
                arraySelect.append(Int(strRating) ?? 0)
            }
            handlerSelectedRating(arraySelect)
        } else {
            let strRating = arrayData[indexPath.row]
            
            if(arrSelectedFilters.contains(strRating))
            {
                arrSelectedFilters.removeAll { $0 == strRating }
            }else{
                arrSelectedFilters.append(strRating)
            }
            handlerSelectedOptions(arrSelectedFilters)
        }
        
    }
}
