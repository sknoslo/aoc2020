import
  strformat,
  strutils,
  algorithm,
  aoc2020pkg/bench

type Bus = tuple[offset, id: int]

proc partOne(eta: int, buses: seq[Bus]): string =
  var
    id = -1
    wait = high(int)
  for b in buses:
    let w = (eta div b.id + 1) * b.id - eta
    if w < wait:
      id = b.id
      wait = w

  $(wait * id)

proc partTwo(buses: seq[Bus]): string =
  "INCOMPLETE"

when isMainModule:
  echo "### DAY 13 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let
    lines = input.splitLines
    eta = lines[0].parseInt
    arr = lines[1].split(',')
  var buses: seq[Bus]
  for offset, id in arr:
    if id == "x":
      continue
    buses.add((offset, id.parseInt))

  benchmark:
    echo(fmt"P1: {partOne(eta, buses)}")
    echo(fmt"P2: {partTwo(buses)}")
