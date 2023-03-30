//
//  UILabel.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 25/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import  UIKit
import SwiftyJSON

extension UILabel
{
    func customCornerRadius(radius:CGFloat)
    {
        var boundingCorners = UIRectCorner()
        if(!isRTL)
        {
            boundingCorners = [.topLeft,.bottomRight]
        }else{
            boundingCorners = [.topRight,.bottomLeft]
        }
        let path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: boundingCorners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func SetPriceValue(originalPrice:String,offerPrice:String) -> NSMutableAttributedString
    {
        let attributeString =  originalPrice.SetAttributedString(color: secondaryColor, font: UIFont.appBoldFontName(size: fontSize12),strikeThrough:false)
        ///------
    
        let attributeString2 =  offerPrice.SetAttributedString(color: grayTextColor, font: UIFont.appBoldFontName(size: fontSize10),strikeThrough:true)
        attributeString.append(attributeString2)
        
        return attributeString
    }
    func setUpOfferLabelUI()
    {
        self.font = UIFont.appBoldFontName(size: 12)
        self.textColor = .white
        self.backgroundColor = secondaryColor
        self.customCornerRadius(radius: 5)
    }
    func setUpAvailabilityUI(color:UIColor,strAvailability:String) -> NSMutableAttributedString
    {
        let strAvailabilityText = getLocalizationString(key: "Availability") + ": "
        let attributeString =  strAvailabilityText.SetAvailableAttributedString(color: grayTextColor, font: UIFont.appRegularFontName(size: fontSize12))
        ///------
        
        let attributeString2 =  strAvailability.SetAvailableAttributedString(color: color, font: UIFont.appBoldFontName(size: fontSize12))
        attributeString.append(attributeString2)
        
        return attributeString
    }
    
    func setUpMultiUILabel(color1:UIColor,color2:UIColor,str1:String,str2:String,font1:UIFont,font2:UIFont) -> NSMutableAttributedString
    {
        let attributeString =  str1.SetAvailableAttributedString(color: color1, font: font1)
        ///------

        let attributeString2 =  str2.SetAvailableAttributedString(color: color2, font: font2)
        attributeString.append(attributeString2)
        
        return attributeString
    }
    func labelCornerRadius(radius:CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func labelBorderColor(color:UIColor,width:CGFloat)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /*func setPriceForItem(_ str: String?) {
        var str = str
        let strAtt = str! as NSString
        print("HTML STRING : ",str)

        str = str?.replacingOccurrences(
            of: "<bdi>",
            with: "")
        str = str?.replacingOccurrences(
            of: "</bdi>",
            with: "")

        let htmlString = str

        var attrStr = NSMutableAttributedString()


        do {
            if let data = htmlString?.data(using: .unicode) {
                attrStr = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        } catch {

        }
        if attrStr.string.contains("–") {
               attrStr.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr.length))
            attrStr.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr.length))
           }

        else if attrStr.string.contains(" ") {
            let r1 = strAtt.range(of: "<bdi>")
            let r2 = strAtt.range(of: "</bdi>")
            let rSub = NSRange(location: r1.location + r1.length, length: r2.location - r1.location - r1.length)
            let sub1 = strAtt.substring(with: rSub)

            let r11 = strAtt.range(of: "<del>")
            let r21 = strAtt.range(of: "</del>")
            let rSub1 = NSRange(location: r11.location + r11.length, length: r21.location - r11.location - r11.length)
            let sub2 = strAtt.substring(with: rSub1)


            var attrStr1: NSMutableAttributedString? = nil
            do {
                if let data = sub1.data(using: .unicode) {
                    attrStr1 = try NSMutableAttributedString(data: data, options: [
                        .documentType: NSAttributedString.DocumentType.html
                    ], documentAttributes: nil)
                }
            } catch {
            }
            var attrStr2: NSMutableAttributedString? = nil
            do {
                if let data = sub2.data(using: .unicode) {
                    attrStr2 = try NSMutableAttributedString(data: data, options: [
                        .documentType: NSAttributedString.DocumentType.html
                    ], documentAttributes: nil)
                }
            } catch {
            }

            let str11 = attrStr1?.string.replacingOccurrences(of: strCurrencySymbol, with: "")
            let str1 = str11?.replacingOccurrences(of: ",", with: "")

            let str22 = attrStr2!.string.replacingOccurrences(of: strCurrencySymbol, with: "")
            let str2 = str22.replacingOccurrences(of: ",", with: "")

            let string = NSMutableAttributedString(string: String(format: "%i.", 1))


            string.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: string.length - 1))
            string.addAttribute(.foregroundColor, value: UIColor.clear, range: NSRange(location: string.length - 1, length: 1))

            attrStr = NSMutableAttributedString()

            let price1 = Double(str1!)
            let price2 = Double(str2)

            if price1 != nil && price2 != nil && price1! > price2! {
                /*attrStr1!.addAttribute(.foregroundColor, value: grayTextColor, range: NSRange(location: 0, length: attrStr1!.length))
                attrStr1!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize12), range: NSRange(location: 0, length: attrStr1!.length))
                attrStr1!.addAttribute(.strikethroughStyle, value: NSNumber(value: 2), range: NSRange(location: 0, length: attrStr1!.length))*/

                //---
                attrStr1 =  attrStr1?.string.SetAttributedString(color: grayTextColor, font: UIFont.appBoldFontName(size: fontSize12),strikeThrough:true)

                //--

                attrStr2!.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr2!.length))
                attrStr2!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr2!.length))

                if isRTL
                {
                    attrStr.append(attrStr1!)
                    attrStr.append(string)
                    attrStr.append(attrStr2!)
                }
                else{
                    attrStr.append(attrStr2!)
                    attrStr.append(string)
                    attrStr.append(attrStr1!)
                }

            } else {
                attrStr1!.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr1!.length))
                attrStr1!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr1!.length))

                /*attrStr2!.addAttribute(.foregroundColor, value: grayTextColor, range: NSRange(location: 0, length: attrStr2!.length))

                attrStr2!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr2!.length))
                attrStr2!.addAttribute(.strikethroughStyle, value: NSNumber(value: 2), range: NSRange(location: 0, length: attrStr2!.length))*/
                attrStr2 =  attrStr2?.string.SetAttributedString(color: grayTextColor, font: UIFont.appBoldFontName(size: fontSize12),strikeThrough:true)


                if !isRTL
                {
                    attrStr.append(attrStr1!)
                    attrStr.append(string)
                    attrStr.append(attrStr2!)
                }
                else{
                    attrStr.append(attrStr2!)
                    attrStr.append(string)
                    attrStr.append(attrStr1!)
                }


            }
        }
        else {
            attrStr.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr.length))
            attrStr.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr.length))
        }

        if isRTL {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .right

            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle: paragraph]
            attrStr.addAttributes(attributes, range: NSRange(location: 0, length: attrStr.length))

        }


        self.attributedText = attrStr

