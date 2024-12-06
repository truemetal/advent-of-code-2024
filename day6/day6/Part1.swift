//
//  Part1.swift
//  day6
//
//  Created by Bohdan Pashchenko on 06.12.2024.
//

import Foundation

class Part1 {
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
        currentCoord = initialGuardCoord
    }

    func solve() throws {
        visitedCoords = [currentCoord]
        nextStep()
        print(visitedCoords.count)
    }

    private var currentCoord: Coord
    private var currentDirection: Direction = .up
    private var visitedCoords: Set<Coord> = []

    private func nextStep() {
        let nextCoord = currentCoord.move(currentDirection)
        guard let nextTile = field.tileAt(nextCoord) else { return }

        if nextTile == .obstacle {
            currentDirection.rotateRight()
        } else {
            currentCoord = nextCoord
            visitedCoords.insert(currentCoord)
        }

        nextStep()
    }
}
