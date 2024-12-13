//
//  MovieCollectionViewCell.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {

    //MARK: - IBOutlet
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var btnfavourite: UIButton!
    @IBOutlet weak var lblMovieReleaseDate: UILabel!
    
    //MARK: - Variable
    var saveUnsaveClouser:(()->Void)?
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMovie.layer.cornerRadius = 8
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgMovie.image = nil
    }
    
    func setUpData(model: MovieResults, isFav: Bool) {
        self.lblMovieTitle.text = model.originalTitle
        if let releaseDate = model.releaseDate, !releaseDate.isEmpty {
            self.lblMovieReleaseDate.text = "Date : \(releaseDate)"
        }else {
            self.lblMovieReleaseDate.text = "NA"
        }
        self.btnfavourite.isSelected = isFav
        if let image = model.posterPath, let imageUrl = URL(string: AppConstants.API.imageBaseURL + image) {
            self.imgMovie.sd_setImage(with: imageUrl)
        }else {
            self.imgMovie.image = UIImage(named: "placeHolder")
        }
    }
    
    
    //MARK: - Action
    @IBAction func btnSaveUnsave(_ sender: Any) {
        self.saveUnsaveClouser?()
    }
}
