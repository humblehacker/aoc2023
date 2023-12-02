import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day01Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    1six7396484
    1ninehgqtjprgnpkchxdkctzk
    sevenmpsmstdfivebtnjljnlnpjrkhhsninefour9
    pppmfmnfourtworxrqrfhbgx8vvxgrjzhvqmztltwo
    9eightctkdnnllnine
    1eight3shhj8hrglbhxsixvhntf
    4rlqzthlhkxvzhcm6
    bklcbpdlfctwofivesqvpxjjzlvn35zhlljrfqf
    36qv
    76six66nine
    eightxfcmkqjqxzxjvrfive3
    """

    func testExtractCalibrationValuesP1() {
        let expected = [14, 11, 99, 88, 99, 18, 46, 35, 36, 76, 33]
        let challenge = Day01(data: testData)
        XCTAssertEqual(expected, Day01.extractCalibrationValuesP1(input: challenge.entities))
    }

    func testExtractCalibrationValuesP2() {
        let expected = [14, 19, 79, 42, 99, 16, 46, 25, 36, 79, 83]
        let challenge = Day01(data: testData)
        XCTAssertEqual(expected, Day01.extractCalibrationValuesP2(input: challenge.entities))
    }

    func testPart1() throws {
        let challenge = Day01(data: testData)
        XCTAssertEqual(555, challenge.part1())
    }

    func testPart2() throws {
        let challenge = Day01(data: testData)
        XCTAssertEqual(538, challenge.part2())
    }
}
