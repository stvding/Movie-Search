//
//  MovieData.swift
//  How Much Longer
//
//  Created by stvding on 2017/2/28.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import Foundation
import UIKit

class movieData {
    var title: String
    var overview: String? = nil
    var id: Int
    var runtime: Int? //in seconds
    var posterURL: String? = nil
    var poster: UIImage? = nil
    var startTime: Date? = nil
    var endTime: Date? = nil
    var year: String? = nil
    var genres: String? = nil
    var releaseDate: String? = nil
    var rating: Double? = nil
    var credit = [(String,String)]()
    var director: String?
    var creditFetched: Bool = false
    var detailFetched:Bool = false
    
    
    init(title: String, overview: String, id:Int, rating: Double)
    {
        self.title = title
        self.overview = overview
        self.id = id
        self.rating = rating
    }
    
    func allDataAvaliable() -> Bool{
        return (overview != nil)&&(runtime != nil)&&(posterURL != nil)&&(startTime != nil)&&(endTime != nil)&&(year != nil)&&(releaseDate != nil)&&(rating != nil)&&(director != nil)
    }
    
    func showtimeSet() -> Bool{
        return (startTime != nil)&&(endTime != nil)
    }
    
}

