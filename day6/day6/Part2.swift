//
//  Part2.swift
//  day6
//
//  Created by Bohdan Pashchenko on 06.12.2024.
//

import Foundation

class Part2 {
    var field: [[Tile]]
    let initialGuardCoord: Coord

    init(contents: String) throws {
        field = contents
            .split(separator: "\n")
            .filter { $0.isEmpty == false }
            .map {
                $0.map {
                    if $0 == "." { return .empty }
                    else if $0 == "#" { return .obstacle }
                    else if $0 == "^" { return .human }
                    else { fatalError() }
                }
            }

        initialGuardCoord = try field.guardCoord
        field[initialGuardCoord.y][initialGuardCoord.x] = .empty
    }

    func solve() throws {
        var loopedRoutesCount = 0

        print("total:", field.count * field[0].count)
        var currentIteration = 0

        for y in 0 ..< field.count {
            for x in 0 ..< field[y].count {
                print("currentIteration:", currentIteration)
                currentIteration += 1

                let newObstacleCoord = Coord(x: x, y: y)
                if newObstacleCoord == initialGuardCoord { continue }
                else if field.tileAt(newObstacleCoord) == .obstacle { continue }

                var newField = field
                newField[newObstacleCoord.y][newObstacleCoord.x] = .obstacle

                let guardRouteCalculator = GuardRouteCalculator(field: newField, currentCoord: initialGuardCoord)
                if guardRouteCalculator.isLooped() {
                    loopedRoutesCount += 1
                }
            }
        }

        print(loopedRoutesCount)
    }

}

class GuardRouteCalculator {
    init(field: [[Tile]], currentCoord: Coord) {
        self.field = field
        self.currentCoord = currentCoord
        self.visitedTiles = [Vector(coord: currentCoord, direction: currentDirection)]
    }

    let field: [[Tile]]
    var currentCoord: Coord
    var currentDirection: Direction = .up
    var visitedTiles: Set<Vector>

    func isLooped() -> Bool {
        let nextCoord = currentCoord.move(currentDirection)
        let nextVector = Vector(coord: nextCoord, direction: currentDirection)

        if visitedTiles.contains(nextVector) { return true }

        guard let nextTile = field.tileAt(nextCoord) else { return false }

        if nextTile == .obstacle {
            currentDirection.rotateRight()
        } else {
            currentCoord = nextCoord
            visitedTiles.insert(Vector(coord: currentCoord, direction: currentDirection))
        }

        return isLooped()
    }
}
