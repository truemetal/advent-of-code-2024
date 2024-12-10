import Foundation

struct Size {
    let width: Int
    let height: Int
}

struct Coord: Hashable {
    let x: Int
    let y: Int
}

extension Coord {
    func delta(to other: Coord) -> Size {
        Size(width: x - other.x, height: y - other.y)
    }
}

extension Size {
    func isWithinBounds(coord: Coord) -> Bool {
        coord.x >= 0 && coord.x < width && coord.y >= 0 && coord.y < height
    }
}
