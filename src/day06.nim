import
  strformat,
  strutils,
  sequtils,
  sets,
  math,
  aoc2020pkg/bench

proc partOne(input: seq[string]): string =
  $input.map(proc (g: string): int = g.replace("\p", "").toHashSet.len).sum

proc partTwo(input: seq[string]): string =
  proc countSharedYeses(g: string): int =
    let answerSets = g.splitLines.map(proc (s: string): HashSet[char] = s.toHashSet)
    foldl(answerSets, intersection(a, b)).len

  $input.map(countSharedYeses).sum

when isMainModule:
  echo "### DAY 06 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let groups = input.split("\p\p")

  benchmark:
    echo(fmt"P1: {partOne(groups)}")
    echo(fmt"P2: {partTwo(groups)}")
