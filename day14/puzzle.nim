import std/[strutils, tables]

type
  Tile = enum Air, Rock, Sand
  Coord = tuple[x: int; y: int]
  Line = seq[Coord]
  Reservoir = object
    rockLines: seq[Line]
    min: Coord
    max: Coord

const
  SOURCE: Coord = (500, 0)
  deltas: seq[Coord] = @[(0, 1), (-1, 1), (1, 1)]

func getCave(rockLines: seq[Line]): Table[Coord, Tile] =
  for line in rockLines:
    for i in 1 ..< line.len:
      for y in min(line[i - 1].y, line[i].y) .. max(line[i - 1].y, line[i].y):
        for x in min(line[i - 1].x, line[i].x) .. max(line[i - 1].x, line[i].x):
          result[(x, y)] = Rock

func simulateSand(input: Reservoir): int =
  var cave = input.rockLines.getCave
  while true:
    var
      sandPos = SOURCE
      failCount, infiniteCount: int

    while failCount < deltas.len:
      failCount = 0
      infiniteCount = 0
      for delta in deltas:
        let nextPos: Coord = (sandPos.x + delta.x, sandPos.y + delta.y)
        if nextPos.x < input.min.x or nextPos.x > input.max.x or nextPos.y > input.max.y:
          infiniteCount += 1
          failCount += 1
          continue

        if cave.getOrDefault(nextPos, Air) == Air:
          sandPos = nextPos
          break
        else:
          failCount += 1

    if infiniteCount > 0 or failCount < deltas.len:
      return

    cave[sandPos] = Sand
    result += 1

func simulateSand2(input: Reservoir): int =
  var cave = input.rockLines.getCave
  let maxY = input.max.y + 2
  while true:
    var
      sandPos = SOURCE
      failCount: int

    while failCount < deltas.len:
      failCount = 0
      for delta in deltas:
        let
          nextPos: Coord = (sandPos.x + delta.x, sandPos.y + delta.y)
          tile = if nextPos.y == maxY: Rock else: cave.getOrDefault(nextPos, Air)

        if tile == Air:
          sandPos = nextPos
          break
        else:
          failCount += 1

    cave[sandPos] = Sand
    result += 1
    if sandPos == SOURCE:
      return


func parseInput*(lines: seq[string]): Reservoir =
  result.min = (high(int), 0)
  result.max = (low(int), low(int))
  for line in lines:
    var rockLine: Line = @[]
    for part in line.split(" -> "):
      let numbers = part.split(",")
      let coord: Coord = (parseInt(numbers[0]), parseInt(numbers[1]))
      rockLine.add(coord)
      result.min.x = min(result.min.x, coord.x)
      result.max.x = max(result.max.x, coord.x)
      result.max.y = max(result.max.y, coord.y)

    result.rockLines.add(rockLine)

func runPartOne*(input: Reservoir): int = input.simulateSand

func runPartTwo*(input: Reservoir): int = input.simulateSand2
