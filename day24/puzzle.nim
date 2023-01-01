import valley

func parseInput*(lines: seq[string]): Scan =
  result.maxX = lines[0].len - 1
  result.maxY = lines.len - 1
  for y, line in lines:
    for x, character in line:
      let pos: Coord = (x, y)
      case character:
        of '.':
          if y == 0:
            result.start = pos
          elif y == result.maxY:
            result.goal = pos
        of '^': result.blizzards.add(initBlizzard(pos, Up))
        of '>': result.blizzards.add(initBlizzard(pos, Right))
        of 'v': result.blizzards.add(initBlizzard(pos, Down))
        of '<': result.blizzards.add(initBlizzard(pos, Left))
        else: discard

proc runPartOne*(input: Scan): int =
  var valley = initValley(input)
  result = valley.traverse()

proc runPartTwo*(input: Scan): int =
  var valley = initValley(input)
  discard valley.traverse()
  discard valley.traverse(true)
  result = valley.traverse()
