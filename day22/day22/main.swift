import Foundation

//let contents = testInput2
let contents = realInput

try Part1(contents: contents).solve()
// this may take a minute, so there's a reportProgress to turn progress on/off
try Part2(contents: contents, reportProgress: false).solve()
