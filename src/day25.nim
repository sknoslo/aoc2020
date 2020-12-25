import
  strformat,
  strutils,
  sequtils,
  aoc2020pkg/bench

proc doWork(value: var int, sub: int) {.inline.} =
  value = (sub * value) mod 20201227

proc getFirst(cardPub, doorPub: int): tuple[loops, pub: int] =
  var loops, value = 1
  while true:
    doWork(value, 7)
    if value == cardPub:
      return (loops, doorPub)
    if value == doorPub:
      return (loops, cardPub)
    loops.inc

proc partOne(cardPub, doorPub: int): string =
  let (loops, pub) = getFirst(cardPub, doorPub)
  var value = 1
  for _ in 1..loops:
    doWork(value, pub)
  $value

proc partTwo(input: string): string =
  "fin"

when isMainModule:
  echo "### DAY 25 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let
    parts = input.splitLines.map(parseInt)
    cardPub = parts[0]
    doorPub = parts[1]

  benchmark:
    echo(fmt"P1: {partOne(cardPub, doorPub)}")
    echo(fmt"P2: {partTwo(input)}")
