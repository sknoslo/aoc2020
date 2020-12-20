import
  strformat,
  strutils,
  math,
  npeg,
  aoc2020pkg/bench

type
  Pic = object
    pixels: seq[char]
    id, w, h, r: int
    f: bool

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

proc `$`(pic: Pic): string =
  result = "Tile " & $pic.id & ":\p"
  for y in 0..<pic.h:
    for x in 0..<pic.w:
      result.add(pic.get(x, y))
    result.add("\p")

proc rot(pic: var Pic) =
  pic.r = pic.r.succ mod 4

proc flip(pic: var Pic) =
  pic.f = not pic.f

proc adjacentTo(a, b: Pic): bool =
  var
    a = a
    b = b
  for _ in 1..2:
    for _ in 1..4:
      for _ in 1..4:
        var match = true
        for x in 0..<a.w:
          if a.get(x, 0) != b.get(x, 0):
            match = false
            break
        if match:
          return true
        b.rot
      a.rot
    b.flip
  false

proc partOne(tiles: seq[Pic]): string =
  var cornerIds: seq[int]
  for t in tiles:
    var adj = 0
    for o in tiles:
      if o.id == t.id:
        continue
      if t.adjacentTo(o):
        adj.inc
    if adj == 2:
      cornerIds.add(t.id)
  echo cornerIds
  $cornerIds.prod

proc partTwo(input: string): string =
  "INCOMPLETE"

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
    let p1 = partOne(pics)
    # for refactoring!
    doAssert p1 == "15405893262491"
    echo(fmt"P1: {p1}")
    echo(fmt"P2: {partTwo(input)}")
