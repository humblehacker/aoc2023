import CustomDump
import XCTest

@testable import AdventOfCode

final class Day02Tests: XCTestCase {
    let testData = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    func testColorCountParser() throws {
        do {
            let input = "3 blue"
            let actual = try ColorCountParser().parse(input)
            let expected = ColorCount(count: 3, color: .blue)
            XCTAssertNoDifference(expected, actual)
        }
        do {
            let input = "10 green"
            let actual = try ColorCountParser().parse(input)
            let expected = ColorCount(count: 10, color: .green)
            XCTAssertNoDifference(expected, actual)
        }
        do {
            let input = "114 red"
            let actual = try ColorCountParser().parse(input)
            let expected = ColorCount(count: 114, color: .red)
            XCTAssertNoDifference(expected, actual)
        }
    }

    func testGameRecordParser() throws {
        do {
            let input = "1 red, 2 green, 6 blue"
            let actual = try GameRecordParser().parse(input)
            let expected = GameRecord(counts: [ColorCount(count: 1, color: .red), ColorCount(count: 2, color: .green), ColorCount(count: 6, color: .blue)])
            XCTAssertNoDifference(expected, actual)
        }

        do {
            let input = "2 green"
            let actual = try GameRecordParser().parse(input)
            let expected = GameRecord(counts: [ColorCount(count: 2, color: .green)])
            XCTAssertNoDifference(expected, actual)
        }
    }

    func testGameParser() throws {
        let input = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
        let actual = try GameParser().parse(input)
        let expected = Game(
            number: 3,
            records: [
                GameRecord(counts: [ColorCount(count: 8, color: .green), ColorCount(count: 6, color: .blue), ColorCount(count: 20, color: .red)]),
                GameRecord(counts: [ColorCount(count: 5, color: .blue), ColorCount(count: 4, color: .red), ColorCount(count: 13, color: .green)]),
                GameRecord(counts: [ColorCount(count: 5, color: .green), ColorCount(count: 1, color: .red)]),
            ]
        )
        XCTAssertNoDifference(expected, actual)
    }

    func testGamesParser() throws {
        let input = """
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        """
        let actual = try GamesParser().parse(input)
        let expected = [
            Game(
                number: 2,
                records: [
                    GameRecord(red: 0, green: 2, blue: 1),
                    GameRecord(red: 1, green: 3, blue: 4),
                    GameRecord(red: 0, green: 1, blue: 1),
                ]
            ),
            Game(
                number: 3,
                records: [
                    GameRecord(red: 20, green: 8, blue: 6),
                    GameRecord(red: 4, green: 13, blue: 5),
                    GameRecord(red: 1, green: 5, blue: 0),
                ]
            ),
        ]

        XCTAssertNoDifference(expected, actual)
    }

    func testPart1() throws {
        let challenge = Day02(data: testData)
        XCTAssertEqual(8, challenge.part1())
    }

    func testPart2() throws {
        let challenge = Day02(data: testData)
        XCTAssertEqual(2286, challenge.part2())
    }
}
