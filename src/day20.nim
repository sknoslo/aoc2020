import
  strformat,
  strutils,
  math,
  npeg,
  aoc2020pkg/bench

type
  Pic = object
    pixels: seq[char]
    id, w, h: int

proc get(pic: Pic, x, y: int): char = pic.pixels[pic.w * y + x]
proc set(pic: var Pic, x, y: int, c: char) = pic.pixels[pic.w * y + x] = c

proc `$`(pic: Pic): string =
  result = "Tile " & $pic.id & ":\p"
  for y in 0..<pic.h:
    for x in 0..<pic.w:
      result.add(pic.get(x, y))
    result.add("\p")

proc rot(pic: var Pic) =
  var rotpic = pic
  for y in 0..<pic.h:
    for x in 0..<pic.w:
      let
        rotx = pic.w - y - 1
        roty = x
      rotpic.set(rotx, roty, pic.get(x, y))
  pic = rotpic

proc flip(pic: var Pic) =
  var flippic = pic
  for y in 0..<pic.h:
    for x in 0..<pic.w:
      let flipx = pic.w - x - 1
      flippic.set(flipx, y, pic.get(x, y))
  pic = flippic

proc adjacentTo(a, b: Pic): bool =
  var
    a = a
    b = b
  for _ in 1..2:
    for _ in 1..4:
      for _ in 1..4:
        if a.pixels[0..<a.w] == b.pixels[0..<a.w]:
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
    echo(fmt"P1: {partOne(pics)}")
    echo(fmt"P2: {partTwo(input)}")
