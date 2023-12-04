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
        return 0
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
