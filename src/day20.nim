import
  strformat,
  strutils,
  sets,
  sequtils,
  tables,
  math,
  npeg,
  aoc2020pkg/bench

type
  Pic = object
    pixels: seq[char]
    id, w, h, r: int
    f: bool
  Dir = enum North, East, South, West
  AdjResult = tuple[yes: bool, d: Dir]

const monster: seq[tuple[x, y: int]] = @[(0, 0), (1, 1), (4, 1), (5, 0), (6, 0), (7, 1), (10, 1), (11, 0), (12, 0), (13, 1), (16, 1), (17, 0), (18, 0), (18, -1), (19, 0)]

proc idx(pic: Pic, x, y: int): int =
  var
    nx = x
    ny = y
  for _ in 0..<pic.r:
    let tmp = nx
    nx = pic.w - ny - 1
    ny = tmp
  if pic.f:
    nx = pic.w - nx - 1
  pic.w * ny + nx
proc get(pic: Pic, x, y: int): char =
  pic.pixels[pic.idx(x, y)]
proc set(pic: var Pic, x, y: int, c: char) =
  pic.pixels[pic.idx(x, y)] = c

proc `$`(pic: Pic): string =
  result = "Tile " & $pic.id & ":\p"
  for y in 0..<pic.h:
    for x in 0..<pic.w:
      result.add(pic.get(x, y))
    result.add("\p")

proc rot(pic: var Pic) =
  pic.r = pic.r.succ mod 4

proc revRot(pic: var Pic, times: int) =
  pic.r = (4 + pic.r - times) mod 4

proc flip(pic: var Pic) =
  pic.f = not pic.f

proc adjacentTo(a, b: var Pic): AdjResult =
  for _ in 0..1:
    for arotations in North..West:
      for _ in 0..3:
        var match = true
        for x in 0..<a.w:
          if a.get(x, 0) != b.get(x, a.h - 1):
            match = false
            break
        if match:
          # To leave a in it's original orientation. Alternatively could have different edge lookup logic
          a.revRot(arotations.int)
          b.revRot(arotations.int)
          return (true, arotations)
        b.rot
      a.rot
    b.flip
  (false, North)

proc partOne(tiles: seq[Pic]): string =
  var
    tiles = tiles
    cornerIds: seq[int]
  for a in 0..<tiles.len:
    var adj = 0
    for b in 0..<tiles.len:
      if tiles[b].id == tiles[a].id:
        continue
      if tiles[a].adjacentTo(tiles[b]).yes:
        adj.inc
    if adj == 2:
      cornerIds.add(tiles[a].id)
  $cornerIds.prod

proc partTwo(input: seq[Pic]): string =
  var
    tiles = input
    toVisit = @[(0, 0, 0)]
    seen: Table[int, tuple[x, y: int]]
    minx, miny, maxx, maxy = 0
  while toVisit.len > 0:
    let (a, x, y) = toVisit.pop
    if x < minx: minx = x
    if x > maxx: maxx = x
    if y < miny: miny = y
    if y > maxy: maxy = y
    seen[tiles[a].id] = (x, y)
    for b in 0..<tiles.len:
      if a == b or seen.hasKey(tiles[b].id):
        continue
      let (yes, dir) = tiles[a].adjacentTo(tiles[b])
      if yes:
        let (dx, dy) =
          case dir
          of North: (0, -1)
          of East: (1, 0)
          of South: (0, 1)
          of West: (-1, 0)
        toVisit.add((b, x + dx, y + dy))

  let tileSize = tiles[0].w - 2
  var fullPic: Pic
  fullPic.w = (maxx - minx + 1) * tileSize
  fullPic.h = (maxy - miny + 1) * tileSize
  fullPic.pixels = newSeq[char](fullPic.w * fullPic.h)

  for t in tiles:
    let
      ox = (seen[t.id].x - minx) * tileSize
      oy = (seen[t.id].y - miny) * tileSize
    for x in 0..<tileSize:
      for y in 0..<tileSize:
        fullPic.set(x + ox, y + oy, t.get(x + 1, y + 1))


  for _ in 0..1:
    for _ in 0..3:
      var hasMonsters = false
      for x in 0..<fullPic.w:
        for y in 0..<fullPic.h:
          if fullPic.get(x, y) == '#':
            var match = true
            for (ox, oy) in monster:
              if x + ox >= fullPic.w or y + oy >= fullPic.h or fullPic.get(x + ox, y + oy) != '#':
                match = false
                break
            if match:
              hasMonsters = true
              for (ox, oy) in monster:
                fullPic.set(x + ox, y + oy, '0')
      if hasMonsters:
        return $fullPic.pixels.count('#')
      fullPic.rot
    fullPic.flip
  "failure"

when isMainModule:
  echo "### DAY 20 ###"

  let input = stdin.readAll

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  var
    pic: Pic
    pics: seq[Pic]

  let parser = peg "pictures":
    pictures <- *picture * !1
    picture <- id * "\p" * pixels * "\p":
      pic.h = pic.pixels.len div pic.w
      pics.add(pic)
      pic.pixels = @[]
    id <- "Tile " * >+Digit * ":":
      pic.id = parseInt($1)
    pixels <- +(row * "\p")
    row <- >+{'#', '.'}:
      pic.w = len($1)
      for c in $1:
        pic.pixels.add(c)

  doAssert parser.match(input).ok

  benchmark:
    echo(fmt"P1: {partOne(pics)}")
    echo(fmt"P2: {partTwo(pics)}")
