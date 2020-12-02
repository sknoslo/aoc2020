## Template File ##
import
  strformat,
  strutils,
  aoc2020pkg/bench

proc part_one(input: string): string =
  "INCOMPLETE"

proc part_two(input: string): string =
  "INCOMPLETE"

when isMainModule:
  echo "### DAY 01 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  # do parsing here

  benchmark:
    echo(fmt"P1: {part_one(input)}")
    echo(fmt"P2: {part_two(input)}")