//        return attrStr
    }*/
    func setPriceForItem(_ str: String) {
        
        let strHTML = str
        _ = strHTML as NSString
        
//        print("HTML STRING : ",strHTML)

    /*    strHTML = strHTML.replacingOccurrences(
            of: "<bdi>",
            with: "")
        strHTML = strHTML.replacingOccurrences(
            of: "</bdi>",
            with: "")

        let htmlString = strHTML

        var attrStr = NSMutableAttributedString()


        do {
            if let data = htmlString.data(using: .unicode) {
                attrStr = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        } catch {

        }
        if attrStr.string.contains("–") {
               attrStr.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr.length))
            attrStr.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr.length))
           }

        else if attrStr.string.contains(" ") {
            let r1 = strAtt.range(of: "<bdi>")
            let r2 = strAtt.range(of: "</bdi>")
            let rSub = NSRange(location: r1.location + r1.length, length: r2.location - r1.location - r1.length)
            let sub1 = strAtt.substring(with: rSub)

            let r11 = strAtt.range(of: "<del>")
            let r21 = strAtt.range(of: "</del>")
            let rSub1 = NSRange(location: r11.location + r11.length, length: r21.location - r11.location - r11.length)
            let sub2 = strAtt.substring(with: rSub1)


            var attrStr1: NSMutableAttributedString? = nil
            do {
                if let data = sub1.data(using: .unicode) {
                    attrStr1 = try NSMutableAttributedString(data: data, options: [
                        .documentType: NSAttributedString.DocumentType.html
                    ], documentAttributes: nil)
                }
            } catch {
            }
            var attrStr2: NSMutableAttributedString? = nil
            do {
                if let data = sub2.data(using: .unicode) {
                    attrStr2 = try NSMutableAttributedString(data: data, options: [
                        .documentType: NSAttributedString.DocumentType.html
                    ], documentAttributes: nil)
                }
            } catch {
            }

            let str11 = attrStr1?.string.replacingOccurrences(of: strCurrencySymbol, with: "")
            let str1 = str11?.replacingOccurrences(of: ",", with: "")

            let str22 = attrStr2!.string.replacingOccurrences(of: strCurrencySymbol, with: "")
            let str2 = str22.replacingOccurrences(of: ",", with: "")

            let string = NSMutableAttributedString(string: String(format: "%i.", 1))


            string.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: string.length - 1))
            string.addAttribute(.foregroundColor, value: UIColor.clear, range: NSRange(location: string.length - 1, length: 1))

            attrStr = NSMutableAttributedString()

            let price1 = Double(str1!)
            let price2 = Double(str2)

            if price1 != nil && price2 != nil && price1! > price2! {
                /*attrStr1!.addAttribute(.foregroundColor, value: grayTextColor, range: NSRange(location: 0, length: attrStr1!.length))
                attrStr1!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize12), range: NSRange(location: 0, length: attrStr1!.length))
                attrStr1!.addAttribute(.strikethroughStyle, value: NSNumber(value: 2), range: NSRange(location: 0, length: attrStr1!.length))*/

                //---
                attrStr1 =  attrStr1?.string.SetAttributedString(color: grayTextColor, font: UIFont.appBoldFontName(size: fontSize12),strikeThrough:true)

                //--

                attrStr2!.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr2!.length))
                attrStr2!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr2!.length))

                if isRTL
                {
                    attrStr.append(attrStr1!)
                    attrStr.append(string)
                    attrStr.append(attrStr2!)
                }
                else{
                    attrStr.append(attrStr2!)
                    attrStr.append(string)
                    attrStr.append(attrStr1!)
                }

            } else {
                attrStr1!.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr1!.length))
                attrStr1!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr1!.length))

                /*attrStr2!.addAttribute(.foregroundColor, value: grayTextColor, range: NSRange(location: 0, length: attrStr2!.length))

                attrStr2!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr2!.length))
                attrStr2!.addAttribute(.strikethroughStyle, value: NSNumber(value: 2), range: NSRange(location: 0, length: attrStr2!.length))*/
                attrStr2 =  attrStr2?.string.SetAttributedString(color: grayTextColor, font: UIFont.appBoldFontName(size: fontSize12),strikeThrough:true)


                if !isRTL
                {
                    attrStr.append(attrStr1!)
                    attrStr.append(string)
                    attrStr.append(attrStr2!)
                }
                else{
                    attrStr.append(attrStr2!)
                    attrStr.append(string)
                    attrStr.append(attrStr1!)
                }


            }
        }
        else {
            attrStr.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr.length))
            attrStr.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr.length))
        }

        if isRTL {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .right

            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle: paragraph]
            attrStr.addAttributes(attributes, range: NSRange(location: 0, length: attrStr.length))

        }


        self.attributedText = attrStr
        */
