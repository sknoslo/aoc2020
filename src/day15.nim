import
  strformat,
  strutils,
  sequtils,
  tables,
  aoc2020pkg/bench

proc partOne(input: seq[uint32]): string =
  var
    lookup: Table[uint32, uint32]
    turn = 0.uint32
    last = input[^1]
  for num in input:
    turn.inc
    lookup[num] = turn
  while turn < 2020:
    if lookup.hasKeyOrPut(last, turn):
      let lastTurn = lookup[last]
      lookup[last] = turn
      last = turn - lastTurn
    else:
      last = 0
    turn.inc
  $last

proc partTwo(input: seq[uint32]): string =
  const target = 30_000_000
  var
    lookup: Table[uint32, uint32]
    turn = 0.uint32
    last = input[^1]
  for num in input:
    turn.inc
    lookup[num] = turn
  while turn < target:
    if lookup.hasKeyOrPut(last, turn):
      let lastTurn = lookup[last]
      lookup[last] = turn
      last = turn - lastTurn
    else:
      last = 0
    turn.inc
  $last

proc partTwoSeq(input: seq[uint32]): string =
  const target = 30_000_000
  var
    lookup = newSeq[uint32](target)
    turn = 0.uint32
    last = input[^1]
  for num in input:
    turn.inc
    lookup[num] = turn
  while turn < target:
    let lastTurn = lookup[last]
    lookup[last] = turn
    if lastTurn != 0:
      last = turn - lastTurn
    else:
      last = 0
    turn.inc
  $last

when isMainModule:
  echo "### DAY 15 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let nums = input.split(',').map(proc (s: string): uint32 = parseUInt(s).uint32)

  benchmark:
    echo(fmt"P1: {partOne(nums)}")
  benchmark:
    echo(fmt"P2: {partTwo(nums)}")
  benchmark:
    echo(fmt"P2seq: {partTwoSeq(nums)}")
