import Foundation

class Part1 {
    let field: [[Character]]
    let size: Size

    init(contents: String) throws {
        field = contents
            .components(separatedBy: "\n")
            .map { Array($0) }

        size = Size(width: field[0].count, height: field.count)
    }

    func solve() throws {
        let allCoords = (0 ..< field.count)
            .flatMap { y in
                (0 ..< field[y].count).map { x in Coord(x: x, y: y) }
            }
            .set

        var visitedCoords: Set<Coord> = []
        var areaAndPerimiter: [(Int, Int)] = []

        while visitedCoords != allCoords {
            let randomCoord = try allCoords.subtracting(visitedCoords).first.throwIfNil()

            var currentRegionArea: Int = 0
            var currentRegionPerimeter: Int = 0
            var thisCoords = Set<Coord>()

            exploreRegion(coord: randomCoord, visitedCoords: &thisCoords, area: &currentRegionArea, perimeter: &currentRegionPerimeter)

            visitedCoords = visitedCoords.union(thisCoords)

            areaAndPerimiter.append((currentRegionArea, currentRegionPerimeter))
        }

        let res = areaAndPerimiter
            .map { $0.0 * $0.1 }
            .reduce(0, +)

        print(res)
    }

    func exploreRegion(coord: Coord, visitedCoords: inout Set<Coord>, area: inout Int, perimeter: inout Int) {
        guard !visitedCoords.contains(coord) else { return }
        visitedCoords.insert(coord)
        let type = field[coord.y][coord.x]

        let newRegionCells = coord
            .neighbors
            .filter { $0.isValid(for: size) }
            .filter { !visitedCoords.contains($0) }
            .filter { field[$0.y][$0.x] == type }

        let neighborsOutsideThisRegionCount = coord
            .neighbors
            .count {
                if $0.isValid(for: size) {
                    let neighborType = field[$0.y][$0.x]
                    return neighborType != type
                }

                return true
            }

        area += 1
        perimeter += neighborsOutsideThisRegionCount

        newRegionCells.forEach {
            exploreRegion(coord: $0, visitedCoords: &visitedCoords, area: &area, perimeter: &perimeter)
        }
    }

    func printField() {
        field.forEach {
            print($0.str)
        }
    }
}
