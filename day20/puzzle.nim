import std/[strutils, lists]

type
  EncryptedCoordinates = object
    ring: DoublyLinkedRing[int]
    numbers: seq[DoublyLinkedNode[int]]
    zero: DoublyLinkedNode[int]

func mix(coordinates: var EncryptedCoordinates) =
  let period = coordinates.numbers.len - 1
  for node in coordinates.numbers:
    if node.value == 0:
      continue

    node.prev.next = node.next
    node.next.prev = node.prev
    var curNode = node
    if node.value > 0:
      for _ in 1 .. node.value mod period:
        curNode = curNode.next

      node.prev = curNode
      node.next = curNode.next
      curNode.next.prev = node
      curNode.next = node
    else:
      for _ in 1 .. abs(node.value) mod period:
        curNode = curNode.prev

      node.next = curNode
      node.prev = curNode.prev
      curNode.prev.next = node
      curNode.prev = node

func decrypt(coordinates: var EncryptedCoordinates; mixCount: int): int =
  for _ in 1 .. mixCount:
    coordinates.mix()

  var node = coordinates.zero
  for i in 1 .. 3:
    for j in 1 .. 1000:
      node = node.next

    result += node.value


func parseInput*(lines: seq[string]): EncryptedCoordinates =
  for line in lines:
    let node = newDoublyLinkedNode(parseInt(line))
    result.ring.add(node)
    result.numbers.add(node)
    if node.value == 0:
      result.zero = node

func runPartOne*(input: EncryptedCoordinates): int =
  var coordinates = input
  result = coordinates.decrypt(1)

func runPartTwo*(input: EncryptedCoordinates): int =
  var coordinates = input
  for value in coordinates.ring.mitems:
    value *= 811589153

  result = coordinates.decrypt(10)
