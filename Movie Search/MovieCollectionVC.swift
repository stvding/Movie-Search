//
//  MovieCollectionVC.swift
//  How Much Longer
//
//  Created by stvding on 2017/3/26.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import UIKit

class MovieCollectionVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !movies.isEmpty {
            EmptyLabel.isHidden = true
        }
        
        MovieCollection.delegate = self
        MovieCollection.dataSource = self
        MovieCollection.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        super.viewWillAppear(animated)
        if movies.count > 0 {
            print("will appear \(movies.count)")
            MovieCollection.isHidden = false
        }
        MovieCollection.reloadData()
    }
    // MARK: - data for VC
    var movies = [movieData](){
        didSet{
            EmptyLabel?.isHidden = true
            MovieCollection?.isHidden = false
        }
    }
    @IBOutlet weak var EmptyLabel: UILabel!
    
    
    
    // MARK: - Collection View
    @IBOutlet weak var MovieCollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(movies.count)
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath)
        
        if movies.count > indexPath.row {
            let movie = movies[indexPath.row]
            if let movieCell = cell as? MovieCollectionViewCell{
                movieCell.movie = movie
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = MovieCollection.frame.width / 2 - 10
        return CGSize(width: width, height: width/2*3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: - segue
    @IBAction func addBackToCollection(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? MovieDetailVC {
            if !movies.contains(where: {$0.id == sourceVC.data.id}) {
                movies.append(sourceVC.data)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailOfMovieInCollection" {
            if let vc = segue.destination as? MovieDetailVC {
                vc.data = movies[(MovieCollection.indexPathsForSelectedItems?.first?.row)!]
            }
        }
    }
}
