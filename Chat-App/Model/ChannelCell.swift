//
//  ChannelCell.swift
//  Chat-App
//
//  Created by Danny Bokati on 5/24/18.
//  Copyright © 2018 Gtech Developeres. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }

        // Configure the view for the selected state
    }
    
    func setupCell(channel: Channel) {
        guard let channelName = channel.channelName else {return}
        channelLabel.text = "#\(channelName)"
    }

}
