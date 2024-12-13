//
//  SavedViewModelTestCases.swift
//  MovieTests
//
//  Created by Mohit on 13/12/24.
//

import Foundation

import XCTest
@testable import Movie


final class BindableTestCases: XCTestCase {
    
    func testInitialValue() {
        // Arrange
        let initialValue = [1, 2, 3]
        let bindable = Bindable(initialValue)

        // Act & Assert
        XCTAssertEqual(bindable.value, initialValue, "Initial value should match the value passed to the initializer.")
    }

    func testBindListenerIsCalledImmediately() {
        // Arrange
        let initialValue = "Initial"
        let bindable = Bindable(initialValue)
        var observedValue: String?

        // Act
        bindable.bind { value in
            observedValue = value
        }

        // Assert
        XCTAssertEqual(observedValue, initialValue, "Listener should be called immediately with the current value.")
    }

    func testListenerIsCalledOnValueChange() {
        // Arrange
        let initialValue = 0
        let bindable = Bindable(initialValue)
        var observedValues: [Int] = []

        // Act
        bindable.bind { value in
            observedValues.append(value)
        }

        bindable.value = 1
        bindable.value = 2
        bindable.value = 3

        // Assert
        XCTAssertEqual(observedValues, [0, 1, 2, 3], "Listener should be called with the initial and updated values.")
    }

    
    
}
