import Foundation

class Part2 {
    let numbers: [Int]
    let reportProgress: Bool

    init(contents: String, reportProgress: Bool) throws {
        numbers = contents.split(separator: "\n").compactMap(\.str.int)
        self.reportProgress = reportProgress
    }

    func solve() throws {
        var allPrices: [[Int]] = []
        var allChanges: [[Int]] = []
        var allPriceForSequence: [[[Int]: Int]] = []
        var allSequences: Set<[Int]> = []

        for n in numbers {
            let prices = pricesFor2kIterations(n: n)
            let changes = zip([n % 10] + prices, prices).map { $1 - $0 }

            allPrices.append(prices)
            allChanges.append(changes)

            var priceForSequence: [[Int]: Int] = [:]
            var keys: Set<[Int]> = []

            for seqStartIdx in 0 ..< (2000 - 3) {
                let seq = changes[seqStartIdx ..< (seqStartIdx + 4)].arr
                if !keys.contains(seq) {
                    priceForSequence[seq] = prices[seqStartIdx + 3]
                    keys.insert(seq)
                    allSequences.insert(seq)
                }
            }

            allPriceForSequence.append(priceForSequence)
        }

        var max = 0

        for (idx, seq) in allSequences.enumerated() {
            let currentSum = allPriceForSequence.map { $0[seq] ?? 0 }.reduce(0, +)
            max = Swift.max(max, currentSum)
            if reportProgress { print("\(idx) / \(allSequences.count)") }
        }

        print("Part 2:", max)
    }

    func numberAfter2kIterations(n: Int) -> Int {
        var n = n
        for _ in 0 ..< 2000 {
            n = nextNumber(for: n)
        }
        return n
    }

    func pricesFor2kIterations(n: Int) -> [Int] {
        var res: [Int] = []
        var n = n
        for _ in 0 ..< 2000 {
            n = nextNumber(for: n)
            res.append(n % 10)
        }
        return res
    }

    func nextNumber(for number: Int) -> Int {
        var number = number
        number = (number ^ (number * 64)) % 16777216
        number = (number ^ (number / 32)) % 16777216
        number = number ^ (number * 2048) % 16777216
        return number
    }
}
