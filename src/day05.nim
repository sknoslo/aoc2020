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

  benchmark:
    let passes = input.splitLines
    echo(fmt"P1: {partOne(passes)}")
    echo(fmt"P2: {partTwo(passes)}")

  # more clever solution... really not sure how I didn't see this before... I mean... soooo many hints in the puzzle
  benchmark:
    let
      passes = input.multiReplace(("F", "0"), ("B", "1"), ("L", "0"), ("R", "1")).splitLines.map(parseBinInt).sorted
      p1 = passes[^1]
    var p2 = -1
    for i in 1..<passes.len:
      if passes[i] - passes[i - 1] == 2:
        p2 = passes[i] - 1
    echo "cleverererer (and maybe slightly faster) solution:"
    echo(fmt"P1: {p1}")
    echo(fmt"P2: {p2}")
