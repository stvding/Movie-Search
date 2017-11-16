//
//  TheatreInfoTableViewCell.swift
//  How Much Longer
//
//  Created by stvding on 2017/3/3.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import UIKit

class TheatreInfoTableViewCell: UITableViewCell {
    
    var showtime:showtimeInfo?{
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        if let showtime = self.showtime{
            nameLabel.text = showtime.theatre
            var combinedShowtimes = String()
            for time in showtime.showtime{
                combinedShowtimes += time.components(separatedBy: "T")[1] + "    "
            }
            showtimeLabel.text = combinedShowtimes
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var showtimeLabel: UILabel!
    
    
}
