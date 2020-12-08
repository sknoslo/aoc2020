import
  intsets,
  strformat,
  strutils,
  sequtils,
  aoc2020pkg/bench

proc part_one(input: openArray[int]): string =
  for a in input:
    for b in input:
      if a + b == 2020:
        return (a * b).intToStr
  "No solution"

proc part_two(input: openArray[int]): string =
  for a in input:
    for b in input:
      for c in input:
        if a + b + c == 2020:
          return (a * b * c).intToStr
  "No solution"


# Given the small input, the "naive" solution above was plenty fast enough, and simpler to write.
# But for funzies, here are some n and n^2 solutions.
proc part_one_faster(input: openArray[int]): string =
  var seen = initIntSet()

  for a in input:
    if seen.contains(2020 - a):
      return $(a * (2020 - a))
    seen.incl(a)
  "No solution"

proc part_two_faster(input: openArray[int]): string =
  var seen = initIntSet()

  for a in input:
    for b in input:
      if seen.contains(2020 - a - b):
        return $(a * b * (2020 - a - b))
      seen.incl(b)
  "No solution"

when isMainModule:
  echo "### DAY 01 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let entries = input.splitLines(false).map(proc (s: string): int = s.parseInt)

  benchmark:
    echo(fmt"P1: {part_one(entries)}")
    echo(fmt"P2: {part_two(entries)}")

  echo ""

  benchmark:
    echo(fmt"P1: {part_one_faster(entries)}")
    echo(fmt"P2: {part_two_faster(entries)}")
