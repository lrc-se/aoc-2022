import rocks

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
