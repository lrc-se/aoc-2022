module Puzzle

open System.Text.RegularExpressions

type Passport = Map<string, string>

let requiredFields = set [ "byr"; "iyr"; "eyr"; "hgt"; "hcl"; "ecl"; "pid"; "cid" ]
let validEyeColors = set [ "amb"; "blu"; "brn"; "gry"; "grn"; "hzl"; "oth" ]

let addField map (pair: string) =
    let parts = pair.Split(':')
    map |> Map.add parts[0] parts[1]

let parsePassport entry: Passport =
    Regex.Split(entry, @"\s+")
    |> Array.fold addField Map.empty

let isValidPassport (passport: Passport) =
    let missingFields =
        requiredFields
        |> Seq.except passport.Keys
        |> Seq.toList

    match missingFields with
    | [] -> true
    | [field] -> field = "cid"
    | _ -> false

let isValidHeight value unit =
    match unit with
    | "cm" -> value >= 150 && value <= 193
    | "in" -> value >= 59 && value <= 76
    | _ -> false

let isValidField key value =
    match key with
    | "byr" -> value >= "1920" && value <= "2002"
    | "iyr" -> value >= "2010" && value <= "2020"
    | "eyr" -> value >= "2020" && value <= "2030"
    | "hgt" ->
        let matchResult = Regex.Match(value, @"^(\d+)(\D+)$")
        matchResult.Success && isValidHeight (int matchResult.Groups[1].Value) matchResult.Groups[2].Value
    | "hcl" -> Regex.IsMatch(value, @"^#[0-9a-f]{6}$")
    | "ecl" -> validEyeColors |> Set.contains value
    | "pid" -> Regex.IsMatch(value, @"^\d{9}$")
    | "cid" -> true
    | _ -> false

let isValidPassport2 passport =
    isValidPassport passport && (passport |> Map.forall isValidField)

let countValid validate items =
    let validItems = items |> Array.filter validate
    validItems.Length


let parseInput lines =
    (lines |> String.concat "\n").Split("\n\n")
    |> Array.map parsePassport

let runPartOne = countValid isValidPassport

let runPartTwo = countValid isValidPassport2
