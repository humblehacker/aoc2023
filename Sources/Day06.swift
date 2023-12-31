import Algorithms
import CustomDump
import Foundation
import Parsing

struct Day06: AdventDay {
    var data: String

    func part1() async throws -> Int {
        try RaceStatsParser()
            .parse(data)
            .races
            .map { $0.buttonPressesBeatingRecord() }
            .map { $0.count }
            .reduce(1, *)
    }

    func part2() async throws -> Int {
        try Pt2RaceParser()
            .parse(data)
            .buttonPressesBeatingRecord()
            .count
    }
}

struct RaceStats: Equatable {
    let races: [Race]
}

struct Race: Equatable {
    let time: Int
    let recordDistance: Int
}

extension Race {
    func distance(for buttonPressTime: Int) -> Int {
        let remainingTime = time - buttonPressTime
        return buttonPressTime * remainingTime
    }

    func buttonPressesBeatingRecord() -> [Int] {
        (0 ..< time)
            .map { distance(for: $0) }
            .filter { $0 > recordDistance }
    }
}

struct RaceStatsParser: Parser {
    var body: some Parser<Substring, RaceStats> {
        Parse { (times: [Int], distances: [Int]) in
            RaceStats(races: zip(times, distances).map { Race(time: $0, recordDistance: $1) })
        } with: {
            "Time:".utf8
            Whitespace()
            Many {
                Int.parser()
            } separator: {
                Whitespace()
            }
            "\n".utf8
            "Distance:".utf8
            Whitespace()
            Many {
                Int.parser()
            } separator: {
                Whitespace()
            }
            Skip { Optionally { "\n" } }
        }
    }
}

struct Pt2RaceParser: Parser {
    var body: some Parser<Substring, Race> {
        Parse { (times: [Int], distances: [Int]) -> Race in
            let time = Int(times.map { String($0) }.joined())!
            let distance = Int(distances.map { String($0) }.joined())!
            return Race(time: time, recordDistance: distance)
        } with: {
            "Time:".utf8
            Whitespace()
            Many {
                Int.parser()
            } separator: {
                Whitespace()
            }
            "\n".utf8
            "Distance:".utf8
            Whitespace()
            Many {
                Int.parser()
            } separator: {
                Whitespace()
            }
            Skip { Optionally { "\n" } }
        }
    }
}
