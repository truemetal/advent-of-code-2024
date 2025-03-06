import Foundation

class Part1 {
    var variables: [String: Bool] = [:]
    var equations: [String: Operation] = [:]

    init(contents: String) throws {
        let parts = contents.split(separator: "\n\n")

        variables = parts[0]
            .split(separator: "\n")
            .map {
                let parts = $0.split(separator: ": ")
                return (parts[0].str, parts[1] == "0" ? false : true)
            }
            .reduce(into: [:]) { $0[$1.0] = $1.1 }

        equations = parts[1]
            .split(separator: "\n")
            .map { parseOperation($0.str) }
            .reduce(into: [:]) { $0[$1.0] = $1.1 }
    }

    func parseOperation(_ input: String) -> (String, Operation) {
        let parts = input.split(separator: " -> ")
        let resVar = parts[1].str

        let equationParts = parts[0].components(separatedBy: " ")
        let lhs = equationParts[0].str
        let rhs = equationParts[2].str

        let operation: Operation

        switch equationParts[1] {
        case "OR": operation = .or(lhs: lhs, rhs: rhs)
        case "XOR": operation = .xor(lhs: lhs, rhs: rhs)
        case "AND": operation = .and(lhs: lhs, rhs: rhs)
        default: fatalError()
        }

        return (resVar, operation)
    }

    func solve() throws {
        let zVars = equations.keys.filter { $0.hasPrefix("z") }

        let resStr = zVars.sorted().reversed().map { getVarValue(varName: $0) ? "1" : "0" }.joined()
        print("Part 1:", Int(resStr, radix: 2)!)
    }

    func getVarValue(varName: String) -> Bool {
        if let v = variables[varName] { return v }

        let op = equations[varName]!
        let lhs = getVarValue(varName: op.lhs)
        let rhs = getVarValue(varName: op.rhs)
        let res = op.perform(lhs: lhs, rhs: rhs)

        variables[varName] = res
        return res
    }
}
