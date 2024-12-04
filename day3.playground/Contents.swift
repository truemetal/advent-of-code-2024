import Cocoa
import RegexBuilder

let contents: String! = Bundle.main.url(forResource: "input", withExtension: "txt").flatMap { try? String(contentsOf: $0, encoding: .utf8) }

func part1() {
    let regex = Regex {
        "mul("
        Capture {
            OneOrMore(.digit)
        }
        ","
        Capture {
            OneOrMore(.digit)
        }
        ")"
    }

    func processMatch(_ match: (Substring, Substring, Substring)) -> Int? {
        guard let a = Int(match.1), let b = Int(match.2) else { return nil }
        return a * b
    }

    let res = contents
        .matches(of: regex)
        .compactMap { processMatch($0.output) }
        .reduce(0, +)

    print(res)
}

func part2() {
    let regex = Regex {
        ChoiceOf {
            Regex {
                "mul("

                Capture {
                    OneOrMore(.digit)
                }
                ","
                Capture {
                    OneOrMore(.digit)
                }
                ")"
            }

            Capture {
                "do()"
            }

            Capture {
                "don't()"
            }
        }
    }

    var processingEnabled = true

    func processMulMatch(_ match: [Substring?]) -> Int? {
        guard processingEnabled else { return nil }

        let match = match.compactMap(\.self)
        guard let a = Int(match[1]), let b = Int(match[2]) else { return nil }

        return a * b
    }

    func processMatch(_ match: [Substring?]) -> Int? {
        if match[3] == "do()" {
            processingEnabled = true
            return nil
        }
        else if match[4] == "don't()" {
            processingEnabled = false
            return nil
        }

        return processMulMatch(match)
    }

    let res = contents
        .matches(of: regex)
        .map { $0.output }
        .map { [$0.0, $0.1, $0.2, $0.3, $0.4] }
        .compactMap { processMatch($0) }
        .reduce(0, +)

    print(res)
}

part1()
part2()
