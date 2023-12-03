import Algorithms
import Foundation
import Parsing

struct Day02: AdventDay {
    var data: String

    var games: [Game] {
        try! GamesParser().parse(data)
    }

    func part1() -> Int {
        return games
            .filter { game in game.records.allSatisfy { $0.red <= 12 && $0.green <= 13 && $0.blue <= 14 } }
            .map { game in game.number }
            .reduce(0, +)
    }

    func part2() -> Int {
        0
    }
}

enum Color: Equatable {
    case red
    case green
    case blue
}

struct ColorCount: Equatable {
    let count: Int
    let color: Color
}

struct ColorCountParser: Parser {
    var body: some Parser<Substring, ColorCount> {
        Parse(ColorCount.init(count:color:)) {
            Int.parser()
            " "
            OneOf {
                "red".map { Color.red }
                "green".map { Color.green }
                "blue".map { Color.blue }
            }
        }
    }
}

struct GameRecord: Equatable {
    let red: Int
    let green: Int
    let blue: Int
}

extension GameRecord {
    init(counts: [ColorCount]) {
        red = counts.first(where: { $0.color == .red })?.count ?? 0
        green = counts.first(where: { $0.color == .green })?.count ?? 0
        blue = counts.first(where: { $0.color == .blue })?.count ?? 0
    }
}

struct GameRecordParser: Parser {
    var body: some Parser<Substring, GameRecord> {
        Parse(GameRecord.init(counts:)) {
            Many {
                ColorCountParser()
            } separator: {
                ", "
            }
        }
    }
}

struct Game: Equatable {
    let number: Int
    let records: [GameRecord]
}

struct GameParser: Parser {
    var body: some Parser<Substring, Game> {
        Parse(Game.init(number:records:)) {
            "Game "
            Int.parser()
            ": "
            Many {
                GameRecordParser()
            } separator: {
                "; "
            }
        }
    }
}

struct GamesParser: Parser {
    var body: some Parser<Substring, [Game]> {
        Many {
            GameParser()
        } separator: {
            "\n"
        }
        Skip { Optionally { "\n" } }
    }
}
