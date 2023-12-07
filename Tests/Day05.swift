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
                MapEntry(dstRange: 49 ..< 49 + 8, srcRange: 53 ..< 53 + 8),
                MapEntry(dstRange: 0 ..< 0 + 42, srcRange: 11 ..< 11 + 42),
                MapEntry(dstRange: 42 ..< 42 + 7, srcRange: 0 ..< 0 + 7),
                MapEntry(dstRange: 57 ..< 57 + 4, srcRange: 7 ..< 7 + 4),
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
                        MapEntry(dstRange: 50 ..< 50 + 2, srcRange: 98 ..< 98 + 2),
                        MapEntry(dstRange: 52 ..< 52 + 48, srcRange: 50 ..< 50 + 48),
                    ]
                ),
                Map(
                    name: "soil-to-fertilizer",
                    entries: [
                        MapEntry(dstRange: 0 ..< 0 + 37, srcRange: 15 ..< 15 + 37),
                        MapEntry(dstRange: 37 ..< 37 + 2, srcRange: 52 ..< 52 + 2),
                        MapEntry(dstRange: 39 ..< 39 + 15, srcRange: 0 ..< 0 + 15),
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

    func testPart1() throws {
        let challenge = Day05(data: testData)
        XCTAssertNoDifference(35, try challenge.part1())
    }

    func testPart2() throws {
        let challenge = Day05(data: testData)
        XCTAssertNoDifference(46, try challenge.part2())
    }
}
