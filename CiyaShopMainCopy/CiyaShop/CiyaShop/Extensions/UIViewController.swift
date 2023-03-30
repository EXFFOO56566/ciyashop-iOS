//
//  UIViewController.swift
//  CiyaShop
//
//  Created by Apple on 08/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework

extension UIViewController {

    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-70, width: screenWidth - 40, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.appRegularFontName(size: fontSize12)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.layer.masksToBounds = true
        self.view.addSubview(toastLabel)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            toastLabel.removeFromSuperview()
        }

    }
    
    func BackNavigate()
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigateToProductDetails(detailDict:JSON)
    {
        if detailDict["type"].string == "external" {
            openUrl(strUrl: detailDict["external_url"].stringValue)
            return;
        }
        if isAddtoCartEnabled && !isCatalogMode {
            let vc = ProductDetailVC(nibName: "ProductDetailVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.dictProductDetail = detailDict
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            getSingleProduct(productId: detailDict["id"].stringValue)
        }
    }
    
    func NavigateToProductsList(categoryDict:JSON)
    {
        let vc = ProductsVC(nibName: "ProductsVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func NavigateToAllCategories()
    {
        let vc = AllCategoriesVC(nibName: "AllCategoriesVC", bundle : nil)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    //MARK:- Common button action
    @IBAction func btnSearchClicked(_ sender: Any)
    {
        let searchVC = SearchVC(nibName: "SearchVC", bundle: nil)
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.BackNavigate()
    }
    
    
    
    //for single product
    func getSingleProduct(productId : String) {
        showLoader()
        
        var params = [AnyHashable : Any]()
        params["include"] = productId
        
        CiyaShopAPISecurity.productListing(params) { (success, message, responseData) in
            
            hideLoader()
            
            let jsonReponse = JSON(responseData!)
            
            if success {
                if jsonReponse[0]["type"].string == "external" {
                    openUrl(strUrl: jsonReponse[0]["external_url"].stringValue)
                    return;
                }
                
                let vc = ProductDetailVC(nibName: "ProductDetailVC", bundle: nil)
                vc.hidesBottomBarWhenPushed = true
                vc.dictProductDetail = jsonReponse[0]
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                showCustomAlert(title: APP_NAME,message: getLocalizationString(key: "technicalIssue"), vc: self)
            }
        }
    }
    
    
}


extension UINavigationController {
    func pushToViewController(_ viewController: UIViewController, animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popViewController(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func popToViewController(_ viewController: UIViewController, animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popToRootViewController(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToRootViewController(animated: animated)
        CATransaction.commit()
    }

}


class BaseViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isStatusBarDark == false {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        }
        return .lightContent
    }
}


