import std/[sequtils, strutils, algorithm]

type
  Monkey* = ref object
    items: seq[int]
    operation: tuple[operator: char; val: int]
    testDivisor: int
    recipients: tuple[ifTrue: int; ifFalse: int]

func newMonkey*(definition: seq[string]): Monkey =
  let operation = definition[1].split("new = old ")[1].split(' ')
  result = Monkey(
    items: definition[0].split(": ")[1].split(", ").map(parseInt).reversed,
    operation: (operation[0][0], if operation[1] == "old": -1 else: parseInt(operation[1])),
    testDivisor: parseInt(definition[2].split(' ')[^1]),
    recipients: (parseInt(definition[3].split(' ')[^1]), parseInt(definition[4].split(' ')[^1]))
  )

func testDivisor*(self: Monkey): int {.inline.} = self.testDivisor

func performOperation(self: Monkey; item: int; period: Natural): int =
  let operand = if self.operation.val == -1: item else: self.operation.val
  if self.operation.operator == '+':
    result = item + operand
  elif self.operation.operator == '*':
    result = item * operand
    if period > 0:
      result = result mod period

func receiveItem(self: Monkey; item: int) = self.items.add(item)

func inspectItems*(self: Monkey; monkeys: seq[Monkey]; worryDivisor: Positive; period: Natural = 0): int =
  result = self.items.len
  for _ in 1 .. self.items.len:
    let worryLevel = self.performOperation(self.items.pop, period) div worryDivisor
    let recipient = if worryLevel mod self.testDivisor == 0: self.recipients.ifTrue else: self.recipients.ifFalse
    monkeys[recipient].receiveItem(worryLevel)