//        return attrStr
    }
    
    /*func setPriceForProduct(str:String,isOnSale:Bool,product:JSON)
    {
        print("str HTML - ",str)

        var strHTML = str
        
        strHTML = strHTML.replacingOccurrences(
            of: "<ins>",
            with: "")
        strHTML = strHTML.replacingOccurrences(
            of: "</ins>",
            with: "")
       
        var attrStr = NSMutableAttributedString()
        do {
            if let data = strHTML.data(using: .unicode) {
                attrStr = try NSMutableAttributedString(data: data, options: [
                    .documentType: NSAttributedString.DocumentType.html
                ], documentAttributes: nil)
            }
        } catch {
        }
        
        attrStr.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr.length))
        attrStr.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr.length))
        
        if(isOnSale)
        {
            let range: NSRange = attrStr.mutableString.range(of: "\(product["regular_price"].stringValue)", options: .caseInsensitive)
            attrStr.addAttribute(.foregroundColor, value: grayTextColor, range: range)

            attrStr.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize12), range: range)
            
        }
        self.attributedText = attrStr
        
        if(isRTL)
        {
            self.textAlignment = .right
        }
    }*/
    func setPriceForProductItem(str:String,isOnSale:Bool,product:JSON)
    {
        print("str HTML - ",str)

        var strHTML = str
        
        strHTML = strHTML.replacingOccurrences(
            of: "<ins>",
            with: "")
        strHTML = strHTML.replacingOccurrences(
            of: "</ins>",
            with: "")
       
        var attrStr = NSMutableAttributedString()
        do {
            if let data = strHTML.data(using: .unicode) {
                attrStr = try NSMutableAttributedString(data: data, options: [
                    .documentType: NSAttributedString.DocumentType.html
                ], documentAttributes: nil)
            }
        } catch {
        }
        
        attrStr.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr.length))
        attrStr.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr.length))
        
        if(isOnSale && product["type"].stringValue != ProductType.grouped.rawValue && product["type"].stringValue != ProductType.variable.rawValue)
        {

            let regularPrice = product["regular_price"].floatValue
            let salePrice = product["sale_price"].floatValue
            
            let convertedRegularPrice = priceFormatter(price: NSNumber(value: regularPrice))
            let convertedSalePrice = priceFormatter(price: NSNumber(value: salePrice))

            //---
            var attrRegularPriceStr = NSMutableAttributedString()
            do {
                if let data = convertedRegularPrice.data(using: .unicode) {
                    attrRegularPriceStr = try NSMutableAttributedString(data: data, options: [
                        .documentType: NSAttributedString.DocumentType.html
                    ], documentAttributes: nil)
                }
            } catch {
            }
            
            attrRegularPriceStr =  attrRegularPriceStr.string.SetAttributedString(color: grayTextColor, font: UIFont.appBoldFontName(size: fontSize12),strikeThrough:true)

            //----
            var attrSalePriceStr = NSMutableAttributedString()
            do {
                if let data = convertedSalePrice.data(using: .unicode) {
                    attrSalePriceStr = try NSMutableAttributedString(data: data, options: [
                        .documentType: NSAttributedString.DocumentType.html
                    ], documentAttributes: nil)
                }
            } catch {
            }
            
            attrSalePriceStr =  attrSalePriceStr.string.SetAttributedString(color: secondaryColor, font: UIFont.appBoldFontName(size: fontSize14),strikeThrough:false)
            
            if(strCurrencySymbolPosition == "left")
            {
                let finalAttrStr = NSMutableAttributedString()
                                
                if(isShowSalePriceLeft)
                {
                    finalAttrStr.append(attrSalePriceStr)
                    finalAttrStr.append(NSAttributedString(string: " "))
                    finalAttrStr.append(attrRegularPriceStr)
                }else{
                    finalAttrStr.append(attrRegularPriceStr)
                    finalAttrStr.append(NSAttributedString(string: " "))
                    finalAttrStr.append(attrSalePriceStr)
                }
                
                self.attributedText = finalAttrStr

            }else{
                let finalAttrStr = NSMutableAttributedString()
                finalAttrStr.append(attrSalePriceStr)
                finalAttrStr.append(NSAttributedString(string: " "))
                finalAttrStr.append(attrRegularPriceStr)
                
                self.attributedText = finalAttrStr
            }
            
        }else{
            self.attributedText = attrStr

        }
        
        if(isRTL)
        {
            self.textAlignment = .right
        }
    }
    
   /* func setPriceForItem(_ str: String?) {
        var str = str
        let strAtt = str!
        
        print("Price HTML - ",str)
        str = str?.replacingOccurrences(
            of: "<bdi>",
            with: "")
        str = str?.replacingOccurrences(
            of: "</bdi>",
            with: "")
        
        let htmlString = str
        var attrStr = NSMutableAttributedString()
        
        do {
            if let data = htmlString?.data(using: .unicode) {
                attrStr = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        } catch {
            
        }
        
        do
        {
            print("attrStr.length - ",attrStr.length)
            if attrStr.string.contains("–") {
                
                //                do {
                attrStr.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr.length))
                
                //                }  catch {
                //                    print("error")
                //                }
                
                
                
                attrStr.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr.length))
            }
                
            else if attrStr.string.contains(" ") {
                //                let r1 = strAtt.range(of: "<bdi>")
                //                let r2 = strAtt.range(of: "</bdi>")
                
                
                
                //                    let rSub = NSRange(location: r1.location + r1.length, length: r2.location - r1.location - r1.length)
                //                    print("rSub - ",rSub)
                //                    let sub1 = strAtt.substring(with: rSub);
                
                let sub1 = strAtt.slice(from: "<bdi>", to: "</bdi>")
                
                
                //                    let r11 = strAtt.range(of: "<del>")
                //                    let r21 = strAtt.range(of: "</del>")
                //
                //
                //                    let rSub1 = NSRange(location: r11.location + r11.length, length: r21.location - r11.location - r11.length)
                //                    let sub2 : String = strAtt.substring(with: rSub1)
                
                let sub2 = strAtt.slice(from: "<del>", to: "</del>")
                
                
                var attrStr1: NSMutableAttributedString? = nil
                do {
                    if let data = sub1?.data(using: .unicode) {
                        attrStr1 = try NSMutableAttributedString(data: data, options: [
                            .documentType: NSAttributedString.DocumentType.html
                        ], documentAttributes: nil)
                        
                        var attrStr2: NSMutableAttributedString? = nil
                        do {
                            if let data = sub2?.data(using: .unicode) {
                                attrStr2 = try NSMutableAttributedString(data: data, options: [
                                    .documentType: NSAttributedString.DocumentType.html
                                ], documentAttributes: nil)
                            }
                        } catch {
                        }
                        
                        let str11 = attrStr1?.string.replacingOccurrences(of: strCurrencySymbol, with: "")
                        let str1 = str11?.replacingOccurrences(of: ",", with: "")
                        
                        var str2 = ""
                        if attrStr2 != nil {
                            let str22 = attrStr2!.string.replacingOccurrences(of: strCurrencySymbol, with: "")
                            str2 = str22.replacingOccurrences(of: ",", with: "")
                        }
                        
                        let string = NSMutableAttributedString(string: String(format: "%i.", 1))
                        
                        string.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: string.length - 1))
                        string.addAttribute(.foregroundColor, value: UIColor.clear, range: NSRange(location: string.length - 1, length: 1))
                        
                        attrStr = NSMutableAttributedString()
                        
                        let price1 = Double(str1!)
                        let price2 = Double(str2)
                        
                        if price1 != nil && price2 != nil && price1! > price2! {
                            /*attrStr1!.addAttribute(.foregroundColor, value: grayTextColor, range: NSRange(location: 0, length: attrStr1!.length))
                             attrStr1!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize12), range: NSRange(location: 0, length: attrStr1!.length))
                             attrStr1!.addAttribute(.strikethroughStyle, value: NSNumber(value: 2), range: NSRange(location: 0, length: attrStr1!.length))*/
                            
                            //---
                            attrStr1 =  attrStr1?.string.SetAttributedString(color: grayTextColor, font: UIFont.appBoldFontName(size: fontSize12),strikeThrough:true)
                            
                            //--
                            
                            attrStr2!.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr2!.length))
                            attrStr2!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr2!.length))
                            
                            if isRTL
                            {
                                attrStr.append(attrStr1!)
                                attrStr.append(string)
                                attrStr.append(attrStr2!)
                            }
                            else{
                                attrStr.append(attrStr2!)
                                attrStr.append(string)
                                attrStr.append(attrStr1!)
                            }
                            
                        } else {
                            attrStr1!.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr1!.length))
                            attrStr1!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr1!.length))
                            
                            /*attrStr2!.addAttribute(.foregroundColor, value: grayTextColor, range: NSRange(location: 0, length: attrStr2!.length))
                             
                             attrStr2!.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr2!.length))
                             attrStr2!.addAttribute(.strikethroughStyle, value: NSNumber(value: 2), range: NSRange(location: 0, length: attrStr2!.length))*/
                            attrStr2 =  attrStr2?.string.SetAttributedString(color: grayTextColor, font: UIFont.appBoldFontName(size: fontSize12),strikeThrough:true)
                            
                            
                            if !isRTL
                            {
                                attrStr.append(attrStr1!)
                                attrStr.append(string)
                                if attrStr2 != nil {
                                    attrStr.append(attrStr2!)
                                }
                                
                            }
                            else{
                                if attrStr2 != nil {
                                    attrStr.append(attrStr2!)
                                }
                                attrStr.append(string)
                                attrStr.append(attrStr1!)
                            }
                            
                            
                        }
                        
                    }
                } catch {
                }
            }
            else {
                attrStr.addAttribute(.foregroundColor, value: secondaryColor, range: NSRange(location: 0, length: attrStr.length))
                attrStr.addAttribute(.font, value: UIFont.appBoldFontName(size: fontSize14), range: NSRange(location: 0, length: attrStr.length))
            }
            
            if isRTL {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .right
                
                let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle: paragraph]
                attrStr.addAttributes(attributes, range: NSRange(location: 0, length: attrStr.length))
                
            }
            
        }
        catch{
            
        }
        
        self.attributedText = attrStr
        
        //        return attrStr
    }*/
}
