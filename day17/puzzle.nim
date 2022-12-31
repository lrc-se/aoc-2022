import std/[sets, tables, hashes]
import rock

type
  Direction = enum Left = -1, Right = 1
  Jets = seq[Direction]
  RockTower = object
    rockCount, height: Natural
  RockChamber = object
    jets: Jets
    rocks: HashSet[Coord]
    tower: RockTower
    rockType: RockType
    jetCounter: int
  Period = object
    start, period: RockTower

func simulateRock(rockChamber: var RockChamber) =
  let rock = newRock(rockChamber.rockType)
  var
    pos: Coord = (3, rockChamber.tower.height + 4)
    canMove = true

  while canMove:
    var x = pos.x + rockChamber.jets[rockChamber.jetCounter].ord
    canMove = (x > 0 and x + rock.width <= 8)
    if canMove:
      for offset, row in rock.form:
        if (x + row.min, pos.y + offset) in rockChamber.rocks or (x + row.max, pos.y + offset) in rockChamber.rocks:
          canMove = false
          break

    if canMove:
      pos.x = x

    var y = pos.y - 1
    canMove = (y > 0)
    if canMove:
      for offset, row in rock.form:
        for x in pos.x + row.min .. pos.x + row.max:
          if (x, y + offset) in rockChamber.rocks:
            canMove = false
            break

    rockChamber.jetCounter = (rockChamber.jetCounter + 1) mod rockChamber.jets.len
    if canMove:
      pos.y = y

  for y, row in rock.form:
    for x in row.min .. row.max:
      rockChamber.rocks.incl((pos.x + x, pos.y + y))

  rockChamber.tower.rockCount += 1
  rockChamber.tower.height = max(rockChamber.tower.height, pos.y + rock.form.len - 1)
  rockChamber.rockType = rockChamber.rockType.next

func hash(rockChamber: RockChamber): Hash =
  var rocks = initTable[int, int]()
  block loop:
    for y in countdown(rockChamber.tower.height, 1, 1):
      for x in 1 .. 7:
        if x notin rocks and (x, y) in rockChamber.rocks:
          rocks[x] = y - rockChamber.tower.height
          if rocks.len == 7:
            break loop

  result = !$(rocks.hash !& rockChamber.rockType.ord !& rockChamber.jetCounter)

func findPeriod(rockChamber: var RockChamber): Period =
  var towers = initTable[Hash, RockTower]()
  while true:
    rockChamber.simulateRock()
    let hash = rockChamber.hash
    if hash in towers:
      let tower = towers[hash]
      return Period(
        start: tower,
        period: RockTower(rockCount: rockChamber.tower.rockCount - tower.rockCount, height: rockChamber.tower.height - tower.height)
      )

    towers[hash] = rockChamber.tower


func parseInput*(lines: seq[string]): Jets =
  for dir in lines[0]:
    result.add(if dir == '<': Left else: Right)

func runPartOne*(input: Jets): int64 =
  var rockChamber = RockChamber(jets: input)
  for _ in 1 .. 2022:
    rockChamber.simulateRock()

  result = rockChamber.tower.height

func runPartTwo*(input: Jets): int64 =
  var rockChamber = RockChamber(jets: input)
  let
    period = rockChamber.findPeriod()
    rockCount = 1_000_000_000_000 - period.start.rockCount

  result = period.start.height + (rockCount div period.period.rockCount) * period.period.height
  let remainder = rockCount mod period.period.rockCount
  if remainder > 0:
    let height = rockChamber.tower.height
    for _ in 1 .. remainder:
      rockChamber.simulateRock()

    result += rockChamber.tower.height - height
