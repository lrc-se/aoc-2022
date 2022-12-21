import std/[strutils, tables]

type
  Job = enum Number, Addition, Subtraction, Multiplication, Division
  Monkey = object
    case job: Job
      of Number:
        number: int
      else:
        monkeys: seq[string]
  Monkeys = Table[string, Monkey]

func calc(job: Job; value, number: int): int =
  case job:
    of Addition: value + number
    of Subtraction: value - number
    of Multiplication: value * number
    of Division: value div number
    else: value

func calcRev(job: Job; value, number: int): int =
  case job:
    of Addition: value - number
    of Subtraction: value + number
    of Multiplication: value div number
    of Division: value * number
    else: value

func yell(monkeys: Monkeys): Table[string, int] =
  while true:
    var hasYelled = false
    for name, monkey in monkeys:
      if name notin result:
        case monkey.job:
          of Number:
            result[name] = monkey.number
            hasYelled = true
          elif monkey.monkeys[0] in result and monkey.monkeys[1] in result:
              result[name] = monkey.job.calc(result[monkey.monkeys[0]], result[monkey.monkeys[1]])
              hasYelled = true

    if not hasYelled:
      return


func parseInput*(lines: seq[string]): Monkeys =
  for line in lines:
    let parts = line.split(": ")
    if '+' in parts[1]:
      result[parts[0]] = Monkey(job: Addition, monkeys: parts[1].split(" + "))
    elif '-' in parts[1]:
      result[parts[0]] = Monkey(job: Subtraction, monkeys: parts[1].split(" - "))
    elif '*' in parts[1]:
      result[parts[0]] = Monkey(job: Multiplication, monkeys: parts[1].split(" * "))
    elif '/' in parts[1]:
      result[parts[0]] = Monkey(job: Division, monkeys: parts[1].split(" / "))
    else:
      result[parts[0]] = Monkey(job: Number, number: parseInt(parts[1]))

func runPartOne*(input: Monkeys): int = input.yell["root"]

func runPartTwo*(input: Monkeys): int =
  var monkeys = input
  monkeys.del("root")
  monkeys.del("humn")

  let
    yelled = monkeys.yell
    root = input["root"]

  var target: tuple[name: string; number: int] =
    if root.monkeys[0] in yelled:
      (root.monkeys[1], yelled[root.monkeys[0]])
    else:
      (root.monkeys[0], yelled[root.monkeys[1]])

  while target.name != "humn":
    let curMonkey = input[target.name]
    var knownIndex, targetIndex: int
    if curMonkey.monkeys[0] in yelled:
      knownIndex = 0
      targetIndex = 1
    else:
      knownIndex = 1
      targetIndex = 0

    let knownName = curMonkey.monkeys[knownIndex]
    target.name = curMonkey.monkeys[targetIndex]
    case curMonkey.job:
      of Addition, Multiplication:
        target.number = curMonkey.job.calcRev(target.number, yelled[knownName])
      of Subtraction, Division:
        target.number =
          if targetIndex == 0:
            curMonkey.job.calcRev(target.number, yelled[knownName])
          else:
            curMonkey.job.calc(yelled[knownName], target.number)
      else: discard

  result = target.number
