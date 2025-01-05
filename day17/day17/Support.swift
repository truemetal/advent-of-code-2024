import Foundation

enum Instruction {
    case adv(Operand)
    case bdv(Operand)
    case cdv(Operand)
    case bxl(Operand)
    case bst(Operand)
    case jnz(Operand)
    case bxc(Operand)
    case out(Operand)

    init(opcode: Int, operandValue: Int) throws {
        switch opcode {
        case 0: try self = .adv(Operand(comboValue: operandValue))
        case 1: try self = .bxl(Operand(literalValue: operandValue))
        case 2: try self = .bst(Operand(comboValue: operandValue))
        case 3: try self = .jnz(Operand(literalValue: operandValue))
        case 4: try self = .bxc(Operand(literalValue: operandValue))
        case 5: try self = .out(Operand(comboValue: operandValue))
        case 6: try self = .bdv(Operand(comboValue: operandValue))
        case 7: try self = .cdv(Operand(comboValue: operandValue))
        default: throw genericError
        }
    }
}

enum Operand {
    case regA, regB, regC, val(Int)

    init(comboValue: Int) throws {
        switch comboValue {
        case 0...3: self = .val(comboValue)
        case 4: self = .regA
        case 5: self = .regB
        case 6: self = .regC
        default: throw genericError
        }
    }

    init(literalValue: Int) throws {
        self = .val(literalValue)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
