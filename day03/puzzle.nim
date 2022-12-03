include prelude

type Rucksack = tuple[first: set[char], second: set[char]]

func parseRucksack(line: string): Rucksack =
  let count = line.len div 2
  for i in 0 ..< count:
    result.first.incl(line[i])
    result.second.incl(line[i + count])

func getPriority(item: char): int = item.ord - (if item >= 'a': 96 else: 38)


func parseInput*(lines: seq[string]): seq[Rucksack] = lines.map(parseRucksack)

func runPartOne*(input: seq[Rucksack]): int =
  for rucksack in input:
    result += (rucksack.second * rucksack.first).toSeq[0].getPriority

func runPartTwo*(input: seq[Rucksack]): int =
  for i in countup(0, input.len - 1, 3):
    result += (
      (input[i].first + input[i].second) *
      (input[i + 1].first + input[i + 1].second) *
      (input[i + 2].first + input[i + 2].second)
    ).toSeq[0].getPriority
