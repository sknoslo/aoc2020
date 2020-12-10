import
  strformat,
  strutils,
  sequtils,
  algorithm,
  tables,
  aoc2020pkg/bench

proc partOne(input: seq[int]): string =
  var sorted = input
  sorted.sort

  var
    prev, ones = 0
    threes = 1
  for jolt in sorted:
    let diff = jolt - prev
    prev = jolt
    if diff == 1:
      ones += 1
    elif diff == 3:
      threes += 1
  $(ones * threes)

proc getJolts(a: seq[int], i: int): int =
  if i == -1:
    return 0
  a[i]

proc choices(adapters: seq[int], i: int, memo: var Table[int, int]): int =
  if i == adapters.len - 1: return 1
  var t = 0
  for j in i + 1..<adapters.len:
    let d = adapters.getJolts(j) - adapters.getJolts(i)
    if d > 3: break
    if memo.contains(j):
      t += memo[j]
    else:
      t += choices(adapters, j, memo)
  memo[i] = t
  t

proc partTwo(input: seq[int]): string =
  var sorted = input
  sorted.sort

  var memo: Table[int, int]
  $choices(sorted, -1, memo)
when isMainModule:
  echo "### DAY 10 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let adapters = input.splitLines.map(parseInt)

  benchmark:
    echo(fmt"P1: {partOne(adapters)}")
    echo(fmt"P2: {partTwo(adapters)}")
