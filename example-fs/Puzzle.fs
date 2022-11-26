module Puzzle

let parseInput (lines: string[]) = lines |> Array.map int

let runPartOne (input: int[]) = input |> Array.sum

let runPartTwo (input: int[]) = input |> Array.reduce (*)
