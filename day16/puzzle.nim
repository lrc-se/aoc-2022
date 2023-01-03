import std/[strutils, sequtils, tables, re, sugar]

type
  Valve = ref object
    name: string
    rate: int
    tunnels: seq[string]
  ValveMap = Table[string, Valve]
  Valves = object
    valveMap: ValveMap
    workingValves: seq[Valve]
  Paths = Table[string, ref Table[string, seq[string]]]
  Minute = object of RootObj
    number, pressure, rate: int
    curValve: Valve
    remainingValves: seq[Valve]
  Minute2 = object of Minute
    openedValves: seq[Valve]

func plus[T](items: seq[T]; item: T): seq[T] =
  result = items
  result.add(item)

func findPath(valveMap: ValveMap; src, dest: string; path: seq[string] = @[]; minLen = int.high): seq[string] =
  if path.len >= minLen:
    return

  let valve = valveMap[src]
  if dest in valve.tunnels:
    return path.plus(dest)

  var curMinLen = minLen
  for name in valve.tunnels:
    if name notin path:
      let nextPath = valveMap.findPath(name, dest, path.plus(name), curMinLen)
      if nextPath.len > 0 and nextPath.len < curMinLen:
        result = nextPath
        curMinLen = nextPath.len

func findPaths(valves: Valves): Paths =
  for valve in valves.valveMap.values:
    var paths = newTable[string, seq[string]]()
    for workingValve in valves.workingValves:
      if workingValve != valve:
        paths[workingValve.name] = valves.valveMap.findPath(valve.name, workingValve.name)

    result[valve.name] = paths

func getMaxPressure(valveMap: ValveMap; paths: Paths; minute: Minute; maxMinutes: int): int =
  for nextValve in minute.remainingValves:
    let
      path = paths[minute.curValve.name][nextValve.name]
      minutes = path.len + 1

    if minute.number + minutes >= maxMinutes:
      continue

    var nextMinute = Minute(curValve: valveMap[path[^1]])
    nextMinute.number = minute.number + minutes
    nextMinute.pressure = minute.pressure + minute.rate * minutes
    nextMinute.rate = minute.rate + nextMinute.curValve.rate
    nextMinute.remainingValves = minute.remainingValves.filter(valve => valve != nextMinute.curValve)
    result = max(result, valveMap.getMaxPressure(paths, nextMinute, maxMinutes))

  if result == 0:
    result = minute.pressure + minute.rate * (maxMinutes - minute.number)

func getMaxPressure2(valves: Valves; maxMinutes: int): int =
  let paths = valves.findPaths
  var pressures: Table[int, seq[tuple[pressure: int; valveNames: seq[Valve]]]]

  func openValves(minute: Minute2) =
    for nextValve in minute.remainingValves:
      let
        path = paths[minute.curValve.name][nextValve.name]
        minutes = path.len + 1

      if minute.number + minutes >= maxMinutes:
        continue

      var nextMinute = Minute2(curValve: valves.valveMap[path[^1]])
      nextMinute.number = minute.number + minutes
      nextMinute.pressure = minute.pressure + minute.rate * minutes
      nextMinute.rate = minute.rate + nextMinute.curValve.rate
      nextMinute.remainingValves = minute.remainingValves.filter(valve => valve != nextMinute.curValve)
      nextMinute.openedValves = minute.openedValves.plus(nextMinute.curValve)
      if nextMinute.openedValves.len notin pressures:
        pressures[nextMinute.openedValves.len] = @[]

      pressures[nextMinute.openedValves.len].add((nextMinute.pressure + nextMinute.rate * (maxMinutes - nextMinute.number), nextMinute.openedValves))
      openValves(nextMinute)

  openValves(Minute2(curValve: valves.valveMap["AA"], remainingValves: valves.workingValves, openedValves: @[]))
  let lengths = pressures.keys.toSeq
  for selfLength in lengths[0 .. ^2]:
    for selfPressure in pressures[selfLength]:
      let selfValves = selfPressure.valveNames
      for elephantLength in lengths[1 .. ^1]:
        if selfLength + elephantLength > valves.workingValves.len:
          continue

        for elephantPressure in pressures[elephantLength]:
          let pressure = selfPressure.pressure + elephantPressure.pressure
          if pressure > result and not elephantPressure.valveNames.any(name => name in selfValves):
            result = pressure


func parseInput*(lines: seq[string]): Valves =
  for line in lines:
    if line =~ re"^Valve (.+) has.*=(\d+);.*valves? (.+)$":
      let valve = Valve(name: matches[0], rate: parseInt(matches[1]), tunnels: matches[2].split(", "))
      result.valveMap[valve.name] = valve
      if valve.rate > 0:
        result.workingValves.add(valve)

func runPartOne*(input: Valves): int =
  input.valveMap.getMaxPressure(input.findPaths, Minute(curValve: input.valveMap["AA"], remainingValves: input.workingValves), 30)

func runPartTwo*(input: Valves): int = input.getMaxPressure2(26)
