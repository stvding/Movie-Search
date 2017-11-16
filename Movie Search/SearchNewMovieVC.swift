//
//  AddNewMovieVC.swift
//  How Much Longer
//
//  Created by stvding on 2017/3/2.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchNewMovieVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    let apiKey = "?api_key=2a8ac0dc7b78acc0f7e8917e80c2c94a"
    let usingTitleToGetMovieID = "https://api.themoviedb.org/3/search/movie"
    
    @IBOutlet weak var searching: UIView!
    var movies = [movieData]()
    
    var searchText: String? {
        didSet{
            table.isHidden = false
            movies.removeAll()
            searchText = searchText?.replacingOccurrences(of: " ", with: "%20")
            searchForMovieWoRuntime(title: searchText!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.isHidden = true
        table.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    override func viewWillAppear(_ animated: Bool) {
        if let selectedRow = table.indexPathForSelectedRow{
            table.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    func searchForMovieWoRuntime(title: String){
        let searchURL = usingTitleToGetMovieID + apiKey + "&query=\(title)"
        Alamofire.request(searchURL).responseJSON {(response) in
            self.searching.isHidden = true
            switch response.result {
            case .success(let value):
                self.parseData(data: JSON(value))
            case .failure(let error):
                print (error)
            }
        }
    }
    
    func parseData(data: JSON){
        let dataArray = data["results"].arrayValue
        if dataArray.count == 0 {
            label.isHidden = false
            table.isHidden = true
            label.text = "No result. Spelling error?"
            return
        }
        for data in dataArray {
            let preliminaryData  = movieData(title: data["title"].stringValue,
                                             overview: data["overview"] == "" ? "Unkown Plot" : data["overview"].stringValue,
                                             id: data["id"].intValue,
                                             rating: data["vote_average"] == JSON.null ? -1 : data["vote_average"].doubleValue)
            
            if data["poster_path"] != JSON.null {
                preliminaryData.posterURL = "https://image.tmdb.org/t/p/w640/"+data["poster_path"].stringValue
            }
            if data["release_date"] != "" {
                preliminaryData.year = data["release_date"].stringValue.components(separatedBy: "-")[0]
                preliminaryData.releaseDate = data["release_date"].stringValue
            }else{
                preliminaryData.releaseDate = "Coming soon..."
            }
            movies.append(preliminaryData)
            table.reloadData()
        }
    }
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var SearchBar: UISearchBar!{
        didSet{
            SearchBar.delegate = self
            SearchBar.resignFirstResponder()
            SearchBar.text = searchText
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        label.isHidden = true
        SearchBar.resignFirstResponder()
        self.searchText = SearchBar.text!
        searching.isHidden = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        if movies.count > indexPath.row {
            let movie = movies[indexPath.row]
            if let movieCell = cell as? MovieDataTableViewCell{
                movieCell.movie = movie
            }
        }
        
        
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = table.indexPathForSelectedRow?.row
        
        let posterImageView = table.cellForRow(at: table.indexPathForSelectedRow!)?.contentView.subviews[0].subviews[0].subviews[0] as! UIImageView
        
        movies[indexPath!].poster = posterImageView.image
    
        let detailVC = segue.destination as! MovieDetailVC
        detailVC.data = movies[indexPath!]
    }
    
    @IBAction func rewindToSearchResults(_ segue: UIStoryboardSegue) {
    }
}
