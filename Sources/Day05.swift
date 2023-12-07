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

    func part1() throws -> Int {
        var locations: [Int] = []
        for seed in almanac.seeds {
            let location = almanac.seedLocation(seed)
            locations.append(location)
        }

        return locations.sorted().first ?? 0
    }

    func part2() throws -> Int {
        var locations: [Int] = []
        let seedRanges = almanac.seedRanges
        for range in seedRanges {
            for seed in range {
                let location = almanac.seedLocation(seed)
                locations.append(location)
            }
        }
        return locations.sorted().first ?? 0
    }
}

struct Almanac: Equatable {
    let seeds: [Int]
    let maps: [Map]
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

    func seedLocation(_ seed: Int) -> Int {
        let soil = seedToSoil(seed)
        let fertilizer = soilToFertilizer(soil)
        let water = fertilizerToWater(fertilizer)
        let light = waterToLight(water)
        let temperature = lightToTemperature(light)
        let humidity = temperatureToHumidity(temperature)
        let location = humidityToLocation(humidity)
        return location
    }

    func seedToSoil(_ seed: Int) -> Int {
        return destinationFromSource(map: "seed-to-soil", source: seed)
    }

    func soilToFertilizer(_ soil: Int) -> Int {
        return destinationFromSource(map: "soil-to-fertilizer", source: soil)
    }

    func fertilizerToWater(_ fertilizer: Int) -> Int {
        return destinationFromSource(map: "fertilizer-to-water", source: fertilizer)
    }

    func waterToLight(_ water: Int) -> Int {
        return destinationFromSource(map: "water-to-light", source: water)
    }

    func lightToTemperature(_ light: Int) -> Int {
        return destinationFromSource(map: "light-to-temperature", source: light)
    }

    func temperatureToHumidity(_ temperature: Int) -> Int {
        return destinationFromSource(map: "temperature-to-humidity", source: temperature)
    }

    func humidityToLocation(_ humidity: Int) -> Int {
        return destinationFromSource(map: "humidity-to-location", source: humidity)
    }

    func destinationFromSource(map: String, source: Int) -> Int {
        guard let map = maps.first(where: { $0.name == map }) else { return 0 }
        return map.destinationFromSource(source)
    }
}

struct Map: Equatable {
    let name: String
    let entries: [MapEntry]
}

extension Map {
    func destinationFromSource(_ source: Int) -> Int {
        for entry in entries {
            if let dest = entry.destinationFromSource(source) {
                return dest
            }
        }
        return source
    }
}

struct MapEntry: Equatable {
    let dstRange: Range<Int>
    let srcRange: Range<Int>
}

extension MapEntry {
    func destinationFromSource(_ source: Int) -> Int? {
        guard let index = srcRange.firstIndex(of: source) else { return nil }
        let offset = index - srcRange.startIndex
        return dstRange[dstRange.index(dstRange.startIndex, offsetBy: offset)]
    }
}

extension MapEntry {
    init(dstRangeStart: Int, srcRangeStart: Int, rangeLength: Int) {
        dstRange = dstRangeStart ..< dstRangeStart + rangeLength
        srcRange = srcRangeStart ..< srcRangeStart + rangeLength
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
