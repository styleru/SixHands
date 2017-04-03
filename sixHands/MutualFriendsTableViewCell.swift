//
//  MutualFriendsTableViewCell.swift
//  sixHands
//
//  Created by Илья on 20.03.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class MutualFriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var sn: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
