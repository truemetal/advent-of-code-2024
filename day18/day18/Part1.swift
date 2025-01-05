import Foundation

class Part1 {
    let byteCoords: [Coord]
    let size: Size
    let start: Coord = Coord(x: 0, y: 0)
    let goal: Coord

    init(contents: String, size: Size, prefix: Int) throws {
        self.size = size
        self.goal = Coord(x: size.width - 1, y: size.height - 1)

        byteCoords = try contents
            .components(separatedBy: "\n")
            .map {
                let items = $0.components(separatedBy: ",").compactMap(\.int)
                try (items.count == 2).throwIfFalse()
                return Coord(x: items[0], y: items[1])
            }
            .prefix(prefix)
            .arr
    }

    func solve() throws {
        buildGraph()
        print("build graph", graph.nodes.count, graph.nodes.map(\.directedEdges.count).reduce(0, +))

        let paths = try graph.shortestPaths(fromStart: start)
        let res = try paths[goal].throwIfNil()
        print("Part 1:", res.cost)
    }

    var graph = DijkstraGraph<Coord>()

    func buildGraph() {
        let byteCoords = byteCoords.set
        var edges: Set<GraphNode<Coord>> = []
        var addedVertices: Set<Coord> = []

        var queue: [Coord] = [start]
        while queue.isNotEmpty {
            let position = queue.removeFirst()
            guard addedVertices.contains(position) == false else { continue }
            addedVertices.insert(position)

            let newEdges = position.neighbors(withSize: size)
                .filter { byteCoords.contains($0) == false }
                .map { ($0, 1) }

            let node = GraphNode(node: position, directedEdges: Dictionary(uniqueKeysWithValues: newEdges))
            edges.insert(node)

            queue += newEdges.map(\.0)
        }

        graph.nodes = edges
    }

    func printField() {
        for y in 0..<size.height {
            for x in 0..<size.width {
                if byteCoords.contains(Coord(x: x, y: y)) {
                    print("#", terminator: "")
                }
                else {
                    print(".", terminator: "")
                }
            }
            print()
        }
    }
}
