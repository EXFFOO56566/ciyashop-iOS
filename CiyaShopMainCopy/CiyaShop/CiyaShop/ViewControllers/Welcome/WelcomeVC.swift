//
//  WelcomeVC.swift
//  CiyaShop
//
//  Created by Apple on 12/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextDoneButton: UIButton!
    @IBOutlet weak var copyRightLabel: UILabel!
    
    var currentPage = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValueToLocal(key: WELCOME_KEY, value: true)
        
        setThemeColors()
        localize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 3,height: self.scrollView.frame.size.height)
    }
    
    
    // MARK: - Theme Methods
    
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        self.skipButton.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        self.nextDoneButton.titleLabel?.font = UIFont.appRegularFontName(size: fontSize12)
        self.copyRightLabel.font = UIFont.appLightFontName(size: fontSize11)
        
        self.skipButton.tintColor = secondaryColor
        self.nextDoneButton.tintColor = secondaryColor
        self.copyRightLabel.textColor = secondaryColor
        
    }
    
    func localize() {
        nextDoneButton.setTitle(getLocalizationString(key: "NEXT"), for: .normal)
        skipButton.setTitle(getLocalizationString(key: "SKIP"), for: .normal)
        copyRightLabel.text = getLocalizationString(key: "AllRigtsReserved")
    }
    
    // MARK: - Button Clicked
    
    @IBAction func skipButtonClicked(_ sender: Any) {
        
        showTabbar()
    }
    
    @IBAction func nextDoneButtonClicked(_ sender: Any) {
        if(currentPage == 2) {
            if isLoginScreen {
                showLogin()
            } else {
                showTabbar()
            }
            
            return;
        }
        
        currentPage = currentPage + 1
        let x = CGFloat(currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
        if(currentPage == 2) {
            nextDoneButton.setTitle(getLocalizationString(key: "DONE"), for: .normal)
        } else {
            nextDoneButton.setTitle(getLocalizationString(key: "NEXT"), for: .normal)
        }
    }
    
    // MARK: - Scrollview Delegate Methods
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        currentPage = Int(pageNumber)
        if(currentPage == 2) {
            nextDoneButton.setTitle(getLocalizationString(key: "DONE"), for: .normal)
        } else {
            nextDoneButton.setTitle(getLocalizationString(key: "NEXT"), for: .normal)
        }
    }
    
    
    // MARK: - Change Root
    
    func showTabbar() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func showLogin() {
        self.dismiss(animated: false) {
            DispatchQueue.main.async {
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
                let loginNavigationController = UINavigationController(rootViewController: loginVC)
                loginNavigationController.navigationBar.isHidden = true
                loginNavigationController.modalPresentationStyle = .fullScreen
                
                keyWindow?.rootViewController!.present(loginNavigationController, animated: true, completion: nil)
            }
        }
    }

    
}
