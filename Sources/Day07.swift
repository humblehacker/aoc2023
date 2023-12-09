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
        return 0
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

        static func kind(cards: [Card]) -> Kind {
            precondition(cards.count == 5)

            // count each strength in hand
            let counts = (0 ... Card.strengths.count).map { strength in
                cards.filter { $0.strength == strength }.count
            }

            if counts.contains(where: { $0 == 5 }) {
                return .fiveOfKind
            }

            if counts.contains(where: { $0 == 4 }) {
                return .fourOfKind
            }

            switch counts.filter({ $0 == 2 }).count {
            case 2: return .twoPair
            case 1: return counts.contains(where: { $0 == 3 }) ? .fullHouse : .onePair
            default: break
            }

            return counts.contains(where: { $0 == 3 }) ? .threeOfKind : .highCard
        }
    }

    struct Card: Equatable {
        let value: String
        let strength: Int
        static let strengths: [Character] = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
    }

    struct HandParser: Parser {
        var body: some Parser<Substring, Hand> {
            Parse { (cardValues: String, bid: Int) -> Hand in
                let cards = cardValues
                    .map { Card(value: String($0), strength: Card.strengths.firstIndex(of: $0)!) }

                return Hand(
                    cards: cards,
                    bid: bid,
                    kind: Hand.kind(cards: cards)
                )
            } with: {
                Prefix(5).map(.string)
                Whitespace()
                Int.parser()
            }
        }
    }

    struct GameParser: Parser {
        var body: some Parser<Substring, Game> {
            Parse(Game.init) {
                Many {
                    HandParser()
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
