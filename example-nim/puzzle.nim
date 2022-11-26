import std/[sequtils, strutils, math]

func parseInput*(lines: openarray[string]): seq[int] =
  lines.map(parseInt)

let runPartOne* = sum[int]

let runPartTwo* = prod[int]
