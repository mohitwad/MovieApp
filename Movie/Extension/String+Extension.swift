//
//  UIString+Extension.swift
//  Movie
//
//  Created by Mohit on 13/12/24.
//

import Foundation


extension Array {
    
    func isValidIndex(index: Int) -> Bool {
        
        if [Int](0..<self.count).contains(index) {
            return true
        }
        return false
    }
    
}
