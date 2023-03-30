//
//  ListDataCell.swift
//  NJELSS
//
//  Created by Chetna on 06/12/16.
//  Copyright © 2016 FinLogic. All rights reserved.
//

import UIKit

class ListDataCell: UITableViewCell {

  
  @IBOutlet weak var valueLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
