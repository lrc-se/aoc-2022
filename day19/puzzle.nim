import std/[strutils, sequtils, sets, tables, hashes, re, math]

type
  Resource = enum Ore, Clay, Obsidian, Geode
  Cost = Table[Resource, int]
  Blueprint = object
    number: int
    robots: Table[Resource, Cost]
  Signature = object
    robots, resources, hash: Hash
    score: int
  Minute = ref object
    robots, resources: CountTable[Resource]
    signature: Signature

func newMinute(robots, resources: CountTable[Resource]): Minute =
  result = Minute(robots: robots, resources: resources)
  result.signature.robots = robots.hash
  result.signature.resources = resources.hash
  result.signature.hash = !$(result.signature.robots !& result.signature.resources)
  for res, count in resources:
    result.signature.score += count * 1000 ^ res.ord

func getMaxGeodes(blueprint: Blueprint; maxMinutes: int): int =
  var minutes = @[newMinute([Ore].toCountTable, initCountTable[Resource]())]
  for i in 1 .. maxMinutes:
    var newMinutes = initTable[Hash, Minute]()
    for minute in minutes:
      if i == maxMinutes:
        result = max(result, minute.resources[Geode] + minute.robots[Geode])
        continue

      var resources = minute.resources
      for res, count in minute.robots:
        resources.inc(res, count)

      var nextMinutes = @[newMinute(minute.robots, resources)]
      let lo = if i == maxMinutes - 1: Resource.high else: Resource.low
      for resource in lo .. Resource.high:
        var canBuild = true
        for res, cost in blueprint.robots[resource]:
          if minute.resources[res] < cost:
            canBuild = false
            break

        if canBuild:
          var
            newRobots = minute.robots
            newResources = resources

          newRobots.inc(resource)
          for res, cost in blueprint.robots[resource]:
            newResources.inc(res, -cost)

          nextMinutes.add(newMinute(newRobots, newResources))

      var hasNew = false
      for nextMinute in nextMinutes:
        if nextMinute.signature.hash notin newMinutes:
          hasNew = true
          break

      if hasNew:
        var removeHashes: HashSet[Hash]
        for prevMinute in newMinutes.values:
          for nextMinute in nextMinutes:
            if (
              nextMinute.signature.robots == prevMinute.signature.robots and
              nextMinute.resources.len == prevMinute.resources.len and
              nextMinute.signature.score > prevMinute.signature.score
            ):
              removeHashes.incl(prevMinute.signature.hash)
              break

        for hash in removeHashes:
          newMinutes.del(hash)

        for nextMinute in nextMinutes:
          newMinutes[nextMinute.signature.hash] = nextMinute

    minutes = newMinutes.values.toSeq


func parseInput*(lines: seq[string]): seq[Blueprint] =
  for line in lines:
    if line =~ re"Blueprint (\d+):.*ore robot costs (\d+) ore\..*clay robot costs (\d+) ore\..*obsidian robot costs (\d+) ore and (\d+) clay\..*geode robot costs (\d+) ore and (\d+) obsidian":
      var blueprint = Blueprint(number: parseInt(matches[0]), robots: initTable[Resource, Cost]())
      blueprint.robots[Ore] = { Ore: parseInt(matches[1]) }.toTable
      blueprint.robots[Clay] = { Ore: parseInt(matches[2]) }.toTable
      blueprint.robots[Obsidian] = { Ore: parseInt(matches[3]), Clay: parseInt(matches[4]) }.toTable
      blueprint.robots[Geode] = { Ore: parseInt(matches[5]), Obsidian: parseInt(matches[6]) }.toTable
      result.add(blueprint)

proc runPartOne*(input: seq[Blueprint]): int =
  for blueprint in input:
    result += blueprint.getMaxGeodes(24) * blueprint.number

proc runPartTwo*(input: seq[Blueprint]): int =
  result = 1
  for blueprint in input[0 ..< min(3, input.len)]:
    result *= blueprint.getMaxGeodes(32)
