import
  strformat,
  sets,
  npeg,
  aoc2020pkg/bench

type
  Dir = enum
    E, SE, SW, W, NW, NE
  Vec2 = tuple[x, y: int]

const dirMap: array[Dir, Vec2] = [(2, 0), (1, -1), (-1, -1), (-2, 0), (-1, 1), (1, 1)]

proc partOne(input: seq[seq[Dir]]): string =
  var tiles: HashSet[Vec2]
  for inst in input:
    var pos: Vec2 = (0, 0)
    for dir in inst:
      let d = dirMap[dir]
      pos.x += d.x
      pos.y += d.y
    if tiles.containsOrIncl(pos):
      tiles.excl(pos)
  $tiles.len

proc partTwo(input: seq[seq[Dir]]): string =
  var
    tiles: HashSet[Vec2]
    minx, miny, maxx, maxy = 0
  for inst in input:
    var pos: Vec2 = (0, 0)
    for dir in inst:
      let d = dirMap[dir]
      pos.x += d.x
      pos.y += d.y
    if tiles.containsOrIncl(pos):
      tiles.excl(pos)
  for _ in 1..100:
    var next: HashSet[Vec2]
    for t in tiles:
      if t.x < minx: minx = t.x
      if t.y < miny: miny = t.y
      if t.x > maxx: maxx = t.x
      if t.y > maxy: maxy = t.y
    for x in minx-1..maxx+1:
      for y in miny-1..maxy+1:
        var adj = 0
        for d in dirMap:
          if tiles.contains((x+d.x, y+d.y)):
            adj.inc
        let black = tiles.contains((x, y))
        if adj == 2 and not black:
          next.incl((x, y))
        elif adj in {1, 2} and black:
          next.incl((x, y))
    tiles = next
  $tiles.len

when isMainModule:
  echo "### DAY 01 ###"

  let input = stdin.readAll

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  var
    instructions: seq[seq[Dir]]
    tmp: seq[Dir]

  let parser = peg "instructions":
    instructions <- +instruction * !1
    instruction <- +dir * "\p":
      instructions.add(tmp)
      tmp = @[]
    dir <- e|se|sw|w|nw|ne
    e <- "e":
      tmp.add(E)
    se <- "se":
      tmp.add(SE)
    sw <- "sw":
      tmp.add(SW)
    w <- "w":
      tmp.add(W)
    nw <- "nw":
      tmp.add(NW)
    ne <- "ne":
      tmp.add(NE)

  doAssert parser.match(input).ok

  benchmark:
    echo(fmt"P1: {partOne(instructions)}")
    echo(fmt"P2: {partTwo(instructions)}")
