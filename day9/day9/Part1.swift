import Foundation

class Part1 {
    var diskMap: [Int?]

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

    func solve() throws {
        while
            let freeSpaceIdx = diskMap.firstIndex(of: nil),
            let currentBlockIdx = diskMap.lastIndex(where: { $0 != nil }),
            freeSpaceIdx < currentBlockIdx {
            diskMap.swapAt(freeSpaceIdx, currentBlockIdx)
        }

        print(diskMap.map {
            $0 != nil ? "\($0!)" : "."
        }.joined())

        let checksum = diskMap
            .enumerated()
            .compactMap { ($0.element ?? 0) * $0.offset }
            .reduce(0, +)

        print(checksum)
    }
}
