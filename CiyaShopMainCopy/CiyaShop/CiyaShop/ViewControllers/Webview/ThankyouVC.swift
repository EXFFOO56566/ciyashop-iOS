//
//  MyAddressesVC.swift
//  CiyaShop
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CiyaShopSecurityFramework
import SwiftyJSON

class ThankyouVC: UIViewController {

    
    @IBOutlet weak var lblThankyou: UILabel!
    @IBOutlet weak var lblOrderPlaced: UILabel!
    @IBOutlet weak var lblNotifyInMoments: UILabel!
    
    @IBOutlet weak var btnContinueShopping: UIButton!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setThemeColors()
        
    }
    
    func setThemeColors() {
        
        self.view.setBackgroundColor()
        
        self.lblThankyou.font = UIFont.appBoldFontName(size: fontSize30)
        self.lblThankyou.text = getLocalizationString(key: "THANKYOU")
        self.lblThankyou.textColor = secondaryColor
        
        self.lblOrderPlaced.font = UIFont.appBoldFontName(size: fontSize18)
        self.lblOrderPlaced.text = getLocalizationString(key: "OrderPlacedSuccess")
        self.lblOrderPlaced.textColor = secondaryColor
        
        self.lblNotifyInMoments.text = getLocalizationString(key: "NotifyInFewMoments")
        self.lblNotifyInMoments.textColor = secondaryColor
        self.lblNotifyInMoments.font = UIFont.appLightFontName(size: fontSize14)

        self.btnContinueShopping.setTitle(getLocalizationString(key: "ContinueShopping"), for: .normal)
        self.btnContinueShopping.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        self.btnContinueShopping.backgroundColor = secondaryColor
        self.btnContinueShopping.tintColor = primaryColor
        
    }
    
    //MARK: - Button Clicked
    
    @IBAction func btnContinueShoppingClicked(_ sender: Any) {
        
        self.navigationController?.popToRootViewController {
            tabController?.selectedIndex = 2
        }
    }
    
}

