//
//  WebviewVC.swift
//  CiyaShop
//
//  Created by Apple on 06/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import WebKit
import CiyaShopSecurityFramework
import SwiftyJSON

class WebviewVC: UIViewController,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    
    //Variables
    var url : String?
    var isReload : Bool = true
    //MARK: - Life Cycle methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThemeColors()
        setLogo()
        setupWebview()
    }
    
    
    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        btnBack.tintColor =  secondaryColor
    }
    
    func setLogo() {
        if appLogo != "" {
            self.imgLogo.sd_setImage(with: appLogo.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                if (image == nil) {
                    self.imgLogo.image = UIImage(named: "appLogo")
                } else {
                    self.imgLogo.image = image
                }
            }
        } else {
            self.imgLogo.image = UIImage(named: "appLogo")
        }
    }
    
    // MARK: - Webview Methods
    func setupWebview() {
        //Webview
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.scrollView.bouncesZoom = false
        wkWebView.scrollView.delegate = self
        wkWebView.navigationDelegate = self
        
        
        //Reuest loading
        let requestUrl = URL(string: self.url ?? "")

        print("webview url - ",self.url ?? "")
        var request = NSMutableURLRequest(url: requestUrl!,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 5);
      
        request = NSMutableURLRequest(url: requestUrl!,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 5)
        
        
        wkWebView.load(request as URLRequest)

        
    }
    
    
    // MARK: - WKWebView Delegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
        if isReload {
            wkWebView.reload()
            isReload = false
        }
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        hideLoader()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let javaScript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        wkWebView.evaluateJavaScript(javaScript, completionHandler: nil)
    }
    //MARK:- Other redirection methods
    func redirectToOrderSuccess() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            DispatchQueue.main.async {
                hideLoader()
                removeAllFromCart()
                
                
            }
        }
    }
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        if wkWebView.canGoBack {
            wkWebView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}
