import Foundation

struct Coord: Hashable {
    var x: Int
    var y: Int
}

struct Size {
    let width: Int
    let height: Int
}

enum Direction {
    case up, down, left, right

    func rotatedRight() -> Direction {
        switch self {
        case .up: return .right
        case .down: return .left
        case .left: return .up
        case .right: return .down
        }
    }

    func rotatedLeft() -> Direction {
        switch self {
        case .up: return .left
        case .down: return .right
        case .left: return .down
        case .right: return .up
        }
    }

    var description: String {
        switch self {
        case .up: return "up"
        case .down: return "down"
        case .left: return "left"
        case .right: return "right"
        }
    }
}

struct Path: Hashable {
    var steps: [Coord]
    var cost: Int
}

enum Tile {
    case wall, empty
}

extension Coord {
    func byMoving(_ direction: Direction) -> Coord {
        switch direction {
        case .up: return Coord(x: x, y: y - 1)
        case .down: return Coord(x: x, y: y + 1)
        case .left: return Coord(x: x - 1, y: y)
        case .right: return Coord(x: x + 1, y: y)
        }
    }

    func isValid(withSize size: Size) -> Bool {
        x >= 0 && y >= 0 && x < size.width && y < size.height
    }

    func neighbors(withSize size: Size) -> [Coord] {
        [byMoving(.up), byMoving(.down), byMoving(.left), byMoving(.right)]
            .filter { $0.isValid(withSize: size) }
    }

    var neighbors: [Coord] {
        [byMoving(.up), byMoving(.down), byMoving(.left), byMoving(.right)]
    }
}
