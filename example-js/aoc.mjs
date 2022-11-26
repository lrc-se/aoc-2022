import { readFileSync } from "fs";
import { parseInput, runPartOne, runPartTwo } from "./puzzle.mjs";

const runPuzzle = { part1: runPartOne, part2: runPartTwo }[process.env.part || "part1"];
if (runPuzzle) {
  const filename = `${process.env.mode == "test" ? "input-test" : "input"}.txt`;
  const input = readFileSync(filename, { encoding: "utf8" }).trim().split("\n");
  console.log("Result:", runPuzzle(parseInput(input)));
} else {
  console.log("Unknown part");
}
