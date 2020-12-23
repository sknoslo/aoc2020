import
  algorithm,
  strformat,
  strutils,
  sequtils,
  lists,
  aoc2020pkg/bench

type
  Cups = object
    curr, size: int
    data: seq[int]

proc setNext(cups: var Cups, next: int) =
  cups.data[cups.curr-1] = next

proc setNext(cups: var Cups, target, next: int) =
  cups.data[target-1] = next

proc next(cups: Cups, target: int): int =
  cups.data[target-1]

proc next(cups: Cups): int =
  var label = cups.curr
  for i in 0..3:
    label = cups.data[label - 1]
  label

proc nextThree(cups: Cups): array[0..2, int] =
  var label = cups.curr
  for i in 0..2:
    result[i] = cups.data[label - 1]
    label = result[i]

proc findDest(cups: Cups): int =
  let skip = cups.nextThree
  var next = cups.curr - 1
  while next < 1 or next in skip:
    next.dec
    if next < 1:
      next = cups.size
  next

proc initGame(initial: seq[int], size: int): Cups =
  result.curr = initial[0]
  result.size = size
  result.data = newSeq[int](size)
  for i in 1..<initial.len:
    let
      v = initial[i-1]
      n = initial[i]
    result.data[v-1] = n
  var last = initial[^1]
  if size > initial.len:
    result.data[last-1] = initial.len + 1
    for i in initial.len+1..size:
      result.data[i-1] = i + 1
      last = i
  result.data[last-1] = initial[0]

proc `$`(cups: Cups): string =
  result = ""
  var
    c = cups.curr
    printed = 0

  while printed < 20 and printed < cups.size:
    result.add($c)
    result.add(' ')
    c = cups.data[c-1]
    printed.inc
  if printed < cups.size:
    result.add("...")
  

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
  var cups = initGame(input, 1_000_000)
  for rnd in 1..10_000_000:
    let
      tomove = cups.nextThree
      dest = cups.findDest
      next = cups.next
    cups.setNext(next)
    cups.setNext(tomove[^1], cups.next(dest))
    cups.setNext(dest, tomove[0])
    cups.curr = next
  let a = cups.next(1)
  let b = cups.next(a)
  $(a*b)

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
