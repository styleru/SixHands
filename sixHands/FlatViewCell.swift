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
    @IBOutlet var subwayColor: UIImageView!
    @IBOutlet weak var numberOfRooms: UILabel!
    
    @IBOutlet var dot: UIImageView!
    @IBOutlet weak var mutualFriends: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    let flat = UIImageView()
    let priceLabel = UILabel()
    let subwayLabel = UILabel()
    let rooms = UILabel()
    let edit = UIButton()
    let sep = UIImageView()
    
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
        contentView.addSubview(sep)
        contentView.addSubview(priceLabel)
        contentView.addSubview(subwayLabel)
        contentView.addSubview(rooms)
        contentView.addSubview(switchButton)
        contentView.addSubview(edit)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
