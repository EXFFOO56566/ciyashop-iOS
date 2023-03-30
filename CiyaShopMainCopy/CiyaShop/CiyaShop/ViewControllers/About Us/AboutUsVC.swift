//
//  AboutUsVC.swift
//  CiyaShop
//
//  Created by Apple on 10/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CiyaShopSecurityFramework

class AboutUsVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblCopyRights: UILabel!
    
    @IBOutlet weak var btnTermsCondition: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    
    @IBOutlet weak var lblFollowUS: UILabel!
    @IBOutlet weak var lblMoreAboutUS: UILabel!
    
    @IBOutlet weak var lblMoreAboutUSDetails: UILabel!
    
    @IBOutlet weak var cvSocialData: UICollectionView!
    
    
    var arrSocial = [JSON]()
    
    
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
        setLogo()
        setSocialData()
        getAboutUsData()

    }

    func setThemeColors() {
        self.view.setBackgroundColor()
        
        
        lblTitle.text = getLocalizationString(key: "AboutUs")
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor =  secondaryColor
        
        btnBack.tintColor =  secondaryColor
        
        lblVersion.text = getLocalizationString(key: "Version") + String(format: " %@", Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! CVarArg)
        lblVersion.font = UIFont.appLightFontName(size: fontSize12)
        lblVersion.textColor =  secondaryColor.withAlphaComponent(0.6)//.darkGray
        
        lblCopyRights.text = getLocalizationString(key: "AllRigtsReserved")
        lblCopyRights.font = UIFont.appLightFontName(size: fontSize12)
        lblCopyRights.textColor =  secondaryColor.withAlphaComponent(0.6)//.darkGray
        
        btnTermsCondition.setTitle(getLocalizationString(key: "TermsCondition"), for: .normal)
        btnTermsCondition.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
        btnTermsCondition.backgroundColor = .clear
        btnTermsCondition.tintColor = secondaryColor
        
        btnPrivacyPolicy.setTitle(getLocalizationString(key: "PrivacyPolicy"), for: .normal)
        btnPrivacyPolicy.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
        btnPrivacyPolicy.backgroundColor = .clear
        btnPrivacyPolicy.tintColor = secondaryColor
        
        lblFollowUS.text = getLocalizationString(key: "FollowUs")
        lblFollowUS.font = UIFont.appRegularFontName(size: fontSize12)
        lblFollowUS.textColor =  secondaryColor.withAlphaComponent(0.6)//.darkGray
        
        lblMoreAboutUS.text = getLocalizationString(key: "MoreAboutUs")
        lblMoreAboutUS.font = UIFont.appRegularFontName(size: fontSize12)
        lblMoreAboutUS.textColor =  secondaryColor.withAlphaComponent(0.6)//.darkGray
        
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
    
    func setSocialData() {
        for socialItem in dictSocialData {
            
            if socialItem.value != "" {
                var socialDict = [String : String]()
                socialDict["socialName"] = socialItem.key
                socialDict["socialLink"] = socialItem.value.stringValue
                arrSocial.append(JSON(socialDict))
            }
        }
        
        cvSocialData.dataSource = self
        cvSocialData.delegate = self
        
        cvSocialData.register(UINib(nibName: "SocialCell", bundle: nil), forCellWithReuseIdentifier: "SocialCell")
        cvSocialData.reloadData()
    }

    // MARK: - Get About us details
    func getAboutUsData() {
        showLoader()
        var params = [AnyHashable : Any]()
        params["page"] = "about_us"
        
        CiyaShopAPISecurity.getStaticPages(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            if success {
                if jsonReponse.type == .array {
                    
                } else if jsonReponse.type == .dictionary {
                    let htmlString = jsonReponse["data"].stringValue
                    var attributedString : NSMutableAttributedString?
                    do {
                        attributedString = try NSMutableAttributedString(data: htmlString.data(using: .unicode)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                    } catch {
                        attributedString = NSMutableAttributedString()
                    }
                    
                    self.lblMoreAboutUSDetails.attributedText = attributedString
                    self.lblMoreAboutUSDetails.sizeToFit()
                } else {
                    
                }
            }
            hideLoader()
        }
    }


    
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTermConditionClicked(_ sender: Any) {
        
        let vc = TermsAndPolicyVC(nibName: "TermsAndPolicyVC", bundle : nil)
        vc.selectedContentType = .termsCondition
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func btnPrivacyPolicyClicked(_ sender: Any) {
        let vc = TermsAndPolicyVC(nibName: "TermsAndPolicyVC", bundle : nil)
        vc.selectedContentType = .privacyPolicy
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension AboutUsVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: - Collectionview method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSocial.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialCell", for: indexPath) as! SocialCell
        
        let socialItem = arrSocial[indexPath.row]
        
        if "facebook" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "facebook-icon")
        } else if "twitter" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "twitter-icon")
        }  else if "linkedin" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "linkedin-icon")
        }  else if "google_plus" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "googleplus-icon")
        }  else if "pinterest" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "pinterest-icon")
        }  else if "instagram" == socialItem["socialName"].string  {
            cell.imgSocialLogo.image = UIImage(named: "instagram-icon")
        } else {
            cell.imgSocialLogo.image = UIImage(named: "website-icon")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30 , height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalCellWidth = 30 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)

        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let socialItem = arrSocial[indexPath.row]
        let url =  socialItem["socialLink"].stringValue
        openUrl(strUrl: url)
    }
    
}

