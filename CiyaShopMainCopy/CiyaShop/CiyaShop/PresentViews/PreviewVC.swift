//
//  PreviewVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 23/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit
import AVFoundation
class PreviewVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var cvProductImage: UICollectionView!
    @IBOutlet weak var btnDone: UIButton!

    
    //MARK:- Variables
    var arrayImages : [JSON] = []
    var selectedImageIndex = 0
    
    //MARK:- Life cycle methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollToSelectedIndex()
    }

    //MARK:- Setup UI
    func setUpUI()
    {
        setupCollectionView()
        setUpImageArray()
        
        //---
        btnDone.setTitle(getLocalizationString(key: "DONE"), for: .normal)
        btnDone.setTitleColor(secondaryColor, for: .normal)
        btnDone.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
        
        
    }
    // MARK: - Image data setup
    func setUpImageArray()
    {
        print("array images -",arrayImages)
        cvProductImage.reloadData()
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
    }
    func scrollToSelectedIndex()
    {
        cvProductImage.scrollToItem(at: IndexPath(item: selectedImageIndex, section: 0), at: .centeredHorizontally, animated: false)

    }
    // MARK: - Configuration
    private func setupCollectionView()
    {
        cvProductImage.delegate = self
        cvProductImage.dataSource = self
         
        cvProductImage.register(UINib(nibName: "ProductImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCollectionViewCell")
    }
   
}
// MARK: - UICollection Delegate methods

extension PreviewVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrayImages.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
        cell.btnPlayPause.addTarget(self, action: #selector(btnPlayPauseClicked(_:)), for: .touchUpInside)
        
        let dict = arrayImages[indexPath.row]
        
        let imageUrl = dict["src"].stringValue
        cell.imgvwProduct.sd_setImage(with: imageUrl.encodeURL(), placeholderImage: UIImage(named: "placeholder"))
        
        
        if(dict["isVideo"].stringValue == "1")
        {
            cell.btnPlayPause.isHidden = false
        }else{
            cell.btnPlayPause.isHidden = true
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: screenWidth , height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
       
    }
    
}
//MARK: - Button Clicked

extension PreviewVC
{
    @objc func btnPlayPauseClicked(_ sender: UIButton)
    {
        let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let vc = AVPlayerViewController()
        vc.player = player

        self.present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
}
