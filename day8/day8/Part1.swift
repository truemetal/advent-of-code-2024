import Foundation

class Part1 {
    let fieldSize: Size
    let antennas: [Character: Set<Coord>]
    var antinodes: [Character: Set<Coord>] = [:]

    init(contents: String) throws {
        let lines = contents.split(separator: "\n").map { Array($0) }
        fieldSize = Size(width: lines[0].count, height: lines.count)

        var antennas: [Character: Set<Coord>] = [:]

        for y in 0 ..< fieldSize.height {
            for x in 0 ..< fieldSize.width {
                let tile = lines[y][x]
                if tile == "." { continue }

                var coords = antennas[tile, default: Set<Coord>()]
                coords.insert(Coord(x: x, y: y))
                antennas[tile] = coords
            }
        }

        self.antennas = antennas
    }

    func solve() throws {
        for (frequency, coords) in antennas {
            for coord in coords {
                let otherCoords = coords.subtracting([coord])
                let deltas = otherCoords.map { coord.delta(to: $0) }
                let thisFrequencyAntinodes = deltas
                    .map { Coord(x: coord.x - $0.width * 2, y: coord.y - $0.height * 2) }
                    .filter {
                        $0.x >= 0 && $0.y >= 0 && $0.x < fieldSize.width && $0.y < fieldSize.height
                    }

                antinodes[frequency] = (antinodes[frequency] ?? []).union(thisFrequencyAntinodes)
            }
        }

//        debugPrint()
        let res = Set(antinodes.values.flatMap(\.self)).count
        print(res)
    }

    func debugPrint() {
        for y in 0 ..< fieldSize.width {
            for x in 0 ..< fieldSize.height {
                if let _ = antinodes.first(where: { $1.contains(Coord(x: x, y: y)) }) {
                    print("#", terminator: "")
                    continue
                }

                if let first = antennas.first(where: { $1.contains(Coord(x: x, y: y)) }) {
                    print(first.key, terminator: "")
                    continue
                }

                print(".", terminator: "")
            }
            print("    ", terminator: "")

            for x in 0 ..< fieldSize.height {
                if let first = antennas.first(where: { $1.contains(Coord(x: x, y: y)) }) {
                    print(first.key, terminator: "")
                    continue
                }

                print(".", terminator: "")
            }

            print()
        }
    }
}
