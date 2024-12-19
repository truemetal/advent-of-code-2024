import Foundation

class Part1 {
    var field: [[Tile]]
    var robotCoord: Coord
    let moves: [Direction]

    init(contents: String) throws {
        let components = contents.components(separatedBy: "\n\n")

        var robotCoord: Coord?

        field = components[0]
            .split(separator: "\n")
            .enumerated()
            .map { (lineIdx, line) in
                Array(line).enumerated().map { (charIdx, char) in
                    if char == "@" { robotCoord = Coord(x: charIdx, y: lineIdx); return Tile.nothing }
                    if char == "#" { return .wall }
                    else if char == "O" { return .box }
                    else if char == "." { return .nothing }
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
            self.move(direction: move)
        }

        var res = 0
        for y in 0 ..< field.count {
            for x in 0 ..< field[y].count {
                if field[y][x] == .box { res += y * 100 + x }
            }
        }

        print(res)
    }

    func move(direction: Direction) {
        var nextCoord = robotCoord.byMoving(direction)

        if field[nextCoord.y][nextCoord.x] == .nothing {
            robotCoord = nextCoord
            return
        }

        if field[nextCoord.y][nextCoord.x] == .wall {
            return
        }

        while field[nextCoord.y][nextCoord.x] == .box {
            nextCoord = nextCoord.byMoving(direction)
        }

        if field[nextCoord.y][nextCoord.x] == .nothing {
            field[nextCoord.y][nextCoord.x] = .box
            robotCoord = robotCoord.byMoving(direction)
            field[robotCoord.y][robotCoord.x] = .nothing
        }
    }

    func printField() {
        field.forEach {
            $0.forEach {
                switch $0 {
                case .nothing: print(".", terminator: "")
                case .wall: print("#", terminator: "")
                case .box: print("O", terminator: "")
                case .boxStart, .boxEnd: fatalError()
                }
            }
            print()
        }
    }
}
