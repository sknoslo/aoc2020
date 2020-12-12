import
  strformat,
  strutils,
  npeg,
  aoc2020pkg/bench

type
  Inst = tuple[i: char, u: int]
  Point = tuple[x, y: int]

# standard library?
proc indexOf(s: openArray[char], c: char): int =
  for i, ch in s:
    if ch == c:
      return i
  -1

proc go(ship: var Point, h: char, u: int) =
  case h
  of 'N': ship.y += u
  of 'S': ship.y -= u
  of 'E': ship.x += u
  of 'W': ship.x -= u
  else: discard

proc go(ship: var Point, way: Point, u: int) =
  ship.x += way.x * u
  ship.y += way.y * u

proc turn(c: var char, d: char, u: int) =
  const
    cw = ['N', 'E', 'S', 'W']
    ccw = ['N', 'W', 'S', 'E']
  let offset = u div 90
  case d
  of 'L': c = ccw[(ccw.indexOf(c) + offset) mod 4]
  of 'R': c = cw[(cw.indexOf(c) + offset) mod 4]
  else: discard

proc rotate(p: var Point, d: char, u: int) =
  # who needs matrices anyway?
  let i = u div 90
  if i mod 2 == 1:
    let t = p.x
    p.x = p.y
    p.y = t
  const
    cw = [(1, -1), (-1, -1), (-1, 1)]
    ccw = [(-1, 1), (-1, -1), (1, -1)]
  let (rx, ry) = if d == 'R':
    cw[i - 1]
  else:
    ccw[i - 1]
  p.x *= rx
  p.y *= ry

proc partOne(input: seq[Inst]): string =
  var
    ship: Point = (0, 0)
    heading = 'E'
  for i in input:
    case i.i
    of 'N', 'E', 'S', 'W': ship.go(i.i, i.u)
    of 'F': ship.go(heading, i.u)
    of 'L', 'R': heading.turn(i.i, i.u)
    else: discard
  $(ship.x.abs + ship.y.abs)

proc partTwo(input: seq[Inst]): string =
  var
    ship: Point = (0, 0)
    way: Point = (10, 1)
  for i in input:
    case i.i
    of 'N', 'E', 'S', 'W': way.go(i.i, i.u)
    of 'F': ship.go(way, i.u)
    of 'L', 'R': way.rotate(i.i, i.u)
    else: discard
  $(ship.x.abs + ship.y.abs)

when isMainModule:
  echo "### DAY 12 ###"

  let input = stdin.readAll

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  var instructions: seq[Inst]
  let parser = peg "instructions":
    instructions <- *instruction * ?"\p" * !1
    instruction <- >dir * >units * "\p":
      instructions.add((($1)[0], parseInt($2)))
    dir <- Alpha
    units <- +Digit

  doAssert parser.match(input).ok

  benchmark:
    echo(fmt"P1: {partOne(instructions)}")
    echo(fmt"P2: {partTwo(instructions)}")
