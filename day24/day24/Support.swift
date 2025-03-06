import Foundation

enum Operation {
    case or(lhs: String, rhs: String)
    case xor(lhs: String, rhs: String)
    case and(lhs: String, rhs: String)

    var lhs: String {
        switch self {
        case .or(let lhs, rhs: _): return lhs
        case .xor(let lhs, rhs: _): return lhs
        case .and(let lhs, rhs: _): return lhs
        }
    }

    var rhs: String {
        switch self {
        case .or(lhs: _, let rhs): return rhs
        case .xor(lhs: _, let rhs): return rhs
        case .and(lhs: _, let rhs): return rhs
        }
    }

    func perform(lhs: Bool, rhs: Bool) -> Bool {
        switch self {
        case .or: return lhs || rhs
        case .and: return lhs && rhs
        case .xor: return lhs != rhs
        }
    }
}

extension Array {
    func subsets(ofLength length: Int) -> [[Element]] {
        guard length > 0 && length <= self.count else { return [] }

        var result: [[Element]] = []

        func backtrack(_ start: Int, _ currentSubset: [Element]) {
            if currentSubset.count == length {
                result.append(currentSubset)
                return
            }

            for i in start ..< self.count {
                backtrack(i + 1, currentSubset + [self[i]])
            }
        }

        backtrack(0, [])
        return result
    }
}
