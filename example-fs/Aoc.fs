open System
open Puzzle

let runner =
    match Environment.GetEnvironmentVariable("part") with
    | "part1" | "" | null -> Some(runPartOne)
    | "part2" -> Some(runPartTwo)
    | _ -> None

match runner with
| Some(runPuzzle) ->
    let filename = (if Environment.GetEnvironmentVariable("mode") = "test" then "input-test" else "input") + ".txt"
    printfn "Result: %s" (
        IO.File.ReadAllLines(filename)
        |> parseInput
        |> runPuzzle
        |> string
    )
| None -> printfn "Unknown part"
