//
//  VariationTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 02/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
class VariationTableViewCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var cvVariationType: UICollectionView!
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!

    @IBOutlet weak var vwVariationContent: UIView!
    
    //MARK:- variables
    var dictDetails = JSON()
    var arrayVariationData : [JSON] = []
    var arrayOptionsData : [JSON] = []
    var handlerCheckSelectedVariation : ()->Void = {}
    var attributeIndex = 0
    
    //MARK:- Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpUI()
    }

    func setUpUI()
    {
        registerCell()
        
        [lblTitle].forEach { (label) in
            label?.font = UIFont.appBoldFontName(size: fontSize14)
            label?.textColor = secondaryColor
        }
    }
    // MARK: - Configuration
    private func registerCell()
    {
        cvVariationType.delegate = self
        cvVariationType.dataSource = self
//
        cvVariationType.register(UINib(nibName: "SizeColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeColorCollectionViewCell")
        
        cvVariationType.register(UINib(nibName: "ProductImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCollectionViewCell")

    }
    //MARK:- Data set
    func setUpData()
    {
        //--
        lblTitle.text = dictDetails["name"].stringValue
//        arrayVariationData = dictDetails["new_options"].arrayValue
        constraintCollectionViewHeight.constant = 50
        cvVariationType.reloadData()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
// MARK: - UICollection Delegate methods

extension VariationTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrayOptionsData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeColorCollectionViewCell", for: indexPath) as! SizeColorCollectionViewCell
        
        cell.imgProduct.isHidden = true
        cell.lblName.isHidden = false
        
        if(arrayVariationData.count != 0)
        {
            let dict = arrayVariationData[indexPath.row]
            
            cell.lblName.text = dict["variation_name"].stringValue
            cell.lblName.textColor = secondaryColor
            cell.imgProduct.backgroundColor = .clear
            
            if(!dict["image"].stringValue.isEmpty){
                cell.imgProduct.sd_setImage(with: dict["image"].stringValue.encodeURL(), placeholderImage: UIImage(named: "placeholder"))
                cell.imgProduct.isHidden = false
                cell.lblName.isHidden = true
                cell.vwBack.backgroundColor = .clear
            }
            else if(!dict["color"].stringValue.isEmpty)
            {
                cell.lblName.isHidden = true
                cell.vwBack.backgroundColor = UIColor.hexToColor(hex:dict["color"].stringValue.replacingOccurrences(of: "#", with: "") )
            }
            else if(!dict["variation_name"].stringValue.isEmpty)
            {
                cell.lblName.text = dict["variation_name"].stringValue
                cell.vwBack.backgroundColor = .clear
            }else{
                //cell.lblName.text = arrayOptionsData[indexPath.row] as? String ?? ""
            }

        }
        else{
            cell.lblName.text = arrayOptionsData[indexPath.row].stringValue
            cell.lblName.isHidden = false
            cell.vwBack.isHidden = true
            cell.imgProduct.isHidden = false


        }
        
        if arraySelectedVariationOptions.count > 0 {
            if arrayOptionsData[indexPath.row] == arraySelectedVariationOptions[attributeIndex] {
//                cell.imgProduct.isHidden = false
                cell.imgSelect.isHidden = false
            } else {
//                cell.imgProduct.isHidden = true
                cell.imgSelect.isHidden = true
            }
        } else {
//            cell.imgProduct.isHidden = true
            cell.imgSelect.isHidden = true
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
   
        return CGSize(width: constraintCollectionViewHeight.constant , height: constraintCollectionViewHeight.constant)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(arraySelectedVariationOptions.count > 0)
        {
            arraySelectedVariationOptions[attributeIndex] = arrayOptionsData[indexPath.row]
            
            print("arraySelectedVariationOptions - ",arraySelectedVariationOptions)
            cvVariationType.reloadData()
            handlerCheckSelectedVariation()
        }
        else{
            print("arraySelectedVariationOptions - ",arraySelectedVariationOptions)

            arraySelectedVariationOptions[attributeIndex] = arrayOptionsData[indexPath.row]
            cvVariationType.reloadData()
        }
       
    }
}
