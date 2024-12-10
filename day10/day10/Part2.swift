import Foundation

class Part2 {
    let field: [[Int]]
    let trailHeads: Set<Coord>
    let size: Size

    init(contents: String) throws {
        field = try contents
            .components(separatedBy: "\n")
            .map {
                try $0
                    .map(String.init)
                    .map { try Int($0).throwIfNil() }
            }

        size = Size(width: field[0].count, height: field.count)

        var trailHeads: Set<Coord> = []
        for y in field.indices {
            for x in field[y].indices {
                if field[y][x] == 0 {
                    trailHeads.insert(Coord(x: x, y: y))
                }
            }
        }
        self.trailHeads = trailHeads
    }

    func solve() throws {
        let res = try trailHeads
            .map(countScore(forTrailHead:))
            .reduce(0, +)

        print(res)
    }

    func countScore(forTrailHead coord: Coord) throws -> Int {
        var paths: Set<[Coord]> = []

        var backlog: [[Coord]] = [[coord]]
        while !backlog.isEmpty {
            let currentPath = backlog.removeFirst()
            let currentPathLastCoord = try currentPath.last.throwIfNil()
            let currentValue = field[currentPathLastCoord.y][currentPathLastCoord.x]

            if currentValue == 9 {
                paths.insert(currentPath)
            }

            for neighborCoord in neighborCoords(for: currentPathLastCoord) {
                if field[neighborCoord.y][neighborCoord.x] == currentValue + 1 {
                    backlog.append(currentPath + [neighborCoord])
                }
            }
        }

        return paths.count
    }

    func neighborCoords(for coord: Coord) -> [Coord] {
        [
            Coord(x: coord.x + 1, y: coord.y),
            Coord(x: coord.x - 1, y: coord.y),
            Coord(x: coord.x, y: coord.y + 1),
            Coord(x: coord.x, y: coord.y - 1)
        ]
            .filter { size.isWithinBounds(coord: $0) }
    }
}
