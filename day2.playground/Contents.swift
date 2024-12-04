import Cocoa

let contents: String! = Bundle.main.url(forResource: "input", withExtension: "txt").flatMap { try? String(contentsOf: $0, encoding: .utf8) }

func part1() {
    var reports: [[Int]] = []

    reports = contents
        .split(separator: "\n")
        .map {
            $0.split(separator: " ")
                .map(String.init)
                .compactMap(Int.init)
        }

    func isReportSafe(_ report: [Int]) -> Bool {
        var expectedIsAscending = false
        for i in 1 ..< report.count {
            let isAscending = report[i] > report[i-1]
            if i == 1 { expectedIsAscending = isAscending }
            if expectedIsAscending != isAscending { return false }

            let diff = abs(report[i] - report[i-1])
            if (1 ... 3).contains(diff) == false { return false }
        }
        return true
    }

    var safeReports = reports.map { isReportSafe($0) }
    .count { $0 }
    print(safeReports)
}

func part2() {
    var reports: [[Int]] = []

    reports = contents
        .split(separator: "\n")
        .map {
            $0.split(separator: " ")
                .map(String.init)
                .compactMap(Int.init)
        }

    func failingIdx(forReport report: [Int]) -> Int? {
        var expectedIsAscending = false

        for i in 1 ..< report.count {
            let isAscending = report[i] > report[i-1]
            if i == 1 { expectedIsAscending = isAscending }

            if expectedIsAscending != isAscending {
                return i
            }

            let diff = abs(report[i] - report[i-1])
            if (1 ... 3).contains(diff) == false {
                return i
            }
        }

        return nil
    }

    let safeReports = reports.count {
        var report = $0
        let idx = failingIdx(forReport: report)
        if idx == nil { return true }
        
        for i in 0 ..< report.count {
            var report = report
            report.remove(at: i)
            if failingIdx(forReport: report) == nil { return true }
        }

        return false
    }

    print(safeReports)
}


//part1()
part2()
