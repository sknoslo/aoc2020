import
  algorithm,
  strformat,
  strutils,
  sequtils,
  lists,
  aoc2020pkg/bench

proc partOne(input: seq[int]): string =
  let
    min = input.min
    max = input.max
  var cups = initDoublyLinkedRing[int]()
  for c in input:
    cups.append(c)
  for mov in 1..100:
    var removed: seq[int]
    for _ in 1..3:
      removed.add(cups.head.next.value)
      cups.remove(cups.head.next)
    var
      target = cups.head.value
      dest: DoublyLinkedNode[int]
    while dest == nil:
      target.dec
      if target < min:
        target = max
      if target notin removed:
        dest = cups.find(target)
    var nextHead = cups.head.next
    cups.head = dest.next
    for n in removed.reversed:
      cups.prepend(n)
    cups.head = nextHead
  cups.head = cups.find(1)
  cups.remove(cups.head)
  cups.head = cups.head.next
  result = ""
  for c in cups:
    result.add($c)

proc partTwo(input: seq[int]): string =
  "uh...."

when isMainModule:
  echo "### DAY 23 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  proc charToInt(c: char): int = parseInt($c)

  let cups = input.toSeq.map(charToInt)

  benchmark:
    echo(fmt"P1: {partOne(cups)}")
    echo(fmt"P2: {partTwo(cups)}")
