import Foundation

class Part1 {
    let robots: [Robot]
    let size: Size

    init(contents: String, size: Size) throws {
        self.size = size

        robots = try contents
            .components(separatedBy: "\n")
            .map {
                let numbers = try $0
                    .replacingOccurrences(of: "p=", with: "")
                    .replacingOccurrences(of: "v=", with: "")
                    .replacingOccurrences(of: ",", with: " ")
                    .components(separatedBy: " ")
                    .map(Int.init)
                    .map { try $0.throwIfNil() }

                return Robot(
                    position: Coord(x: numbers[0], y: numbers[1]),
                    velocity: Coord(x: numbers[2], y: numbers[3])
                )
            }
    }

    func solve() throws {
        let robots = robots
            .map { $0.byMoving(iterations: 100, withSize: size) }

        let middleLine = Coord(x: size.width / 2, y: size.height / 2)

        let q1Count = robots
            .count { $0.position.x < middleLine.x && $0.position.y < middleLine.y }

        let q2Count = robots
            .count { $0.position.x > middleLine.x && $0.position.y < middleLine.y }

        let q3Count = robots
            .count { $0.position.x < middleLine.x && $0.position.y > middleLine.y }

        let q4Count = robots
            .count { $0.position.x > middleLine.x && $0.position.y > middleLine.y }

        print(q1Count * q2Count * q3Count * q4Count)
    }
}

