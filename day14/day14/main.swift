import Foundation

//let contents = testInput
//let size = Size(width: 11, height: 7)

let contents = realInput
let size = Size(width: 101, height: 103)

try Part1(contents: contents, size: size).solve()
try Part2(contents: contents, size: size).solve()
