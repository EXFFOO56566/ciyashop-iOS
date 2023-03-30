//
//  PriceRangeTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 12/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RangeSeekSlider
class PriceRangeTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var vwSlider: RangeSeekSlider!

    @IBOutlet weak var lblMinimum: UILabel!
    @IBOutlet weak var lblMaximium: UILabel!

    
    //MARK:- Variables
    var handlerSliderValue : (CGFloat,CGFloat)->Void = {_,_  in}
    var minPrice : CGFloat = 0.0
    var maxPrice : CGFloat = 0.0
    var selectedMinPrice : CGFloat = 0.0
    var selectedMaxPrice : CGFloat = 0.0
    var strPriceCurrencySymbol = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwContent.backgroundColor = .white
        self.vwContent.layer.borderWidth = 0.5
        self.vwContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        //---
        lblTitle.textColor = secondaryColor
        lblTitle.font = UIFont.appBoldFontName(size: fontSize14)
        lblTitle.text = getLocalizationString(key: "PriceRange")
        //---
        [lblMinimum,lblMaximium].forEach { (label) in
            label?.font = UIFont.appRegularFontName(size: 10)
            label?.textColor = normalTextColor
        }
        
        //--
        vwSlider.delegate = self
        vwSlider.tintColor = UIColor.lightGray.withAlphaComponent(0.8)
        vwSlider.colorBetweenHandles = secondaryColor
        vwSlider.handleDiameter = 10
        vwSlider.handleColor = secondaryColor
        
        vwSlider.minDistance = 5
        vwSlider.hideLabels = true
        vwSlider.minLabelFont = UIFont.appRegularFontName(size: 10)
        vwSlider.maxLabelFont = UIFont.appRegularFontName(size: 10)
        vwSlider.minLabelColor = secondaryColor
        vwSlider.maxLabelColor = secondaryColor
        vwSlider.labelPadding = 0
        vwSlider.lineHeight = 2
        vwSlider.initialColor = secondaryColor
        
        if(isRTL)
        {
            vwSlider.rotateView(degrees: 180)
        }
        
    }
    func setUpData()
    {
        print("minPrice - ",minPrice)
        print("maxPrice - ",maxPrice)
        print("selectedMinPrice - ",selectedMinPrice)
        print("selectedMaxPrice - ",selectedMaxPrice)
        
        vwSlider.minValue = floor(minPrice)
        vwSlider.maxValue = floor(maxPrice)
        vwSlider.selectedMinValue = selectedMinPrice
        vwSlider.selectedMaxValue = selectedMaxPrice
        //---
        
        lblMinimum.text = "\(strPriceCurrencySymbol) \(Int(selectedMinPrice))"
        lblMaximium.text = "\(strPriceCurrencySymbol) \(Int(selectedMaxPrice))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//MARK:- Range slider delegate
extension PriceRangeTableViewCell : RangeSeekSliderDelegate
{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat)
    {
        print("minValue - ",Int(minValue))
        print("maxValue - ",Int(maxValue))
        
        lblMinimum.text = "\(strPriceCurrencySymbol) \(Int(minValue))"
        lblMaximium.text = "\(strPriceCurrencySymbol) \(Int(maxValue))"
        handlerSliderValue(minValue,maxValue)
    }
    
}
