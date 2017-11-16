//
//  MovieDetailVC.swift
//  How Much Longer
//
//  Created by stvding on 2017/3/5.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MovieDetailVC: UIViewController {
    var data: movieData = movieData(title: "", overview: "", id: 0, rating: 99)
    
    let apiKey = "?api_key=2a8ac0dc7b78acc0f7e8917e80c2c94a"
    var usingIDToGetMovieDetail: String {
        get{
            return "https://api.themoviedb.org/3/movie/"+String(data.id)+apiKey
        }
    }
    var usingIDtOGetCastInfo: String {
        get{
            return "https://api.themoviedb.org/3/movie/"+String(data.id)+"/credits" + apiKey
        }
    }
    var countdownTimer = Timer()
    let dformatter = DateFormatter()
    let calender = Calendar(identifier: .gregorian)
    
    @IBOutlet weak var addToCollectionBtn: UIButton! //todo
    @IBAction func addToCollection(_ sender: Any) {
//            let vc = destination as! UINavigationController
//            let detailVC = vc.visibleViewController as! MovieCollectionVC
//            detailVC.movies.append(data)
        
    } //todo
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startInLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var castsLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overviewtitleLabel: UILabel!
    @IBOutlet weak var castTitleLabel: UILabel!
    @IBOutlet weak var overviewScrolling: UIScrollView!
    @IBOutlet weak var castScrolling: UIScrollView!
    @IBOutlet weak var searchForShowtimeBtn: UIButton!
    @IBOutlet weak var castScrollingView: UIView!
    @IBOutlet weak var castScrollBottom: NSLayoutConstraint!
    @IBOutlet weak var castScrollTop: NSLayoutConstraint!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        overviewtitleLabel.layer.cornerRadius = 5
        overviewtitleLabel.layer.masksToBounds = true
        overviewScrolling.layer.borderWidth = 1
        overviewScrolling.layer.cornerRadius = 10
        
        castTitleLabel.layer.cornerRadius = 5
        castTitleLabel.layer.masksToBounds = true
        castScrolling.layer.borderWidth = 1
        castScrolling.layer.cornerRadius = 10
        
        searchForShowtimeBtn.layer.cornerRadius = 10
        addToCollectionBtn.layer.cornerRadius = 10
        
        posterImage.layer.cornerRadius = 10
        
        startInLabel.isHidden = true
        timerLabel.isHidden = true
        searchForShowtimeBtn.isHidden = true
        
        if !(data.creditFetched && data.detailFetched) {
            print("fetching data...")
            DispatchQueue.global(qos: .userInitiated).async {
                self.searchForDetailedInfo(movieId: self.data.id)
            }
        }else{
            print("fetch new info")
            updateUI_castInfo()
            updateUI_movieInfo()
        }
        
        if data.showtimeSet(){
            
            print("new time")
            startInLabel.isHidden = false
            timerLabel.isHidden = false
            countdownTimer.invalidate()
            countdownTimer = Timer.scheduledTimer(timeInterval: 1,
                                                  target: self,
                                                  selector: #selector(countdown),
                                                  userInfo: nil, repeats: true)
        }
    }
    
    deinit {
        print("deinit")
        
    }

    @IBAction func showFullScreenCountDown(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended{
            performSegue(withIdentifier: "showFullScreenCountdown", sender: self)
        }
    }
    
    func parse(time: DateComponents) {
        let hours = (time.second ?? 0) / 3600
        let minutes = (time.second ?? 0) / 60 % 60
        let seconds = (time.second ?? 0) % 60
        timerLabel.text = String(format: "%02i:%02i.%02i", hours, minutes, seconds)
    }
    
    func countdown(){
        if countdownTimer.isValid {
            let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: (data.endTime)!)
            let ETA = Calendar.current.dateComponents([.second], from: Date(), to: (data.startTime)!)
            
            if ETA.second! > 0{
                parse(time: ETA)
                startInLabel.text = "Your movie starts in"
                return
            }else if timeLeft.second! > 0 {
                parse(time: timeLeft)
                startInLabel.isHidden = false
                startInLabel.text = "Your movie ends in"
            }else {
                countdownTimer.invalidate()
                print("timer gone")
                timerLabel.text = "Movie ended"
                timerLabel.font = timerLabel.font.withSize(40)
                startInLabel.isHidden = true
                
                UIView.animate(withDuration: 5, delay: 5, options: .curveEaseInOut, animations: {
                    self.timerLabel.alpha = 0
                    self.timerLabel.transform = CGAffineTransform(scaleX: 10, y: 10)
                }, completion: { (done) in
                    if done {
                        print("gone")
                        self.timerLabel.isHidden = true
                        self.timerLabel.transform = .identity
                    }
                })
            }
        } else {
            self.data.startTime = nil
            self.data.endTime = nil
        }
    }
    
    func updateUI_movieInfo(){
        titleLabel.text = data.title
        typeLabel.text = data.genres
        releaseDateLabel.text = data.releaseDate
        
        let rating = data.rating! >= 0.0 ? String(data.rating!) : "?"
        ratingLabel.text = "⭐ " + rating + "/10"
        
        if let runtime = data.runtime {
            print(data.runtime)
            runtimeLabel.text = String(runtime / 60) + " minutes"
        } else{ runtimeLabel.text = "Unkown runtime" }
        
        overviewLabel.text = data.overview
        posterImage.image = data.poster!
//        fullScreenPoster.image = data.poster!
        backgroundImageView.image = data.poster!
        
        if data.posterURL != nil && data.poster == #imageLiteral(resourceName: "600px-No_image_available"){
            print("regrab")
            regrabImage()
        }
        dformatter.dateFormat = "yyyy"
        if let year = data.year{
            if Int(dformatter.string(from: Date()))! - Int(year)! <= 1 {
                searchForShowtimeBtn.isHidden = false
            }
        }
    }
    
    func updateUI_castInfo(){
        directorLabel.text = data.director ?? "Unkown director"
        
        let str = NSMutableAttributedString()
        for (cast, charactor) in data.credit{
            let bold = NSMutableAttributedString(string: cast, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)])
            let italian = NSMutableAttributedString(string: " as "+charactor, attributes: [NSFontAttributeName: UIFont.italicSystemFont(ofSize: 17)])
            str.append(bold)
            str.append(italian)
            str.append(NSAttributedString(string: "\n"))
        }
        castsLabel.attributedText = str.length == 0 ? NSAttributedString(string:"Cast Unkown") : str
    }
    
    func searchForDetailedInfo(movieId: Int){
        Alamofire.request(usingIDToGetMovieDetail).responseJSON{(detail) in
            switch detail.result {
            case .success(let value):
                print(self.data.id)
                self.data.runtime = JSON(value)["runtime"].intValue * 60
                
                let genres = JSON(value)["genres"].arrayValue
                var str = "Unknown genre"
                if genres.count != 0 {
                    str = ""
                    for (index,genre) in genres.enumerated(){
                        str += genre["name"].stringValue
                        if index < genres.count-1 { str += ", "}
                    }
                }
                self.data.genres = str
                self.data.detailFetched = true
                self.updateUI_movieInfo()
            case .failure(let error):
                print(error)
            }
        }
        if data.credit.count == 0 {
            Alamofire.request(usingIDtOGetCastInfo).responseJSON{(detail) in
                switch detail.result {
                case .success(let value):
                    var credit = [(String,String)]()
                    for cast in JSON(value)["cast"].arrayValue{
                        credit.append((cast["name"].stringValue, cast["character"].stringValue))
                    }
                    self.data.credit = credit
                    
                    for crew in JSON(value)["crew"].arrayValue {
                        if crew["job"].stringValue == "Director" { // Get director
                            self.data.director = crew["name"].stringValue
                            break
                        }
                    }
                    self.data.creditFetched = true
                    self.updateUI_castInfo()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func regrabImage(){
        if let poster = data.posterURL{
            if let posterURL = URL(string: poster){
                DispatchQueue.global(qos: .userInitiated).async {
                    if let posterData = NSData(contentsOf: posterURL){
                        DispatchQueue.main.async {
                            self.data.poster = UIImage(data: posterData as Data)!
                            self.posterImage.image = UIImage(data: posterData as Data)!
                            self.backgroundImageView.image = UIImage(data: posterData as Data)!
                        }
                    }
                }
            }
        }
    }
    
//    @IBOutlet weak var fullScreenPoster: UIImageView!
//    var imageFullScreen = false
    
//    
//    @IBAction func tapToGoFullScreen(_ sender: UITapGestureRecognizer) {
//        if !imageFullScreen {
//            fullScreenPoster.isHidden = false
//        }else{
//            fullScreenPoster.isHidden = true
//        }
//        imageFullScreen = !imageFullScreen
//    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if segue.identifier == "showFullScreenCountdown" {
            let vc = destination as! TimerCountdownVC
            vc.start = data.startTime
            vc.end = data.endTime
            vc.image = data.poster
            vc.movieTitle = data.title
        } else if segue.identifier == "showTheaterInfo" {
            let vc = destination as! TheatreInfoPopoverVC
            vc.movieData = data
        }
    }
    
    @IBAction func rewindToMovieDetailVC(_ segue: UIStoryboardSegue) { }
}
