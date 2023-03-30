//
//  FailureVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 13/07/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class FailureVC: UIViewController {

    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblSubMessage: UILabel!
    
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
        
        
        self.lblMessage.font = UIFont.appBoldFontName(size: fontSize18)
        self.lblMessage.text = getLocalizationString(key: "OrderPlacedFailure")
        self.lblMessage.textColor = .red
        
        self.lblSubMessage.text = getLocalizationString(key: "OrderPlacedFailureSubMessage")
        self.lblSubMessage.textColor = secondaryColor
        self.lblSubMessage.font = UIFont.appLightFontName(size: fontSize14)

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
