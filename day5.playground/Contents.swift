import Cocoa
import RegexBuilder

struct GenericError: Error { }
let genericError = GenericError()

extension Optional {
    func throwIfNil() throws -> Wrapped {
        guard let self else { throw genericError }
        return self
    }
}

let testContents = Bundle.main.url(forResource: "test_input", withExtension: "txt").flatMap { try? String(contentsOf: $0, encoding: .utf8) }

let realContents = Bundle.main.url(forResource: "real_input", withExtension: "txt").flatMap { try? String(contentsOf: $0, encoding: .utf8) }

//let contents = try testContents.throwIfNil()
let contents = try realContents.throwIfNil()

// MARK: -

// key goes before values
var rules: [Int: Set<Int>] = [:]

try contents
    .components(separatedBy: "\n\n")[0]
    .components(separatedBy: "\n")
    .forEach {
        let rule = $0.components(separatedBy: "|")
        let a = try Int(rule[0]).throwIfNil()
        let b = try Int(rule[1]).throwIfNil()
        var set = rules[b] ?? []
        set.insert(a)
        rules[b] = set
    }

let sequences: [[Int]] = contents
    .components(separatedBy: "\n\n")[1]
    .components(separatedBy: "\n")
    .filter { $0.isEmpty == false }
    .map {
        $0
            .components(separatedBy: ",")
            .compactMap(Int.init)
    }

func isSequenceValid(_ sequence: [Int]) -> Bool {
    assert(sequence.count > 1)

    for idx in 1 ..< sequence.count {
        let prev = sequence[idx - 1]
        let current = sequence[idx]

        if let set = rules[prev], set.contains(current) { return false }
    }

    return true
}

// MARK: -

func part1() throws {
    let res = sequences
        .filter { isSequenceValid($0) }
        .map {
            $0[Int($0.count / 2)]
        }
        .reduce(0, +)

    print(res)
}

// MARK: -

func part2() {
    let incorrectSequences = sequences
        .filter { isSequenceValid($0) == false }

    func fixedSequence(_ sequence: [Int]) -> [Int] {
        assert(sequence.count > 1)
        var sequence = sequence

        for idx in 1 ..< sequence.count {
            let prev = sequence[idx - 1]
            let current = sequence[idx]

            if let set = rules[prev], set.contains(current) {
                sequence.swapAt(idx, idx - 1)
            }
        }

        if isSequenceValid(sequence) == false {
            sequence = fixedSequence(sequence)
        }

        return sequence
    }

    let res = incorrectSequences
        .enumerated()
        .map {
            let res = fixedSequence($1)
            print($0, isSequenceValid(res))
            return res
        }
        .map {
            $0[Int($0.count / 2)]
        }
        .reduce(0, +)

    print(res)
}

//try part1()
part2()
