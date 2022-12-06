func findStartPosition(stream: openarray[char]; length: int): int =
  var group: set[char]
  for pos in length .. stream.len:
    for character in stream[pos - length ..< pos]:
      group.incl(character)

    if group.card == length:
      return pos

    group = {}


func parseInput*(lines: seq[string]): string = lines[0]

func runPartOne*(input: string): int = input.findStartPosition(4)

func runPartTwo*(input: string): int = input.findStartPosition(14)
