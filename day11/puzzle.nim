import std/[strutils, sequtils, tables, math, sugar]
import monkey

func calculateMonkeyBusinessLevel(monkeys: seq[Monkey]; roundCount: Natural; worryDivisor: Positive): int =
  var counts = initCountTable[int]()
  let period = if worryDivisor == 1: lcm(monkeys.map(m => m.testDivisor)) else: 0
  for _ in 1 .. roundCount:
    for num, monkey in monkeys:
      counts.inc(num, monkey.inspectItems(monkeys, worryDivisor, period))

  counts.sort()
  result = counts.values.toSeq[0 .. 1].prod


func parseInput*(lines: seq[string]): seq[Monkey] =
  lines.join("\n").split("\n\n").map(line => newMonkey(line.split("\n")[1 .. ^1]))

func runPartOne*(input: seq[Monkey]): int = input.calculateMonkeyBusinessLevel(20, 3)

func runPartTwo*(input: seq[Monkey]): int = input.calculateMonkeyBusinessLevel(10_000, 1)
