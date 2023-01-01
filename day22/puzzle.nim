import std/[strutils, tables, math]

type
  Facing = enum Right, Down, Left, Up
  Action = enum Move, Turn
  Position = tuple[row: int; col: int]
  PathAction = object
    case action: Action
      of Move:
        number: int
      of Turn:
        rotation: int
  BoardRow = ref object
    offset: int
    tiles: string
  Board = object
    rows: seq[BoardRow]
    width, height: int
  MonkeyNotes = object
    board: Board
    path: seq[PathAction]
  Mover = object
    pos: Position
    facing: Facing
  Face = object
    pos: Position
    rotations: int

const facingLen = 4

func rotate(facing: var Facing; steps: int) =
  facing = Facing((facingLen + facing.ord + (steps mod facingLen)) mod facingLen)

func calcPassword(mover: Mover): int = 1000 * (mover.pos.row + 1) + 4 * (mover.pos.col + 1) + mover.facing.ord

func move(pos: var Position; direction: Facing; steps = 1) =
  case direction:
    of Right: pos.col += steps
    of Down: pos.row += steps
    of Left: pos.col -= steps
    of Up: pos.row -= steps

func rotationSign(fromFacing, toFacing: Facing): int =
  if abs(toFacing.ord - fromFacing.ord - 1) mod facingLen == 0: 1 else: -1

func getFaces(board: Board; size: int): Table[Position, Table[Facing, Face]] =
  var pos: Position = (0, board.rows[0].offset)
  while pos.row < board.height:
    if pos.col >= board.rows[pos.row].offset and pos.col < board.rows[pos.row].tiles.len + board.rows[pos.row].offset:
      var faces = initTable[Facing, Face]()
      for direction in Facing.low .. Facing.high:
        var
          facePos = pos
          row: BoardRow

        block searchLoop:
          for _ in 1 .. 3:
            facePos.move(direction, size)
            if facePos.row < 0 or facePos.row >= board.height or facePos.col < 0 or facePos.col >= board.width:
              break

            row = board.rows[facePos.row]
            if facePos.col >= row.offset and facePos.col < row.tiles.len + row.offset:
              faces[direction] = Face(pos: facePos, rotations: 0)
              break searchLoop

            let directions =
              case direction:
                of Right, Left: [Up, Down]
                else: [Left, Right]

            for dir in directions:
              var facePos2 = facePos
              for steps in 1 .. 3:
                facePos2.move(dir, size)
                if facePos2.row < 0 or facePos2.row >= board.height or facePos2.col < 0 or facePos2.col >= board.width:
                  break

                let row2 = board.rows[facePos2.row]
                if facePos2.col >= row2.offset and facePos2.col < row2.tiles.len + row2.offset:
                  faces[direction] = Face(pos: facePos2, rotations: steps * rotationSign(direction, dir))
                  break searchLoop

        result[pos] = faces

    pos.move(Right, size)
    if pos.col >= board.width:
      pos.move(Down, size)
      pos.col = 0

  for pos, faces in result:
    for dir, face in faces:
      if abs(face.rotations) > 1 and dir notin result[face.pos]:
        result[face.pos][dir] = Face(pos: pos, rotations: -face.rotations)

  var remaining: Table[Position, tuple[pos: Position; steps: int]]
  for pos1, faces in result:
    if faces.len != 3:
      continue

    for pos2, faces2 in result:
      let steps = (abs(pos2.row - pos1.row) + abs(pos2.col - pos1.col)) div size
      if faces2.len < facingLen and steps > 3:
        remaining[pos1] = (pos2, (steps - 1) mod facingLen)

  for pos, target in remaining:
    if result[pos].len == facingLen:
      continue

    var dir1: Facing
    for dir in Facing.low .. Facing.high:
      if dir notin result[pos]:
        dir1 = dir
        break

    var dir2 = Facing(abs(dir1.ord - target.steps) mod facingLen)
    if dir2 in result[target.pos]:
      dir2.rotate(2)

    let rotations = target.steps * rotationSign(dir1, dir2)
    result[pos][dir1] = Face(pos: target.pos, rotations: rotations)
    result[target.pos][dir2] = Face(pos: pos, rotations: -rotations)

