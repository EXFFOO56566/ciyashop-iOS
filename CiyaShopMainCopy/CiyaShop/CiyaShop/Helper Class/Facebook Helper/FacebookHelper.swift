//
//  FacebookHelper.swift
//  CiyaShop
//
//  Created by Apple on 28/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

typealias FaceBookLoginBlock = (Bool,[AnyHashable : Any]?) -> Void

class FacebookHelper  {
    
    var facebookLoginCompletion: FaceBookLoginBlock?
    var dictFbDetails: [AnyHashable : Any]?

    private static var shareInstance: FacebookHelper = {
         let instance = FacebookHelper()
         return instance
     }()

    
    class func shared() -> FacebookHelper {
        return shareInstance
    }
    
    private func loginFBUser() {
        let loginFB = LoginManager()
        loginFB.logIn(permissions: ["public_profile", "email"], from: keyWindow?.rootViewController) { (result, error) in
            
            var response = [AnyHashable : Any]()
            
            if error != nil {
                response["error"] = "1"
                self.facebookLoginCompletion!(false,response)
            } else if result!.isCancelled {
                response["error"] = "2"
                self.facebookLoginCompletion!(false,response)
            } else {
                self.getFBUserDetails()
            }
        }
    }
    
    
    private func getFBUserDetails() {
        GraphRequest(graphPath: "me", parameters: ["fields" : "picture.type(large), email, id,first_name, last_name"]).start { (connection, result, error) in
            if error != nil {
                var response = [AnyHashable : Any]()
                response["error"] = "3"
                self.facebookLoginCompletion!(false,response)
            } else {
                self.facebookLoginCompletion!(true,(result as! [AnyHashable : Any]))
            }
        }
    }
    
    func getFacebookDetails(vc : UIViewController,onComplition: @escaping FaceBookLoginBlock)
    {
        self.facebookLoginCompletion = onComplition
        
        if (AccessToken.current != nil) {
            getFBUserDetails()
        } else {
            loginFBUser()
        }
    }
    
    
}



