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



class RecentViewedProductCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var cvRecentViewedProducts: UICollectionView!
    
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var lblSmallTitle: UILabel!
    @IBOutlet weak var lblBigTitle: UILabel!
    
    
    //MARK:- variables
    
    var arrProducts : Array<JSON>!
    var cellHeight : CGFloat = 130
    var timer = Timer()
    
    
    var viewAllButtonAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    // MARK: - Configuration
    private func setupCollectionView() {
        
        setupCell()
        
        cvRecentViewedProducts.delegate = self
        cvRecentViewedProducts.dataSource = self
        cvRecentViewedProducts.setBackgroundColor()
        
        cvHeightConstraint.constant = (cellHeight*screenWidth/375)
        
        cvRecentViewedProducts.register(UINib(nibName: "SpecialDealProductItemCell", bundle: nil), forCellWithReuseIdentifier: "SpecialDealProductItemCell")
        
        reloadCollectionData()
        
    }
    
    func setupCell(){
        
        contentView.setBackgroundColor()
        
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
//            self.lblBigTitle.text = headerStrings[1].uppercased() + " " +  headerStrings[2].uppercased()
        } else {
            self.lblSmallTitle.text = headerStrings[0].uppercased()
            if headerStrings.count > 1 {
                self.lblBigTitle.text = headerStrings[1].uppercased()
            } else {
                self.lblBigTitle.text = ""
            }
        }
    }
    
    func reloadCollectionData() {
        self.cvRecentViewedProducts.reloadData()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        self.contentView.layoutIfNeeded()
        
            cvWidthConstraint.constant = screenWidth
            cvHeightConstraint.constant = (cellHeight*screenWidth/375)

        return  CGSize(width: screenWidth, height: (self.cvHeightConstraint.constant + 48 )*screenWidth/375)
    }
    
    
    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrProducts.count > 5 {
            return 5
        }
        return arrProducts.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialDealProductItemCell", for: indexPath) as! SpecialDealProductItemCell
        
        cell.setProductData(product: arrProducts[indexPath.row])
        
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width:  screenWidth*0.78 - 12 , height: cellHeight*screenWidth/375)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.parentContainerViewController()?.navigateToProductDetails(detailDict: arrProducts[indexPath.row])
    }
    
    
}
