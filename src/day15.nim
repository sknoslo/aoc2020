import
  strformat,
  strutils,
  sequtils,
  tables,
  aoc2020pkg/bench

proc partOne(input: seq[int]): string =
  var
    nums = input
    lookup: Table[int, int]
    turn = 0
    last = nums[^1]
  for num in nums:
    turn.inc
    lookup[num] = turn
  while turn < 2020:
    if lookup.hasKeyOrPut(last, turn):
      let lastTurn = lookup[last]
      lookup[last] = turn
      last = turn - lastTurn
    else:
      last = 0
    nums.add(last)
    turn.inc
  $last

proc partTwo(input: seq[int]): string =
  const target = 30_000_000
  var
    nums = input
    lookup: Table[int, int]
    turn = 0
    last = nums[^1]
  for num in nums:
    turn.inc
    lookup[num] = turn
  while turn < target:
    if lookup.hasKeyOrPut(last, turn):
      let lastTurn = lookup[last]
      lookup[last] = turn
      last = turn - lastTurn
    else:
      last = 0
    nums.add(last)
    turn.inc
  $last

when isMainModule:
  echo "### DAY 15 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let nums = input.split(',').map(parseInt)

  benchmark:
    echo(fmt"P1: {partOne(nums)}")
    echo(fmt"P2: {partTwo(nums)}")
