import Foundation

class Part1 {
    var locks: [[Int]] = []
    var keys: [[Int]] = []

    init(contents: String) throws {
        for block in contents.components(separatedBy: "\n\n") {
            let blockLines = block.split(separator: "\n")

            if isLock(blockLines: blockLines) {
                locks.append(count(char: "#", blockLines: blockLines))
            }
            else if isKey(blockLines: blockLines) {
                keys.append(count(char: "#", blockLines: blockLines))
            }
            else {
                fatalError()
            }
        }
    }

    func isLock(blockLines: [some StringProtocol]) -> Bool {
        guard let first = blockLines.first, let last = blockLines.last else { return false }
        if first == Array(repeating: "#", count: first.count).str, last == Array(repeating: ".", count: last.count).str { return true }

        return false
    }

    func isKey(blockLines: [some StringProtocol]) -> Bool {
        guard let first = blockLines.first, let last = blockLines.last else { return false }
        if first == Array(repeating: ".", count: first.count).str, last == Array(repeating: "#", count: last.count).str { return true }

        return false
    }

    func count(char: Character, blockLines: [some StringProtocol]) -> [Int] {
        (0 ..< blockLines[0].count).map { count(char: char, columnIdx: $0, blockLines: blockLines) }
    }

    func count(char: Character, columnIdx: Int, blockLines: [some StringProtocol]) -> Int {
        blockLines.dropFirst().dropLast().count {
            $0.arr[columnIdx] == char
        }
    }

    func solve() throws {
        var res = 0
        for lock in locks {
            for key in keys {
                let fits = zip(key, lock).map { $0 + $1 }.contains { $0 > 5 } == false
                if fits { res += 1 }
            }
        }

        print("Part 1:", res)
    }
}
