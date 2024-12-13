//
//  MovieDetailVC.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblMovieTItle: UILabel!
    @IBOutlet weak var lblMovieDescription: UILabel!
    @IBOutlet weak var lblMovieReleaseDate: UILabel!
    @IBOutlet weak var lblMovieRating: UILabel!
    @IBOutlet weak var lblMoviePopularity: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //MARK: - Variable
    var viewModel = MovieDetailViewModel()
    private var errorMessageView:ErrorMessageView?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoInternet()
        bindUI()
        fetchMovieDetails()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - NoInternetView
    private func setupNoInternet() {
        errorMessageView = ErrorMessageView(frame: self.view.bounds)
        errorMessageView?.addView(on: self.view, icon: UIImage(named: "noInernet"), text: EmptyMessage.NoInternet.text, attribute: EmptyMessage.NoInternet.attribute, selectHandler: { [weak self] strTap in
            if strTap == EmptyMessage.NoInternet.attribute {
                self?.fetchMovieDetails()
            }
        })
        errorMessageView?.hide()
    }
    
    //MARK: - Call APi
    func fetchMovieDetails() {
        self.viewModel.fetchMovieDetails() {[weak self] message in
            if let message {
                self?.showToast(message)
            }
        }
    }
    
    //MARK: - BindUIWIthViewModel
    func bindUI() {
        self.viewModel.isFetching.bind {[weak self] status in
            if status{
                self?.loading.startAnimating()
            }else{
                self?.loading.stopAnimating()
            }
        }
        self.viewModel.hasNoInternetConnection.bind {[weak self] value in
            if value {
                self?.errorMessageView?.show()
            }else {
                self?.errorMessageView?.hide()
            }
        }
        self.viewModel.movieDetails.bind {[weak self] movieDetailModel in
            guard let movieDetailModel = movieDetailModel else {return}
            if let _ = movieDetailModel.success {
                self?.showToast(movieDetailModel.statusMessage ?? "")
                self?.scrollView.isHidden = true
            }else {
                self?.scrollView.isHidden = false
                self?.setUpUI(movieModel: movieDetailModel)
            }
            
        }
    }
    
    func setUpUI(movieModel: MovieDetailModel) {
        self.imgMovie.layer.cornerRadius = 10
        self.lblMovieTItle.text = movieModel.originalTitle
        self.lblMovieDescription.text = movieModel.overview
        if let releaseDate = movieModel.releaseDate, !releaseDate.isEmpty {
            self.lblMovieReleaseDate.text = releaseDate
        }else {
            self.lblMovieReleaseDate.text = "NA"
        }
       
        if let voteAvg = movieModel.voteAverage {
            self.lblMovieRating.text = "\(voteAvg)"
        }
        if let popularity = movieModel.popularity {
            self.lblMoviePopularity.text = "\(popularity)"
        }
        if let image = movieModel.posterPath, let imageUrl = URL(string: AppConstants.API.imageBaseURL + image) {
            self.imgMovie.sd_setImage(with: imageUrl)
        }else {
            self.imgMovie.image = UIImage(named: "placeHolder")
        }
        
    }
}
