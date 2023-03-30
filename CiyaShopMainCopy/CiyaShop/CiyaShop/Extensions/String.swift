//
//  String.swift
//  CiyaShop
//
//  Created by Apple on 22/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom..<rangeTo])
    }
    
    func camelCase() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized // If input is in llamaCase
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func encodeURL() -> URL {
        return URL(string: self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
    }
    
    func htmlEncodedString() -> String {

        guard let data = self.data(using: .utf8) else {
            return ""
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return ""
        }

        return attributedString.string

    }
    
    func SetAttributedString(color:UIColor,font:UIFont,strikeThrough:Bool) -> NSMutableAttributedString
    {
               
       let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
       
       let attributes: [NSAttributedString.Key: Any] = [
           .font: font,
           .strikethroughStyle: strikeThrough,
           .foregroundColor : color
       ]
       
       attributeString.addAttributes(attributes, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    func SetAvailableAttributedString(color:UIColor,font:UIFont) -> NSMutableAttributedString
    {
               
       let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
       
       let attributes: [NSAttributedString.Key: Any] = [
           .font: font,
           .foregroundColor : color
       ]
       
       attributeString.addAttributes(attributes, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    func withoutHtmlString() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
    
    func isValidEmail() -> Bool {
       let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
       return testEmail.evaluate(with: self)
    }
    
    var unescapingUnicodeCharacters: String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, "Any-Hex/Java" as NSString, true)

        return mutableString as String
    }
    func convertToAttributedFromHTML() -> NSAttributedString?
    {
            var attributedText: NSAttributedString?
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
            if let data = data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                attributedText = attrStr
            }
        return attributedText
    }
    func convertStringToDate(originalFormate: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = originalFormate
        return dateFormatter.date(from:self)!
    }
    func convertDateStringToString(originalFormate: String,requiredFormate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = originalFormate
        guard let date = dateFormatter.date(from:self) else{
            return ""
        }
        dateFormatter.dateFormat = requiredFormate
        return dateFormatter.string(from: date)
    }
}

extension Double {
    func roundToDecimal() -> Double {
        let multiplier = pow(10, Double(decimalPoints))
        return Darwin.round(self * multiplier) / multiplier
    }
}

