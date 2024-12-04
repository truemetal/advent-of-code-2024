import Cocoa
import RegexBuilder

struct GenericError: Error { }
let genericError = GenericError()

extension Optional {
    func throwIfNil() throws -> Wrapped {
        guard let self else { throw genericError }
        return self
    }
}

let testContents = Bundle.main.url(forResource: "test_input", withExtension: "txt").flatMap { try? String(contentsOf: $0, encoding: .utf8) }

let realContents = Bundle.main.url(forResource: "real_input", withExtension: "txt").flatMap { try? String(contentsOf: $0, encoding: .utf8) }

let contents = try testContents.throwIfNil()
//let contents = try realContents.throwIfNil()

// MARK: -

struct Size {
    let width: Int
    let height: Int
}

enum Direction: CaseIterable { case up, down, left, right, upLeft, upRight, downLeft, downRight }

struct Coord {
    var x: Int
    var y: Int

    func isValidCoord(withSize: Size) -> Bool {
        if x < 0 || y < 0 || x >= withSize.width || y >= withSize.height { return false }
        return true
    }

    func movingOneStep(in direction: Direction) -> Coord {
        var point = self

        switch direction {
        case .up: point.y -= 1
        case .down: point.y += 1
        case .left: point.x -= 1
        case .right: point.x += 1
        case .upLeft: point.y -= 1; point.x -= 1
        case .upRight: point.y -= 1; point.x += 1
        case .downLeft: point.y += 1; point.x -= 1
        case .downRight: point.y += 1; point.x += 1
        }

        return point
    }
}

func word(fromCoord point: Coord, atDirection: Direction, length: Int, array: [[Character]]) -> String? {
    var res: String = ""
    var point = point

    while res.count < length {
        guard point.isValidCoord(withSize: Size(width: array[0].count, height: array.count)) else { return nil }

        let char = array[point.y][point.x]
        res.append(char)
        point = point.movingOneStep(in: atDirection)
    }

    return res
}

func subArray(topLeftCoord: Coord, size: Size, array: [[Character]]) -> [[Character]]? {
    let bottomRightCoord = Coord(x: topLeftCoord.x + size.width - 1, y: topLeftCoord.y + size.height - 1)

    guard bottomRightCoord.isValidCoord(withSize: Size(width: array[0].count, height: array.count)) else { return nil }

    let res = array[topLeftCoord.y ... bottomRightCoord.y]
        .map { Array($0[topLeftCoord.x ... bottomRightCoord.x]) }
    return res
}

// MARK: -

func part1() {
    let array: [[Character]] = contents
        .split(separator: "\n")
        .map { $0.map(\.self) }

    func countTargetWords(thatStartAtCoord coord: Coord) -> Int {
        let words = Direction.allCases.compactMap {
            word(fromCoord: coord, atDirection: $0, length: 4, array: array)
        }

        return words.count { $0 == "XMAS" }
    }

    var res = 0

    for y in 0 ..< array.count {
        for x in 0 ..< array[y].count {
            let coord = Coord(x: x, y: y)
            res += countTargetWords(thatStartAtCoord: coord)
        }
    }

    print(res)
}

// MARK: -

func part2() {
    let array: [[Character]] = contents
        .split(separator: "\n")
        .map { $0.map(\.self) }

    func isTargetSubarray(arr: [[Character]]) -> Bool {
        assert(arr.count == 3 && arr[0].count == 3)

        let d1 = word(fromCoord: Coord(x: 0, y: 0), atDirection: .downRight, length: 3, array: arr)
        let d2 = word(fromCoord: Coord(x: 0, y: 2), atDirection: .upRight, length: 3, array: arr)

        return (d1 == "MAS" || d1 == "SAM") &&
        (d2 == "MAS" || d2 == "SAM")
    }

    var res = 0

    for y in 0 ..< array.count {
        for x in 0 ..< array[y].count {
            if let subArr = subArray(topLeftCoord: Coord(x: x, y: y), size: Size(width: 3, height: 3), array: array) {
                res += isTargetSubarray(arr: subArr) ? 1 : 0
            }
        }
    }

    print(res)
}

part1()
part2()
