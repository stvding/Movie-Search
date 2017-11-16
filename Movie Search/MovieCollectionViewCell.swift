//
//  MovieCollectionViewCell.swift
//  How Much Longer
//
//  Created by stvding on 2017/3/26.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var cell: UIView!
    
    var mainImage: UIImage? {
        didSet{
            moviePoster?.image = mainImage
        }
    }
    
    var movie: movieData? {
        didSet {
            updateUI()
        }
    }
    
    
    private func updateUI(){
        moviePoster?.image = nil
        moviePoster.layer.cornerRadius = 10
        cell.layer.cornerRadius = 20
        
        if let movie = self.movie {
            mainImage = movie.poster
        }
    }
}
