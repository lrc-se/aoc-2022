module Puzzle

let private getCalories (elves: int[][]) =
  elves |> Array.map Array.sum


let parseInput lines =
  (lines |> String.concat "\n").Split("\n\n")
    |> Array.map (fun elf -> elf.Split("\n") |> Array.map int)

let runPartOne input =
  input
  |> getCalories
  |> Array.max

let runPartTwo input =
  let cals =
    input
    |> getCalories
    |> Array.sortDescending

  cals[0] + cals[1] + cals[2]
