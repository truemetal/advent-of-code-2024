import Foundation

class Part2 {
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
                var thisFrequencyAntinodes = Set<Coord>()

                for otherCoord in otherCoords {
                    let delta = coord.delta(to: otherCoord)
                    var harmonicsCoord = coord

                    // extend the ray up until area bounds
                    while fieldSize.isWithinBounds(coord: harmonicsCoord) {
                        thisFrequencyAntinodes.insert(harmonicsCoord)
                        harmonicsCoord = Coord(x: harmonicsCoord.x - delta.width, y: harmonicsCoord.y - delta.height)
                    }
                }

                antinodes[frequency] = (antinodes[frequency] ?? []).union(thisFrequencyAntinodes)
            }
        }

        debugPrint()
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
