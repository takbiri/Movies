//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Mohammad Takbiri on 6/21/21.
//

import UIKit
import SVProgressHUD
import SDWebImage

class MoviesViewController: UIViewController {
    
    var moviesViewModel = MoviesViewModel()
    var movies:[Movie] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        
        SVProgressHUD.show()
        
        moviesViewModel.delegate = self
        moviesViewModel.fetchMovies()
        
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension MoviesViewController: MoviesViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func didFinishFetchMovies(movies: [Movie]) {
        SVProgressHUD.dismiss()
        
        self.movies = movies
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
        
        cell.movieNameLabel.text = self.movies[indexPath.row].title

        guard let imageURL = URL(string: Utilities.postersBaseURL + self.movies[indexPath.row].poster) else {
            cell.posterImageView.image = UIImage(named: "not-found")
            return cell
        }
        
        cell.posterImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "loading"))
        return cell
    }
}
