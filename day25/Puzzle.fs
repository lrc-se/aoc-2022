module Puzzle

let private pow5 exp = int64 (5.0 ** float exp)

let private parseSnafu (snafu: string) =
    let rec loop value digits =
        match digits with
        | [] -> value
        | digit :: tail ->
            let nextValue = value + pow5 (digits.Length - 1) * (
                match digit with
                | '-' -> -1L
                | '=' -> -2L
                | _ -> int64 digit - 48L)

            loop nextValue tail

    loop 0 (snafu.ToCharArray() |> Array.toList)

let private toSnafu (value: int64) =
    let rec loop (digits: char list) curValue =
        match curValue with
        | 0L -> digits
        | _ ->
            let factor = pow5 digits.Length
            let nextFactor = factor * 5L
            let units = (curValue % nextFactor) / factor
            let nextValue = curValue - factor * units

            match units with
            | 4L -> loop ('-' :: digits) (nextValue + nextFactor)
            | 3L -> loop ('=' :: digits) (nextValue + nextFactor)
            | _ -> loop (char (units + 48L) :: digits) nextValue

    let snafu =
        loop [] value
        |> List.map string
        |> String.concat ""

    if snafu = "" then "0" else snafu


let parseInput lines = lines

let runPartOne (input: string[]) =
    input
    |> Array.sumBy parseSnafu
    |> toSnafu

let runPartTwo _ = "Blender started!"
