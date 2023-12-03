import CustomDump
import XCTest

@testable import AdventOfCode

final class Day03Tests: XCTestCase {
    let testData = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    func testPart1() throws {
        let challenge = Day03(data: testData)
        XCTAssertEqual(4361, challenge.part1())
    }

    // func testPart2() throws {
    //     let challenge = Day03(data: testData)
    //     XCTAssertEqual(2286, challenge.part2())
    // }
}
