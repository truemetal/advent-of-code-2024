import Foundation

class Part2 {
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
        var cache: [String: Int] = [:]

        func countPossibleOptions(design: String) -> Int {
            if let res = cache[design] {
                return res
            }

            var res = 0

            let towels = towels.filter { design.starts(with: $0) }
            for towel in towels {
                if towel == design {
                    cache[design] = (cache[design] ?? 0) + 1
                    res += 1
                }

                let rest = design.dropFirst(towel.count)
                res += countPossibleOptions(design: rest.str)
            }

            cache[design] = res
            return res
        }

        let count = designs.map {
            let res = countPossibleOptions(design: $0)
            return res
        }

        print("Part 2:", count.reduce(0, +))
    }
}
