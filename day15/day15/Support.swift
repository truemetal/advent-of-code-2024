import Foundation

struct Coord: Hashable {
    var x: Int
    var y: Int
}

enum Direction {
    case up, down, left, right
}

enum Tile {
    case wall, box, nothing, boxStart, boxEnd
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
}
