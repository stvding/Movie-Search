//
//  TheatreInfoTableViewVC.swift
//  How Much Longer
//
//  Created by stvding on 2017/3/3.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

@IBDesignable
class TheatreInfoPopoverVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UISearchBarDelegate {
    var movieData: movieData? = nil
    var showtimes = Dictionary<Int, showtimeInfo>()
    let dformatter = DateFormatter()
    let calender = Calendar(identifier: .gregorian)
    
    let apiKey1 = "&api_key=ary3988rdxaw9v5xnsacy8tk"
    let apiKey2 = "&api_key=vxvjsc4e8yyz2e8kf7k8hbnw"
    let onConnectURL = "http://data.tmsapi.com/v1.1/movies/showings?"
    let radius = "&radius=10"
    let startDate = Date()
    var coordinate = "&lat=37.785834000000001&lng=-122.406417"
    
    var errorAlert = UIAlertController()
    var alert = UIAlertController()
    let locationManager = CLLocationManager()
    let cityManager = CLGeocoder()
    
    @IBOutlet weak var SearchBar: UISearchBar!{
        didSet{
            SearchBar.delegate = self
            SearchBar.resignFirstResponder()
        }
    }
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searching: UIView!
    @IBOutlet weak var LocationSearch: UIView!
    
    @IBOutlet weak var locationBtn: UIButton!
    @IBAction func locationBtnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        SearchBar.text = ""
    }
    @IBOutlet weak var locationLabel: UIButton!
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.resignFirstResponder()
        if let result = SearchBar.text{
            if !result.isEmpty{
                cityManager.geocodeAddressString(result) { (place, error) in
                    if (place?.count == 0 || error != nil) {
                        return
                    }
                    let gps = place?[0].location?.coordinate
                    self.coordinate = "&lat=\((gps?.latitude)!)&lng=\((gps?.longitude)!)"
                    self.locationLabel.setTitle("Location: \((place?[0].name)!)", for: .normal)
                    self.searchShowimeByTitle(title: (self.movieData?.title)!)
                }
                
            }
        }
    }
    var request: String {
        get{
            return (onConnectURL+"startDate="+dformatter.string(from:startDate)+coordinate+radius+apiKey1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.layer.cornerRadius = 20
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        dformatter.timeZone = TimeZone(abbreviation: "EST")
        dformatter.dateFormat = "yyyy"
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
        
        //Set up alert for "No Result"
        alert = UIAlertController(title: "Sorry", message: "No showtime found in nearby theather", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "return",
                                      style: .default,
                                      handler: { (alertAction) in
                                        self.dismiss(animated: true, completion: nil)}))
        
        errorAlert = UIAlertController(title: "Dammit", message: "Something wrong with the network or the OnConnect Server. Basically, you are done for the today.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "return",
                                      style: .default,
                                      handler: { (alertAction) in
                                        self.dismiss(animated: true, completion: nil)}))
        
        
        if let releaseYear = movieData?.year {
            if Int(releaseYear)! < Int(dformatter.string(from: Date()))!-2 {
                if self.presentedViewController == nil {
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print("Already presentd an alert,1")
                }
                return
            }
        }else{
            if self.presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            }else{
                print("Already presentd an alert,1")
            }
            return
        }
        
        dformatter.dateFormat = "yyyy-MM-dd"
        locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searching.isHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
//        manager.delegate = nil
        let location = locations[0].coordinate
        cityManager.reverseGeocodeLocation(locations[0]) { (cityMarkers, error) in
            self.locationLabel.setTitle("Location: \((cityMarkers?[0].name)!)", for: .normal)
        }
        coordinate = "&lat=\(location.latitude)&lng=\(location.longitude)"
        print("search")
        searchShowimeByTitle(title: (movieData?.title)!)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Motherfucking failed?!! with error: \(error)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showtimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TheatreCell", for: indexPath)
        let key = Array(showtimes.keys)[indexPath.row]
        let value = showtimes[key]
        
        if let showtimeCell = cell as? TheatreInfoTableViewCell {
            showtimeCell.showtime = value
        }
        return cell
    }
    
    
    func searchShowimeByTitle(title: String){
        searching.isHidden = false
//        print(request)
        Alamofire.request(request).responseJSON {(response) in
            switch response.result {
            case .success(let value):
                print("sucess!")
                self.parseData(data: JSON(value))
            case .failure(let error):
                if self.presentedViewController == nil {
                    self.present(self.errorAlert, animated: true, completion: {
                        self.LocationSearch.isHidden = true
                        self.searching.isHidden = true
                    })
                }else{
                    print("Already presentd an alert,1")
                }
                
                
                print (error)
                
            }
        }
        locationManager.delegate = self
    }
    
    func parseData(data: JSON){
        self.showtimes.removeAll()
        for movie in data.arrayValue {
            if movie["title"].stringValue == movieData?.title{
                print("found!")
                let showtimes = movie["showtimes"].arrayValue
                for showtime in showtimes {
                    let theatreId = showtime["theatre"]["id"].intValue
                    if self.showtimes[theatreId] != nil{
                        self.showtimes[theatreId]!.addShowtime(newTime: showtime["dateTime"].stringValue)
                        
                    }else{
                        self.showtimes[theatreId] = showtimeInfo(showtime: [showtime["dateTime"].stringValue],
                                                                 theatre: showtime["theatre"]["name"].stringValue)
                    }
                    table.reloadData()
                }
            }
            
        }
        
        self.searching.isHidden = true
        if self.showtimes.count == 0 {
            print("not found")
           if self.presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
           }else{
                print("Already presentd an alert,2")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let timeVC = segue.destination as? ShowtimeSelectionPopoverVC {
            if let indexPath = table.indexPathForSelectedRow?.row{
                let key = Array(showtimes.keys)[indexPath]
                let value = showtimes[key]
                timeVC.info = value
                timeVC.movieData = movieData
            }
        }
    }
}
