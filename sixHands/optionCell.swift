//
//  optionCell.swift
//  sixHands
//
//  Created by Nikita Guzhva on 06/07/2017.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class optionCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
