import std/[sets, tables, hashes]

type
  Range = tuple[min: int; max: int]
  Coord = tuple[x: int; y: int]
  RockType = enum Horizontal, Plus, Angle, Vertical, Block
  Rock = ref object
    rockType: RockType
    form: seq[Range]
    width: int

  Direction* = enum Left = -1, Right = 1
  Jets* = seq[Direction]
  RockTower* = object
    rockCount*, height*: Natural
  RockChamber* = object
    jets*: Jets
    rocks: HashSet[Coord]
    tower*: RockTower
    rockType: RockType
    jetCounter: int
  Period* = object
    start*, period*: RockTower


func next*(self: RockType): RockType = (if self < RockType.high: self.succ else: RockType.low)


func newRock*(rockType: RockType): Rock =
  result = Rock(rockType: rockType)
  case rockType:
    of Horizontal:
      result.form = @[(0, 3)]
      result.width = 4
    of Plus:
      result.form = @[(1, 1), (0, 2), (1, 1)]
      result.width = 3
    of Angle:
      result.form = @[(0, 2), (2, 2), (2, 2)]
      result.width = 3
    of Vertical:
      result.form = @[(0, 0), (0, 0), (0, 0), (0, 0)]
      result.width = 1
    of Block:
      result.form = @[(0, 1), (0, 1)]
      result.width = 2

func form*(self: Rock): seq[Range] = self.form

func width*(self: Rock): int = self.width


func simulateRock*(self: var RockChamber) =
  let rock = newRock(self.rockType)
  var
    pos: Coord = (3, self.tower.height + 4)
    canMove = true

  while canMove:
    var x = pos.x + self.jets[self.jetCounter].ord
    canMove = (x > 0 and x + rock.width <= 8)
    if canMove:
      for offset, row in rock.form:
        if (x + row.min, pos.y + offset) in self.rocks or (x + row.max, pos.y + offset) in self.rocks:
          canMove = false
          break

    if canMove:
      pos.x = x

    var y = pos.y - 1
    canMove = (y > 0)
    if canMove:
      for offset, row in rock.form:
        for x in pos.x + row.min .. pos.x + row.max:
          if (x, y + offset) in self.rocks:
            canMove = false
            break

    self.jetCounter = (self.jetCounter + 1) mod self.jets.len
    if canMove:
      pos.y = y

  for y, row in rock.form:
    for x in row.min .. row.max:
      self.rocks.incl((pos.x + x, pos.y + y))

  self.tower.rockCount += 1
  self.tower.height = max(self.tower.height, pos.y + rock.form.len - 1)
  self.rockType = self.rockType.next

func hash*(self: RockChamber): Hash =
  var rocks = initTable[int, int]()
  block loop:
    for y in countdown(self.tower.height, 1, 1):
      for x in 1 .. 7:
        if x notin rocks and (x, y) in self.rocks:
          rocks[x] = y - self.tower.height
          if rocks.len == 7:
            break loop

  result = !$(rocks.hash !& self.rockType.ord !& self.jetCounter)

func findPeriod*(self: var RockChamber): Period =
  var towers = initTable[Hash, RockTower]()
  while true:
    self.simulateRock()
    let hash = self.hash
    if hash in towers:
      let tower = towers[hash]
      return Period(
        start: tower,
        period: RockTower(rockCount: self.tower.rockCount - tower.rockCount, height: self.tower.height - tower.height)
      )

    towers[hash] = self.tower
