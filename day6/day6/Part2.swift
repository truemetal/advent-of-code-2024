//
//  Part2.swift
//  day6
//
//  Created by Bohdan Pashchenko on 06.12.2024.
//

import Foundation

@MainActor
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

    var loopedRoutesCount = 0
    var currentIteration = 0

    func printCurrentIteration() {
        print("currentIteration:", currentIteration)
        currentIteration += 1
    }

    func solve() async throws {
        print("total:", field.count * field[0].count)

        await withTaskGroup(of: Void.self) { group in
            for y in 0 ..< field.count {
                for x in 0 ..< field[y].count {
                    group.addTask {
                        let newObstacleCoord = Coord(x: x, y: y)
                        if newObstacleCoord == self.initialGuardCoord { return }
                        else if await self.field.tileAt(newObstacleCoord) == .obstacle { return }

                        var newField = await self.field
                        newField[newObstacleCoord.y][newObstacleCoord.x] = .obstacle

                        let guardRouteCalculator = GuardRouteCalculator(field: newField, currentCoord: self.initialGuardCoord)
                        if await guardRouteCalculator.isLooped() {
                            await MainActor.run { self.loopedRoutesCount += 1 }
                        }

                        await self.printCurrentIteration()
                    }
                }
            }
        }

        print(loopedRoutesCount)
    }
}

actor GuardRouteCalculator {
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
        var nextCoord = currentCoord.move(currentDirection)
        var nextVector = Vector(coord: nextCoord, direction: currentDirection)

        while visitedTiles.contains(nextVector) == false {
            guard let nextTile = field.tileAt(nextCoord) else { return false }

            if nextTile == .obstacle {
                currentDirection.rotateRight()
            } else {
                currentCoord = nextCoord
                visitedTiles.insert(Vector(coord: currentCoord, direction: currentDirection))
            }

            nextCoord = currentCoord.move(currentDirection)
            nextVector = Vector(coord: nextCoord, direction: currentDirection)
        }

        return true
    }
}
