//
//  LoaderVC.swift
//  CiyaShop
//
//  Created by Apple on 10/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class LoaderVC: UIViewController {
    
    
    @IBOutlet weak var imgLoader: UIImageView!
    
    
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.imgLoader.animationImages = loaderImages as? [UIImage];
            self.imgLoader.animationDuration = 1.5
            self.imgLoader.startAnimating()
        }
        self.imgLoader.layer.cornerRadius = 3
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutSubviews()
        
        
    }

}
