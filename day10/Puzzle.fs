module Puzzle

let private executeLine (values: int list) (line: string) =
    match line.Split(' ') with
    | [| "noop" |] -> values.Head :: values
    | [| "addx"; value |] -> [ values.Head + int value; values.Head ] @ values
    | _ -> values

let private signalStrength (values: int array) cycle = values[cycle - 1] * cycle

let private drawScreen (pixels: char list) value =
    match pixels.Length % 40 with
    | pos when pos >= value - 1 && pos <= value + 1 -> '#' :: pixels
    | _ -> '.' :: pixels


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
    let values =
        input
        |> Array.fold executeLine [1]
        |> List.rev

    let screen =
        values
        |> List.fold drawScreen []
        |> List.tail
        |> List.rev
        |> List.chunkBySize 40
        |> List.map (List.map string >> String.concat "")
        |> String.concat "\n"

    "\n" + screen
