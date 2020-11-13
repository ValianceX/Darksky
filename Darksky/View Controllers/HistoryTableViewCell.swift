//
//  HistoryTableViewCell.swift
//  Darksky
//
//  Created by Sydney Karimi on 11/12/20.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var historyCellLabel: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var mainWeatherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
