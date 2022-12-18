import std/[strutils, sequtils, sets, sugar]

type Coord = tuple[x: int; y: int; z: int]

const deltas: seq[Coord] = @[(-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1)]

func isOutside(cubes: HashSet[Coord]; cube, min, max: Coord): bool =
  if cube in cubes:
    return false

  var
    cubes2 = cubes
    curCubes = @[cube]

  while curCubes.len > 0:
    let curCube = curCubes[0]
    if curCube.x < min.x or curCube.x > max.x or curCube.y < min.y or curCube.y > max.y or curCube.z < min.z or curCube.z > max.z:
      return true

    curCubes.delete(0)
    if curCube notin cubes2:
      cubes2.incl(curCube)
      for delta in deltas:
        let pos: Coord = (curCube.x + delta.x, curCube.y + delta.y, curCube.z + delta.z)
        if pos notin cubes2:
          curCubes.add(pos)


func parseInput*(lines: seq[string]): HashSet[Coord] =
  for line in lines:
    let parts = line.split(',')
    result.incl((parseInt(parts[0]), parseInt(parts[1]), parseInt(parts[2])))

func runPartOne*(input: HashSet[Coord]): int =
  for cube in input:
    for delta in deltas:
      let pos: Coord = (cube.x + delta.x, cube.y + delta.y, cube.z + delta.z)
      if pos notin input:
        result += 1

func runPartTwo*(input: HashSet[Coord]): int =
  let
    cubes = input.toSeq
    xs = cubes.map(coord => coord.x)
    ys = cubes.map(coord => coord.y)
    zs = cubes.map(coord => coord.z)
    min: Coord = (min(xs), min(ys), min(zs))
    max: Coord = (max(xs), max(ys), max(zs))

  for cube in input:
    for delta in deltas:
      let pos: Coord = (cube.x + delta.x, cube.y + delta.y, cube.z + delta.z)
      if input.isOutside(pos, min, max):
        result += 1
