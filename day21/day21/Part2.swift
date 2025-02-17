import Foundation

class Part2 {
    let solver: Solver
    
    init(contents: String) throws {
        try solver = Solver(contents: contents, sequentialRobotLayers: 25)
    }

    func solve() throws {
        print("Part 2:", try solver.solve())
    }
}
