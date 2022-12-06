import std/setutils

func findStartPosition(stream: openarray[char]; length: int): int =
  for pos in length .. stream.len:
    if stream[pos - length ..< pos].toSet.card == length:
      return pos


func parseInput*(lines: seq[string]): string = lines[0]

func runPartOne*(input: string): int = input.findStartPosition(4)

func runPartTwo*(input: string): int = input.findStartPosition(14)
