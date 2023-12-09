import CustomDump
import XCTest

@testable import AdventOfCode

final class Day07Tests: XCTestCase {
    let testData = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    func testCardKind() throws {
        let game = try Day07.GameParser().parse("""
        AAAAA 0
        AAAA2 0
        AAAQQ 0
        AAA23 0
        AAQQ2 0
        AA234 0
        23456 0
        """)
        let actual = game.hands.map { Day07.Hand.kind(cards: $0.cards) }
        let expected: [Day07.Hand.Kind] = [
            .fiveOfKind,
            .fourOfKind,
            .fullHouse,
            .threeOfKind,
            .twoPair,
            .onePair,
            .highCard,
        ]
        XCTAssertNoDifference(expected, actual)
    }

    func testOrderedHands() throws {
        let game = try Day07.GameParser().parse(testData)
        let actual = game.orderedHands()
        let expected = [0, 3, 2, 1, 4].map { game.hands[$0] }
        XCTAssertNoDifference(expected, actual)
    }

    func testWinnings() throws {
        let game = try Day07.GameParser().parse(testData)
        let hands = game.orderedHands()
        let actual = Day07.Game.winnings(orderedHands: hands)
        let expected = [765 * 1, 220 * 2, 28 * 3, 684 * 4, 483 * 5]
        XCTAssertNoDifference(expected, actual)
    }

    func testPart1() async throws {
        let actual = try await Day07(data: testData).part1()
        let expected = 6440
        XCTAssertNoDifference(expected, actual)
    }

    func testPart2() async throws {
        let actual = try await Day07(data: testData).part2()
        let expected = 0
        XCTAssertNoDifference(expected, actual)
    }
}
