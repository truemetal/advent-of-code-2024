import Foundation

struct Coord: Hashable {
    var x: Int
    var y: Int
}

struct Size {
    let width: Int
    let height: Int
}

struct Robot: Equatable {
    let position: Coord
    let velocity: Coord
}

extension Robot {
    func byMoving(iterations: Int, withSize size: Size) -> Robot {
        var p = position
        p.x += velocity.x * iterations
        p.y += velocity.y * iterations

        p.x = p.x % size.width
        p.y = p.y % size.height

        p.x = p.x < 0 ? size.width + p.x : p.x
        p.y = p.y < 0 ? size.height + p.y : p.y
        
        return Robot(position: p, velocity: velocity)
    }
}
