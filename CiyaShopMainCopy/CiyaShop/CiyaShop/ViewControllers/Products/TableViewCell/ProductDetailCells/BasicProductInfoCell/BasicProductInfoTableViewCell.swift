//
//  BasicProductInfoTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 13/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import AVFoundation
import AVKit

class BasicProductInfoTableViewCell: UITableViewCell
{
    //MARK:- Outlets
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var cvProductImage: UICollectionView!
    @IBOutlet weak var pcImage: UIPageControl!

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet weak var lblEarnPoints: UILabel!
    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var vwEarnPoints: UIView!

    @IBOutlet weak var btnWishList: UIButton!
    @IBOutlet weak var btnShare: UIButton!

    @IBOutlet weak var constraintHeightEarnPoints: NSLayoutConstraint!

    //MARK:- Variables
    var dictVideo = [String:JSON]()
    var arrayImages : [JSON] = []
    var dictDetails = JSON()
    
    var strPrice = ""
    var availability = false
    var onSale = false
    var strSalePrice : Float = 0.0
    var strRegularPrice : Float = 0.0
    //MARK:- Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpUI()
    }
    //MARK:- Notification register
    func RegisterNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationDataUpdate), name: NSNotification.Name(rawValue: REFRESH_BASIC_DETAILS), object: nil)

    }
    @objc func NotificationDataUpdate(_ notification : NSNotification)
    {
        let dict = JSON(notification.userInfo ?? "")
        print("Notification dict - ",dict)
        strPrice = dict["price_html"].stringValue
        availability = dict["in_stock"].boolValue
        onSale = dict["on_sale"].boolValue
        strRegularPrice = dict["regular_price"].floatValue
        strSalePrice = dict["sale_price"].floatValue
        
        arrayImages = dict["images"].arrayValue
        
        cvProductImage.reloadData()
    }
    func SetUpVariationDetails()
    {
        let priceValue = strPrice.withoutHtmlString()
        if priceValue == "" {
           self.lblPrice.text = " "
        } else {
//           self.lblPrice.setPriceForItem(strPrice)
            self.lblPrice.setPriceForProductItem(str: dictDetails["price_html"].stringValue, isOnSale: dictDetails["on_sale"].boolValue, product: dictDetails)
 
            
        }
        
        lblOffer.isHidden = !onSale
        
        //--
        if onSale{
            if strRegularPrice == strSalePrice {
                self.lblOffer.isHidden = true
            } else {
                let discount = strRegularPrice - strSalePrice
                let discountPercentage = discount * 100 / strRegularPrice
                var strDiscount = ""
                
                if fmod(discountPercentage, 1.0) == 0.0 {
                    strDiscount = String(format: "%d%% %@", Int(discountPercentage) ,getLocalizationString(key: "OFF"))
                    self.lblOffer.text = strDiscount
                } else {
                    strDiscount = String(format: "%.2f%% %@", discountPercentage ,getLocalizationString(key: "OFF"))
                    self.lblOffer.text = strDiscount
                }
                self.lblOffer.isHidden = false
            }
        }else {
            self.lblOffer.isHidden = true
        }
        
        
        //-----
        if(availability)
        {
            lblAvailability.attributedText = lblAvailability.setUpAvailabilityUI(color: greenColor, strAvailability: "" + getLocalizationString(key: "InStock"))
        }else if(availability == false)
        {
            lblAvailability.attributedText = lblAvailability.setUpAvailabilityUI(color: .red, strAvailability: getLocalizationString(key: "OutOfStock"))
        }
        
        setUpImageArray()
    }
    //MARK:- Setup UI
    func setUpUI()
    {
        // Initialization code
        setupCollectionView()
        
        pcImage.currentPageIndicatorTintColor = secondaryColor
        pcImage.tintColor = grayTextColor
        
        //--
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwContent.cornerRadius(radius: 5)
        //---
        lblProductName.font = UIFont.appBoldFontName(size: fontSize14)
        lblProductName.textColor = normalTextColor
        
        //--
        lblOffer.setUpOfferLabelUI()
        
        //---
        lblEarnPoints.font = UIFont.appBoldFontName(size: fontSize12)
        lblEarnPoints.textColor = normalTextColor
        
        vwEarnPoints.backgroundColor = secondaryColor.withAlphaComponent(0.22)

        vwEarnPoints.cornerRadius(radius: 3)
        vwEarnPoints.viewBorder(borderWidth: 1, borderColor: secondaryColor)
        //---

       
        self.btnWishList.isSelected = false
    
        self.btnWishList.setImage(UIImage(named: "wishlist-line")?.maskWithColor(color: normalTextColor), for: .normal)
        self.btnWishList.setImage(UIImage(named: "whishlist-fill")?.maskWithColor(color: secondaryColor), for: .selected)
        
        self.btnShare.setImage(UIImage(named: "share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.btnShare.tintColor = normalTextColor
        
        [btnWishList,btnShare].forEach { (button) in
            button?.backgroundColor = UIColor.white
            button?.makeRoundButton()
            button?.layer.borderWidth = 0.5
            button?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        //--
        
        //---
        
        
        if(isRTL){
            vwRating.rotateView(degrees: 180)
        }
    }
    func setUpData()
    {
        print("Basic detail dict - ",dictDetails)
        
        if checkItemExistsInWishlist(productId: dictDetails["id"].stringValue) {
            self.btnWishList.isSelected = true
        } else {
            self.btnWishList.isSelected = false
        }
        
        
        lblProductName.text = dictDetails["name"].stringValue
               
        if dictDetails["rewards_message"].stringValue.count != 0
        {
            lblEarnPoints.attributedText = dictDetails["rewards_message"].stringValue.htmlToAttributedString
            constraintHeightEarnPoints.constant = 21
            lblEarnPoints.font = UIFont.appRegularFontName(size: fontSize12)
        }else{
            constraintHeightEarnPoints.constant = 0
        }
        
        SetUpVariationDetails()

        if dictDetails["rating"].exists() {
            if dictDetails["rating"].stringValue != "" {
                self.vwRating.rating = Double(dictDetails["rating"].stringValue)!
            } else {
                self.vwRating.rating = 0
            }
        } else {
            if dictDetails["average_rating"].exists() {
                if dictDetails["average_rating"].stringValue != "" {
                    self.vwRating.rating = Double(dictDetails["average_rating"].stringValue)!
                } else {
                    self.vwRating.rating = 0
                }
            } else {
                self.vwRating.rating = 0
            }
        }
        
        
        //---
        if isWishList {
            if checkItemExistsInWishlist(productId: dictDetails["id"].stringValue) {
                self.btnWishList.isSelected = true
            } else {
                self.btnWishList.isSelected = false
            }
        } else {
            self.btnWishList.isSelected = false
            self.btnWishList.isHidden = true
        }
        //---
        
        
    }
    
    // MARK: - Configuration
    private func setupCollectionView()
    {
        cvProductImage.delegate = self
        cvProductImage.dataSource = self
         
        cvProductImage.register(UINib(nibName: "ProductImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCollectionViewCell")
    }
    // MARK: - Image data setup
    func setUpImageArray()
    {
        //arrayImages = dictDetails["images"].arrayValue
        
        if(arrayImages.count > 1)
        {
            pcImage.isHidden = false
            pcImage.numberOfPages = arrayImages.count
            
            if dictVideo.count > 0 {
                pcImage.numberOfPages = arrayImages.count + 1
            }
        }else{
            
            if dictVideo.count > 0 {
                pcImage.numberOfPages = arrayImages.count + 1
                pcImage.isHidden = false
            } else {
                pcImage.isHidden = true
            }
        }
        
        
        
        cvProductImage.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
// MARK: - UICollection Delegate methods

extension BasicProductInfoTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0 {
            if dictVideo.count > 0 {
               return 1
            }
            return 0
        } else {
            return arrayImages.count
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
            cell.btnPlayPause.addTarget(self, action: #selector(btnPlayPauseClicked(_:)), for: .touchUpInside)

            cell.setUpVideoImage(dictVideo: dictVideo)
            cell.btnPlayPause.isHidden = false
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
            cell.btnPlayPause.addTarget(self, action: #selector(btnPlayPauseClicked(_:)), for: .touchUpInside)
            
            let dict = arrayImages[indexPath.row]
            cell.dictImage = dict
            cell.setUpImageData()

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: collectionView.frame.size.width , height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.section == 0 {
            redirectVdieoPlayer()
        } else {
            
            let vc = PreviewVC(nibName: "PreviewVC", bundle: nil)
            vc.arrayImages = arrayImages
            vc.selectedImageIndex = indexPath.row
            self.parentContainerViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if dictVideo.count > 0 {
            pcImage.currentPage = indexPath.row + indexPath.section
        } else {
            pcImage.currentPage = indexPath.row
        }
        
    }
}
//MARK:- Video Player methods
extension BasicProductInfoTableViewCell : AVPlayerViewControllerDelegate
{
    
    @objc func btnPlayPauseClicked(_ sender: UIButton) {
        redirectVdieoPlayer()
    }
    
    func redirectVdieoPlayer() {
        let webviewVC = WebviewVC(nibName: "WebviewCheckoutVC", bundle: nil)
        webviewVC.url = dictVideo["url"]?.string
        self.parentContainerViewController()?.navigationController?.pushViewController(webviewVC, animated: true)
    }
    
}



