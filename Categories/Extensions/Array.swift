//
//  Array.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import Foundation

extension Array {

    func randomElements(numberElements n: Int) -> [Element] {
        var copy = self
        for i in stride(from: count - 1, to: count - n - 1, by: -1) {
            copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
        return Array(copy.suffix(n))
    }
    
}
