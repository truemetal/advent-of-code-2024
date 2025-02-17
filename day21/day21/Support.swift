import Foundation

struct Coord: Hashable, Equatable {
    let x: Int
    let y: Int

    func isValid(forSize size: Size) -> Bool {
        x >= 0 && x < size.width && y >= 0 && y < size.height
    }
}

struct Size {
    let width: Int
    let height: Int
}

extension [[String]] {
    var size: Size {
        .init(width: self[0].count, height: count)
    }
}

enum Step {
    case left
    case right
    case up
    case down
}

extension Coord {
    func move(_ step: Step) -> Coord {
        switch step {
        case .left: return .init(x: x - 1, y: y)
        case .right: return .init(x: x + 1, y: y)
        case .up: return .init(x: x, y: y - 1)
        case .down: return .init(x: x, y: y + 1)
        }
    }
}

extension [Coord] {
    func steps(size: Size) -> String {
        guard count > 1 else { return "A" }
        var current = self[0]
        var res = ""
        for coord in self[1...] {
            if coord == current.move(.up) { res += "^" }
            if coord == current.move(.down) { res += "v" }
            if coord == current.move(.left) { res += "<" }
            if coord == current.move(.right) { res += ">" }
            current = coord
        }
        return res + "A"
    }
}
