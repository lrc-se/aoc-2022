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

func calculatePathLength(heightMap: HeightMap; stopEarly = false): int =
  var
    visited = { heightMap.dest: 0 }.toTable
    unvisited = initTable[Coord, int]()

  for delta in deltas:
    let pos: Coord = (heightMap.dest.x + delta.x, heightMap.dest.y + delta.y)
    if pos in heightMap.elevations and heightMap.elevations[pos] >= HIGH - 1:
      unvisited[pos] = 1

  while unvisited.len > 0:
    var
      curCoord: Coord
      curLength = high(int)

    for coord, length in unvisited:
      if length < curLength:
        curCoord = coord
        curLength = length

    if stopEarly and heightMap.elevations[curCoord] == LOW:
      return curLength

    unvisited.del(curCoord)
    visited[curCoord] = curLength
    for delta in deltas:
      let pos: Coord = (curCoord.x + delta.x, curCoord.y + delta.y)
      if pos notin visited and pos in heightMap.elevations and heightMap.elevations[pos] >= heightMap.elevations[curCoord] - 1:
        unvisited[pos] = curLength + 1

  result = visited.getOrDefault(heightMap.start, high(int))


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

func runPartTwo*(input: HeightMap): int = input.calculatePathLength(true)
