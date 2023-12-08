import Algorithms
import Foundation
import Parsing

struct Day05: AdventDay {
    var data: String
    let almanac: Almanac

    init(data: String) {
        self.data = data
        almanac = try! AlmanacParser().parse(data)
    }

    func part1() async throws -> Int {
        var lowestLocation = Int.max
        for seed in almanac.seeds {
            let location = almanac.seedLocation(seed)
            lowestLocation = min(lowestLocation, location)
        }

        return lowestLocation != Int.max ? lowestLocation : 0
    }

    func part2() async throws -> Int {
        let batchSize = 10
        let seedRanges = almanac.seedRanges
        var lowestLocation = Int.max

        for batchStart in stride(from: seedRanges.startIndex, to: seedRanges.endIndex, by: batchSize) {
            let batchEnd = min(batchStart + batchSize, seedRanges.endIndex)
            let batchRanges = seedRanges[batchStart ..< batchEnd]

            await withTaskGroup(of: Int.self) { group in
                for range in batchRanges {
                    group.addTask {
                        range
                            .map { almanac.seedLocation($0) }
                            .min() ?? 0
                    }
                }

                lowestLocation = await group.min() ?? 0
            }
        }
        return lowestLocation
    }
}

struct Almanac: Equatable {
    let seeds: [Int]

    var seedToSoil: Map!
    var soilToFertilizer: Map!
    var fertilizerToWater: Map!
    var waterToLight: Map!
    var lightToTemperature: Map!
    var temperatureToHumidity: Map!
    var humidityToLocation: Map!

    init(seeds: [Int], maps: [Map]) {
        self.seeds = seeds
        for map in maps {
            switch map.name {
            case "seed-to-soil": seedToSoil = map
            case "soil-to-fertilizer": soilToFertilizer = map
            case "fertilizer-to-water": fertilizerToWater = map
            case "water-to-light": waterToLight = map
            case "light-to-temperature": lightToTemperature = map
            case "temperature-to-humidity": temperatureToHumidity = map
            case "humidity-to-location": humidityToLocation = map
            default: fatalError()
            }
        }
    }
}

extension Almanac {
    var seedRanges: [Range<Int>] {
        stride(from: seeds.startIndex, to: seeds.endIndex, by: 2)
            .map { index in
                let startSeed = seeds[index]
                let endSeed = seeds[index + 1]
                return startSeed ..< startSeed + endSeed
            }
    }

    @inline(never)
    func seedLocation(_ seed: Int) -> Int {
        let soil = seedToSoil.destinationFromSource(seed)
        let fertilizer = soilToFertilizer.destinationFromSource(soil)
        let water = fertilizerToWater.destinationFromSource(fertilizer)
        let light = waterToLight.destinationFromSource(water)
        let temperature = lightToTemperature.destinationFromSource(light)
        let humidity = temperatureToHumidity.destinationFromSource(temperature)
        let location = humidityToLocation.destinationFromSource(humidity)
        return location
    }
}

struct Map: Equatable {
    let name: String
    let entries: [MapEntry]

    init(name: String, entries: [MapEntry]) {
        self.name = name
        self.entries = entries.sorted { $0.srcRange.startIndex < $1.srcRange.startIndex }
    }
}

extension Map {
    func destinationFromSource(_ source: Int) -> Int {
        guard
            let entry = entries.binarySearch(where: {
                if $0.srcRange.contains(source) {
                    return 0
                }

                if $0.srcRange.lowerBound > source {
                    return -1
                }

                return 1
            })
        else {
            return source
        }
        return entry.destinationFromSource(source)!
    }
}

struct MapEntry: Equatable {
    let srcRange: Range<Int>
    let dstOffset: Int
}

extension MapEntry {
    init(dstRangeStart: Int, srcRangeStart: Int, rangeLength: Int) {
        srcRange = srcRangeStart ..< srcRangeStart + rangeLength
        dstOffset = dstRangeStart - srcRangeStart
    }
}

extension MapEntry {
    func destinationFromSource(_ source: Int) -> Int? {
        guard source >= srcRange.startIndex, source < srcRange.endIndex else { return nil }
        return source + dstOffset
    }
}

extension MapEntry: Comparable {
    static func < (lhs: MapEntry, rhs: MapEntry) -> Bool {
        return lhs.srcRange.lowerBound < rhs.srcRange.lowerBound
    }
}

// MARK: Parsers

struct AlmanacParser: Parser {
    var body: some Parser<Substring, Almanac> {
        Parse(Almanac.init(seeds:maps:)) {
            SeedsParser()
            "\n\n".utf8
            Many {
                MapParser()
            } separator: {
                "\n\n"
            } terminator: {
                ""
            }
            Skip { Optionally { "\n" }}
        }
    }
}

struct SeedsParser: Parser {
    var body: some Parser<Substring, [Int]> {
        "seeds: "
        Many {
            Int.parser()
        } separator: {
            " ".utf8
        }
    }
}

struct MapParser: Parser {
    var body: some Parser<Substring, Map> {
        Parse(Map.init(name:entries:)) {
            Prefix { $0 != " " }.map(String.init)
            " map:".utf8
            "\n".utf8
            Many {
                MapEntryParser()
            } separator: {
                "\n"
            } terminator: {
                ""
            }
        }
    }
}

struct MapEntryParser: Parser {
    var body: some Parser<Substring, MapEntry> {
        Parse(MapEntry.init(dstRangeStart:srcRangeStart:rangeLength:)) {
            Int.parser()
            " "
            Int.parser()
            " "
            Int.parser()
        }
    }
}

extension RandomAccessCollection where Element: Comparable {
    func binarySearch(where predicate: (Element) -> Int) -> Element? {
        var low = startIndex
        var high = index(before: endIndex)
        while low <= high {
            let mid = index(low, offsetBy: distance(from: low, to: high) / 2)
            let value = predicate(self[mid])
            if value == 0 {
                return self[mid]
            }
            if value < 0 {
                high = index(before: mid)
            } else {
                low = index(after: mid)
            }
        }
        return nil
    }
}
