## Template File ##
import
  strformat,
  strutils,
  aoc2020pkg/bench

proc partOne(input: string): string =
  "INCOMPLETE"

proc partTwo(input: string): string =
  "INCOMPLETE"

when isMainModule:
  echo "### DAY 01 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  # do parsing here

  benchmark:
    echo(fmt"P1: {partOne(input)}")
    echo(fmt"P2: {partTwo(input)}")
