import CustomDump
import XCTest

@testable import AdventOfCode

final class Day06Tests: XCTestCase {
    let testData = """
    """

    func testPart1() async throws {
        let actual = try await Day06(data: testData).part1()
        let expected = 0
        XCTAssertNoDifference(expected, actual)
    }

    func testPart2() async throws {
        let actual = try await Day06(data: testData).part2()
        let expected = 0
        XCTAssertNoDifference(expected, actual)
    }
}
