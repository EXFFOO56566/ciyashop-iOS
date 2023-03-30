//
//  Protocols.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 20/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import  SwiftyJSON

protocol ShowVariationPopUpDelegate
{
    func ShowVariationView(productDetailDict : JSON)
}
protocol OpenVideoPlayerDelegate
{
    func PresentVideoPlayer()
}
protocol PreviewImagesDelegate
{
    func NavigateToShowImages()
}

protocol OrderDetailDelegate
{
    func updateMyOrders()
}

protocol CategorySelectionDelegate
{
    func selectCategory(categoryId : Int)
}


