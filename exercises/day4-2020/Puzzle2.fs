module Puzzle2

open System.Text.RegularExpressions

type FieldType =
    | BirthYear
    | IssueYear
    | ExpirationYear
    | Height
    | HairColor
    | EyeColor
    | PassportID
    | CountryID

type Passport = Map<FieldType, string>

let fieldTypeMap =
    Map [
        ("byr", BirthYear)
        ("iyr", IssueYear)
        ("eyr", ExpirationYear)
        ("hgt", Height)
        ("hcl", HairColor)
        ("ecl", EyeColor)
        ("pid", PassportID)
        ("cid", CountryID)
    ]

let requiredFields = fieldTypeMap.Values |> Set.ofSeq
let validEyeColors = set [ "amb"; "blu"; "brn"; "gry"; "grn"; "hzl"; "oth" ]

let addField passport (pair: string) =
    let parts = pair.Split(':')
    passport |> Map.add (fieldTypeMap |> Map.find parts[0]) parts[1]

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
    | [fieldType] -> fieldType = CountryID
    | _ -> false

let isValidHeight value unit =
    match unit with
    | "cm" -> value >= 150 && value <= 193
    | "in" -> value >= 59 && value <= 76
    | _ -> false

let isValidField fieldType value =
    match fieldType with
    | BirthYear -> value >= "1920" && value <= "2002"
    | IssueYear -> value >= "2010" && value <= "2020"
    | ExpirationYear -> value >= "2020" && value <= "2030"
    | Height ->
        let matchResult = Regex.Match(value, @"^(\d+)(\D+)$")
        matchResult.Success && isValidHeight (int matchResult.Groups[1].Value) matchResult.Groups[2].Value
    | HairColor -> Regex.IsMatch(value, @"^#[0-9a-f]{6}$")
    | EyeColor -> validEyeColors |> Set.contains value
    | PassportID -> Regex.IsMatch(value, @"^\d{9}$")
    | CountryID -> true

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
