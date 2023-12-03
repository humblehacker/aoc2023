import Algorithms
import Foundation
import Parsing

struct Day03: AdventDay {
    var data: String

    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    // sum all numbers adjacent to a symbol
    //
    //       a b c
    //       d * e
    //       f g h
    //
    func part1() -> Int {
        return 0
    }

    func part2() -> Int {
        return 0
    }
}
