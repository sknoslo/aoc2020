import
  strformat,
  strutils,
  sequtils,
  algorithm,
  aoc2020pkg/bench

proc half(a, b: int): int {.inline.} = (a + b) div 2

proc getSeatId(pass: string): int =
  var
    f, l = 0
    r = 7
    b = 127
  for c in pass:
    case c
    of 'F':
      b = half(f, b)
    of 'B':
      f = half(f, b) + 1
    of 'L':
      r = half(l, r)
    of 'R':
      l = half(l, r) + 1
    else:
      raise newException(Defect, "found " & $c)
  f * 8 + l

proc partOne(input: seq[string]): string =
  $input.map(getSeatId).max

proc partTwo(input: seq[string]): string =
  let seats = input.map(getSeatId).sorted

  for i in 1..<seats.len:
    if seats[i] - seats[i - 1] == 2:
      return $(seats[i] - 1)
  "no bueno"

when isMainModule:
  echo "### DAY 05 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let passes = input.splitLines

  benchmark:
    echo(fmt"P1: {partOne(passes)}")
    echo(fmt"P2: {partTwo(passes)}")
