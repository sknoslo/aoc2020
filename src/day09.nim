import
  strformat,
  strutils,
  sequtils,
  intsets,
  math,
  aoc2020pkg/bench

proc hasPair(v: int, possible: IntSet): bool =
  for p in possible:
    if possible.contains(v-p):
      return true


proc partOne(input: seq[int]): string =
  for i in 25..<input.len:
    let
      possible = input[i-25..<i].toIntSet
      v = input[i]
    if v.hasPair(possible):
      continue
    return $v

proc partTwo(input: seq[int]): string =
  var v: int
  for i in 25..<input.len:
    let
      possible = input[i-25..<i].toIntSet
    v = input[i]
    if v.hasPair(possible):
      continue
    break
  
  var
    a = 0
    b = 1
  while true:
    let s = input[a..b].sum

    if s == v:
      return $(input[a..b].max + input[a..b].min)
    elif s < v:
      b += 1
    else:
      a += 1

when isMainModule:
  echo "### DAY 09 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let code = input.splitLines.map(parseInt)

  benchmark:
    echo(fmt"P1: {partOne(code)}")
    echo(fmt"P2: {partTwo(code)}")
