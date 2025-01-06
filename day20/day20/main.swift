import Foundation

//let contents = testInput
let contents = realInput

// Part1 is quite long, unfortunately
try Part1(contents: contents, printProgress: false).solve()
try Part2(contents: contents).solve()
