import Foundation

class Part2 {
    var stones: [Int: Int] = [:]

    init(contents: String) throws {
        try contents
            .components(separatedBy: " ")
            .map { try $0.int.throwIfNil() }
            .forEach {
                let c = stones[$0, default: 0]
                stones[$0] = c + 1
            }
    }

    func solve() throws {
        try (0 ..< 75).forEach { _ in
            var res: [Int: Int] = [:]

            for (stone, count) in stones {
                let stepRes = try processStone(stone: stone, count: count)

                for (step, stepCount) in stepRes {
                    res[step] = res[step, default: 0] + stepCount
                }
            }

            stones = res
        }

        print("part 2:", stones.values.reduce(0, +))
    }

    func processStone(stone: Int, count: Int) throws -> [(Int, Int)] {
        guard count > 0 else { return [] }

        if stone == 0 {
            return [(1, count)]
        }

        let str = stone.str
        if str.count % 2 == 0 {
            let head = try str.arr[0 ..< (str.count / 2)].str.int.throwIfNil()
            let tail = try str.arr[(str.count / 2) ..< str.count].str.int.throwIfNil()

            return [(head, count), (tail, count)]
        }

        return [(stone * 2024, count)]
    }
}
