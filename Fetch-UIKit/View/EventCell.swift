//
//  EventCell.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/17/21.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
