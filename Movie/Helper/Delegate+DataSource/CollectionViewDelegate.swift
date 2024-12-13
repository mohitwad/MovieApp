//
//  CollectionViewDelegate.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import UIKit
class CollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - variables
    var didSelectIndex: (IndexPath) -> ()
    var didDeselectIndex: ((IndexPath) -> ())?
    var isDynamicWidth: Bool = false
    var sizeForItem: (Int) -> (CGSize)
    var moveItemAt: ((IndexPath,IndexPath) -> ())?
    var sizeForItemWithIndexPath: ((IndexPath) -> (CGSize))?
    var alignCenterCell: Bool = false
    var cellWidth: Int!
    var didEndDecelerating: ((UIScrollView) -> ())?
    var didEndDragging: ((UIScrollView) -> ())?
    var didScroll: ((UIScrollView) -> ())?
    var minimumInterItemSpacing: ((Int) -> (CGFloat))?
    
    var sizeForSectionHeader: ((Int) -> (CGSize))?
    var sizeForSectionFooter: ((Int) -> (CGSize))?
    var willDisplayCell: ((_ cell: UICollectionViewCell,IndexPath) -> ())?
    
    //MARK: - Initializers
    init(didSelectIndex: @escaping (IndexPath) -> (), sizeForItem: @escaping (Int) -> (CGSize), alignCenter: Bool = false, cellWidth: Int = 60, didEndDragging: ((UIScrollView) -> ())? = nil) {
        
        self.didSelectIndex = didSelectIndex
        self.sizeForItem = sizeForItem
        self.alignCenterCell = alignCenter
        self.cellWidth = cellWidth
        self.didEndDragging = didEndDragging
    }
    
    //MARK: - Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectIndex(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        didDeselectIndex?(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return minimumInterItemSpacing?(section) ?? 0
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = cellWidth * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: alignCenterCell ? leftInset : 0.0, bottom: 0, right: alignCenterCell ? rightInset : 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return sizeForItemWithIndexPath?(indexPath) ?? sizeForItem(indexPath.row)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        didEndDragging?(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return self.sizeForSectionHeader?(section) ?? CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return self.sizeForSectionFooter?(section) ?? CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.willDisplayCell?(cell, indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItemAt?(sourceIndexPath,destinationIndexPath)
    }
    
}

