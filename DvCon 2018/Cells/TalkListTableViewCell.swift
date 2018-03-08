//
//  TalkListTableViewCell.swift
//  DvCon
//
//  Created by Aubhro Sengupta on 1/25/17.
//  Copyright © 2017 Aubhro Sengupta. All rights reserved.
//

import UIKit

class TalkListTableViewCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
