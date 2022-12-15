import std/[strutils, sequtils, sets, re, sugar, algorithm]

type
  Coord = tuple[x: int; y: int]
  Range = tuple[minX: int; maxX: int]
  Beacon = object
    pos: Coord
    dist: int
  Sensor = object
    pos: Coord
    beacon: Beacon
  Scan = object
    sensors: seq[Sensor]
    min, max: Coord

func dist(coord1, coord2: Coord): int = abs(coord1.x - coord2.x) + abs(coord1.y - coord2.y)

func getScanLine(sensors: seq[Sensor]; y: int): seq[Range] =
  for sensor in sensors:
    let offset = sensor.beacon.dist - abs(y - sensor.pos.y)
    if offset >= 0:
      result.add((sensor.pos.x - offset, sensor.pos.x + offset))


func parseInput*(lines: seq[string]): Scan =
  for line in lines:
    if line =~ re"Sensor at x=(-?\d+), y=(-?\d+):.*x=(-?\d+), y=(-?\d+)":
      let
        pos: Coord = (parseInt(matches[0]), parseInt(matches[1]))
        beaconPos: Coord = (parseInt(matches[2]), parseInt(matches[3]))
        beaconDist = pos.dist(beaconPos)

      result.sensors.add(Sensor(pos: pos, beacon: Beacon(pos: beaconPos, dist: beaconDist)))
      result.min = (min(result.min.x, pos.x - beaconDist), min(result.min.y, pos.y - beaconDist))
      result.max = (max(result.max.x, pos.x + beaconDist), max(result.max.y, pos.y + beaconDist))

func runPartOne*(input: Scan; isTest: bool): int =
  let
    beaconPositions = input.sensors.map(s => s.beacon.pos).toHashSet
    y = if isTest: 10 else: 2_000_000
    ranges = input.sensors.getScanLine(y)

  for x in input.min.x .. input.max.x:
    if (x, y) notin beaconPositions:
      for range in ranges:
        if x >= range.minX and x <= range.maxX:
          result += 1
          break

func runPartTwo*(input: Scan; isTest: bool): int =
  let
    maxY = if isTest: 20 else: 4_000_000
    startY = max(0, input.min.y)
    stopY = min(maxY, input.max.y)
    loop =
      if startY > maxY - stopY:
        (start: startY, stop: stopY, delta: 1)
      else:
        (start: stopY, stop: startY, delta: -1)

  var y = loop.start
  while y != loop.stop:
    var
      ranges = input.sensors.getScanLine(y).sorted((a, b) => a.minX - b.minX)
      i = 1

    while i < ranges.len:
      if ranges[i].maxX < ranges[i - 1].maxX:
        ranges[i] = ranges[i - 1]
      elif ranges[i].minX == ranges[i - 1].maxX + 2:
        return (ranges[i].minX - 1) * 4_000_000 + y

      i += 1

    y += loop.delta
