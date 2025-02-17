import Foundation

class Solver {
    let codes: [String]
    let sequentialRobotLayers: Int

    var sequentialKeypadRoutes: [String: [String]] = [:]
    var decimalKeypadRoutes: [String: [String]] = [:]

    init(contents: String, sequentialRobotLayers: Int) throws {
        codes = contents.components(separatedBy: "\n").filter(\.isNotEmpty)
        self.sequentialRobotLayers = sequentialRobotLayers
        makeDecimalKeypadRoutes()
        makeSequentialKeypadRoutes()
    }

    func makeSequentialKeypadRoutes() {
        let seqMap = """
X^A
<v>
""".split(separator: "\n").map { $0.arr.map(\.str) }

        let seqKeys = Set(["^", "v", "<", ">", "A"])
        let pathDestinations = seqKeys.flatMap { current in
            seqKeys.map { "\(current)\($0)" }
        }
        let coordForDestination: [String: Coord] = [
            "^": Coord(x: 1, y: 0),
            "A": Coord(x: 2, y: 0),
            "<": Coord(x: 0, y: 1),
            "v": Coord(x: 1, y: 1),
            ">": Coord(x: 2, y: 1)
        ]

        pathDestinations.forEach { dest in
            assert(dest.count == 2)
            let from = dest.arr[0].str
            let to = dest.arr[1].str
            if from == to { sequentialKeypadRoutes[dest] = ["A"] }
            else {
                sequentialKeypadRoutes["\(from)\(to)"] = Self.steps(map: seqMap, path: [coordForDestination[from]!], target: to)
            }
        }
    }

    func makeDecimalKeypadRoutes() {
        let decMap = """
789
456
123
X0A
""".split(separator: "\n").map { $0.arr.map(\.str) }

        let decKeys = Set(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A"])

        let pathDestinationsDec = decKeys.flatMap { current in
            decKeys.map { "\(current)\($0)" }
        }

        let coordForDestinationDec: [String: Coord] = [
            "0": Coord(x: 1, y: 3),
            "A": Coord(x: 2, y: 3),
            "1": Coord(x: 0, y: 2),
            "2": Coord(x: 1, y: 2),
            "3": Coord(x: 2, y: 2),
            "4": Coord(x: 0, y: 1),
            "5": Coord(x: 1, y: 1),
            "6": Coord(x: 2, y: 1),
            "7": Coord(x: 0, y: 0),
            "8": Coord(x: 1, y: 0),
            "9": Coord(x: 2, y: 0)
        ]

        pathDestinationsDec.forEach { dest in
            assert(dest.count == 2)
            let from = dest.arr[0].str
            let to = dest.arr[1].str
            if from == to { decimalKeypadRoutes[dest] = ["A"] }
            else {
                decimalKeypadRoutes["\(from)\(to)"] = Self.steps(map: decMap, path: [coordForDestinationDec[from]!], target: to)
            }
        }
    }

    static func steps(map: [[String]], path: [Coord], target: String) -> [String] {
        let visitred = path.map { map[$0.y][$0.x] }.set
        let mapSize = map.size

        var res: [String] = []
        let directions = [Step.up, .down, .left, .right]

        for dir in directions {
            let newCoord = path.last!.move(dir)
            guard newCoord.isValid(forSize: mapSize) else { continue }
            let newChar = map[newCoord.y][newCoord.x]
            guard newChar != "X", visitred.contains(newChar) == false else { continue }

            if newChar == target {
                res = [(path + [newCoord]).steps(size: mapSize)]
                break
            }

            res += steps(map: map, path: path + [newCoord], target: target)
        }

        let min = res.min { $0.count < $1.count }?.count ?? 0
        return res.filter { $0.count <= min }
    }

    func solve() throws -> Int {
        var sum = 0

        for code in codes {
            let decKbdCode = codeToDecCode(code: code)
            let len = decKbdCode.map { seqCodeLength(code: $0, depth: sequentialRobotLayers) }.min()!
            sum += len * code.replacingOccurrences(of: "A", with: "").int!
        }

        return sum
    }

    var cache: [String: Int] = [:]

    func seqCodeLength(code: String, depth: Int) -> Int {
        let cacheKey = "\(code)-\(depth)"
        if let v = cache[cacheKey] { return v }

        if depth == 1 {
            var len = 0
            for (a, b) in zip(("A" + code).arr.map(\.str), code.arr.map(\.str)) {
                len += sequentialKeypadRoutes[a + b]![0].count
                cache[cacheKey] = len
            }

            return len
        }

        var len = 0
        for (a, b) in zip(("A" + code).arr.map(\.str), code.arr.map(\.str)) {
            var minLen = Int.max
            for subSeq in sequentialKeypadRoutes[a + b]! {
                minLen = min(seqCodeLength(code: subSeq, depth: depth - 1), minLen)
            }
            len += minLen
        }

        cache[cacheKey] = len
        return len
    }

    func codeToDecCode(code: String) -> [String] {
        var res: [String] = []

        var queue: [(String, String)] = [("", "A" + code)]

        while let (currentSequence, code) = queue.popLast() {
            let currentButton = code.arr[0].str
            let nextButton = code.arr[1].str

            let options = decimalKeypadRoutes[currentButton + nextButton]!

            if code.count == 2 {
                res += options.map { currentSequence + $0 }
            }
            else {
                queue += options.map { (currentSequence + $0, code.dropFirst().str) }
            }
        }

        return res
    }
}
