import Algorithms
import Foundation

struct Day01: AdventDay {
    var data: String

    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    func part1() -> Int {
        let values = Day01.extractCalibrationValuesP1(input: entities)
        let sum = values.reduce(0, +)
        return sum
    }

    func part2() -> Int {
        let values = Day01.extractCalibrationValuesP2(input: entities)
        let sum = values.reduce(0, +)
        return sum
    }

    static func extractCalibrationValueP1(input: String) -> Int {
        let first = input.first { $0.isNumber } ?? "0"
        let last = input.last { $0.isNumber } ?? first
        let result = "\(first)\(last)"
        return Int(result) ?? 0
    }

    static func extractCalibrationValuesP1(input: [String]) -> [Int] {
        input.map { extractCalibrationValueP1(input: $0) }
    }

    static let numberMap = [
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9,
    ]

    static let numbers = [
        "o": ["one"],
        "t": ["two", "three"],
        "f": ["four", "five"],
        "s": ["six", "seven"],
        "e": ["eight"],
        "n": ["nine"],
    ]

    static func extractCalibrationValueP2(input: String) -> Int {
        var inputToParse = input
        var digits: [String] = []

        while let c = inputToParse.first {
            defer { inputToParse = String(inputToParse.dropFirst()) }
            switch (c.isNumber, c.isLetter) {
            case (true, _):
                digits.append("\(c)")
            case (_, true):
                guard let potentialNumbers = numbers[String(c)] else {
                    break
                }
                for potential in potentialNumbers {
                    if inputToParse.prefix(potential.count) == potential {
                        digits.append(String(numberMap[potential]!))
                        break
                    }
                }
            default:
                ()
            }
        }

        let first = digits.first ?? "0"
        let last = digits.last ?? first
        let result = "\(first)\(last)"
        return Int(result) ?? 0
    }

    static func extractCalibrationValuesP2(input: [String]) -> [Int] {
        input.map { extractCalibrationValueP2(input: $0) }
    }
}
