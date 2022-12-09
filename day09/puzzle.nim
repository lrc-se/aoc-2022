import std/[strutils, sequtils, sets, math]

type
  Vector = object
    x: int
    y: int
  Motion = object
    delta: Vector
    steps: int

func parseMotion(line: string): Motion =
  let parts = line.split(' ')
  case parts[0]:
    of "U": result.delta = Vector(x: 0, y: -1)
    of "R": result.delta = Vector(x: 1, y: 0)
    of "D": result.delta = Vector(x: 0, y: 1)
    of "L": result.delta = Vector(x: -1, y: 0)

  result.steps = parseInt(parts[1])

func simulateRope(motions: seq[Motion]; knotCount: int): HashSet[Vector] =
  var headPos = Vector(x: 0, y: 0)
  var knotPositions = newSeq[Vector](knotCount - 1)
  for motion in motions:
    for _ in 1 .. motion.steps:
      headPos.x += motion.delta.x
      headPos.y += motion.delta.y

      var nextPos = headPos
      for knotPos in knotPositions.mitems:
        let deltaX = nextPos.x - knotPos.x
        let deltaY = nextPos.y - knotPos.y
        let dist = deltaX.abs + deltaY.abs
        if dist > 1:
          if deltaX == 0:
            knotPos.y += deltaY.sgn
          elif deltaY == 0:
            knotPos.x += deltaX.sgn
          elif dist > 2:
            knotPos.x += deltaX.sgn
            knotPos.y += deltaY.sgn

        nextPos = knotPos

      result.incl(knotPositions[^1])


func parseInput*(lines: seq[string]): seq[Motion] = lines.map(parseMotion)

func runPartOne*(input: seq[Motion]): int = simulateRope(input, 2).card

func runPartTwo*(input: seq[Motion]): int = simulateRope(input, 10).card
