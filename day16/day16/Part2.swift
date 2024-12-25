import Foundation

class Part2 {
    let field: [[Tile]]
    let size: Size
    let start: Coord
    let goal: Coord

    init(contents: String) throws {
        var start: Coord?
        var goal: Coord?

        try field = contents
            .components(separatedBy: "\n")
            .enumerated()
            .map { y, line in
                try line.enumerated().map { x, char in
                    switch char {
                    case ".": return .empty
                    case "#": return .wall
                    case "E": goal = Coord(x: x, y: y); return .empty
                    case "S": start = Coord(x: x, y: y); return .empty
                    default: throw genericError
                    }
                }
            }

        self.start = try start.throwIfNil()
        self.goal = try goal.throwIfNil()
        size = Size(width: field[0].count, height: field.count)
    }

    func solve() throws {
        let paths = try findPaths()
        let min = try paths.map(\.cost).min().throwIfNil()

        let resCells = paths
            .filter { $0.cost == min }
            .flatMap { $0.steps }
            .map { $0.coord }
            .set

        print(resCells.count)
    }

    func findPaths() throws -> [Path] {
        var queue = [Path(steps: [Position(coord: start, direction: .right)], cost: 0)]

        var resPaths: [Path] = []
        var stepByCost: [Position: Int] = [:]

        while queue.isNotEmpty {
            let currentPath = queue.removeFirst()

            let lastStep = try currentPath.steps.last.throwIfNil()
            let visited: Set<Position> = currentPath.steps.set

            if lastStep.coord == goal { resPaths.append(currentPath) }

            let nextSteps = [
                (lastStep.direction.rotatedLeft(), 1001),
                (lastStep.direction.rotatedRight(), 1001),
                (lastStep.direction, 1)
            ]
                .map { (Position(coord: lastStep.coord.byMoving($0.0), direction: $0.0), $0.1) }
                .filter {
                    visited.contains($0.0) == false && visited.contains($0.0.oppositeStep()) == false
                }
                .filter {
                    $0.0.coord.isValid(withSize: size)
                }
                .filter {
                    field[$0.0.coord.y][$0.0.coord.x] != .wall
                }

            queue += nextSteps
                .map {
                    var r = currentPath
                    r.steps.append($0.0)
                    r.cost += $0.1
                    return r
                }
                .filter {
                    guard let lastStep = $0.steps.last else { return true }
                    if let currentCost = stepByCost[lastStep], $0.cost > currentCost { return false }
                    stepByCost[lastStep] = $0.cost
                    return true
                }
        }

        return resPaths
    }

    func printField(path: Set<Position>) {
        let path = path.map(\.coord).set

        for y in 0 ..< size.height {
            for x in 0 ..< size.width {
                if path.contains(Coord(x: x, y: y)) {
                    print("O", terminator: "")
                }
                else {
                    if field[y][x] == .empty {
                        print(".", terminator: "")
                    } else if field[y][x] == .wall {
                        print("#", terminator: "")
                    }
                    else { fatalError() }
                }
            }
            print("")
        }
    }
}
