//
//  GenresViewModel.swift
//  Movies
//
//  Created by Mohammad Takbiri on 6/21/21.
//

import Foundation
import TMDBSwift

protocol GenresViewModelDelegate {
    func didFinishFetchGenres(genres: [Genre])
}

class GenresViewModel {
    
    var delegate: GenresViewModelDelegate?
    
    func fetchGenres(){
        
        GenresMDB.genres(listType: .movie, language: "en") { apiReturn, returnedGenres in
            if let returnedGenres = returnedGenres {
                
                var genres:[Genre] = []
                
                returnedGenres.forEach { genre in
                    genres.append(Genre(name: genre.name ?? "", id: genre.id ?? 00))
                }
                
                self.delegate?.didFinishFetchGenres(genres: genres)
            }
            
        }
    }
}
