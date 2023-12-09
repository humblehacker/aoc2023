import Algorithms
import CustomDump
import Foundation
import Parsing

struct Day07: AdventDay {
    var data: String

    func part1() async throws -> Int {
        let game = try GameParser().parse(data)
        let orderedHands = game.orderedHands()
        let winnings = Game.winnings(orderedHands: orderedHands)
        return winnings.reduce(0, +)
    }

    func part2() async throws -> Int {
        let game = try GameParser(jokersWild: true).parse(data)
        let orderedHands = game.orderedHands()
        let winnings = Game.winnings(orderedHands: orderedHands)
        return winnings.reduce(0, +)
    }

    struct Game: Equatable {
        let hands: [Hand]

        func orderedHands() -> [Hand] {
            hands.sorted()
        }

        static func winnings(orderedHands: [Hand]) -> [Int] {
            orderedHands.enumerated().map { index, hand in
                hand.bid * (1 + index)
            }
        }
    }

    struct Hand: Equatable {
        let cards: [Card]
        let bid: Int
        let kind: Kind

        enum Kind: Int {
            case highCard
            case onePair
            case twoPair
            case threeOfKind
            case fullHouse
            case fourOfKind
            case fiveOfKind
        }

        static func kind(cards: [Card], jokersWild: Bool = false) -> Kind {
            precondition(cards.count == 5)
            let cardStrengths = jokersWild ? Card.strengthsP2 : Card.strengthsP1

            // count each strength in hand
            var counts = (0 ... cardStrengths.count).map { strength in
                cards.filter { $0.strength == strength }.count
            }

            var jokersCount = 0
            if jokersWild {
                jokersCount = counts[0]
                counts[0] = 0
            }

            func count(_ count: Int, jokers: Int = 0) -> Int { counts.filter { $0 + jokers == count }.count }

            switch (count(2), count(3), count(4), count(5), jokersCount) {
            case (0, 0, 0, 1, 0): return .fiveOfKind
            case (0, 0, 1, 0, 1): return .fiveOfKind
            case (0, 1, 0, 0, 2): return .fiveOfKind
            case (1, 0, 0, 0, 3): return .fiveOfKind
            case (0, 0, 0, 0, 4): return .fiveOfKind
            case (0, 0, 0, 0, 5): return .fiveOfKind

            case (0, 0, 1, 0, 0): return .fourOfKind
            case (0, 1, 0, 0, 1): return .fourOfKind
            case (1, 0, 0, 0, 2): return .fourOfKind
            case (0, 0, 0, 0, 3): return .fourOfKind

            case (1, 1, 0, 0, 0): return .fullHouse
            case (2, 0, 0, 0, 1): return .fullHouse

            case (0, 1, 0, 0, 0): return .threeOfKind
            case (1, 0, 0, 0, 1): return .threeOfKind
            case (0, 0, 0, 0, 2): return .threeOfKind

            case (2, 0, 0, 0, 0): return .twoPair

            case (1, 0, 0, 0, 0): return .onePair
            case (0, 0, 0, 0, 1): return .onePair

            case (0, 0, 0, 0, 0): return .highCard
            default: break
            }

            return .highCard
        }
    }

    struct Card: Equatable {
        let value: String
        let strength: Int
        static let strengthsP1: [Character] = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
        static let strengthsP2: [Character] = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]
    }

    struct HandParser: Parser {
        let jokersWild: Bool
        var body: some Parser<Substring, Hand> {
            Parse { (cardValues: String, bid: Int) -> Hand in
                let cardStrengths = jokersWild ? Card.strengthsP2 : Card.strengthsP1
                let cards = cardValues
                    .map { Card(value: String($0), strength: cardStrengths.firstIndex(of: $0)!) }

                return Hand(
                    cards: cards,
                    bid: bid,
                    kind: Hand.kind(cards: cards, jokersWild: jokersWild)
                )
            } with: {
                Prefix(5).map(.string)
                Whitespace()
                Int.parser()
            }
        }
    }

    struct GameParser: Parser {
        let jokersWild: Bool

        init(jokersWild: Bool = false) {
            self.jokersWild = jokersWild
        }

        var body: some Parser<Substring, Game> {
            Parse(Game.init) {
                Many {
                    HandParser(jokersWild: jokersWild)
                } separator: {
                    "\n"
                }
                Skip { Optionally { "\n" } }
            }
        }
    }
}

extension Day07.Hand: Comparable {
    static func < (lhs: Day07.Hand, rhs: Day07.Hand) -> Bool {
        if lhs.kind == rhs.kind {
            for (l, r) in zip(lhs.cards.map { $0.strength }, rhs.cards.map { $0.strength }) {
                if l == r { continue }
                if l > r { return false }
                if l < r { return true }
            }

            return false
        }

        if lhs.kind.rawValue < rhs.kind.rawValue {
            return true
        }

        return false
    }
}

extension Day07.Hand: CustomDebugStringConvertible {
    var debugDescription: String {
        let cardsOut = cards.map { $0.value }.joined()
        let strengthsOut = cards.map { String(format: "%2d", $0.strength) }.joined(separator: " ")
        return "[\(cardsOut)](\(strengthsOut)) \(kind)"
    }
}
