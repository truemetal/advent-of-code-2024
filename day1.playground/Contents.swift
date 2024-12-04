import Cocoa

let contents: String! = Bundle.main.url(forResource: "input", withExtension: "txt").flatMap { try? String(contentsOf: $0, encoding: .utf8) }

func part1() {
    var arr1: [Int] = []
    var arr2: [Int] = []

    contents
        .split(separator: "\n")
        .forEach {
            let str = $0.components(separatedBy: "   ").compactMap(Int.init)
            arr1.append(str[0])
            arr2.append(str[1])
        }

    arr1.sort()
    arr2.sort()

    let res = zip(arr1, arr2)
        .map { abs($0.0 - $0.1) }
        .reduce(0, +)

    print(res)
}

func part2() {
    var arr1: [Int] = []
    var arr2: [Int: Int] = [:]

    contents
        .split(separator: "\n")
        .forEach {
            let str = $0.components(separatedBy: "   ").compactMap(Int.init)
            arr1.append(str[0])
            let count = arr2[str[1]] ?? 0
            arr2[str[1]] = count + 1
        }

    arr1.sort()

    let res = arr1
        .map { $0 * (arr2[$0] ?? 0) }
        .reduce(0, +)

    print(res)
}

//part1()
part2()
