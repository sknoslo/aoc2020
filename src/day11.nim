import
  strformat,
  strutils,
  sequtils,
  math,
  aoc2020pkg/bench

type
  Point = tuple[x, y: int]
  Map = object
    w, h: int
    tiles: seq[char]

const adj: array[0..7, Point] =
  [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

proc ob(map: Map, x, y: int): bool =
  x < 0 or y < 0 or x >= map.w or y >= map.h

proc get(map: Map, x, y: int): char =
  if map.ob(x, y):
    return '.'
  map.tiles[x + y * map.w]

proc put(map: var Map, x, y: int, t: char) =
  map.tiles[x + y * map.w] = t

proc adjOccupied(m: Map, x, y: int): int =
  adj.map(proc (p: Point): int =
    if m.get(x + p.x, y + p.y) == '#':
      1
    else:
      0).sum

proc adjOccupied2(m: Map, x, y: int): int =
  adj.map(proc (p: Point): int =
    var
      dx = x + p.x
      dy = y + p.y
    while not m.ob(dx, dy):
      let t = m.get(dx, dy)
      if t == '#':
        return 1
      elif t == 'L':
        return 0
      dx = dx + p.x
      dy = dy + p.y
    0).sum

proc `$`(map: Map): string =
  result = ""
  for i, t in map.tiles:
    result.add(t)
    if (i + 1) mod map.w == 0:
      result.add('\n')

proc partOne(input: Map): string =
  var prev, curr: Map
  curr = input
  while curr.tiles != prev.tiles:
    prev = curr
    for x in 0..<prev.w:
      for y in 0..<prev.h:
        let
          occ = prev.adjOccupied(x, y)
          t = prev.get(x, y)
        curr.put(x, y, t)
        if t == '.':
          continue
        if occ == 0 and t == 'L':
          curr.put(x, y, '#')
        elif occ > 3 and t == '#':
          curr.put(x, y, 'L')
  $curr.tiles.count('#')

proc partTwo(input: Map): string =
  var prev, curr: Map
  curr = input
  while curr.tiles != prev.tiles:
    prev = curr
    for x in 0..<prev.w:
      for y in 0..<prev.h:
        let
          occ = prev.adjOccupied2(x, y)
          t = prev.get(x, y)
        curr.put(x, y, t)
        if t == '.':
          continue
        if occ == 0 and t == 'L':
          curr.put(x, y, '#')
        elif occ > 4 and t == '#':
          curr.put(x, y, 'L')
  $curr.tiles.count('#')

when isMainModule:
  echo "### DAY 11 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let
    inLines = input.splitLines
    tiles = inLines.join("").toSeq
    h = inLines.len
    w = tiles.len div h
    map = Map(w: w, h: h, tiles: tiles)

  benchmark:
    echo(fmt"P1: {partOne(map)}")
    echo(fmt"P2: {partTwo(map)}")
