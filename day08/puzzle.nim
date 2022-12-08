import std/[strutils, math]

type Delta = tuple[x: int; y: int]

const deltas: seq[Delta] = @[(0, -1), (-1, 0), (1, 0), (0, 1)]

func countVisibleTrees(treeMap: seq[string]): int =
  let
    height = treeMap.len
    width = treeMap[0].len

  for y in 0 ..< height:
    for x in 0 ..< width:
      let treeHeight = parseInt(treeMap[y][x .. x])
      for delta in deltas:
        var
          posY = y + delta.y
          posX = x + delta.x
          visible = true

        while posY >= 0 and posY < height and posX >= 0 and posX < width:
          if parseInt(treeMap[posY][posX .. posX]) >= treeHeight:
            visible = false
            break

          posY += delta.y
          posX += delta.x

        if visible:
          result += 1
          break

func getMaxScenicScore(treeMap: seq[string]): int =
  let
    height = treeMap.len
    width = treeMap[0].len

  for y in 0 ..< height:
    for x in 0 ..< width:
      let treeHeight = parseInt(treeMap[y][x .. x])
      var scores: array[deltas.len, int]
      for i, delta in deltas:
        var
          posY = y + delta.y
          posX = x + delta.x

        while posY >= 0 and posY < height and posX >= 0 and posX < width:
          scores[i] += 1
          if parseInt(treeMap[posY][posX .. posX]) >= treeHeight:
            break

          posY += delta.y
          posX += delta.x

        if scores[i] == 0:
          break

      let score = scores.prod
      if score > result:
        result = score


func parseInput*(lines: seq[string]): seq[string] = lines

func runPartOne*(input: seq[string]): int = input.countVisibleTrees

func runPartTwo*(input: seq[string]): int = input.getMaxScenicScore
