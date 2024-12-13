//
//  SavedMovieListVC.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import UIKit
protocol SavedDelegate:NSObject {
    func updateDataAfterUnsaveResult()
}


class SavedMovieListVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var cvSavedMoviesList: UICollectionView!
    
    //MARK: - Variable
    private var errorMessageView:ErrorMessageView?
    weak var delegate: SavedDelegate?
    var viewModel = SavedMoviesViewModel()
    var cvDelegate:CollectionViewDelegate?
    var cvDatasource:CollectionViewDataSource<UICollectionViewCell, String>?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleCollection()
        setupNoDataView()
        bindUI()
        getSavedMoviewList()

        // Do any additional setup after loading the view.
    }
    //MARK: - SetupNoInternetView
    private func setupNoDataView() {
        
        errorMessageView = ErrorMessageView(frame: self.cvSavedMoviesList.bounds)
        errorMessageView?.addView(on: self.cvSavedMoviesList, icon: UIImage(named: "emptySave"), text: EmptyMessage.Saved.text, attribute:"", selectHandler: { strTap in })
        errorMessageView?.hide()
    }
    
    func bindUI() {
        self.viewModel.movieList.bind { [weak self] result in
            if result.isEmpty {
                self?.errorMessageView?.show()
            } else {
                self?.errorMessageView?.hide()
                self?.cvSavedMoviesList.reloadData()
            }
        }
    }
    
    func getSavedMoviewList() {
        self.viewModel.fetchAllSavedMovies()
    }
    
    //MARK: CollectionViewSetup
    private func handleCollection() {
        cvSavedMoviesList.registerCustom(MovieCollectionViewCell.self)
        cvDatasource = CollectionViewDataSource(cellForIndexPath: { [weak self] indexPath in
            guard let `self` =  self else { return UICollectionViewCell() }
            if let cell = self.cvSavedMoviesList.dequeueCell(MovieCollectionViewCell.self, indexPath: indexPath) {
                cell.setUpData(model: self.viewModel.movieList.value[indexPath.row],isFav: self.viewModel.isMovieSaved(id: self.viewModel.movieList.value[indexPath.row].id ?? 0))
                cell.saveUnsaveClouser = {[weak self] in
                    guard let `self` = self else {return}
                    self.actionSaveUnsave(model: self.viewModel.movieList.value[indexPath.row])
                }
                return cell
            }
            return UICollectionViewCell()
        }, sections: 1, rowsInSection: { [weak self] section in
            guard let `self` =  self else { return 0}
            return self.viewModel.movieList.value.count
        })
        
        cvDelegate = CollectionViewDelegate(didSelectIndex: { [weak self] indexPath in
            guard let `self` =  self else { return }
            self.openDetailView(model: self.viewModel.movieList.value[indexPath.row])
        }, sizeForItem: { int in
            CGSize.zero
        })
        cvSavedMoviesList.delegate = cvDelegate
        cvSavedMoviesList.dataSource = cvDatasource
        cvSavedMoviesList.collectionViewLayout = createCompositionalLayout()
        cvSavedMoviesList.reloadData()
    }
    
    func openDetailView(model: MovieResults) {
        guard let detailVC = self.storyboard?.instantiateViewController(identifier: "MovieDetailVC") as? MovieDetailVC else { return }
        detailVC.viewModel.selectedMovieId.value = model.id ?? 0
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func actionSaveUnsave(model: MovieResults) {
        self.viewModel.toggleSaveStatus(for: model) {[weak self] message in
            self?.showToast(message)
            self?.viewModel.fetchAllSavedMovies()
            self?.delegate?.updateDataAfterUnsaveResult()
        }
    }
}
