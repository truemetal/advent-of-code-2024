import Foundation

class Part1 {
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
        let res = trailHeads
            .map(countScore(forTrailHead:))
            .reduce(0, +)

        print(res)
    }

    func countScore(forTrailHead coord: Coord) -> Int {
        var visitedNines: Set<Coord> = []

        var backlog: [Coord] = [coord]
        while !backlog.isEmpty {
            let currentCoord = backlog.removeFirst()
            let currentValue = field[currentCoord.y][currentCoord.x]

            if currentValue == 9 {
                visitedNines.insert(currentCoord)
            }

            for neighborCoord in neighborCoords(for: currentCoord) {
                if field[neighborCoord.y][neighborCoord.x] == currentValue + 1 {
                    backlog.append(neighborCoord)
                }
            }
        }

        return visitedNines.count
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
