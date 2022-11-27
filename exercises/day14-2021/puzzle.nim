import std/[strutils, tables]

type
  Instructions = object
    polymerTemplate: string
    insertionRules: Table[string, char]
  PairCounts = CountTable[string]
  ElementCounts = CountTable[char]

func getPairCounts(polymer: string): PairCounts =
  result = initCountTable[string]()
  for i in 1 ..< polymer.len:
    result.inc(polymer[i - 1 .. i])

func performInsertions(instructions: Instructions; iterationCount: int): PairCounts =
  result = getPairCounts(instructions.polymerTemplate)
  for _ in 1 .. iterationCount:
    var prevCounts = result
    for pair, element in instructions.insertionRules:
      let prevCount = prevCounts[pair]
      result.inc(pair[0] & element, prevCount)
      result.inc(element & pair[1], prevCount)
      result.inc(pair, -prevCount)

func getElementCounts(pairCounts: PairCounts; firstElement: char): ElementCounts =
  result = initCountTable[char]()
  result.inc(firstElement)
  for pair, count in pairCounts.pairs:
    result.inc(pair[1], count)

func runPuzzle(instructions: Instructions; count: int): int =
  let pairCounts = instructions.performInsertions(count)
  let elementCounts = pairCounts.getElementCounts(instructions.polymerTemplate[0])
  result = elementCounts.largest.val - elementCounts.smallest.val


func parseInput*(lines: openarray[string]): Instructions =
  let sections = lines.join("\n").split("\n\n")
  result = Instructions(polymerTemplate: sections[0], insertionRules: initTable[string, char]())
  for rule in sections[1].split("\n"):
    let parts = rule.split(" -> ")
    result.insertionRules[parts[0]] = parts[1][0]

func runPartOne*(instructions: Instructions): int = runPuzzle(instructions, 10)

func runPartTwo*(instructions: Instructions): int = runPuzzle(instructions, 40)
