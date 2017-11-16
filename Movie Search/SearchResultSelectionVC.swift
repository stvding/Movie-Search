////
////  SearchResultSelectionVC.swift
////
////
////  Created by stvding on 2017/2/27.
////
////
//
//import UIKit
//import Alamofire
//import SwiftyJSON
//
//class searchResultSelectionVC: UITableViewController,UISearchBarDelegate {
//    let apiKey = "?api_key=2a8ac0dc7b78acc0f7e8917e80c2c94a"
//    let usingTitleToGetMovieID = "https://api.themoviedb.org/3/search/movie"
//    let usingIDToGetMovieDetail = "https://api.themoviedb.org/3/movie/"
//    
//    var movies = [movieData]()
//    
//    var searchText: String? {
//        didSet{
//            movies.removeAll()
//            searchText = searchText?.replacingOccurrences(of: " ", with: "%20")
//            searchForMovieWoRuntime(title: searchText!)
//        }
//    }
//    
//    
//    func searchForRuntime(indexPath: Int){
//        let movie = movies[indexPath]
//        let searchURL = usingIDToGetMovieDetail + String(movie.id) + apiKey
//        Alamofire.request(searchURL).responseJSON{(detail) in
//            switch detail.result {
//            case .success(let value):
//                movie.runtime = JSON(value)["runtime"].intValue * 60
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    func searchForMovieWoRuntime(title: String){
//        let searchURL = usingTitleToGetMovieID + apiKey + "&query=\(title)"
//        Alamofire.request(searchURL).responseJSON {(response) in
//            switch response.result {
//            case .success(let value):
//                self.parseData(data: JSON(value))
//            case .failure(let error):
//                print (error)
//            }
//        }
//    }
//
//    func parseData(data: JSON){
//        let dataArray = data["results"].arrayValue
//        for data in dataArray {
//            let preliminaryData  = movieData(title: data["title"].stringValue,
//                                                overview: data["overview"].stringValue,
//                                                id: data["id"].intValue,
//                                                runtime: nil,
//                                                poster: nil,
//                                                posterURL: nil,
//                                                startTime: nil,
//                                                endTime: nil,
//                                                year: data["year"].stringValue)
//            
//            if data["poster_path"] != JSON.null {
//                preliminaryData.posterURL = (string: "https://image.tmdb.org/t/p/w640/"+data["poster_path"].stringValue)
//            }
//            
//            movies.append(preliminaryData)
//            self.tableView.reloadData()
//        }
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return movies.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
//        
//        let movie = movies[indexPath.row]
//        if let movieCell = cell as? MovieDataTableViewCell{
//            movieCell.movie = movie
//        }
//        
//        return cell
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    @IBOutlet weak var searchBar: UISearchBar!{
//        didSet{
//            searchBar.delegate = self
//            searchBar.text = searchText
//        }
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchText = searchBar.text!
//    }
//    
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        let indexPath = tableView.indexPathForSelectedRow?.row
////        searchForRuntime(indexPath: indexPath!)
////        
////        
////        let tabcon = segue.destination as! UITabBarController
////        if let navcon = tabcon.viewControllers![1] as? UINavigationController{
////            if let manual = navcon.viewControllers[0] as? TimeSelectionVC{
////                manual.data = movies[indexPath!]
////            }
////        }
////        if let navcon = tabcon.viewControllers![0] as? UINavigationController{
////            if let lookup = navcon.visibleViewController as? TheatreInfoTableViewVC{
////                lookup.movieData = movies[indexPath!]
////            }
////        }
////        
////        print(movies[indexPath!].runtime ?? "not avaiable")
//    }
//    
//}
