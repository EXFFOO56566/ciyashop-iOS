//
//  SizeColorTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 12/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
enum collectionType
{
    case color
    case size
}

class SizeColorTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwContent: UIView!

    @IBOutlet weak var cvSizeColor: UICollectionView!

    //MARK:- Variables
    var arraySizeColor : [JSON] = []
    var selectedCollectionType = collectionType.color
    var handlerSelectedAttribute : ([JSON]) -> Void = {_ in}
    //MARK:- LifeCycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        //---
        lblTitle.textColor = secondaryColor
        lblTitle.font = UIFont.appBoldFontName(size: fontSize14)
        SetUpTitle()
        setupCollectionView()
    }
    // MARK: - Configuration
   private func setupCollectionView()
   {
       cvSizeColor.delegate = self
       cvSizeColor.dataSource = self
        
       cvSizeColor.register(UINib(nibName: "SizeColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeColorCollectionViewCell")
       
       self.cvSizeColor.reloadData()
   }
    func SetUpTitle()
    {
        if selectedCollectionType == .color
        {
             lblTitle.text = getLocalizationString(key: "Color")
        }
        else{
            lblTitle.text = getLocalizationString(key: "Size")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
// MARK: - UICollection Delegate methods

extension SizeColorTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return arraySizeColor.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeColorCollectionViewCell", for: indexPath) as! SizeColorCollectionViewCell
        
        let dict = arraySizeColor[indexPath.row]
        //print("arraySizeColor indexPath.row -",dict)
        cell.vwBack.backgroundColor = .white
        if(selectedCollectionType == .color)
        {
            //cell.SetUpColorUI()
            if(!dict["color"].stringValue.isEmpty){
                cell.vwBack.backgroundColor = UIColor.hexToColor(hex: dict["color"].stringValue)
                cell.lblName.isHidden = true
            }else{
                cell.lblName.text = dict["variation_name"].stringValue
                cell.lblName.isHidden = false
            }
            
            if(dict["isSelected"].stringValue == "1")
            {
                cell.imgSelect.isHidden = false
            }else{
                cell.imgSelect.isHidden = true
            }
            
        }
        else if(selectedCollectionType == .size)
        {
            //cell.SetUpSizeUI()
            cell.lblName.text = dict["size"].stringValue
            //cell.vwBack.backgroundColor = GetColor(stringColor: dict["color"].stringValue)
            if(dict["isSelected"].stringValue == "1")
            {
                cell.imgSelect.isHidden = false
            }else{
                cell.imgSelect.isHidden = true
            }

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 40 , height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var dictMain = arraySizeColor[indexPath.row]

        if(selectedCollectionType == .size)
        {
            if(dictMain["isSelected"].stringValue == "1")
            {
                dictMain["isSelected"].stringValue = "0"
            }
            else{
                dictMain["isSelected"].stringValue = "1"
            }
            arraySizeColor[indexPath.row] = dictMain
            print("size dict - ",dictMain)
        }else if(selectedCollectionType == .color){

            if(dictMain["isSelected"].stringValue == "1")
            {
                dictMain["isSelected"].stringValue = "0"
            }
            else{
                dictMain["isSelected"].stringValue = "1"
            }
            arraySizeColor[indexPath.row] = dictMain
            print("color dict - ",dictMain)

        }
        handlerSelectedAttribute(arraySizeColor)
        cvSizeColor.reloadData()
    }
}
