//
//  UICollectionView+Extension.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import Foundation
import UIKit

protocol ReusableView {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return String(describing: self)
    }
}
extension UICollectionReusableView: ReusableView {}

extension UICollectionView {

    func registerCustom<T: UICollectionViewCell>(_: T.Type) {

        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func registerForSupplementaryHeader<T: UICollectionReusableView>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    func registerForSupplementaryFooter<T: UICollectionReusableView>(_: T.Type) {
          let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
      }
    func isValidIndexPath(indexpath: IndexPath) -> Bool {

        return indexpath.section < self.numberOfSections && indexpath.row < self.numberOfItems(inSection: indexpath.section)
    }
    func dequeueCell<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T? {

        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }

}
