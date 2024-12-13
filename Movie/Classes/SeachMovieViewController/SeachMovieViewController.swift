//
//  MovieViewController.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import UIKit

class SeachMovieViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var cvMoviesList: UICollectionView!
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //MARK: - Variable
    var viewModel = MovieSearchViewModel()
    private var errorMessageView:ErrorMessageView?
    private var cvDelegate:CollectionViewDelegate?
    private var cvDatasource:CollectionViewDataSource<UICollectionViewCell, String>?
    private var typingTimer: Timer? // Timer for debouncing
    private let typingDelay: TimeInterval = 0.5 // Delay in seconds
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoInternet()
        self.handleCollection()
        bindUI()
        // Do any additional setup after loading the view.
    }
    
    func fetchSearchResult(searchText: String) {
        if let message = self.viewModel.validateSearchQuery(searchText) {
            self.viewModel.movies.value.removeAll()
            self.showToast(message)
            return
        }
        self.viewModel.loadMovies(for: searchText) {[weak self] message in
            if let message {
                self?.viewModel.movies.value.removeAll()
                self?.showToast(message)
            }
        }
    }
    
    //MARK: - SetupNoInternetView
    private func setupNoInternet() {
        errorMessageView = ErrorMessageView(frame: self.cvMoviesList.bounds)
        errorMessageView?.addView(on: self.cvMoviesList, icon: UIImage(named: "noInernet"), text: EmptyMessage.NoInternet.text, attribute: EmptyMessage.NoInternet.attribute, selectHandler: { [weak self] strTap in
            if strTap == EmptyMessage.NoInternet.attribute {
                if let searchText = self?.searchBar.text {
                    self?.fetchSearchResult(searchText: searchText)
                }
            }
        })
        errorMessageView?.hide()
    }
    //MARK: - BindViewModelToUI
    private func bindUI() {
        self.viewModel.isFetching.bind {[weak self] status in
            if status{
                self?.loading.startAnimating()
            }else{
                self?.loading.stopAnimating()
            }
        }
        self.viewModel.hasNoInternet.bind {[weak self] value in
            if value {
                self?.errorMessageView?.updateMessageImage(icon: UIImage(named: "noInernet"), attribute: EmptyMessage.NoInternet.attribute, message: EmptyMessage.NoInternet.text)
                self?.errorMessageView?.show()
            }else {
                self?.errorMessageView?.hide()
            }
        }
        self.viewModel.movies.bind { [weak self] result in
            if result.isEmpty {
                self?.errorMessageView?.updateMessageImage(icon: UIImage(named: "empty"), attribute: EmptyMessage.Search.attribute, message: EmptyMessage.Search.text)
                self?.errorMessageView?.show()
                self?.cvMoviesList.reloadData()
            }else {
                self?.errorMessageView?.hide()
                self?.cvMoviesList.reloadData()
            }
        }
    }
    
    //MARK: CollectionViewSetup
    private func handleCollection() {
        cvMoviesList.registerCustom(MovieCollectionViewCell.self)
        cvDatasource = CollectionViewDataSource(cellForIndexPath: { [weak self] indexPath in
            guard let `self` =  self else { return UICollectionViewCell() }
            if let cell = self.cvMoviesList.dequeueCell(MovieCollectionViewCell.self, indexPath: indexPath) {
                cell.setUpData(model: self.viewModel.movies.value[indexPath.row],isFav: self.viewModel.isMovieFavorited(id: self.viewModel.movies.value[indexPath.row].id ?? 0))
                cell.saveUnsaveClouser = {[weak self] in
                    guard let `self` = self else {return}
                    self.actionSaveUnsave(model: self.viewModel.movies.value[indexPath.row])
                }
                return cell
            }
            return UICollectionViewCell()
        }, sections: 1, rowsInSection: { [weak self] section in
            guard let `self` =  self else { return 0}
            return self.viewModel.movies.value.count
        })
        
        cvDelegate = CollectionViewDelegate(didSelectIndex: { [weak self] indexPath in
            guard let `self` =  self else { return }
            self.openDetailView(model: self.viewModel.movies.value[indexPath.row])
        }, sizeForItem: { int in
            CGSize.zero
        })
        cvMoviesList.delegate = cvDelegate
        cvMoviesList.dataSource = cvDatasource
        cvMoviesList.collectionViewLayout = createCompositionalLayout()
        cvMoviesList.reloadData()
    }
    
    private func openDetailView(model: MovieResults) {
        guard let detailVC = self.storyboard?.instantiateViewController(identifier: "MovieDetailVC") as? MovieDetailVC else { return }
        detailVC.viewModel.selectedMovieId.value = model.id ?? 0
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func actionSaveUnsave(model: MovieResults) {
        self.viewModel.toggleMovieFavoriteStatus(movie: model) {[weak self] message in
            self?.showToast(message)
            self?.cvMoviesList.reloadData()
        }
    }
    
    //MARK: Action
    
    @IBAction func btnShowSavedList(_ sender: Any) {
        guard let savedVC = self.storyboard?.instantiateViewController(identifier: "SavedMovieListVC") as? SavedMovieListVC else { return }
        savedVC.delegate = self
        self.navigationController?.pushViewController(savedVC, animated: true)
    }
}

extension SeachMovieViewController:SavedDelegate {
    func updateDataAfterUnsaveResult() {
        self.cvMoviesList.reloadData()
    }
}
extension SeachMovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.viewModel.movies.value.removeAll()
            return
        }
        self.errorMessageView?.hide()
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: typingDelay, repeats: false) { [weak self] _ in
            self?.fetchSearchResult(searchText: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    
}

