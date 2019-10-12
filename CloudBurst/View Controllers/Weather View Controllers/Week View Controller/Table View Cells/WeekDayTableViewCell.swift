//
//  WeekDayTableViewCell.swift
//  CloudBurst
//
//  Created by Decheng Ma on 1/10/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import UIKit

class WeekDayTableViewCell: UITableViewCell {
    
    // Mark: - Properties
    
    @IBOutlet var dayLabel: UILabel! {
        didSet {
            dayLabel.textColor = .baseTextColor
            dayLabel.font = .heavyLarge
        }
    }
    
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = .black
            dateLabel.font = .lightRegular
        }
    }
    
    @IBOutlet var windSpeedLabel: UILabel! {
        didSet {
            windSpeedLabel.textColor = .black
            windSpeedLabel.font = .lightSmall
        }
    }
    
    @IBOutlet var temperatureLabel: UILabel! {
        didSet {
            temperatureLabel.textColor = .black
            temperatureLabel.font = .lightSmall
        }
    }
    
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.tintColor = .baseTintColor
        }
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
       
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with representable: WeekDayRepresentable) {
        dayLabel.text = representable.day
        dateLabel.text = representable.date
        iconImageView.image = representable.image
        windSpeedLabel.text = representable.windSpeed
        temperatureLabel.text = representable.temperature
    }

}
