import std/[sequtils, strutils, tables]

type
  Move = enum
    Rock = 1
    Paper = 2
    Scissors = 3
  Result = enum
    Loss = 0
    Draw = 3
    Win = 6
  MoveResult = tuple[winsAgainst: Move, losesAgainst: Move]
  Player = tuple[move: Move, result: Result]
  Strategy = tuple[opponentMove: Move, player: Player]

let moveMap = { 'A': Rock, 'B': Paper, 'C': Scissors }.toTable

let moveResultsMap: Table[Move, MoveResult] = {
  Rock: (Scissors, Paper),
  Paper: (Rock, Scissors),
  Scissors: (Paper, Rock)
}.toTable

let playerMap: Table[char, Player] = {
  'X': (Rock, Loss),
  'Y': (Paper, Draw),
  'Z': (Scissors, Win)
}.toTable

proc parseStrategy (line: string): Strategy =
  let parts = line.split(' ')
  result = (moveMap[parts[0][0]], playerMap[parts[1][0]])


func parseInput*(lines: seq[string]): seq[Strategy] = lines.map(parseStrategy)

proc runPartOne*(strategies: seq[Strategy]): int =
  for strategy in strategies:
    result += strategy.player.move.ord
    if strategy.opponentMove == strategy.player.move:
      result += Draw.ord
    elif strategy.opponentMove == moveResultsMap[strategy.player.move].winsAgainst:
      result += Win.ord

proc runPartTwo*(strategies: seq[Strategy]): int =
  for strategy in strategies:
    case strategy.player.result:
      of Loss: result += moveResultsMap[strategy.opponentMove].winsAgainst.ord
      of Draw: result += Draw.ord + strategy.opponentMove.ord
      of Win: result += Win.ord + moveResultsMap[strategy.opponentMove].losesAgainst.ord
