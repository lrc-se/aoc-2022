import std/[os, strutils]
import puzzle

let
  runPuzzle =
    case getEnv("part"):
      of "part1", "": runPartOne
      of "part2": runPartTwo
      else: quit "Unknown part"
  isTest = (getEnv("mode") == "test")
  filename = (if isTest: "input-test" else: "input") & ".txt"

echo "Result: ", readFile(filename).strip(leading = false).splitLines.parseInput.runPuzzle(isTest)
