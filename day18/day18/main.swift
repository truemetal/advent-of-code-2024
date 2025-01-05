import Foundation

//let contents = testInput; let size = Size(width: 7, height: 7); let prefix = 12
let contents = realInput; let size = Size(width: 71, height: 71); let prefix = 1024

try Part1(contents: contents, size: size, prefix: prefix).solve()
// part 2 runs a bit slow, running in release mode makes it faster
try Part2(contents: contents, size: size, prefix: prefix).solve()
