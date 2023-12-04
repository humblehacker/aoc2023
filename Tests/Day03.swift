import CustomDump
import XCTest

@testable import AdventOfCode

final class Day03Tests: XCTestCase {
    let testData = """
    467..114..
    ...*......
    ..35...633
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    func testParseSymbols() throws {
        let actual = Day03.parseSymbols(input: testData.split(separator: "\n").map { String($0) })
        let expected = [
            Symbol(value: "*", coordinate: Coordinate(x: 3, y: 1)),
            Symbol(value: "#", coordinate: Coordinate(x: 6, y: 3)),
            Symbol(value: "*", coordinate: Coordinate(x: 3, y: 4)),
            Symbol(value: "+", coordinate: Coordinate(x: 5, y: 5)),
            Symbol(value: "$", coordinate: Coordinate(x: 3, y: 8)),
            Symbol(value: "*", coordinate: Coordinate(x: 5, y: 8)),
        ]
        XCTAssertNoDifference(expected, actual)
    }

    func testParsePartNumbers() throws {
        let actual = Day03.parsePartNumbers(input: testData.split(separator: "\n").map { String($0) })
        let expected = [
            PartNumber(467, coordinate: Coordinate(x: 0, y: 0)),
            PartNumber(114, coordinate: Coordinate(x: 5, y: 0)),
            PartNumber(35, coordinate: Coordinate(x: 2, y: 2)),
            PartNumber(633, coordinate: Coordinate(x: 7, y: 2)),
            PartNumber(617, coordinate: Coordinate(x: 0, y: 4)),
            PartNumber(58, coordinate: Coordinate(x: 7, y: 5)),
            PartNumber(592, coordinate: Coordinate(x: 2, y: 6)),
            PartNumber(755, coordinate: Coordinate(x: 6, y: 7)),
            PartNumber(664, coordinate: Coordinate(x: 1, y: 9)),
            PartNumber(598, coordinate: Coordinate(x: 5, y: 9)),
        ]
        XCTAssertNoDifference(expected, actual)
    }

    func testGenerateSymbolMap() throws {
        let symbols = Day03.parseSymbols(input: testData.split(separator: "\n").map { String($0) })
        let actual = Day03.generateSymbolMap(symbols)
        let expected = [
            1: [3: Symbol(value: "*", coordinate: Coordinate(x: 3, y: 1))],
            3: [6: Symbol(value: "#", coordinate: Coordinate(x: 6, y: 3))],
            4: [3: Symbol(value: "*", coordinate: Coordinate(x: 3, y: 4))],
            5: [5: Symbol(value: "+", coordinate: Coordinate(x: 5, y: 5))],
            8: [
                3: Symbol(value: "$", coordinate: Coordinate(x: 3, y: 8)),
                5: Symbol(value: "*", coordinate: Coordinate(x: 5, y: 8)),
            ],
        ]
        XCTAssertNoDifference(expected, actual)
    }

    func testCoordinatesForPartNumber() throws {
        do {
            let actual = Day03.coordinates(for: PartNumber(35, coordinate: Coordinate(x: 2, y: 2)), maxX: 9, maxY: 9)
            let expected = [
                Coordinate(x: 1, y: 1),
                Coordinate(x: 2, y: 1),
                Coordinate(x: 3, y: 1),
                Coordinate(x: 4, y: 1),
                Coordinate(x: 1, y: 2),
                Coordinate(x: 4, y: 2),
                Coordinate(x: 1, y: 3),
                Coordinate(x: 2, y: 3),
                Coordinate(x: 3, y: 3),
                Coordinate(x: 4, y: 3),
            ]
            XCTAssertNoDifference(expected, actual)
        }
        do {
            /*    6 7 8 9
               1  . . . .
               2  . 6 3 3
               3  # . . .

             */
            let actual = Day03.coordinates(for: PartNumber(633, coordinate: Coordinate(x: 7, y: 2)), maxX: 9, maxY: 9)
            let expected = [
                Coordinate(x: 6, y: 1),
                Coordinate(x: 7, y: 1),
                Coordinate(x: 8, y: 1),
                Coordinate(x: 9, y: 1),
                Coordinate(x: 6, y: 2),
                Coordinate(x: 6, y: 3),
                Coordinate(x: 7, y: 3),
                Coordinate(x: 8, y: 3),
                Coordinate(x: 9, y: 3),
            ]
            XCTAssertNoDifference(expected, actual)
        }
    }

    func testPart1() throws {
        let challenge = Day03(data: testData)
        XCTAssertEqual(4361, challenge.part1())
    }

    // func testPart2() throws {
    //     let challenge = Day03(data: testData)
    //     XCTAssertEqual(2286, challenge.part2())
    // }
}
