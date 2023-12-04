import Algorithms
import Foundation
import Parsing

struct Day03: AdventDay {
    var data: String

    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    var partNumbers: [PartNumber] {
        Self.parsePartNumbers(input: entities)
    }

    var symbols: [Symbol] {
        Self.parseSymbols(input: entities)
    }

    static let symbolChars = "#$%&*+-/=@"

    public static func parseSymbols(input: [String]) -> [Symbol] {
        var result: [Symbol] = []
        var row = 0
        for line in input {
            var column = 0
            for c in line {
                if symbolChars.contains(c) {
                    result.append(Symbol(value: String(c), coordinate: Coordinate(x: column, y: row)))
                }
                column += 1
            }
            row += 1
        }

        return result
    }

    static func parsePartNumbers(input: [String]) -> [PartNumber] {
        var result: [PartNumber] = []
        var row = 0
        for line in input {
            var column = 0
            var number = ""
            var coordinate: Coordinate?
            for c in line {
                if c.isNumber {
                    if number.isEmpty {
                        coordinate = Coordinate(x: column, y: row)
                    }
                    number.append(String(c))
                } else if let coord = coordinate {
                    result.append(PartNumber(number: Int(number)!, coordinate: coord))
                    number = ""
                    coordinate = nil
                }

                column += 1
            }
            // handle if last character in row is a digit
            if let coord = coordinate {
                result.append(PartNumber(Int(number)!, coordinate: coord))
                number = ""
                coordinate = nil
            }
            row += 1
        }

        return result
    }

    typealias SymbolMap = [Int: [Int: Symbol]]

    static func generateSymbolMap(_ symbols: [Symbol]) -> SymbolMap {
        var result: SymbolMap = [:]

        for symbol in symbols {
            result[symbol.y, default: .init()][symbol.x] = symbol
        }

        return result
    }

    static func coordinates(for partNumber: PartNumber, maxX: Int, maxY: Int) -> [Coordinate] {
        let range = partNumber.x ... partNumber.x + String(partNumber.number).count - 1
        let yRange = max(0, partNumber.y - 1) ... min(maxY, partNumber.y + 1)
        let xRange = max(0, range.first! - 1) ... min(maxX, range.last! + 1)
        var result: [Coordinate] = []
        for y in yRange {
            for x in xRange {
                guard !range.contains(x) || y != partNumber.y else { continue }
                result.append(Coordinate(x: x, y: y))
            }
        }

        return result
    }

    static func symbols(adjacentTo coordinates: [Coordinate], in symbolMap: SymbolMap) -> [Symbol] {
        let adjacentSymbols = coordinates.compactMap { coordinate in symbolMap[coordinate.y]?[coordinate.x] }
        return adjacentSymbols
    }

    // sum all numbers adjacent to a symbol
    //
    //       a b c
    //       d * e
    //       f g h
    //
    func part1() -> Int {
        let entities = data.split(separator: "\n").map { String($0) }
        let partNumbers = Self.parsePartNumbers(input: entities)
        let symbols = Self.parseSymbols(input: entities)
        let symbolMap = Self.generateSymbolMap(symbols)

        var adjacentNumbers: [PartNumber] = []
        for number in partNumbers {
            let coordinates = Self.coordinates(for: number, maxX: entities.first!.count, maxY: entities.count)
            let symbols = Self.symbols(adjacentTo: coordinates, in: symbolMap)
            for _ in symbols {
                adjacentNumbers.append(number)
            }
        }

        let sum = adjacentNumbers.map { $0.number }.reduce(0, +)
        return sum
    }

    func part2() -> Int {
        return 0
    }
}

struct Coordinate: Equatable {
    let x: Int
    let y: Int
}

struct Symbol: Equatable {
    let value: String
    let coordinate: Coordinate

    var x: Int { coordinate.x }
    var y: Int { coordinate.y }
}

struct PartNumber: Equatable {
    let number: Int
    let coordinate: Coordinate

    var x: Int { coordinate.x }
    var y: Int { coordinate.y }

    init(_ number: Int, coordinate: Coordinate) {
        self.number = number
        self.coordinate = coordinate
    }
}
