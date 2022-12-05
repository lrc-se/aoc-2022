import std/[sequtils, strutils, re, sugar]

type
  Step = object
    count: int
    source: int
    dest: int
  Procedure = object
    stacks: seq[seq[char]]
    steps: seq[Step]


func parseInput*(lines: seq[string]): Procedure =
  let sections = lines.join("\n").split("\n\n").map(sec => sec.split("\n"))
  let stackLines = sections[0]
  let offsets = stackLines[^1].pairs.toSeq.filter(pair => pair.val != ' ').map(pair => pair.key)
  result.stacks = newSeqWith(offsets.len, newSeq[char](0))
  for row in countdown(stackLines.len - 2, 0, 1):
    for i, offset in offsets.pairs:
      if stackLines[row][offset] != ' ':
        result.stacks[i].add(stackLines[row][offset])

  for step in sections[1]:
    if step =~ re"move (\d+) from (\d+) to (\d+)":
      result.steps.add(Step(count: parseInt(matches[0]), source: parseInt(matches[1]) - 1, dest: parseInt(matches[2]) - 1))

func runPartOne*(input: Procedure): string =
  var stacks = input.stacks
  for step in input.steps:
    for _ in 1 .. step.count:
      stacks[step.dest].add(stacks[step.source].pop)

  for stack in stacks:
    result &= stack[^1]

func runPartTwo*(input: Procedure): string =
  var stacks = input.stacks
  for step in input.steps:
    for crate in stacks[step.source][^step.count .. ^1]:
      stacks[step.dest].add(crate)

    stacks[step.source].setLen(stacks[step.source].len - step.count)

  for stack in stacks:
    result &= stack[^1]
