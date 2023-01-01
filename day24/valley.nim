import std/[sets, tables]

type
  Direction* = enum Up, Down, Left, Right
  Coord* = tuple[x: int; y: int]
  Blizzard = object
    pos: Coord
    dir: Direction
  Scan* = object
    blizzards*: seq[Blizzard]
    maxX*, maxY*: int
    start*, goal*: Coord
  Valley* = object
    scan: Scan
    minute: int
    blizzards: Table[int, seq[Blizzard]]
    blizzardPositions: Table[int, HashSet[Coord]]

const deltas: Table[Direction, Coord] = { Up: (0, -1), Right: (1, 0), Down: (0, 1), Left: (-1, 0) }.toTable

func initBlizzard*(pos: Coord; dir: Direction): Blizzard = Blizzard(pos: pos, dir: dir)

func initValley*(scan: Scan): Valley =
  result = Valley(
    scan: scan,
    minute: 1,
    blizzards: { 0: scan.blizzards }.toTable,
    blizzardPositions: initTable[int, HashSet[Coord]]()
  )

func getBlizzardPositions(self: var Valley): HashSet[Coord] =
  if self.minute notin self.blizzardPositions:
    self.blizzards[self.minute] = self.blizzards[self.minute - 1]
    self.blizzardPositions[self.minute] = initHashSet[Coord]()
    for blizzard in self.blizzards[self.minute].mitems:
      blizzard.pos.x += deltas[blizzard.dir].x
      if blizzard.pos.x == 0:
        blizzard.pos.x = self.scan.maxX - 1
      elif blizzard.pos.x == self.scan.maxX:
        blizzard.pos.x = 1

      blizzard.pos.y += deltas[blizzard.dir].y
      if blizzard.pos.y == 0:
        blizzard.pos.y = self.scan.maxY - 1
      elif blizzard.pos.y == self.scan.maxY:
        blizzard.pos.y = 1

      self.blizzardPositions[self.minute].incl(blizzard.pos)

  result = self.blizzardPositions[self.minute]

func traverse*(self: var Valley; backwards = false): int =
  let goal = if backwards: self.scan.start else: self.scan.goal
  var
    positions = [if backwards: self.scan.goal else: self.scan.start].toHashSet
    allNextPositions = initHashSet[Coord]()

  while true:
    for pos in positions:
      let blizzardPositions = self.getBlizzardPositions
      var nextPositions: seq[Coord]
      for dir in Direction.low .. Direction.high:
        let nextPos: Coord = (pos.x + deltas[dir].x, pos.y + deltas[dir].y)
        if nextPos == goal:
          return self.minute

        if nextPos notin blizzardPositions and nextPos.x > 0 and nextPos.x < self.scan.maxX and nextPos.y > 0 and nextPos.y < self.scan.maxY:
          nextPositions.add(nextPos)

      if pos notin blizzardPositions:
        nextPositions.add(pos)

      if nextPositions.len > 0:
        for nextPos in nextPositions:
          allNextPositions.incl(nextPos)

    positions = allNextPositions
    allNextPositions.clear()
    self.minute += 1
