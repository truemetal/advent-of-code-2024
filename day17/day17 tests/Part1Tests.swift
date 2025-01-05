import Testing

struct Part1Tests {
    @Test func test1() throws {
        let p1 = try Part1(contents: testInput)
        try p1.solve()
        #expect(p1.output == [4, 6, 3, 5, 6, 3, 5, 2, 1, 0])
    }

    @Test func test2() throws {
        let p1 = try Part1(contents: testInput2)
        try p1.solve()
        #expect(p1.regB == 1)
    }

    @Test func test3() throws {
        let p1 = try Part1(contents: testInput3)
        try p1.solve()
        #expect(p1.output == [0, 1, 2])
    }

    @Test func test4() throws {
        let p1 = try Part1(contents: testInput4)
        try p1.solve()
        #expect(p1.output == [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0])
        #expect(p1.regA == 0)
    }

    @Test func test5() throws {
        let p1 = try Part1(contents: testInput5)
        try p1.solve()
        #expect(p1.regB == 26)
    }

    @Test func test6() throws {
        let p1 = try Part1(contents: testInput6)
        try p1.solve()
        #expect(p1.regB == 44354)
    }
}
