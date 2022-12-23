import std/[sequtils, sets, tables, sugar]

type
  Direction = enum North, South, West, East, NorthEast, NorthWest, SouthEast, SouthWest
  Coord = tuple[x: int; y: int]
  Elves = HashSet[Coord]

const
  deltas: Table[Direction, Coord] = {
    North: (0, -1),
    South: (0, 1),
    West: (-1, 0),
    East: (1, 0),
    NorthEast: (1, -1),
    NorthWest: (-1, -1),
    SouthEast: (1, 1),
    SouthWest: (-1, 1)
  }.toTable
  lookDirections = {
    North: [North, NorthEast, NorthWest],
    South: [South, SouthEast, SouthWest],
    West: [West, NorthWest, SouthWest],
    East: [East, NorthEast, SouthEast]
  }.toTable
  moveDirections = [North, South, West, East]

func performRound(elves: var Elves; dirOffset: int): int =
  var
    proposals = initTable[Coord, Coord]()
    destinations = initCountTable[Coord]()

  for elf in elves:
    var otherElves = initHashSet[Coord]()
    for dir in Direction.low .. Direction.high:
      let pos = (elf.x + deltas[dir].x, elf.y + deltas[dir].y)
      if pos in elves:
        otherElves.incl(pos)

    if otherElves.card == 0:
      continue

    var dirCounter = dirOffset
    for _ in moveDirections.low .. moveDirections.high:
      var canMove = true
      let moveDirection = moveDirections[dirCounter mod moveDirections.len]
      for lookDirection in lookDirections[moveDirection]:
        if (elf.x + deltas[lookDirection].x, elf.y + deltas[lookDirection].y) in otherElves:
          canMove = false
          break

      if canMove:
        let pos = (elf.x + deltas[moveDirection].x, elf.y + deltas[moveDirection].y)
        proposals[elf] = pos
        destinations.inc(pos)
        break

      dirCounter += 1

  for oldPos, newPos in proposals:
    if destinations[newPos] == 1:
      elves.excl(oldPos)
      elves.incl(newPos)
      result += 1


func parseInput*(lines: seq[string]): Elves =
  for y, line in lines:
    for x, character in line:
      if character == '#':
        result.incl((x, y))

func runPartOne*(input: Elves): int =
  var elves = input
  for i in 0 .. 9:
    discard elves.performRound(i)

  let
    elfSeq = elves.toSeq
    xs = elfSeq.map(elf => elf.x)
    ys = elfSeq.map(elf => elf.y)
    min: Coord = (min(xs), min(ys))
    max: Coord = (max(xs), max(ys))

  for y in min.y .. max.y:
    for x in min.x .. max.x:
      if (x, y) notin elves:
        result += 1

func runPartTwo*(input: Elves): int =
  var elves = input
  while elves.performRound(result) > 0:
    result += 1

  result += 1
