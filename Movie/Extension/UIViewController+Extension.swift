//
//  UIViewController+Extension.swift
//  Movie
//
//  Created by Mohit on 13/12/24.
//

import UIKit
extension UIViewController {
    
    //MARK: - CollectionViewLayout
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            return self.layoutSection()
       }
    }
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
    //MARK: - Show Tost Message Alert
    func showToast(_ message: String){
        let messageLbl = UILabel()
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont.systemFont(ofSize: 12)
        messageLbl.textColor = .white
        messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)

        let textSize:CGSize = messageLbl.intrinsicContentSize
        let labelWidth = min(textSize.width,  self.view.frame.width - 40)

        messageLbl.frame = CGRect(x: 20, y:  self.view.frame.height - 90, width: labelWidth + 30, height: textSize.height + 20)
        messageLbl.center.x =  self.view.center.x
        messageLbl.layer.cornerRadius = messageLbl.frame.height/2
        messageLbl.layer.masksToBounds = true
        self.view.addSubview(messageLbl)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

        UIView.animate(withDuration: 1, animations: {
            messageLbl.alpha = 0
        }) { (_) in
            messageLbl.removeFromSuperview()
        }
        }
    }
}
