import Foundation

class Part2 {
    let machineInputs: [MachineInput]

    init(contents: String) throws {
        machineInputs = try contents
            .components(separatedBy: "\n\n")
            .compactMap {
                let c = $0.components(separatedBy: "\n")
                guard c.count == 3 else { throw genericError }

                let aInput = c[0]
                    .replacingOccurrences(of: "Button A: ", with: "")
                    .replacingOccurrences(of: "X", with: "")
                    .replacingOccurrences(of: "Y", with: "")
                    .components(separatedBy: ", ")
                    .compactMap(Int.init)

                let bInput = c[1]
                    .replacingOccurrences(of: "Button B: ", with: "")
                    .replacingOccurrences(of: "X", with: "")
                    .replacingOccurrences(of: "Y", with: "")
                    .components(separatedBy: ", ")
                    .compactMap(Int.init)

                let prize = c[2]
                    .replacingOccurrences(of: "Prize: ", with: "")
                    .replacingOccurrences(of: "X=", with: "")
                    .replacingOccurrences(of: "Y=", with: "")
                    .components(separatedBy: ", ")
                    .compactMap(Int.init)

                guard aInput.count == 2, bInput.count == 2, prize.count == 2 else { throw genericError }
                let resModifier = 10000000000000
                return MachineInput(aOffset: Coord(x: aInput[0], y: aInput[1]), bOffset: Coord(x: bInput[0], y: bInput[1]), prize: Coord(x: prize[0] + resModifier, y: prize[1] + resModifier))
            }
    }

    func solve() throws {
        let res = machineInputs
            .compactMap { solveSystemOfEquations(input: $0) }
            .map { $0.0 * 3 + $0.1 }
            .reduce(0, +)

        print(res)
    }

    func solveSystemOfEquations(input: MachineInput) -> (Int, Int)? {
        let ax = input.aOffset.x
        let ay = input.aOffset.y
        let bx = input.bOffset.x
        let by = input.bOffset.y
        let px = input.prize.x
        let py = input.prize.y

        if (py*ax-px*ay) % (by*ax-bx*ay) != 0 { return nil }
        let bTaps = (py*ax-px*ay) / (by*ax-bx*ay)
        if (px-bTaps*bx) % ax != 0 { return nil }
        let aTaps = (px-bTaps*bx) / ax

        return (aTaps, bTaps)
    }

}
