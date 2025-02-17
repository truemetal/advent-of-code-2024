import Foundation

class Part1 {
    let numbers: [Int]

    init(contents: String) throws {
        numbers = contents.split(separator: "\n").compactMap(\.str.int)
    }

    func solve() throws {
        let res = numbers.map(numberAfter2kIterations(n:)).reduce(0, +)
        print("Part 1:", res)
    }

    func numberAfter2kIterations(n: Int) -> Int {
        var n = n
        for _ in 0 ..< 2000 {
            n = nextNumber(for: n)
        }
        return n
    }

    func nextNumber(for number: Int) -> Int {
        var number = number
        number = (number ^ (number * 64)) % 16777216
        number = (number ^ (number / 32)) % 16777216
        number = number ^ (number * 2048) % 16777216
        return number
    }
}
