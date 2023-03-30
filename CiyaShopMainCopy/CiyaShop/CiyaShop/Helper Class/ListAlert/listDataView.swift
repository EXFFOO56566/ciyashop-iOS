//
//  listDataView.swift
//  NJELSS
//
//  Created by Chetna on 06/12/16.
//  Copyright © 2016 FinLogic. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias CompletionSingleSelectBlock = (JSON) -> Void

class listDataView: UIView , UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var tableviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleView: UIView!
    
    var isCustomKey : Bool = false
    var strCustomKeyName : String = ""
    
    var selectedValue : String?
    var listData : Array<JSON>?
    var completionSingle : CompletionSingleSelectBlock?
    
    
    override func awakeFromNib() {
        
        tableview.register(UINib(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "Cell")
        let height = UIScreen.main.nativeBounds.height
        
        titleLabel.font = UIFont.appBoldFontName(size: fontSize14)
        titleView.backgroundColor = secondaryColor
        
        if UIDevice().userInterfaceIdiom == .phone {
            if height == 2436 || height == 2688 || height == 1792 {
                tableviewBottomConstraint.constant = 104
            } else {
                tableviewBottomConstraint.constant = 64
            }
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideView))
        blurView.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    //  MARK: - UITableview Datasource and delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListDataCell
        
        
        if isCustomKey == true {
            if self.listData![indexPath.row].type == .dictionary {
                if let symbol = listData![indexPath.row]["symbol"].string {
                    var attrStr : NSMutableAttributedString?
                    do {
                        attrStr = try NSMutableAttributedString(data: symbol.data(using: .unicode)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                    } catch {
                        attrStr = NSMutableAttributedString()
                    }
                    cell.valueLabel.text = listData![indexPath.row][strCustomKeyName].stringValue + " ( " + attrStr!.string + " )"
                } else {
                    cell.valueLabel.text = listData![indexPath.row][strCustomKeyName].stringValue
                }
                
                if listData![indexPath.row][strCustomKeyName].string == self.selectedValue {
                    cell.isSelected = true
                } else {
                    cell.isSelected = false
                }
                
            } else {
                cell.valueLabel.text = listData![indexPath.row].stringValue
            }
        } else {
            cell.valueLabel.text = listData![indexPath.row].stringValue
            
            if cell.valueLabel.text == self.selectedValue {
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }
            cell.accessoryType = cell.isSelected ? .checkmark : .none
        }
        
        
        cell.valueLabel.font = UIFont.appLightFontName(size: fontSize12)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        completionSingle!(listData![indexPath.row])
        self.removeFromSuperview()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    
    //  MARK: - on Tap gesture
    
    @objc func hideView() {
        self.removeFromSuperview()
    }

}
