//
//  FlatViewCell.swift
//  sixHands
//
//  Created by Илья on 20.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class FlatViewCell: UITableViewCell {

    @IBOutlet weak var flatImage: UIImageView!
    @IBOutlet weak var subway: UILabel!
    @IBOutlet weak var numberOfRooms: UILabel!
    @IBOutlet weak var mutualFriends: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
