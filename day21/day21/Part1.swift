import Foundation

class Part1 {
    let solver: Solver

    init(contents: String) throws {
        try solver = Solver(contents: contents, sequentialRobotLayers: 2)
    }

    func solve() throws {
        print("Part 1:", try solver.solve())
    }
}
