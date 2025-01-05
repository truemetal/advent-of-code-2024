import Foundation

class Part1 {
    var regA: Int
    var regB: Int
    var regC: Int
    var program: [Int]
    var output: [Int] = []

    init(contents: String) throws {
        let components = contents.components(separatedBy: "\n\n")
        try (components.count == 2).throwIfFalse()

        // registers
        let registers = components[0].components(separatedBy: "\n")
        try (registers.count == 3).throwIfFalse()

        func parseRegister(str: String, regName: String) throws -> Int {
            try str.starts(with: "Register \(regName): ").throwIfFalse()
            return try Int(str.replacingOccurrences(of: "Register \(regName): ", with: "")).throwIfNil()
        }

        regA = try parseRegister(str: registers[0], regName: "A")
        regB = try parseRegister(str: registers[1], regName: "B")
        regC = try parseRegister(str: registers[2], regName: "C")

        // program
        try components[1].starts(with: "Program: ").throwIfFalse()
        program = try components[1]
            .replacingOccurrences(of: "Program: ", with: "")
            .components(separatedBy: ",")
            .map { try Int($0).throwIfNil() }
    }

    func solve() throws {
        try program.count.isMultiple(of: 2).throwIfFalse()
        let instructions = try program
            .chunked(into: 2)
            .map { try Instruction(opcode: $0[0], operandValue: $0[1]) }

        let i = Interpreter(regA: regA, regB: regB, regC: regC, program: instructions)
        try i.run()
        regA = i.regA
        regB = i.regB
        regC = i.regC
        output = i.output

        print("Part 1:", output.map(\.str).joined(separator: ","))
    }
}

