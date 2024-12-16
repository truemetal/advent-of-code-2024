import Foundation

class Part1 {
    var stones: [Int] = []

    init(contents: String) throws {
        stones = try contents
            .components(separatedBy: " ")
            .map { try Int($0).throwIfNil() }
    }

    func solve() throws {
        try (0 ..< 25).forEach { _ in
            stones = try stones.flatMap(processStone)
        }

        print("part 1:", stones.count)
    }

    func processStone(stone: Int) throws -> [Int] {
        if stone == 0 { return [1] }

        let str = stone.str
        if str.count % 2 == 0 {
            let head = try str.arr[0 ..< (str.count / 2)].str.int.throwIfNil()
            let tail = try str.arr[(str.count / 2) ..< str.count].str.int.throwIfNil()
            return [head, tail]
        }

        return [stone * 2024]
    }
}
