//
//  SortByOptionsVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 15/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SortByOptionsVC: UIViewController {

    //MARK:- Outlets

    @IBOutlet weak var pickerSortOptions: UIPickerView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblSortBy: UILabel!

    //MARK:- variables
   
    var arrayOptions : [String] = [
        getLocalizationString(key: "NewestFirst"),
        getLocalizationString(key: "Rating"),
        getLocalizationString(key: "Popularity"),
        getLocalizationString(key: "PriceLowToHigh"),
        getLocalizationString(key: "PriceHighToLow")
    ]
    
    //MARK:- Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpUI()
    }
    //MARK:- Set up UI
    func setUpUI()
    {
        [btnCancel,btnDone].forEach { (button) in
            button?.setTitleColor(UIColor.white, for: .normal)
            button?.titleLabel?.font = UIFont.appBoldFontName(size: fontSize12)
        }
        
        lblSortBy.textColor = UIColor.white
        lblSortBy.font = UIFont.appBoldFontName(size: fontSize14)
        
        //---
        pickerSortOptions.delegate = self
        pickerSortOptions.dataSource = self
        
        //--
        lblSortBy.text = getLocalizationString(key: "SortBy")
        btnDone.setTitle(getLocalizationString(key: "DONE").uppercased(), for: .normal)
        btnCancel.setTitle(getLocalizationString(key: "Cancel").uppercased(), for: .normal)

    }



}
//MARK:- Picker
extension SortByOptionsVC : UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOptions[row]
    }
    
}
//MARK:- Other methods
extension SortByOptionsVC
{
    func DismissView()
    {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK:- Button action
extension SortByOptionsVC
{
    @IBAction func btnDoneClicked(_ sender: UIButton) {
        print("Picker selected value - ",arrayOptions[pickerSortOptions.selectedRow(inComponent: 0)])
        DismissView()
    }
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        DismissView()
    }
}
