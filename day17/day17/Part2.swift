import Foundation

class Part2 {
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

        // getting close to the target regA value - it would have similar similar length to the program
        // https://www.reddit.com/r/adventofcode/comments/1hgcuw8/2024_day_17_part_2_any_hints_folks/?rdt=59414
        regA = pow(8, program.count - 1)

        while true {
            let i = Interpreter(regA: regA, regB: regB, regC: regC, program: instructions)
            try i.run()

            if i.output == program {
                print("Part 2:", regA.str)
                return
            }

            // an insight from the following source, we can optimize greatly optimize by amending digits based on it's position multiplied by 8, which is enourmously faster then just brute-force "regA += 1"
            // https://www.reddit.com/r/adventofcode/comments/1hgcuw8/comment/m2imogu/
            // https://www.bytesizego.com/blog/aoc-day17-golang
            try? (0 ..< min(i.output.count, program.count)).reversed().forEach {
                if i.output[$0] != program[$0] {
                    regA += pow(8, Int($0))
                    throw genericError
                }
            }
        }
    }
}

func pow(_ a: Int, _ b: Int) -> Int {
    Array(repeating: a, count: b).reduce(1, *)
}
