//
//  Support.swift
//  day6
//
//  Created by Bohdan Pashchenko on 06.12.2024.
//

import Foundation

enum Tile {
    case empty, obstacle, human
}

extension Tile: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty: return "."
        case .obstacle: return "#"
        case .human: return "^"
        }
    }
}

enum Direction {
    case up, right, down, left

    var rotatedRight: Direction {
        switch self {
        case .up: return .right
        case .right: return .down
        case .down: return .left
        case .left: return .up
        }
    }

    mutating func rotateRight() {
        self = rotatedRight
    }
}

struct Coord: Hashable {
    let x: Int
    let y: Int

    func move(_ direction: Direction) -> Coord {
        switch direction {
        case .up: return Coord(x: x, y: y - 1)
        case .right: return Coord(x: x + 1, y: y)
        case .down: return Coord(x: x, y: y + 1)
        case .left: return Coord(x: x - 1, y: y)
        }
    }
}

struct Vector: Hashable {
    let coord: Coord
    let direction: Direction
}

extension Array where Element == [Tile] {
    func isValidCoord(_ coord: Coord) -> Bool {
        coord.x >= 0 && coord.y >= 0 && coord.x < self[0].count && coord.y < self.count
    }
}

extension Array where Element == [Tile] {
    var guardCoord: Coord {
        get throws {
            var x: Int?
            let y = self.firstIndex {
                x = $0.firstIndex { $0 == .human }
                return x != nil
            }
            return try Coord(x: x.throwIfNil(), y: y.throwIfNil())
        }
    }
}

extension Array where Element == [Tile] {
    func tileAt(_ coord: Coord) -> Tile? {
        self.isValidCoord(coord) ? self[coord.y][coord.x] : nil
    }
}
