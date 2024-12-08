//
//  Part1.swift
//  day7
//
//  Created by Bohdan Pashchenko on 08.12.2024.
//

import Foundation

class Part1 {
    let input: [(Int, [Int])]

    init(contents: String) throws {
        input = try contents
            .components(separatedBy: "\n")
            .map {
                let c = $0.components(separatedBy: ": ")
                let res = try Int(c[0]).throwIfNil()
                let num = try c[1]
                    .components(separatedBy: " ")
                    .map { try Int($0).throwIfNil() }

                return(res, num)
            }
    }

    func solve() throws {
        let validNums = input.filter {
            isValid(res: $0.0, numbers: $0.1)
        }

        let res = validNums
            .map(\.0)
            .reduce(0, +)

        print(res)
    }

    func isValid(res: Int, numbers: [Int]) -> Bool {
        let operators = combinations([Operator.add, .mul], length: numbers.count - 1)

        return operators.contains {
            numbers.evaluate(operators: $0) == res
        }
    }
}
