import CustomDump
import XCTest

@testable import AdventOfCode

final class Day05Tests: XCTestCase {
    let testData = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

    func testParseMap() throws {
        let input = """
        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4
        """
        let expected = Map(
            name: "fertilizer-to-water",
            entries: [
                MapEntry(srcRange: 53 ..< 53 + 8, dstOffset: -4),
                MapEntry(srcRange: 11 ..< 11 + 42, dstOffset: -11),
                MapEntry(srcRange: 0 ..< 0 + 7, dstOffset: 42),
                MapEntry(srcRange: 7 ..< 7 + 4, dstOffset: 50),
            ]
        )
        let actual = try MapParser().parse(input)
        XCTAssertNoDifference(expected, actual)
    }

    func testAlmanacParser() throws {
        let input = """
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15
        """

        let expected = Almanac(
            seeds: [79, 14, 55, 13],
            maps: [
                Map(
                    name: "seed-to-soil",
                    entries: [
                        MapEntry(srcRange: 98 ..< 98 + 2, dstOffset: -48),
                        MapEntry(srcRange: 50 ..< 50 + 48, dstOffset: 2),
                    ]
                ),
                Map(
                    name: "soil-to-fertilizer",
                    entries: [
                        MapEntry(srcRange: 15 ..< 15 + 37, dstOffset: -15),
                        MapEntry(srcRange: 52 ..< 52 + 2, dstOffset: -15),
                        MapEntry(srcRange: 0 ..< 0 + 15, dstOffset: 39),
                    ]
                ),
            ]
        )
        let actual = try AlmanacParser().parse(input)
        XCTAssertNoDifference(expected, actual)
    }

    func testSeedRanges() throws {
        let almanac = Almanac(seeds: [79, 14, 55, 13], maps: [])
        let actual = almanac.seedRanges
        let expected = [79 ..< 93, 55 ..< 68]
        XCTAssertNoDifference(expected, actual)
    }

    func testPart1() async throws {
        let actual = try await Day05(data: testData).part1()
        let expected = 35
        XCTAssertNoDifference(expected, actual)
    }

    func testPart2() async throws {
        let actual = try await Day05(data: testData).part2()
        let expected = 46
        XCTAssertNoDifference(expected, actual)
    }
}
