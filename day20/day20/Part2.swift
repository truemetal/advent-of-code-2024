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
        let paths = try findPaths(field: field, cullLongerThan: nil)
        try (paths.count == 1).throwIfFalse()
        let path = paths[0]

        var count = 0

        for (idx1, p1) in path.steps.enumerated() {
            for (idx2, p2) in path.steps.enumerated().dropFirst(idx1) {
                let distanceBetweenPoints = abs(p1.x - p2.x) + abs(p1.y - p2.y)
                guard distanceBetweenPoints <= 20 else { continue }

                let p1ToGoal = path.cost - idx1
                let p2ToGoal = path.cost - idx2

                let save = p1ToGoal - p2ToGoal - distanceBetweenPoints
                if save >= 100 { count += 1 }
            }
        }

        print("Part 2:", count)
    }

    func findPaths(field: [[Tile]], cullLongerThan maxCost: Int?) throws -> [Path] {
        var queue = [Path(steps: [start], cost: 0)]

        var resPaths: [Path] = []
        var stepByCost: [Coord: Int] = [:]

        while queue.isNotEmpty {
            let currentPath = queue.removeFirst()

            let lastStep = try currentPath.steps.last.throwIfNil()
            let visited: Set<Coord> = currentPath.steps.set

            if lastStep == goal { resPaths.append(currentPath) }

            let nextSteps = lastStep.neighbors(withSize: size)
                .filter { visited.contains($0) == false }
                .filter { field[$0.y][$0.x] != .wall }

            queue += nextSteps
                .map {
                    var r = currentPath
                    r.steps.append($0)
                    r.cost += 1
                    return r
                }
                .filter {
                    guard let lastStep = $0.steps.last else { return true }
                    if let currentCost = stepByCost[lastStep], $0.cost > currentCost { return false }
                    if let maxCost, $0.cost > maxCost { return false }
                    stepByCost[lastStep] = $0.cost
                    return true
                }
        }

        return resPaths
    }
}
