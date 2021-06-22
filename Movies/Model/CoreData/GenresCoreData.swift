//
//  ShoppingListCVModel.swift
//  PAYBACK
//
//  Created by Mohammad Takbir on 6/20/21.
//

import Foundation
import UIKit
import CoreData

protocol GenresCoreDataDelegate {
    func genresList(_ list: [Genre])
}
class GenresCoreData {
    
    var delegate: GenresCoreDataDelegate?
    var managedObjectContext: NSManagedObjectContext!
    var entity: NSManagedObject!
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    init() {
        print("init")
        managedObjectContext = appDelegate!.persistentContainer.viewContext
    }
    
    func readData(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GenresDB")
        do {
            let results = try managedObjectContext.fetch(request)
            var list: [Genre] = []

            for result in results as! [NSManagedObject] {
                let gID = result.value(forKey: "id") as! Int
                let gTitle = "\(result.value(forKey: "title") ?? "")"
                let genre = Genre(name: gTitle, id: gID)
                list.append(genre)
            }
            
            self.delegate?.genresList(list)
            
        }catch let error {
            print("error for fetching from CoreData: \(error.localizedDescription)")
        }
        
    }
    
    func saveData(_ item: [Genre]){
        
        item.forEach { genre in
            
            entity = NSEntityDescription.insertNewObject(forEntityName: "GenresDB", into: managedObjectContext)
            entity.setValue(genre.name, forKey: "title")
            entity.setValue(genre.id, forKey: "id")
            
            do {
                try managedObjectContext.save()
            }catch let error {
                print("error in saving data: \(error.localizedDescription)")
            }
            
        }
    }
    
}

