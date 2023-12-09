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

    func testCardKindNoJokers() throws {
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

    func testFiveOfKindJokersWild() throws {
        let game = try Day07.GameParser(jokersWild: true).parse("""
        AAAAA 0
        JAAAA 0
        JJAAA 0
        JJJAA 0
        JJJJA 0
        JJJJJ 0
        """)
        let actual = game.hands.map {
            let kind = Day07.Hand.kind(cards: $0.cards, jokersWild: true)
            return kind
        }
        let expected: [Day07.Hand.Kind] = [.fiveOfKind, .fiveOfKind, .fiveOfKind, .fiveOfKind, .fiveOfKind, .fiveOfKind]
        XCTAssertNoDifference(expected, actual)
    }

    func testFourOfKindJokersWild() throws {
        let game = try Day07.GameParser(jokersWild: true).parse("""
        AAAA2 0
        JAAA2 0
        JJAA2 0
        JJJA2 0
        """)
        let actual = game.hands.map {
            let kind = Day07.Hand.kind(cards: $0.cards, jokersWild: true)
            return kind
        }
        let expected: [Day07.Hand.Kind] = [.fourOfKind, .fourOfKind, .fourOfKind, .fourOfKind]
        XCTAssertNoDifference(expected, actual)
    }

    func testFullHouseKindJokersWild() throws {
        let game = try Day07.GameParser(jokersWild: true).parse("""
        AAA22 0
        JAA22 0
        """)
        let actual = game.hands.map {
            let kind = Day07.Hand.kind(cards: $0.cards, jokersWild: true)
            return kind
        }
        let expected: [Day07.Hand.Kind] = [
            .fullHouse,
            .fullHouse,
        ]
        XCTAssertNoDifference(expected, actual)
    }

    func testThreeKindJokersWild() throws {
        let game = try Day07.GameParser(jokersWild: true).parse("""
        AAA23 0
        JAA23 0
        JJA23 0
        """)
        let actual = game.hands.map {
            let kind = Day07.Hand.kind(cards: $0.cards, jokersWild: true)
            return kind
        }
        let expected: [Day07.Hand.Kind] = [.threeOfKind, .threeOfKind, .threeOfKind]
        XCTAssertNoDifference(expected, actual)
    }

    func testTwoPairKindJokersWild() throws {
        let game = try Day07.GameParser(jokersWild: true).parse("""
        AATT3 0
        """)
        let actual = game.hands.map {
            let kind = Day07.Hand.kind(cards: $0.cards, jokersWild: true)
            return kind
        }
        let expected: [Day07.Hand.Kind] = [.twoPair]
        XCTAssertNoDifference(expected, actual)
    }

    func testOnePairKindJokersWild() throws {
        let game = try Day07.GameParser(jokersWild: true).parse("""
        AA234 0
        JA234 0
        """)
        let actual = game.hands.map {
            let kind = Day07.Hand.kind(cards: $0.cards, jokersWild: true)
            return kind
        }
        let expected: [Day07.Hand.Kind] = [.onePair, .onePair]
        XCTAssertNoDifference(expected, actual)
    }

    func testHighCardKindJokersWild() throws {
        let game = try Day07.GameParser(jokersWild: true).parse("""
        A2345 0
        """)
        let actual = game.hands.map {
            let kind = Day07.Hand.kind(cards: $0.cards, jokersWild: true)
            return kind
        }
        let expected: [Day07.Hand.Kind] = [.highCard]
        XCTAssertNoDifference(expected, actual)
    }

    func testOrderedHands() throws {
        let game = try Day07.GameParser().parse(testData)
        let actual = game.orderedHands()
        let expected = [0, 3, 2, 1, 4].map { game.hands[$0] }
        XCTAssertNoDifference(expected, actual)
    }

    func testOrderedHandsP2() throws {
        let game = try Day07.GameParser(jokersWild: true).parse(testData)
        let actual = game.orderedHands()
        let expected = [0, 2, 1, 4, 3].map { game.hands[$0] }
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
        let expected = 5905
        XCTAssertNoDifference(expected, actual)
    }
}
