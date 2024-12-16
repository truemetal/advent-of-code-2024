import Foundation

struct Coord: Hashable {
    let x: Int
    let y: Int
}

struct Size {
    let width: Int
    let height: Int
}

extension Coord {
    func isValid(for size: Size) -> Bool {
        x >= 0 && x < size.width && y >= 0 && y < size.height
    }

    var neighbors: [Coord] {
        [Coord(x: x + 1, y: y), Coord(x: x - 1, y: y), Coord(x: x, y: y + 1), Coord(x: x, y: y - 1)]
    }

    func coord(forDirection d: Direction) -> Coord {
        switch d {
        case .up: return Coord(x: x, y: y - 1)
        case .down: return Coord(x: x, y: y + 1)
        case .left: return Coord(x: x - 1, y: y)
        case .right: return Coord(x: x + 1, y: y)
        }
    }

    func direction(toNeighbor c: Coord) throws -> Direction {
        if coord(forDirection: .up) == c { return .up }
        if coord(forDirection: .down) == c { return .down }
        if coord(forDirection: .left) == c { return .left }
        if coord(forDirection: .right) == c { return .right }
        throw genericError
    }
}

enum Direction {
    case up, down, left, right

    func isOpposite(to d: Direction) -> Bool {
        switch self {
        case .up: return d == .down
        case .down: return d == .up
        case .left: return d == .right
        case .right: return d == .left
        }
    }
}
