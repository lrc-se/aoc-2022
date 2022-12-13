module Puzzle

type PacketValue =
    | Integer of int
    | List of PacketValue list

let private tokenize (str: string) =
    str.Replace("[", "[,").Replace("]",",]").Split(',')
    |> List.ofArray

let rec private parseList tokens =
    let rec loop items tokens =
        match tokens with
        | [] -> items |> List.rev, []
        | "[" :: tail ->
            match parseList tail with
            | (list, remainingTokens) -> loop (List(list) :: items) remainingTokens
        | "]" :: tail -> items |> List.rev, tail
        | value :: tail ->
            match value with
            | "" -> loop items tail
            | _ -> loop (Integer(int value) :: items) tail

    loop List.empty tokens

let private parsePacket (line: string) =
    line
    |> tokenize
    |> parseList
    |> fun listResult -> List(fst listResult)

let private parsePacketPair (lines: string[]) = parsePacket lines[0], parsePacket lines[1]

let rec private comparePacketValue left right =
    match left with
    | Integer leftValue ->
        match right with
        | Integer rightValue -> leftValue - rightValue
        | List _ -> comparePacketValue (List([left])) right
    | List leftList ->
        match right with
        | Integer _ -> comparePacketValue left (List([right]))
        | List rightList -> (leftList, rightList) ||> List.compareWith comparePacketValue


let parseInput lines = lines

let runPartOne (input: string[]) =
    (input |> String.concat "\n").Split("\n\n")
    |> Array.map (fun line ->
        line.Split("\n")
        |> parsePacketPair
        ||> comparePacketValue)
    |> Array.indexed
    |> Array.sumBy (fun (i, value) -> if value < 0 then i + 1 else 0)

let runPartTwo (input: string[]) =
    let dividers = [| "[[2]]"; "[[6]]" |] |> Array.map parsePacket
    let packets =
        input
        |> Array.filter (fun line -> line.Length > 0)
        |> Array.map parsePacket
        |> Array.append dividers
        |> Array.sortWith comparePacketValue

    dividers
    |> Array.map (fun div -> (packets |> (Array.findIndex ((=) div))) + 1)
    |> Array.reduce (*)
