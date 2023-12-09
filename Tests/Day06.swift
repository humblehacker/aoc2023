import CustomDump
import XCTest

@testable import AdventOfCode

final class Day06Tests: XCTestCase {
    let testData = """
    Time:      7  15   30
    Distance:  9  40  200
    """

    func testPart1() async throws {
        let actual = try await Day06(data: testData).part1()
        let expected = 288
        XCTAssertNoDifference(expected, actual)
    }

    func testPart2() async throws {
        let actual = try await Day06(data: testData).part2()
        let expected = 71503
        XCTAssertNoDifference(expected, actual)
    }
}
