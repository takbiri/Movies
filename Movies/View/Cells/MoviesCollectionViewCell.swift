//
//  MoviesCollectionViewCell.swift
//  Movies
//
//  Created by Mohammad Takbiri on 6/21/21.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.layer.cornerRadius = 10
        self.backView.layer.masksToBounds = true
    }

}
