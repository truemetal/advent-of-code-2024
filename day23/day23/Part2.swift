import Foundation

class Part2 {
    var groups: [Set<String>] = []
    var dict: [String: Set<String>] = [:]

    init(contents: String) throws {
        contents.components(separatedBy: "\n").forEach {
            let pair = $0.components(separatedBy: "-")

            let one = pair[0]
            let two = pair[1]

            dict[one] = ((dict[one] ?? []) + [two]).set
            dict[two] = ((dict[two] ?? []) + [one]).set
        }
    }

    func solve() throws {
        let possibleSets = dict.map { $1.union([$0]) }

        var maxSet: Set<String> = []

        for possibleSet in possibleSets {
            for combinationLenghth in (0 ..< possibleSet.count).reversed() {
                if maxSet.count >= combinationLenghth { break }
                for combinantion in combinations(possibleSet.arr, combinationLenghth) {
                    if isGroup(set: combinantion.set) {
                        maxSet = combinantion.set
                    }
                }
            }
        }

        print("Part 2:", maxSet.sorted().joined(separator: ","))
    }

    func isGroup(set: Set<String>) -> Bool {
        for i in set {
            var set = set
            set.remove(i)
            if dict[i, default: []].isSuperset(of: set) == false { return false }
        }
        return true
    }
}

