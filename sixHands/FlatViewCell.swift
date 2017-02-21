//
//  FlatViewCell.swift
//  sixHands
//
//  Created by Илья on 20.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class FlatViewCell: UITableViewCell {


    
    @IBOutlet weak var separator: UIImageView!

    @IBOutlet weak var flatImage: UIImageView!
    @IBOutlet weak var subway: UILabel!
    @IBOutlet weak var numberOfRooms: UILabel!
    @IBOutlet weak var mutualFriends: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    let flat = UIImageView()
    let priceLabel = UILabel()
    let subwayLabel = UILabel()
    let rooms = UILabel()
    let views = UILabel()
    let new = UILabel()
    
    let switchButton = UISwitch()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        contentView.addSubview(flat)
        contentView.addSubview(priceLabel)
        contentView.addSubview(subwayLabel)
        contentView.addSubview(rooms)
        contentView.addSubview(views)
        contentView.addSubview(new)
        contentView.addSubview(switchButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
