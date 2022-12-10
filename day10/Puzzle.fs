module Puzzle

let private executeLine (values: int list) (line: string) =
    match line.Split(' ') with
    | [| "noop" |] -> values.Head :: values
    | [| "addx"; value |] -> [ values.Head + int value; values.Head ] @ values
    | _ -> values

let private signalStrength (values: int array) cycle = values[cycle - 1] * cycle

let private pixelValue cycle value =
    match cycle % 40 with
    | pos when pos >= value - 1 && pos <= value + 1 -> '#'
    | _ -> '.'


let parseInput lines = lines

let runPartOne input =
    let values =
        input
        |> Array.fold executeLine [1]
        |> List.rev
        |> Array.ofList

    [| 20; 60; 100; 140; 180; 220 |]
    |> Array.map (signalStrength values)
    |> Array.sum
    |> string

let runPartTwo input =
    let screen =
        input
        |> Array.fold executeLine [1]
        |> List.rev
        |> List.take (6 * 40)
        |> List.mapi pixelValue
        |> List.chunkBySize 40
        |> List.map (List.map string >> String.concat "")
        |> String.concat "\n"

    "\n" + screen
