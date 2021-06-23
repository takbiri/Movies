//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Mohammad Takbiri on 6/21/21.
//

import Foundation
import TMDBSwift

protocol MoviesViewModelDelegate: AnyObject {
    func didFinishFetchMovies(movies: [Movie])
}

class MoviesViewModel {
    
    weak var delegate: MoviesViewModelDelegate?
    var genreID: Int!
    var page:Double = 1
    
    func fetchMovies(){
        
        DiscoverMovieMDB.genreList(genreId: genreID, page: page) { apiReturn, returnedMovies in
            print("page number :\(self.page)")
            var movies:[Movie] = []
            
            returnedMovies?.forEach({ movie in
                movies.append(Movie(title: movie.original_title ?? "", poster: movie.poster_path ?? ""))
            })
            
            self.delegate?.didFinishFetchMovies(movies: movies)
            self.page += 1
            
        }
    }
}
