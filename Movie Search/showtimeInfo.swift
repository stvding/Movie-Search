//
//  showtimeInfo.swift
//  How Much Longer
//
//  Created by stvding on 2017/3/3.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import Foundation



class showtimeInfo {
    var showtime: [String]
    var theatre: String
    
    init(showtime: [String], theatre: String) {
        self.showtime = showtime
        self.theatre = theatre
    }
    
    func addShowtime(newTime: String) {
        showtime.append(newTime)
        showtime = Array(Set(showtime))
        showtime.sort()
    }
}
