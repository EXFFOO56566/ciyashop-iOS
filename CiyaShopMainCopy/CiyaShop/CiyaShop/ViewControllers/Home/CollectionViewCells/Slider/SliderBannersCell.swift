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

class SliderBannersCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var cvSliderBanner: UICollectionView!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var timer = Timer()
    var counter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
        self.contentView.setBackgroundColor()
        cvSliderBanner.setBackgroundColor()
        cvSliderBanner.delegate = self
        cvSliderBanner.dataSource = self
        
        cvWidthConstraint.constant = screenWidth
        
        cvSliderBanner.register(UINib(nibName: "SliderBannerItemCell", bundle: nil), forCellWithReuseIdentifier: "SliderBannerItemCell")
        self.cvSliderBanner.reloadData()
        
        self.pageControl.numberOfPages = arrSliders.count
        self.pageControl.pageIndicatorTintColor = primaryColor
        self.pageControl.currentPageIndicatorTintColor = secondaryColor
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        
        cvWidthConstraint.constant = screenWidth
        cvHeightConstraint.constant = 180*screenWidth/375
        
        return  CGSize(width: screenWidth, height: 180*screenWidth/375)
    }
    
    @objc func changeImage() {
        if counter < arrSliders.count {
            let index = IndexPath.init(item: counter, section: 0)
            cvSliderBanner.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            cvSliderBanner.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
    }

    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        return arrSliders.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderBannerItemCell", for: indexPath) as! SliderBannerItemCell
        
        let imageUrl = arrSliders[indexPath.row]["upload_image_url"].string
        
        DispatchQueue.global(qos: .userInitiated).async {
            cell.imgBanner.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                DispatchQueue.main.async {
                    if (image == nil) {
                        cell.imgBanner.image =  UIImage(named: "noImage")
                        
                    } else {
                        
                        cell.imgBanner.image =  image
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth , height: 180*screenWidth/375)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
        productsVC.fromCategory = true
        productsVC.categoryID = arrSliders[indexPath.row]["slider_cat_id"].intValue
        self.parentContainerViewController()?.navigationController?.pushViewController(productsVC, animated: true)
    }
}
