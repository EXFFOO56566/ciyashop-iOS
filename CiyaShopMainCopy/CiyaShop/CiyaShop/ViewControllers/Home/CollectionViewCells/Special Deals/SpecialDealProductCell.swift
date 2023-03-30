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



class SpecialDealProductCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var cvSpecialDealsProducts: UICollectionView!
    
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentviewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblSmallTitle: UILabel!
    @IBOutlet weak var lblBigTitle: UILabel!
    
    //Sale View
    @IBOutlet weak var lblEndOfTheSale: UILabel!
    
    @IBOutlet weak var viewHours: UIView!
    @IBOutlet weak var viewMinutes: UIView!
    @IBOutlet weak var viewSeconds: UIView!
    
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var lblSeconds: UILabel!
    
    @IBOutlet weak var lblTimerIndicator1: UILabel!
    @IBOutlet weak var lblTimerIndicator2: UILabel!
    
    @IBOutlet weak var imgTimer: UIImageView!
    
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
        
        cvSpecialDealsProducts.delegate = self
        cvSpecialDealsProducts.dataSource = self
        cvSpecialDealsProducts.setBackgroundColor()
        
        contentviewWidthConstraint.constant = screenWidth
        cvHeightConstraint.constant = (cellHeight*screenWidth/375)
        
        cvSpecialDealsProducts.register(UINib(nibName: "SpecialDealProductItemCell", bundle: nil), forCellWithReuseIdentifier: "SpecialDealProductItemCell")
        
        reloadCollectionData()
        
    }
    
    func setupCell(){
        
        contentView.setBackgroundColor()
        
        self.lblSmallTitle.font = UIFont.appLightFontName(size: fontSize11)
        self.lblSmallTitle.textColor = secondaryColor
        
        self.lblBigTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblBigTitle.textColor = secondaryColor
        
        self.lblEndOfTheSale.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblEndOfTheSale.text = getLocalizationString(key: "EndOfTheSale")
        self.lblEndOfTheSale.textColor = normalTextColor//secondaryColor
        
        self.btnViewAll.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        self.btnViewAll.backgroundColor = .clear
        self.btnViewAll.setTitle(getLocalizationString(key: "viewAll"), for: .normal)
        self.btnViewAll.setTitleColor(secondaryColor, for: .normal)
        
        self.imgTimer.tintColor = secondaryColor
        
        self.lblHours.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblHours.textColor = .white//primaryColor
        
        self.lblMinutes.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblMinutes.textColor = .white//primaryColor
        
        self.lblSeconds.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblSeconds.textColor = .white//primaryColor
        
        self.viewHours.backgroundColor = secondaryColor
        self.viewMinutes.backgroundColor = secondaryColor
        self.viewSeconds.backgroundColor = secondaryColor
        
        self.lblTimerIndicator1.font = UIFont.appBoldFontName(size: fontSize30)
        self.lblTimerIndicator1.textColor = secondaryColor
        
        self.lblTimerIndicator2.font = UIFont.appBoldFontName(size: fontSize30)
        self.lblTimerIndicator2.textColor = secondaryColor
    }
    
    func setupCellHeader(strTitle : String){
        
        let headerStrings = strTitle.components(separatedBy: " ")
        if headerStrings.count > 2 {
            self.lblSmallTitle.text = headerStrings[0].uppercased() + " " + headerStrings[1].uppercased()
            self.lblBigTitle.text = ""
            for i in 2...headerStrings.count - 1 {
                self.lblBigTitle.text = self.lblBigTitle.text! + headerStrings[i].uppercased() + " "
            }
            
        } else {
            self.lblSmallTitle.text = headerStrings[0].uppercased()
            if headerStrings.count > 1 {
                self.lblBigTitle.text = headerStrings[1].uppercased()
            } else {
                self.lblBigTitle.text = ""
            }
        }
        
        //deal details
        
        if self.timer.isValid {
            self.timer.invalidate()
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeTimerValue), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func changeTimerValue() {
        lblHours.text = String(format: "%02d", saleHours)
        lblMinutes.text = String(format: "%02d", saleMinute)
        lblSeconds.text = String(format: "%02d", saleSeconds)
    }
    
    func reloadCollectionData() {
                self.cvSpecialDealsProducts.reloadData()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        self.contentView.layoutIfNeeded()

            cvWidthConstraint.constant = screenWidth
            cvHeightConstraint.constant = (cellHeight*screenWidth/375)

         self.contentView.layoutIfNeeded()
        
        return  CGSize(width: screenWidth, height: self.cvHeightConstraint.constant + 104 + 90*screenWidth/375)
    }
    
    
    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrProducts.count > 4 {
            return 4
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
    
    //MARK: - Button Clicked
    
    @objc func btnFavouriteClicked(_ sender: Any) {
        let favouriteButton = sender as! UIButton
        let featureProduct = arrProducts[favouriteButton.tag]
        print(featureProduct)
    }
    
    @objc func btnAddtoCartClicked(_ sender: Any) {
        let cartButton = sender as! UIButton
        let product = arrProducts[cartButton.tag]
        
        onAddtoCartButtonClicked(viewcontroller: self.viewContainingController()!, product: product, collectionView: cvSpecialDealsProducts, index: cartButton.tag)
        if self.viewContainingController()! is HomeVC {
            (self.viewContainingController() as! HomeVC).updateCartBadge()
        }
    }

    @IBAction func btnViewAllClicked(_ sender: Any) {
        viewAllButtonAction?()
    }

}
