import std/tables

type
  Coord = tuple[x: int; y: int]
  HeightMap = object
    start: Coord
    dest: Coord
    elevations: Table[Coord, int]

const
  LOW = 'a'.ord
  HIGH = 'z'.ord
  deltas: seq[Coord] = @[(0, -1), (1, 0), (0, 1), (-1, 0)]

func calculatePathLength(heightMap: HeightMap): int =
  var
    output = { heightMap.start: 0 }.toTable
    lengths = initTable[Coord, int]()

  for delta in deltas:
    let pos: Coord = (heightMap.start.x + delta.x, heightMap.start.y + delta.y)
    if heightMap.elevations.hasKey(pos) and heightMap.elevations[pos] <= LOW + 1:
      lengths[pos] = 1

  while lengths.len > 0:
    var
      coord: Coord
      shortestLength = high(int)

    for key, val in lengths:
      if val < shortestLength:
        coord = key
        shortestLength = val

    lengths.del(coord)
    output[coord] = shortestLength
    for delta in deltas:
      let pos: Coord = (coord.x + delta.x, coord.y + delta.y)
      if not output.hasKey(pos) and heightMap.elevations.hasKey(pos) and heightMap.elevations[pos] <= heightMap.elevations[coord] + 1:
        lengths[pos] = shortestLength + 1

  result = output.getOrDefault(heightMap.dest, -1)


func parseInput*(lines: seq[string]): HeightMap =
  for y, line in lines:
    for x, val in line:
      case val:
        of 'S':
          result.elevations[(x, y)] = LOW
          result.start = (x, y)
        of 'E':
          result.elevations[(x, y)] = HIGH
          result.dest = (x, y)
        else:
          result.elevations[(x, y)] = val.ord

func runPartOne*(input: HeightMap): int = input.calculatePathLength

func runPartTwo*(input: HeightMap): int =
  var heightMap = input
  var pathLengths: seq[int]
  for coord, elevation in heightMap.elevations:
    if elevation == LOW:
      heightMap.start = coord
      let pathLength = heightMap.calculatePathLength
      if pathLength != -1:
        pathLengths.add(pathLength)

  result = pathLengths.min
