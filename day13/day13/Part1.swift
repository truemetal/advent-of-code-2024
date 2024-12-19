import Foundation

class Part1 {
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
                return MachineInput(aOffset: Coord(x: aInput[0], y: aInput[1]), bOffset: Coord(x: bInput[0], y: bInput[1]), prize: Coord(x: prize[0], y: prize[1]))
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
        let aX = input.aOffset.x
        let aY = input.aOffset.y
        let bX = input.bOffset.x
        let bY = input.bOffset.y
        let pX = input.prize.x
        let pY = input.prize.y

        // bT = (pY * aX - pX * aY) / (bY * aX - bX * aY)
        // aT = (pX - bT * bX) / aX

        if (pY*aX-pX*aY) % (bY*aX-bX*aY) != 0 { return nil }
        let bTaps = (pY*aX-pX*aY) / (bY*aX-bX*aY)
        if (pX-bTaps*bX) % aX != 0 { return nil }
        let aTaps = (pX-bTaps*bX) / aX

        return (aTaps, bTaps)
    }
}

// prizeX = aTaps * aX + bTaps * bX
// prizeY = aTaps * aY + bTaps * bY
// aTaps = (pX - bTaps * bX) / aX << !
// (pX - bTaps * bX) / aX * aY + bTaps * bY = pY
// pX / aX * aY - bTaps * bX / aX * aY + bTaps * bY = pY
// bTaps * (by - bX / aX * aY) = pY - pX / aX * aY
// bT = (pY - pX / aX * aY) / (by - bX / aX * aY)
// bT = (pY * aX - pX * aY) / (bY * aX - bX * aY) << !
