//
//  CollectionViewDataSource.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import UIKit
class CollectionViewDataSource<Cell: UICollectionViewCell, ViewModel>: NSObject, UICollectionViewDataSource {
    
    //MARK: - Variables
    private var cellIdentifier: String!
    var items: [ViewModel]?
    var configureCell: ((Cell, ViewModel) -> ())?
    var numberOfSections = 1
    var canMoveItem: ((IndexPath) -> (Bool))?
    var cellForIndexPath: ((IndexPath) -> UICollectionViewCell)?
    var rowsInSection: ((Int) -> (Int))?
    
    var sectionHeaderView: ((IndexPath) -> (UICollectionReusableView))?
    var sectionFooterView: ((IndexPath) -> (UICollectionReusableView))?
         
    //MARK: - Initializers
    init(cellIdentifier: String, items: [ViewModel], configureCell: @escaping (Cell, ViewModel) -> ()) {
        
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    init(cellForIndexPath: @escaping ((IndexPath) -> UICollectionViewCell), sections: Int, rowsInSection: @escaping (Int) -> (Int)) {
        self.cellForIndexPath = cellForIndexPath
        self.numberOfSections = sections
        self.rowsInSection = rowsInSection
    }
    
//    //MARK: - Skeleton Functions
//    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return skeletonItemsCount?() ?? 0
//    }
//    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
//
//        return skeletonIdentifier?() ?? cellIdentifier
//    }
    
    
    //MARK: - Functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.numberOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let rows = self.rowsInSection {
            return rows(section)
        }
        return (items!.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = cellForIndexPath?(indexPath) {
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! Cell
        
        cell.tag = indexPath.row
        let item = items?[indexPath.row]
        self.configureCell?(cell, item!)
        
        return cell
    }
    
    func updateCollectionViewItems(items: [ViewModel]?) {
        
        if items != nil{
            self.items = items
        }
    }
    func updateItemAtIndex(item: ViewModel, index: Int) {
        
        if self.items != nil && self.items!.count > index {
            self.items![index] = item
        }
    }
    func insertItem(item: ViewModel, index: Int) {
        
        if items?.count ?? 0 < index { return }
         self.items?.insert(item, at: index)
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            return self.sectionHeaderView?(indexPath) ?? UICollectionReusableView()
        case UICollectionView.elementKindSectionFooter:
            
            return self.sectionFooterView?(indexPath) ?? UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
    
}
