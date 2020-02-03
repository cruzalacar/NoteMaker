//
//  MyDataTableViewCell.swift
//  PlannerApp
//
//  Created by Murtaza on 2019-12-02.
//  Copyright © 2019 Ryle  Macaraig. All rights reserved.
//

import UIKit

// Step 3 - add following outlets for table view cell and connect them in sb
// Step 4 - move on to GetData
class MyDataTableViewCell: UITableViewCell {

    @IBOutlet var myName : UILabel!
    @IBOutlet var myDate : UILabel!
    @IBOutlet var myLogo : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