func moveToFace(mover: var Mover; face: Face; offset: Position; size: int) =
  mover.pos = (mover.pos.row - offset.row, mover.pos.col - offset.col)
  mover.facing.rotate(face.rotations)
  for _ in 1 .. abs(face.rotations):
    let oldPos = mover.pos
    if face.rotations > 0:
      mover.pos.row = oldPos.col
      mover.pos.col = size - oldPos.row - 1
    else:
      mover.pos.row = size - oldPos.col - 1
      mover.pos.col = oldPos.row

  case mover.facing:
    of Right:
      mover.pos.move(Down, face.pos.row)
      mover.pos.col = face.pos.col
    of Down:
      mover.pos.move(Right, face.pos.col)
      mover.pos.row = face.pos.row
    of Left:
      mover.pos.move(Down, face.pos.row)
      mover.pos.col = face.pos.col + size - 1
    of Up:
      mover.pos.move(Right, face.pos.col)
      mover.pos.row = face.pos.row + size - 1


func parseInput*(lines: seq[string]): MonkeyNotes =
  result.board.width = int.low
  result.board.height = lines.len - 2
  for line in lines[0 .. ^3]:
    let offset = line.rfind(" ") + 1
    result.board.rows.add(BoardRow(offset: offset, tiles: line[offset .. ^1]))
    result.board.width = max(result.board.width, line.len)

  var number = ""
  for character in lines[^1]:
    case character:
      of 'R', 'L':
        result.path.add(PathAction(action: Move, number: parseInt(number)))
        result.path.add(PathAction(action: Turn, rotation: if character == 'R': 1 else: -1))
        number = ""
      else:
        number &= character

  if number.len > 0:
    result.path.add(PathAction(action: Move, number: parseInt(number)))

func runPartOne*(input: MonkeyNotes): int =
  var mover = Mover(pos: (0, input.board.rows[0].offset), facing: Right)
  for pathAction in input.path:
    case pathAction.action:
      of Turn:
        mover.facing.rotate(pathAction.rotation)
      of Move:
        var nextPos = mover.pos
        for _ in 1 .. pathAction.number:
          var row = input.board.rows[mover.pos.row]
          case mover.facing:
            of Right:
              nextPos.col += 1
              if nextPos.col >= row.tiles.len + row.offset:
                nextPos.col = row.offset
            of Down:
              while true:
                nextPos.row = (nextPos.row + 1) mod input.board.height
                row = input.board.rows[nextPos.row]
                if nextPos.col >= row.offset and nextPos.col < row.tiles.len + row.offset:
                  break
            of Left:
              nextPos.col -= 1
              if nextPos.col < row.offset:
                nextPos.col = row.tiles.len + row.offset - 1
            of Up:
              while true:
                nextPos.row = if nextPos.row > 0: nextPos.row - 1 else: input.board.height - 1
                row = input.board.rows[nextPos.row]
                if nextPos.col >= row.offset and nextPos.col < row.tiles.len + row.offset:
                  break

          if row.tiles[nextPos.col - row.offset] == '#':
            break

          mover.pos = nextPos

  result = mover.calcPassword

func runPartTwo*(input: MonkeyNotes): int =
  let
    size = gcd(input.board.width, input.board.height)
    faces = input.board.getFaces(size)

  var
    mover = Mover(pos: (0, input.board.rows[0].offset), facing: Right)
    curFacePos = mover.pos

  for pathAction in input.path:
    case pathAction.action:
      of Turn:
        mover.facing.rotate(pathAction.rotation)
      of Move:
        var nextMover = mover
        for _ in 1 .. pathAction.number:
          var
            nextPos = mover.pos
            nextFacePos = curFacePos
            hasChangedFace: bool

          nextPos.move(mover.facing)
          case mover.facing:
            of Right: hasChangedFace = (nextPos.col >= curFacePos.col + size)
            of Down: hasChangedFace = (nextPos.row >= curFacePos.row + size)
            of Left: hasChangedFace = (nextPos.col < curFacePos.col)
            of Up: hasChangedFace = (nextPos.row < curFacePos.row)

          if hasChangedFace:
            let nextFace = faces[curFacePos][mover.facing]
            nextMover.moveToFace(nextFace, curFacePos, size)
            nextFacePos = nextFace.pos
          else:
            nextMover.pos = nextPos

          let row = input.board.rows[nextMover.pos.row]
          if row.tiles[nextMover.pos.col - row.offset] == '#':
            break

          mover = nextMover
          curFacePos = nextFacePos

  result = mover.calcPassword
