//
//  GenresViewModel.swift
//  Movies
//
//  Created by Mohammad Takbiri on 6/21/21.
//

import Foundation
import TMDBSwift

protocol GenresViewModelDelegate: AnyObject {
    func didFinishFetchGenres(genres: [Genre])
}

class GenresViewModel {
    
    weak var delegate: GenresViewModelDelegate?
    var genresCoreData = GenresCoreData()
    
    func fetchGenres(){
        
        // We will check if the last update was for 24 hours ago or more, if yes we need to update the CoreData with the new data, otherwise we will read the data from the CoreData.
        if let date = UserDefaults.standard.object(forKey: "lastUpdate") as? Date {
            if let difference = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, difference < 24 {
                fetchTheDataFromTheCoreData()
            }else{
                fetchTheDataFromTheOnlineServer()
            }
        }else {
            fetchTheDataFromTheOnlineServer()
        }

    }
    
    private func fetchTheDataFromTheOnlineServer(){
        GenresMDB.genres(listType: .movie, language: "en") { apiReturn, returnedGenres in
            if let returnedGenres = returnedGenres {
                
                var genres:[Genre] = []
                
                returnedGenres.forEach { genre in
                    genres.append(Genre(name: genre.name ?? "", id: genre.id ?? 0))
                }
                
                // Save the current time for deciding to read from the CoreData or the online server in the future.
                UserDefaults.standard.set(Date(), forKey:"lastUpdate")
                
                self.genresCoreData.saveData(genres)
                self.delegate?.didFinishFetchGenres(genres: genres)
                
            }
        }
    }
    
    private func fetchTheDataFromTheCoreData(){
        
        self.genresCoreData.delegate = self
        self.genresCoreData.readData()
        
    }
}

extension GenresViewModel: GenresCoreDataDelegate {
    func genresList(_ list: [Genre]) {
        self.delegate?.didFinishFetchGenres(genres: list)
    }
    
}
