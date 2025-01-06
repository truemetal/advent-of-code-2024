import Foundation

class Part1 {
    let field: [[Tile]]
    let size: Size
    let start: Coord
    let goal: Coord
    let printProgress: Bool

    init(contents: String, printProgress: Bool) throws {
        self.printProgress = printProgress
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
        buildGraph(field: field)

        let paths = try graph.shortestPaths(fromStart: start)
        let baseline = try paths[goal].throwIfNil().cost

        var saveByCount: [Int: Int] = [:]

        var progress = 0

        for y in 1 ..< (size.height - 1) {
            for x in 1 ..< (size.width - 1) {
                progress += 1
                if printProgress {
                    print(progress, "/", (size.height - 2) * (size.width - 2))
                }

                guard field[y][x] == .wall else { continue }
                var field = self.field
                field[y][x] = .empty

                buildGraph(field: field)
                let paths = try graph.shortestPaths(fromStart: start)
                let thisCost = try paths[goal].throwIfNil().cost
                let diff = baseline - thisCost
                saveByCount[diff] = (saveByCount[diff] ?? 0) + 1
            }
        }

        let res = saveByCount
            .filter { $0.key >= 100 }
            .map { $0.value }
            .reduce(0, +)

        print("Part 1:", res)
    }

    var graph = DijkstraGraph<Coord>()

    func buildGraph(field: [[Tile]]) {
        var edges: Set<GraphNode<Coord>> = []
        var addedVertices: Set<Coord> = []

        var queue: [Coord] = [start]
        while queue.isNotEmpty {
            let position = queue.removeFirst()
            guard addedVertices.contains(position) == false else { continue }
            addedVertices.insert(position)

            let newEdges = position
                .neighbors(withSize: size)
                .filter { field[$0.y][$0.x] == .empty }
                .map { ($0, 1) }

            let node = GraphNode(node: position, directedEdges: Dictionary(uniqueKeysWithValues: newEdges))
            edges.insert(node)

            queue += newEdges.map(\.0)
        }

        graph.nodes = edges
    }

    func printField() {
        field.forEach {
            print(
                $0.map {
                    switch $0 {
                    case .empty: return "."
                    case .wall: return "#"
                    }
                }.joined()
            )
        }
    }
}
