//
//  Part2.swift
//  day7
//
//  Created by Bohdan Pashchenko on 08.12.2024.
//

import Foundation

@MainActor
class Part2 {
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

    func solve() async throws {
        let validNums: [Int] = await withTaskGroup(of: Int?.self, returning: [Int].self) { group in
            input.forEach { input in
                group.addTask {
                    await self.isValid(res: input.0, numbers: input.1) ? input.0 : nil
                }
            }

            var res: [Int?] = []
            while let next = await group.next() { res.append(next) }
            return res.compactMap(\.self)
        }

        let res = validNums
            .reduce(0, +)

        print(res)
    }

    func isValid(res: Int, numbers: [Int]) -> Bool {
        let operators = getOperatorsCombinations(forLen: numbers.count - 1)

        return operators.contains {
            numbers.evaluate(operators: $0) == res
        }
    }

    func getOperatorsCombinations(forLen len: Int) -> [[Operator]] {
        if let res = cache[len] {
            return res
        }

        let res = combinations([Operator.add, Operator.mul, Operator.concat], length: len)
        cache[len] = res

        return res
    }

    var cache: [Int: [[Operator]]] = [:]
}
