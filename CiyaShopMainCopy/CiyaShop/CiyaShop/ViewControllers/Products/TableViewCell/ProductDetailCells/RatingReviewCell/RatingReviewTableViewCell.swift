//
//  RatingReviewTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 14/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import CiyaShopSecurityFramework

class RatingReviewTableViewCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var tblReview: UITableView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotalRating: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var vwRating: CosmosView!

    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!

    @IBOutlet weak var lbl1Count: UILabel!
    @IBOutlet weak var lbl2Count: UILabel!
    @IBOutlet weak var lbl3Count: UILabel!
    @IBOutlet weak var lbl4Count: UILabel!
    @IBOutlet weak var lbl5Count: UILabel!
    
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var slider4: UISlider!
    @IBOutlet weak var slider5: UISlider!

    @IBOutlet weak var btnRateAndReview: UIButton!
    @IBOutlet weak var HeightBtnRateAndReviewconstraint:  NSLayoutConstraint!

    @IBOutlet weak var HeightReviewTableconstraint:  NSLayoutConstraint!
    @IBOutlet weak var HeightViewAllReviewconstraint:  NSLayoutConstraint!

    @IBOutlet weak var btnViewAllReview: UIButton!
    @IBOutlet weak var vwAllReview: UIView!

    
    //MARK:- Variables
    var dictDetails = JSON()
    var arrayReviews : [JSON] = []
    
    var OneReviewCount = 0
    var TwoReviewCount = 0
    var ThreeReviewCount = 0
    var FourReviewCount = 0
    var FiveReviewCount = 0
    
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
        registerDatasourceCell()
        //--
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwContent.cornerRadius(radius: 5)
        
        //---
        lblTitle.font = UIFont.appBoldFontName(size: fontSize14)
        lblTitle.textColor = secondaryColor
        
        //--
      
        
        //---
        [lbl1,lbl2,lbl3,lbl4,lbl5].forEach { (label) in
            label?.font = UIFont.appBoldFontName(size: fontSize12)
            label?.textColor = normalTextColor
        }
        //--
        [lbl1Count,lbl2Count,lbl3Count,lbl4Count,lbl5Count].forEach { (label) in
            label?.font = UIFont.appRegularFontName(size: fontSize12)
            label?.textColor = normalTextColor
        }
        
        //--
        
        [slider1,slider2,slider3,slider4,slider5].forEach { (slider) in
            slider?.setThumbImage(UIImage(), for: .normal)
            slider?.maximumTrackTintColor = UIColor.lightGray
            slider?.isUserInteractionEnabled = false
        }
        
        slider1.minimumTrackTintColor = .red
        slider2.minimumTrackTintColor = .orange
        slider3.minimumTrackTintColor = UIColor.hexToColor(hex: "009900")
        slider4.minimumTrackTintColor = UIColor.hexToColor(hex: "009900")
        slider5.minimumTrackTintColor = UIColor.hexToColor(hex: "009900")
        
        
        
        //--
        [btnRateAndReview].forEach { (button) in
            button?.titleLabel?.font = UIFont.appRegularFontName(size: fontSize14)
            button?.layer.cornerRadius = (button?.frame.size.height)! / 2
            button?.setTitleColor(.white, for: .normal)
        }
        btnRateAndReview.backgroundColor = secondaryColor
       
        
        //--
        btnViewAllReview.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
        btnViewAllReview.setTitleColor(secondaryColor, for: .normal)
        
        //---
       
        tblReview.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblReview.tableFooterView = UIView()
        tblReview.reloadData()

        if isRTL
        {
            btnViewAllReview.contentHorizontalAlignment = .right // There is no left
        }
        
    }
    func HideShowViewRatingButton()
    {
        if(arrayReviews.count>3)
        {
            vwAllReview.isHidden = false
            HeightViewAllReviewconstraint.constant = 50
        }else{
            HeightViewAllReviewconstraint.constant = 0
            vwAllReview.isHidden = true
        }
    }
    func setUpData()
    {
        lblTitle.text = getLocalizationString(key: "RatingsNReviews")

        
        btnRateAndReview.isHidden = !dictDetails["reviews_allowed"].boolValue
        
        if dictDetails["reviews_allowed"].boolValue
        {
            HeightBtnRateAndReviewconstraint.constant = 36
        }else{
            HeightBtnRateAndReviewconstraint.constant = 0

        }
        
        //---
        let avgRating = String(format:"%.2f", dictDetails["average_rating"].doubleValue)
        lblTotalRating.attributedText = lblTotalRating.setUpMultiUILabel(color1: normalTextColor, color2: grayTextColor, str1: "\(avgRating)", str2: "/5",font1: UIFont.appBoldFontName(size: fontSize18),font2: UIFont.appRegularFontName(size: fontSize14))
            //--
        
        //--
        let rateValue = dictDetails["average_rating"].doubleValue
        vwRating.rating = rateValue
        
        //--

        
        
        
        //--
        btnRateAndReview.setTitle(getLocalizationString(key: "RateNWriteReview"), for: .normal)
        btnViewAllReview.setTitle(getLocalizationString(key: "ViewAllReviews"), for: .normal)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let obj = object as? UITableView {
            if obj == self.tblReview && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    print("newSize Review contentsize - ",newSize)

                    HeightReviewTableconstraint.constant = tblReview.contentSize.height
                    self.contentView.layoutIfNeeded()
                    self.contentView.layoutSubviews()
                }
            }
        }
    }
    func setProgressColor(value:Int,slider:UISlider)
    {
        
        slider.value = Float(value)
    }
    func setProgressValue()
    {
        [slider1,slider2,slider3,slider4,slider5].forEach { (slider) in
            slider?.maximumValue = Float(arrayReviews.count)
            
        }
        
        lbl1Count.text = "\(OneReviewCount)"
        lbl2Count.text = "\(TwoReviewCount)"
        lbl3Count.text = "\(ThreeReviewCount)"
        lbl4Count.text = "\(FourReviewCount)"
        lbl5Count.text = "\(FiveReviewCount)"

        setProgressColor(value: OneReviewCount, slider: slider1)
        setProgressColor(value: TwoReviewCount, slider: slider2)
        setProgressColor(value: ThreeReviewCount, slider: slider3)
        setProgressColor(value: FourReviewCount, slider: slider4)
        setProgressColor(value: FiveReviewCount, slider: slider5)
    }
    // MARK: - Cell Register
    func registerDatasourceCell()
    {
        
        tblReview.delegate = self
        tblReview.dataSource = self
        
        tblReview.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//MARK:-  UITableview Delegate Datasource
extension RatingReviewTableViewCell : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(arrayReviews.count>3)
        {
            return 3
        }
        return arrayReviews.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        
        let dict = arrayReviews[indexPath.row]
        
        cell.setUpReviewData(dict:dict)
        
        return cell
    }
    
}


