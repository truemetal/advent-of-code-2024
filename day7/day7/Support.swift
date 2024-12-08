//
//  Support.swift
//  day7
//
//  Created by Bohdan Pashchenko on 08.12.2024.
//

import Foundation

enum Operator {
    case add, mul, concat
}

func combinations<T>(_ elements: [T], length: Int) -> [[T]] {
    if length == 0 { return [[]] }
    if elements.isEmpty { return [] }

    var result = [[T]]()

    for element in elements {
        let subcombinations = combinations(elements, length: length - 1)

        for subcombination in subcombinations {
            result.append([element] + subcombination)
        }
    }

    return result
}

extension Array where Element == Int {
    func evaluate(operators: [Operator]) -> Int {
        if self.isEmpty { return 0 }
        if operators.count != (self.count - 1) { fatalError() }
        var res = self[0]

        for idx in 0 ..< operators.count {
            let op = operators[idx]
            let right = self[idx + 1]

            switch op {
            case .add: res += right
            case .mul: res *= right
            case .concat: res = Int("\(res)\(right)") ?? 0
            }
        }

        return res
    }
}
