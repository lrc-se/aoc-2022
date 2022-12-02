import std/[os, strutils]
import puzzle

let runPuzzle =
  case getEnv("part"):
    of "part1", "": runPartOne
    of "part2": runPartTwo
    else: quit "Unknown part"

let filename = (if getEnv("mode") == "test": "input-test" else: "input") & ".txt"
echo "Result: ", readFile(filename).strip.splitLines.parseInput.runPuzzle
