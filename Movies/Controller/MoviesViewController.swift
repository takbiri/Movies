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
        
        updateCollectionView()
    }
    
    func updateCollectionView(){
        
        var columns:CGFloat = 2
        let device = UIDevice.current.userInterfaceIdiom
        
        if device == .pad {
            columns = 4
        }else if device == .phone{
            columns = 2
        }
        
        // Configure collection's cell with custom size
        let width = (self.view.frame.size.width / columns) - 40
        let height = width * 1.5
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20

        collectionView.register(UINib(nibName: "MoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 14, bottom: 15, right: 14)
    }
}

extension MoviesViewController: MoviesViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func didFinishFetchMovies(movies: [Movie]) {
        SVProgressHUD.dismiss()
        
        // Update the collection view with the new datas in the next pages.
        if movies.count != 0 {
            let currentCount = self.movies.count

            self.movies.append(contentsOf: movies)
            
            var indexPaths:[IndexPath] = []
            for i in 0 ..< movies.count {
                indexPaths.append(IndexPath(row: currentCount + i, section: 0))
            }
            self.collectionView.insertItems(at: indexPaths)

        }
        
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

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.movies.count - 2 {
            moviesViewModel.fetchMovies()
        }
    }
}
