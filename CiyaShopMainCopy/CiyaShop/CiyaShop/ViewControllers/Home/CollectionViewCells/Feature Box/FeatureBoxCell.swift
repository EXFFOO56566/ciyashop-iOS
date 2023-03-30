//
//  TopCategoriesCell.swift
//  CiyaShop
//
//  Created by Apple on 22/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class FeatureBoxCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var cvFeatureProducts: UICollectionView!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblSmallTitle: UILabel!
    @IBOutlet weak var lblBigTitle: UILabel!
        
    var arrProducts : Array<JSON>!

    //MARK:- Awake nib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    // MARK: - Configuration
    private func setupCollectionView() {
        
        setupCell()
        
        cvFeatureProducts.delegate = self
        cvFeatureProducts.dataSource = self
        cvFeatureProducts.setBackgroundColor()
        
        cvWidthConstraint.constant = screenWidth
        
        cvFeatureProducts.register(UINib(nibName: "FeatureBoxItemCell", bundle: nil), forCellWithReuseIdentifier: "FeatureBoxItemCell")
        
        DispatchQueue.main.async {
            self.cvFeatureProducts.reloadData()
        }
    }
    
    func setupCell(){

        self.contentView.setBackgroundColor()
        self.lblSmallTitle.font = UIFont.appLightFontName(size: fontSize11)
        self.lblSmallTitle.textColor = secondaryColor
        
        self.lblBigTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblBigTitle.textColor = secondaryColor
        
    }
    
    func setupCellHeader(strTitle : String){
        
        let headerStrings = strTitle.components(separatedBy: " ")
        if headerStrings.count > 2 {
            self.lblSmallTitle.text = headerStrings[0].uppercased()
            self.lblBigTitle.text = ""
            for i in 1...headerStrings.count - 1 {
                self.lblBigTitle.text = self.lblBigTitle.text! + headerStrings[i].uppercased() + " "
            }
//            self.lblBigTitle.text = headerStrings[1].uppercased() + " " + headerStrings[2].uppercased() + " " + headerStrings[3].uppercased()
        } else {
            self.lblSmallTitle.text = headerStrings[0].uppercased()
            if headerStrings.count > 1 {
                self.lblBigTitle.text = headerStrings[1].uppercased()
            } else {
                self.lblBigTitle.text = ""
            }
        }
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        
        cvWidthConstraint.constant = screenWidth
        cvHeightConstraint.constant = self.cvFeatureProducts.contentSize.height
        
        return  CGSize(width: screenWidth, height: self.cvFeatureProducts.contentSize.height + 80)
    }
    
    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureBoxItemCell", for: indexPath) as! FeatureBoxItemCell
        
        
        if let imageUrl = arrProducts[indexPath.row]["feature_image"].string {
            cell.imgFeature.sd_setImage(with: imageUrl.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                if (image == nil) {
                    cell.imgFeature.image =  UIImage(named: "noImage")
                }
            }
        } else {
            cell.imgFeature.image =  nil
        }
        
        
        
        if let featureTitle = arrProducts[indexPath.row]["feature_title"].string {
            cell.lblTitle.text = featureTitle == "" ? " " : featureTitle
        } else {
            cell.lblTitle.text = " "
        }
        
        if let featureContent = arrProducts[indexPath.row]["feature_content"].string {
            cell.lblContent.text = featureContent == "" ? " " : featureContent
        } else {
            cell.lblContent.text = " "
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:  collectionView.frame.size.width/2 - 12 , height: 120*collectionView.frame.size.width/375)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
