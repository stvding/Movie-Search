//
//  MovieDataTableViewCell.swift
//  How Much Longer
//
//  Created by stvding on 2017/2/28.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import UIKit

class MovieDataTableViewCell: UITableViewCell {
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    @IBOutlet weak var cell: UIView!
    
    var mainImage: UIImage? {
        didSet{
            moviePosterImageView?.image = mainImage
        }
    }
    
    var movie: movieData? {
        didSet {
            updateUI()
        }
    }
    
    func fetchImage(){
        mainImage = #imageLiteral(resourceName: "600px-No_image_available")
        if let poster = movie?.posterURL{
            if let posterURL = URL(string: poster){
                DispatchQueue.global(qos: .userInitiated).async {
                    if let posterData = try? Data(contentsOf: posterURL){
                        DispatchQueue.main.async {
                            if posterURL == URL(string: (self.movie?.posterURL)!) {
                                self.mainImage = UIImage(data: posterData)!
                            }
                        }
                    }
                }
            }
        }

    }
    
    private func updateUI(){
        mainImage = nil
        movieTitleLabel?.text = nil
        movieOverviewLabel?.text = nil
        moviePosterImageView.layer.cornerRadius = 10
        cell.layer.cornerRadius = 20
        
        if let movie = self.movie {
            movieTitleLabel.text = movie.title
            movieOverviewLabel?.text = movie.overview
            fetchImage()
        }
    }
}
