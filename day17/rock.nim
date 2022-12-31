type
  Range = tuple[min: int; max: int]
  Coord* = tuple[x: int; y: int]
  RockType* = enum Horizontal, Plus, Angle, Vertical, Block
  Rock* = ref object
    rockType: RockType
    form: seq[Range]
    width: int

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
