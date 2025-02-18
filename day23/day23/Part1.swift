import Foundation

class Part1 {
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
        let possibleKeys = Set(dict.keys)
        var possibleTriplets: Set<Set<String>> = []

        possibleKeys.forEach { key in
            let connections = dict[key, default: []] + [key]
            let res = combinations(connections, 3).map(\.set).set
            possibleTriplets = possibleTriplets.union(res)
        }

        possibleTriplets = possibleTriplets.filter { set in
            set.contains { $0.starts(with: "t") }
        }

        possibleTriplets = possibleTriplets.filter { set in
            for item in set {
                var others = set
                others.remove(item)
                if dict[item, default: []].isSuperset(of: others) == false { return false }
            }
            return true
        }

        print("Part 1:", possibleTriplets.count)
    }
}
