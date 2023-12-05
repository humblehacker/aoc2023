import Algorithms
import Foundation
import Parsing

struct Day04: AdventDay {
    var data: String

    func part1() -> Int {
        let cards = try! CardsParser().parse(data)
        let points = cards.map { Day04.calculatePoints(card: $0) }
        return points.reduce(0, +)
    }

    func part2() -> Int {
        let cards = try! CardsParser().parse(data)
        var winMap: [Int: Int] = [:] // ID -> Count
        for card in cards {
            winMap[card.id,default:0] += 1
            let winningCards = Self.calculateWinningCards(for: card, cards: cards)
            guard !winningCards.isEmpty else { continue }
            let winCount = winMap[card.id] ?? 0

            for win in winningCards {
                winMap[win.id, default: 0] += winCount
            }
        }

        return winMap.values.reduce(0, +)
    }

    static func parseCard(input: String) throws -> Card {
        try CardParser().parse(input)
    }

    static func parseCards(input: String) throws -> [Card] {
        try CardsParser().parse(input)
    }

    static func calculatePoints(card: Card) -> Int {
        let matchingNumbers = Set(card.winningNumbers).intersection(card.ourNumbers)
        return Int(pow(Double(2), Double(matchingNumbers.count - 1)))
    }

    static func calculateMatches(card: Card) -> Int {
        let matchingNumbers = Set(card.winningNumbers).intersection(card.ourNumbers)
        return matchingNumbers.count
    }

    static func calculateWinningCards(for card: Card, cards: [Card]) -> [Card] {
        let matchCount = Self.calculateMatches(card: card)
        guard matchCount > 0 else { return [] }
        return Array(cards[card.id ..< card.id + matchCount])
    }
}

struct Card: Equatable {
    let id: Int
    let winningNumbers: [Int]
    let ourNumbers: [Int]
}

struct CardParser: Parser {
    var body: some Parser<Substring, Card> {
        Parse {
            Card(id: $0, winningNumbers: $1, ourNumbers: $2)
        } with: {
            // id
            "Card".utf8
            Whitespace()
            Int.parser()
            ": ".utf8

            // winning numbers
            Many {
                OneOf {
                    Digits(2)
                    Parse {
                        " ".utf8
                        Digits(1)
                    }
                }
            } separator: {
                " ".utf8
            }

            " | ".utf8

            // our numbers
            Many {
                OneOf {
                    Digits(2)
                    Parse {
                        " ".utf8
                        Digits(1)
                    }
                }
            } separator: {
                " ".utf8
            }
        }
    }
}

struct CardsParser: Parser {
    var body: some Parser<Substring, [Card]> {
        Many {
            CardParser()
        } separator: {
            "\n"
        }
        Skip { Optionally { "\n" } }
    }
}
