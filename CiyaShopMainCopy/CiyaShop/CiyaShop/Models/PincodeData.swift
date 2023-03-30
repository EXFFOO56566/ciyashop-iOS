//
//  PincodeData.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 18/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class PincodeData: NSObject
{
    var availableat_text = ""
    var cod_available_msg = ""
    var cod_data_label = ""
    var cod_help_text = ""
    var cod_not_available_msg = ""
    var del_data_label = ""
    var del_help_text = ""
    
    var del_saturday = false
    var del_sunday = false
    
    var error_msg_blank = ""
    var error_msg_check_pincode = ""
    var pincode_placeholder_txt = ""
    var show_city_on_product = false
    var show_cod_on_product = false
    var show_estimate_on_product = false
    var show_product_page = false
    var show_state_on_product = false
}
