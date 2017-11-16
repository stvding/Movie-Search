//
//  ViewController.swift
//  How Much Longer
//
//  Created by stvding on 2017/2/23.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TimerCountdownVC: UIViewController {
    var countdownTimer = Timer()
    var start: Date? = nil
    var end: Date? = nil
    var image: UIImage? = nil
    var movieTitle: String? = nil
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieTimeLeftLabel: UILabel!
    @IBOutlet weak var movieEndTimeLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var endDay: UILabel!
    @IBOutlet weak var EndAt: UILabel!
    @IBOutlet weak var EndIn: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    
    let dformatter = DateFormatter()
    let calender = Calendar(identifier: .gregorian)
    
    
    func convertDateIntoCurrentTimezoneInString(_ dateToBeConvert: Date) -> String {
        dformatter.timeZone = TimeZone(abbreviation: "EST")
        dformatter.dateFormat = "HH:mm"
        return dformatter.string(from: dateToBeConvert)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 0.5 * backBtn.bounds.size.width
        self.moviePosterImageView.image = image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        movieTitleLabel.text = movieTitle
        movieEndTimeLabel.text = convertDateIntoCurrentTimezoneInString(end!)
        
        if !calender.isDateInToday(end!) {
            endDay.text = "tomorrow"
        }
        
        countdownTimer.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(updateUI),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    func parse(time: DateComponents) {
        let hours = (time.second ?? 0) / 3600
        let minutes = (time.second ?? 0) / 60 % 60
        let seconds = (time.second ?? 0) % 60
        movieTimeLeftLabel.text = String(format: "%02i:%02i.%02i", hours, minutes, seconds)
    }
    
    func updateUI() {
        let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end!)
        let ETA = Calendar.current.dateComponents([.second], from: Date(), to: start!)
        
        if ETA.second! > 0{
            parse(time: ETA)
            EndIn.text = "starts in"
            return
        } else if timeLeft.second! > 0 {
            parse(time: timeLeft)
            EndIn.isHidden = false
            EndIn.text = "ends in"
            EndAt.text = "Movie ends at"
        } else {
            EndAt.text = "at"
            countdownTimer.invalidate()
            movieTimeLeftLabel.text = "Movie ended"
            movieTimeLeftLabel.font = movieEndTimeLabel.font.withSize(60)
            EndIn.isHidden = true
        }
    }
    
}

