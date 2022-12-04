module Puzzle

type Pair = Set<int> * Set<int>

let private parseAssignment (part: string) =
  part.Split('-')
  |> fun nums -> seq { int nums[0] .. int nums[1] }
  |> Set.ofSeq

let private parsePair (line: string): Pair =
  let parts = line.Split(',')
  (parseAssignment parts[0], parseAssignment parts[1])

let private countPairs (filter: Pair -> bool) = Array.filter filter >> Array.length


let parseInput = Array.map parsePair

let runPartOne = countPairs (fun pair -> Set.isSubset (fst pair) (snd pair) || Set.isSubset (snd pair) (fst pair))

let runPartTwo = countPairs (fun pair -> not (Set.intersect (fst pair) (snd pair) |> Set.isEmpty))
