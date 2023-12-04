import CustomDump
import XCTest

@testable import AdventOfCode

final class Day04Tests: XCTestCase {
    let testData = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

    func testParseCard() throws {
        let input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
        let actual = try Day04.parseCard(input: input)
        let expected = Card(id: 1, winningNumbers: [41, 48, 83, 86, 17], ourNumbers: [83, 86, 6, 31, 17, 9, 48, 53])
        XCTAssertNoDifference(expected, actual)
    }

    func testParseCards() throws {
        let actual = try Day04.parseCards(input: testData)
        let expected = [
            Card(id: 1, winningNumbers: [41, 48, 83, 86, 17], ourNumbers: [83, 86, 6, 31, 17, 9, 48, 53]),
            Card(id: 2, winningNumbers: [13, 32, 20, 16, 61], ourNumbers: [61, 30, 68, 82, 17, 32, 24, 19]),
            Card(id: 3, winningNumbers: [1, 21, 53, 59, 44], ourNumbers: [69, 82, 63, 72, 16, 21, 14, 1]),
            Card(id: 4, winningNumbers: [41, 92, 73, 84, 69], ourNumbers: [59, 84, 76, 51, 58, 5, 54, 83]),
            Card(id: 5, winningNumbers: [87, 83, 26, 28, 32], ourNumbers: [88, 30, 70, 12, 93, 22, 82, 36]),
            Card(id: 6, winningNumbers: [31, 18, 13, 56, 72], ourNumbers: [74, 77, 10, 23, 35, 67, 36, 11]),
        ]
        XCTAssertNoDifference(expected, actual)
    }

    func testCalculatePoints_withWins() throws {
        let card = Card(id: 1, winningNumbers: [41, 48, 83, 86, 17], ourNumbers: [83, 86, 6, 31, 17, 9, 48, 53])
        let actual = Day04.calculatePoints(card: card)
        let expected = 8
        XCTAssertNoDifference(expected, actual)
    }

    func testCalculatePoints_noWins() throws {
        let card = Card(id: 6, winningNumbers: [31, 18, 13, 56, 72], ourNumbers: [74, 77, 10, 23, 35, 67, 36, 11])
        let actual = Day04.calculatePoints(card: card)
        let expected = 0
        XCTAssertNoDifference(expected, actual)
    }

    func testPart1() throws {
        let challenge = Day04(data: testData)
        XCTAssertNoDifference(13, challenge.part1())
    }

    func testPart2() throws {
        let challenge = Day04(data: testData)
        XCTAssertNoDifference(0, challenge.part2())
    }
}
