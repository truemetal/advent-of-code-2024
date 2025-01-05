import Foundation

class Part1 {
    let towels: [String]
    let designs: [String]

    init(contents: String) throws {
        let components = contents.components(separatedBy: "\n\n")
        try (components.count == 2).throwIfFalse()

        towels = components[0].components(separatedBy: ", ")
        designs = components[1].components(separatedBy: "\n")
    }

    func solve() throws {
        let towels = towels.set
        var cache: [String: Bool] = [:]

        func isPossible(design: String) -> Bool {
            if let res = cache[design] { return res }

            let towels = towels.filter { design.starts(with: $0) }
            for towel in towels {
                if towel == design {
                    cache[design] = true
                    return true
                }
                let rest = design.dropFirst(towel.count)
                if isPossible(design: rest.str) { return true }
            }

            cache[design] = false
            return false
        }

        let count = designs.count { isPossible(design: $0) }
        print("Part 1:", count)
    }
}
