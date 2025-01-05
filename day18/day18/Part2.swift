import Foundation

class Part2 {
    let byteCoords: [Coord]
    let size: Size
    let start: Coord = Coord(x: 0, y: 0)
    let goal: Coord
    let prefix: Int

    init(contents: String, size: Size, prefix: Int) throws {
        self.size = size
        self.prefix = prefix
        self.goal = Coord(x: size.width - 1, y: size.height - 1)

        byteCoords = try contents
            .components(separatedBy: "\n")
            .map {
                let items = $0.components(separatedBy: ",").compactMap(\.int)
                try (items.count == 2).throwIfFalse()
                return Coord(x: items[0], y: items[1])
            }
    }

    func solve() throws {
        var failedByte: Coord?

        for prefix in prefix ..< byteCoords.count {
            buildGraph(byteCoords: byteCoords.prefix(prefix).arr)
            let paths = try graph.shortestPaths(fromStart: start)
            if paths[goal] == nil {
                failedByte = byteCoords[prefix - 1]
                break
            }
        }

        try print("Part 2: \(failedByte.throwIfNil().x),\(failedByte.throwIfNil().y)")
    }

    var graph = DijkstraGraph<Coord>()

    func buildGraph(byteCoords: [Coord]) {
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
}
