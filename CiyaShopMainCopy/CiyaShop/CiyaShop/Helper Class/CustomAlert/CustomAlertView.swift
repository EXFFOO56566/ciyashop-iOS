//
//  CustomAlertVC.swift
//  CiyaShop
//
//  Created by Apple on 20/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias onConfirmBlock = () -> Void


class CustomAlertView: UIView {
    
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    @IBOutlet weak var vwConfirmation: UIStackView!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    var onConfirm : onConfirmBlock?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        setThemeColors()
    }
    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.backgroundColor = .clear
        
        self.lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        self.lblTitle.textColor = grayTextColor //secondaryColor
        
        self.lblDescription.font = UIFont.appLightFontName(size: fontSize12)
        self.lblDescription.textColor = grayTextColor //secondaryColor
        
        btnCancel.tintColor = .white
        btnCancel.setTitle(getLocalizationString(key: "OK").uppercased(), for: .normal)
        btnCancel.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnCancel.setTitleColor(.white, for: .normal)
        btnCancel.backgroundColor = secondaryColor
        
        btnYes.tintColor = .white
        btnYes.setTitle(getLocalizationString(key: "Yes").uppercased(), for: .normal)
        btnYes.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnYes.setTitleColor(.white, for: .normal)
        btnYes.backgroundColor = secondaryColor
        
        btnNo.tintColor = .white
        btnNo.setTitle(getLocalizationString(key: "No").uppercased(), for: .normal)
        btnNo.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        btnNo.setTitleColor(.white, for: .normal)
        btnNo.backgroundColor = secondaryColor
        
       
    }
    
    // MARK: - Button Clicked
    @IBAction func btnCancelClicked(_ sender: Any) {
        hideView()
        if onConfirm != nil {
            onConfirm!()
        }
    }
    
    
    @IBAction func btnNoClicked(_ sender: Any) {
        hideView()
    }
    
    
    @IBAction func btnYesClicked(_ sender: Any) {
        hideView()
        onConfirm!()
    }
    
    //  MARK: - on Tap gesture
    
    @objc func hideView() {
        self.transform = .identity
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (animated) in
            self.removeFromSuperview()
        }
        
        
    }
    
}

