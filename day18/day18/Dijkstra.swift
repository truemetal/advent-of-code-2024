import Foundation

class DijkstraGraph<Node> where Node: Hashable {
    var nodes: Set<GraphNode<Node>> = []

    func shortestPaths(fromStart start: Node) throws -> [Node: PathItem<Node>] {
        let nodes = nodes.reduce(into: [:]) { $0[$1.node] = $1 }
        var result = [start: PathItem(cost: 0, parentPosition: start)]

        var visitedNodes: Set<Node> = []
        var queue: [Node] = [start]

        while !queue.isEmpty {
            let currentPosition = try queue
                .min { try result[$0].throwIfNil().cost < result[$1].throwIfNil().cost }
                .throwIfNil()

            let currentPositionIdx = try queue.firstIndex(of: currentPosition).throwIfNil()
            queue.remove(at: currentPositionIdx)

            visitedNodes.insert(currentPosition)

            let currentNode = try nodes[currentPosition].throwIfNil()
            let currentPathItem = try result[currentPosition].throwIfNil()

            for (edge, cost) in currentNode.directedEdges {
                let newCost = currentPathItem.cost + cost

                if newCost < (result[edge]?.cost ?? .max) {
                    result[edge] = PathItem(cost: newCost, parentPosition: currentPosition)
                    if !visitedNodes.contains(edge) { queue.append(edge) }
                }
            }
        }

        return result
    }
}

struct GraphNode<Node>: Hashable where Node: Hashable {
    let node: Node
    let directedEdges: [Node: Int]
}

struct PathItem<NodeType> {
    var cost: Int
    var parentPosition: NodeType
}
