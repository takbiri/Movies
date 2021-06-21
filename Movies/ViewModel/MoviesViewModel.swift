//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Mohammad Takbiri on 6/21/21.
//

import Foundation
import TMDBSwift

protocol MoviesViewModelDelegate {
    func didFinishFetchMovies(movies: [Movie])
}
class MoviesViewModel {
    
    var genreID: Int!
    var delegate: MoviesViewModelDelegate?
    
    
    func fetchMovies(){
        
        DiscoverMovieMDB.genreList(genreId: 12, page: 1) { apiReturn, returnedMovies in
            
            var movies:[Movie] = []
            
            returnedMovies?.forEach({ movie in
                movies.append(Movie(title: movie.original_title ?? "", poster: movie.poster_path ?? ""))
            })
            
            self.delegate?.didFinishFetchMovies(movies: movies)
            
        }
    }
}
