import Foundation

class Part2 {
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
            var thisCoords = Set<Coord>()

            exploreRegion(coord: randomCoord, visitedCoords: &thisCoords, area: &currentRegionArea)

            visitedCoords = visitedCoords.union(thisCoords)
            let currentRegionSidesCount = try calculateSidesFor(region: thisCoords)

            areaAndPerimiter.append((currentRegionArea, currentRegionSidesCount))
        }

        let res = areaAndPerimiter
            .map { $0.0 * $0.1 }
            .reduce(0, +)

        print(res)
    }

    func exploreRegion(coord: Coord, visitedCoords: inout Set<Coord>, area: inout Int) {
        guard !visitedCoords.contains(coord) else { return }
        visitedCoords.insert(coord)
        let type = field[coord.y][coord.x]

        let newRegionCells = coord
            .neighbors
            .filter { $0.isValid(for: size) }
            .filter { !visitedCoords.contains($0) }
            .filter { field[$0.y][$0.x] == type }

        area += 1

        newRegionCells.forEach {
            exploreRegion(coord: $0, visitedCoords: &visitedCoords, area: &area)
        }
    }

    func calculateSidesFor(region: Set<Coord>) throws -> Int {
        var corners = 0

        func checkForCorners(coord: Coord) {
            let upCoord = coord.coord(forDirection: .up)
            let downCoord = coord.coord(forDirection: .down)
            let leftCoord = coord.coord(forDirection: .left)
            let rightCoord = coord.coord(forDirection: .right)

            let upRightCoord = coord.coord(forDirection: .up).coord(forDirection: .right)
            let upLeftCoord = coord.coord(forDirection: .up).coord(forDirection: .left)
            let downRightCoord = coord.coord(forDirection: .down).coord(forDirection: .right)
            let downLeftCoord = coord.coord(forDirection: .down).coord(forDirection: .left)

            let upSameType = region.contains(upCoord)
            let downSameType = region.contains(downCoord)
            let rightSameType = region.contains(rightCoord)
            let leftSameType = region.contains(leftCoord)
            
            let upRightSameType = region.contains(upRightCoord)
            let upLeftSameType = region.contains(upLeftCoord)
            let downRightSameType = region.contains(downRightCoord)
            let downLeftSameType = region.contains(downLeftCoord)

            // internal corners
            if upSameType && rightSameType && !upRightSameType { corners += 1 }
            if upSameType && leftSameType && !upLeftSameType { corners += 1 }
            if downSameType && rightSameType && !downRightSameType { corners += 1 }
            if downSameType && leftSameType && !downLeftSameType { corners += 1 }

            // external corners
            if !upSameType && !rightSameType { corners += 1 }
            if !upSameType && !leftSameType { corners += 1 }
            if !downSameType && !rightSameType { corners += 1 }
            if !downSameType && !leftSameType { corners += 1 }
        }

        region.forEach { checkForCorners(coord: $0) }

        return corners // corners equal sides
    }
}