//MARK:- Button action
extension RatingReviewTableViewCell
{
    @IBAction func btnRateAndReviewClicked(_ sender : UIButton)
    {
        let vc = ProductRatingReviewVC(nibName: "ProductRatingReviewVC", bundle: nil)
        vc.dictDetails = dictDetails
        self.parentContainerViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnViewAllReviewsClicked(_ sender : UIButton)
    {
        let vc = ViewAllReviewsVC(nibName: "ViewAllReviewsVC", bundle: nil)
        vc.arrayReviews = arrayReviews
        self.parentContainerViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:- SetUp API Data
extension RatingReviewTableViewCell
{
    func setUpAPIData(arrayReviewsLocal:[JSON],oneCount:Int,twoCount:Int,threeCount:Int,fourCount:Int,fiveCount:Int)
    {
        
        OneReviewCount = oneCount
        TwoReviewCount = twoCount
        ThreeReviewCount = threeCount
        FourReviewCount = fourCount
        FiveReviewCount = fiveCount
        
        print("counts - ",OneReviewCount)
        print("counts - ",TwoReviewCount)
        print("counts - ",ThreeReviewCount)
        print("counts - ",FourReviewCount)
        print("counts - ",FiveReviewCount)

        arrayReviews = arrayReviewsLocal
        setProgressValue()
        HideShowViewRatingButton()
        tblReview.reloadData()
    }
}


