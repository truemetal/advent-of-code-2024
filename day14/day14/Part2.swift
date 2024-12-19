import Foundation

class Part2 {
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
        var iterations = -1
        var robots = self.robots

        while hasManyRobotsInHorizontalLine(robots: robots) == false, iterations < 11000 {
            iterations += 1

            robots = self.robots
                .map { $0.byMoving(iterations: iterations, withSize: size) }
        }

        printField(robots: robots)
        print()
        print("elapsed iterations:", iterations)
        print("max intersection size:", maxIntersectionSize)
    }

    func hasManyEmptyLines(robots: [Robot]) -> Bool {
        var coords = Set<Coord>()
        robots.forEach { coords.insert($0.position) }

        var emptyLineCount = 0

        for y in 0 ..< size.height {
            let expectedCoords: Set<Coord> = ((0 ..< size.width).map { Coord(x: $0, y: y) }).set
            let intersection = coords.intersection(expectedCoords)
            if intersection.count == 0 { emptyLineCount += 1 }
            if emptyLineCount == 17 { return true }
        }

        return false
    }

    var maxIntersectionSize = 0

    func hasManyRobotsInHorizontalLine(robots: [Robot]) -> Bool {
        var coords = Set<Coord>()
        robots.forEach { coords.insert($0.position) }

        for y in 0 ..< size.height {
            let expectedCoords: Set<Coord> = ((0 ..< size.width).map { Coord(x: $0, y: y) }).set

            let intersection = coords.intersection(expectedCoords)
            maxIntersectionSize = max(maxIntersectionSize, intersection.count)
            if intersection.count == 35 { return true }
        }

        return false
    }

    func printField(robots: [Robot]) {
        var coords = Set<Coord>()
        robots.forEach { coords.insert($0.position) }
        
        for y in 0..<size.height {
            for x in 0..<size.width {
                let coord = Coord(x: x, y: y)
                if coords.contains(coord) {
                    print("#", terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print()
        }
    }
}
