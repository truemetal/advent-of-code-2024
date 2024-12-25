import Foundation

class Part1 {
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
        buildGraph()

        let paths = try graph.shortestPaths(fromStart: Position(coord: start, direction: .right))

        let res = try [Direction.up, .right, .down, .left]
            .compactMap { d in
                let end = Position(coord: goal, direction: d)
                return paths[end]?.cost
            }
            .min()
            .throwIfNil()

        print(res)
    }

    var graph = DijkstraGraph<Position>()
    var nodes: [Position: GraphNode<Position>] = [:]

    func buildGraph() {
        var edges: Set<GraphNode<Position>> = []
        var addedVertices: Set<Position> = []

        var queue: [Position] = [Position(coord: start, direction: .right)]
        while queue.isNotEmpty {
            let position = queue.removeFirst()
            guard addedVertices.contains(position) == false else { continue }
            addedVertices.insert(position)

            let newEdges = [
                (position.direction.rotatedLeft(), 1001),
                (position.direction.rotatedRight(), 1001),
                (position.direction, 1)
            ]
                .map { (Position(coord: position.coord.byMoving($0.0), direction: $0.0), $0.1) }
                .filter { field[$0.0.coord.y][$0.0.coord.x] == .empty }

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

    func printField(path: [Position]) {
        let path = path.map(\.coord).set

        for y in 0 ..< size.height {
            for x in 0 ..< size.width {
                if path.contains(Coord(x: x, y: y)) {
                    print("+", terminator: "")
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
