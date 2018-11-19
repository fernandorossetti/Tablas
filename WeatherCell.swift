//
//  WeatherCell.swift
//  WeatherFeedBase
//
//  Created by fernando rossetti 12/12/16.
//  Copyright © 2016 NextU. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
