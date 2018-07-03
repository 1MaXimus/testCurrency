//
//  MyTableViewCell.swift
//  CurrencyTest
//
//  Created by Maxim Pakhotin on 02.07.2018.
//  Copyright © 2018 Maxim Pakhotin. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization cod
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
