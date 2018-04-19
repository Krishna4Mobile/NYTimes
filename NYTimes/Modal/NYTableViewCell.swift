//
//  NYTableViewCell.swift
//  NYTimes
//
//  Created by mac admin on 19/04/18.
//  Copyright © 2018 mac admin. All rights reserved.
//

import UIKit

class NYTableViewCell: UITableViewCell {

    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var byLineLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
