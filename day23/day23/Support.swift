import Foundation

func combinations<T>(_ array: [T], _ k: Int) -> [[T]] {
    guard k > 0 else { return [[]] }
    guard array.count >= k else { return [] }

    if k == array.count { return [array] }

    var result: [[T]] = []

    for (index, element) in array.enumerated() {
        let remaining = Array(array[(index+1)...])
        for subCombination in combinations(remaining, k - 1) {
            result.append([element] + subCombination)
        }
    }

    return result
}
