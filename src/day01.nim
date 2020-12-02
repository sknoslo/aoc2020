import
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

