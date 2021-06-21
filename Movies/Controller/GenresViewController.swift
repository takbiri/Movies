//
//  GenresViewController.swift
//  Movies
//
//  Created by Mohammad Takbiri on 6/21/21.
//

import UIKit
import SVProgressHUD

class GenresViewController: UIViewController {

    var genresViewModel = GenresViewModel()
    var genres:[Genre] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView(){
        SVProgressHUD.show()
        genresViewModel.delegate = self
        genresViewModel.fetchGenres()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension GenresViewController: GenresViewModelDelegate, UITableViewDelegate, UITableViewDataSource {
    func didFinishFetchGenres(genres: [Genre]) {
        
        SVProgressHUD.dismiss()
        self.genres = genres
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = genres[indexPath.row].name
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showMovies", sender: self.genres[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovies" {
            let vc = segue.destination as! MoviesViewController
            vc.moviesViewModel.genreID = sender as? Int
        }
    }
}
