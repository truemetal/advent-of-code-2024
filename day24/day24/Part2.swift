import Foundation

class Part2 {
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

    func checkSwap(wire1: String, wire2: String) throws -> [Int] {
        let originalEquations = equations
        defer { equations = originalEquations }

        swap(wire1: wire1, wire2: wire2)

        return try verify()
    }

    func swap(wire1: String, wire2: String) {
        let wire1Op = equations[wire1]!
        let wire2Op = equations[wire2]!

        equations[wire1] = wire2Op
        equations[wire2] = wire1Op
    }

    func solve() throws {
        // ---- figure out possible replacements

        let originalErrors = try verify()

        let potentialFailingWires = originalErrors.flatMap { varsForZ(idx: $0) }.set.arr
        var possibleReplacements: Set<[String]> = []

        for i in 0 ..< (potentialFailingWires.count - 1) {
            print("\(i) \\ \(potentialFailingWires.count)")
            for y in (i + 1) ..< potentialFailingWires.count {
                do {
                    let newErrors = try checkSwap(wire1: potentialFailingWires[i], wire2: potentialFailingWires[y])
                    if newErrors.count < originalErrors.count {                        possibleReplacements.insert([potentialFailingWires[i], potentialFailingWires[y]])
                    }
                }
                catch {

                }
            }
        }

        // ---- enumerate possible replacements until matching combo is found

        let originalEquations = equations
        let subsets = subsets(possibleReplacements.arr, ofLength: 4)
        for subset in subsets {
            equations = originalEquations
            for pair in subset {
                swap(wire1: pair[0], wire2: pair[1])
            }
            if (try? verify()) == [] {
                print("Part 2:", subset.flatMap(\.self).sorted().joined(separator: ","))
                return
            }
        }

        print("Part 2: N/A")
    }

    func subsets<T>(_ array: [T], ofLength length: Int) -> [[T]] {
        guard length > 0 && length <= array.count else { return [] }

        var result: [[T]] = []

        func backtrack(_ start: Int, _ currentSubset: [T]) {
            if currentSubset.count == length {
                result.append(currentSubset)
                return
            }

            for i in start..<array.count {
                backtrack(i + 1, currentSubset + [array[i]])
            }
        }

        backtrack(0, [])
        return result
    }

    func verify() throws -> [Int] {
        let origVariables = variables
        defer { variables = origVariables }

        var failing: Set<Int> = []

        let xVars = variables.keys.filter { $0.hasPrefix("x") }.sorted() + ["x45"]
        let yVars = variables.keys.filter { $0.hasPrefix("y") }.sorted() + ["y45"]

        for i in 0 ..< 45 {
            variables = [:]
            xVars.forEach { variables[$0] = false }
            yVars.forEach { variables[$0] = false }
            variables[yVars[i]] = true
            if Int(try zBinVal, radix: 2)! != Int(try binStr(vars: yVars), radix: 2)! {
                failing.insert(i)
            }
        }

        for i in 0 ..< 45 {
            variables = [:]
            xVars.forEach { variables[$0] = false }
            yVars.forEach { variables[$0] = false }
            variables[xVars[i]] = true
            if Int(try zBinVal, radix: 2)! != Int(try binStr(vars: xVars), radix: 2)! {
                failing.insert(i)
            }
        }

        for i in 1 ..< 45 {
            variables = [:]
            xVars.forEach { variables[$0] = false }
            yVars.forEach { variables[$0] = false }
            variables[xVars[i]] = true
            variables[xVars[i-1]] = true
            variables[yVars[i-1]] = true
            let z = Int(try zBinVal, radix: 2)!

            variables[xVars[i + 1]] = true
            variables[xVars[i]] = false
            variables[xVars[i - 1]] = false

            if z != Int(try binStr(vars: xVars), radix: 2)! {
                failing.insert(i)
            }
        }

        for i in 1 ..< 45 {
            variables = [:]
            xVars.forEach { variables[$0] = false }
            yVars.forEach { variables[$0] = false }
            variables[yVars[i]] = true
            variables[yVars[i-1]] = true
            variables[xVars[i-1]] = true
            let z = Int(try zBinVal, radix: 2)!

            variables[yVars[i + 1]] = true
            variables[yVars[i]] = false
            variables[yVars[i - 1]] = false

            if z != Int(try binStr(vars: yVars), radix: 2)! {
                failing.insert(i)
            }
        }

        return failing.arr.sorted()
    }

    func binStr(vars: [String]) throws -> String {
        try vars.sorted().reversed().map { try getVarValue(varName: $0) ? "1" : "0" }.joined()
    }

    func varsForZ(idx: Int) -> [String] {
        var res: [String] = []

        let zName = "z" + idx.formatted(.number.precision(.integerLength(2)))
        var queue = [zName]

        while queue.isNotEmpty {
            let current = queue.removeFirst()
            //            if current.starts(with: "x") || current.starts(with: "y") { continue }

            guard let op = equations[current] else { continue }
            //            if op.lhs.starts(with: "x") == false, op.lhs.starts(with: "y") == false, op.lhs.starts(with: "z") == false { queue.append(op.lhs) }
            //            if op.rhs.starts(with: "x") == false, op.rhs.starts(with: "y") == false, op.rhs.starts(with: "z") == false { queue.append(op.rhs) }
            queue.append(op.lhs)
            queue.append(op.rhs)

            res.append(current)
        }

        return res
    }

    lazy var zVars = equations.keys.filter { $0.hasPrefix("z") }

    var zBinVal: String {
        get throws {
            return try binStr(vars: zVars)
        }
    }

    func getVarValue(varName: String, requestedVars: Set<String> = []) throws -> Bool {
        if requestedVars.contains(varName) { throw genericError }
        var requestedVars = requestedVars
        requestedVars.insert(varName)
        if let v = variables[varName] { return v }

        let op = equations[varName]!
        let lhs = try getVarValue(varName: op.lhs, requestedVars: requestedVars)
        let rhs = try getVarValue(varName: op.rhs, requestedVars: requestedVars)
        let res = op.perform(lhs: lhs, rhs: rhs)

        variables[varName] = res
        return res
    }
}
