import Foundation

class Interpreter {
    var regA: Int
    var regB: Int
    var regC: Int

    var program: [Instruction]
    var output: [Int] = []

    init(regA: Int, regB: Int, regC: Int, program: [Instruction]) {
        self.regA = regA
        self.regB = regB
        self.regC = regC
        self.program = program
    }

    func run() throws {
        while currentInstructionPointer < program.count {
            let instruction = program[currentInstructionPointer]
            performInstruction(instruction)
        }
    }

    var currentInstructionPointer = 0

    func performInstruction(_ instruction: Instruction) {
        switch instruction {
        case .adv(let operand):
            regA = Int(regA.dbl / pow(2, val(for: operand).dbl))

        case .bdv(let operand):
            regB = Int(regA.dbl / pow(2, val(for: operand).dbl))

        case .cdv(let operand):
            regC = Int(regA.dbl / pow(2, val(for: operand).dbl))

        case .bxl(let operand):
            regB = regB ^ val(for: operand)

        case .bst(let operand):
            regB = val(for: operand) % 8

        case .jnz(let operand):
            if regA != 0 {
                currentInstructionPointer = val(for: operand)
                return
            }

        case .bxc:
            regB = regB ^ regC

        case .out(let operand):
            output.append(val(for: operand) % 8)
        }

        currentInstructionPointer += 1
    }

    func val(for o: Operand) -> Int {
        switch o {
        case .regA: return regA
        case .regB: return regB
        case .regC: return regC
        case .val(let v): return v
        }
    }
}
