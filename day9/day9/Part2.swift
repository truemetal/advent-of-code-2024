import Foundation

class Part2 {
    var diskMap: [Int?]
    var movedFilesId: Set<Int> = []

    init(contents: String) throws {
        var currentFileIdx = 0

        diskMap = try contents
            .enumerated()
            .flatMap { idx, char in
                let isFile = idx % 2 == 0
                defer { isFile ? currentFileIdx += 1 : () }
                let count = try Int(String(char)).throwIfNil()
                return Array(repeating: isFile ? currentFileIdx : nil, count: count)
            }
    }

    var movedFiles: Set<Int> = []

    func getNextFileRange() -> ClosedRange<Int>? {
        var endIdx = diskMap.count - 1

        while true {
            guard let block = diskMap[endIdx], movedFiles.contains(block) == false else {
                endIdx -= 1
                if endIdx < 0 { return nil }
                continue
            }

            movedFiles.insert(block)
            break
        }

        var startIdx = endIdx

        while true {
            let nextIdx = startIdx - 1
            if nextIdx < 0 { break }

            if diskMap[nextIdx] != diskMap[startIdx] { break }
            startIdx = nextIdx
        }

        return startIdx...endIdx
    }

    func firstFreeBlock(ofLength len: Int) -> Range<Int>? {
        var startIdx = 0

        while startIdx <= (diskMap.count - len) {
            if Array(diskMap[startIdx..<startIdx+len]) == Array(repeating: nil, count: len) {
                return startIdx..<startIdx+len
            }

            startIdx += 1
        }

        return nil
    }

    func solve() throws {
        while let fileRange = getNextFileRange() {
            if let freeBlockRange = firstFreeBlock(ofLength: fileRange.count),
               try freeBlockRange.first.throwIfNil() < fileRange.first.throwIfNil() {
                let temp = diskMap[fileRange]
                diskMap[fileRange] = diskMap[freeBlockRange]
                diskMap[freeBlockRange] = temp
                print("moving: \(temp.first!!)")
            }
        }

        let res = diskMap
            .enumerated()
            .map { ($0.element ?? 0) * $0.offset }
            .reduce(0, +)

        print(res)
    }

    func strFrom(diskMap: some Collection<Int?>) -> String {
        diskMap.map {
            $0 != nil ? "\($0!)" : "."
        }.joined()
    }
}
