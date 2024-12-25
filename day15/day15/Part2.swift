import Foundation

class Part2 {
    var field: [[Tile]]
    var robotCoord: Coord
    let moves: [Direction]
    let withAnimation: Bool

    init(contents: String, withAnimation: Bool) throws {
        self.withAnimation = withAnimation
        let components = contents.components(separatedBy: "\n\n")

        var robotCoord: Coord?

        field = components[0]
            .split(separator: "\n")
            .enumerated()
            .map { (lineIdx, line) in
                Array(line).enumerated().flatMap { (charIdx, char) in
                    if char == "@" { robotCoord = Coord(x: charIdx * 2, y: lineIdx); return [Tile.nothing, .nothing] }
                    if char == "#" { return [.wall, .wall] }
                    else if char == "O" { return [.boxStart, .boxEnd] }
                    else if char == "." { return [.nothing, .nothing] }
                    fatalError()
                }
            }

        self.robotCoord = try robotCoord.throwIfNil()

        moves = components[1]
            .replacingOccurrences(of: "\n", with: "")
            .map {
                if $0 == "^" { return .up }
                if $0 == "v" { return .down }
                if $0 == "<" { return .left }
                if $0 == ">" { return .right }
                fatalError()
            }
    }

    func solve() throws {
        for move in moves {
            if withAnimation {
                usleep(50 * 1000)
                cls()
                printField()
            }
            try self.move(direction: move)
        }

        var res = 0
        for y in 0 ..< field.count {
            for x in 0 ..< field[y].count {
                if field[y][x] == .boxStart { res += y * 100 + x }
            }
        }

        print(res)
    }

    func move(direction: Direction) throws {
        var layers: [Set<Coord>] = [[robotCoord]]
        guard try checkMovePossibility(forLayers: &layers, direction: direction) else { return }
        try performMove(layers: layers, direction: direction)
        robotCoord = robotCoord.byMoving(direction)
    }

    func performMove(layers: [Set<Coord>], direction: Direction) throws {
        for layer in layers.reversed() {
            for coord in layer {
                let nextCoord = coord.byMoving(direction)
                field[nextCoord.y][nextCoord.x] = field[coord.y][coord.x]
                field[coord.y][coord.x] = .nothing
            }
        }
    }

    func checkMovePossibility(forLayers layers: inout [Set<Coord>], direction: Direction) throws -> Bool {
        switch direction {
        case .left, .right:
            return try checkMovePossibilityHorizontal(forLayers: &layers, direction: direction)

        case .up, .down:
            return try checkMovePossibilityVertical(forLayers: &layers, direction: direction)
        }
    }

    func checkMovePossibilityHorizontal(forLayers layers: inout [Set<Coord>], direction: Direction) throws -> Bool {
        while true {
            let lastLayer = try layers.last.throwIfNil()
            try (lastLayer.count == 1).throwIfFalse()

            let coord = try lastLayer.first.throwIfNil()
            let nextCoord = coord.byMoving(direction)

            if field[nextCoord.y][nextCoord.x] == .nothing { return true }
            if field[nextCoord.y][nextCoord.x] == .wall { return false }

            if field[nextCoord.y][nextCoord.x] == .boxStart {
                switch direction {
                case .left, .down, .up: throw genericError

                case .right:
                    layers.append([nextCoord])
                    layers.append([nextCoord.byMoving(.right)])
                }
            }

            if field[nextCoord.y][nextCoord.x] == .boxEnd {
                switch direction {
                case .right, .down, .up: throw genericError

                case .left:
                    layers.append([nextCoord])
                    layers.append([nextCoord.byMoving(.left)])
                }
            }
        }
    }

    func checkMovePossibilityVertical(forLayers layers: inout [Set<Coord>], direction: Direction) throws -> Bool {
        try [Direction.up, .down].contains(direction).throwIfFalse()

        let layer = try layers.last.throwIfNil()
        var newLayer: Set<Coord> = []

        for coord in layer {
            let nextCoord = coord.byMoving(direction)
            switch field[nextCoord.y][nextCoord.x] {
            case .nothing: continue
            case .wall: return false
            case .boxStart:
                newLayer.formUnion([nextCoord, nextCoord.byMoving(.right)])
            case .boxEnd: newLayer.formUnion([nextCoord, nextCoord.byMoving(.left)])
            case .box: throw genericError
            }
        }

        newLayer.subtract(layer)
        if newLayer.isEmpty { return true }

        layers.append(newLayer)
        return try checkMovePossibility(forLayers: &layers, direction: direction)
    }

    func printField() {
        var res = field.map {
            $0.map {
                switch $0 {
                case .nothing: return "."
                case .wall: return "#"
                case .box: fatalError()
                case .boxStart: return "["
                case .boxEnd: return "]"
                }
            }.joined()
        }

        if field[robotCoord.y][robotCoord.x] != .nothing { fatalError() }

        var robotLine = res[robotCoord.y].arr
        robotLine[robotCoord.x] = "@"
        res[robotCoord.y] = robotLine.str

        res.forEach { print($0) }
    }
}

func cls() {
    print("\u{001B}[2J") // clear the screen
    print("\u{001B}[0;0H", terminator: "") // jump to 0, 0
}
