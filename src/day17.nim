import
  strformat,
  strutils,
  sets,
  aoc2020pkg/bench

type
  Coord = tuple[x, y, z: int]
  World = HashSet[Coord]
  BCoord = tuple[x, y, z, w: int]
  BWorld = HashSet[BCoord]

proc partOne(world: World): string =
  var curr = world
  for _ in 1..6:
    var next: World
    var minx, miny, minz, maxx, maxy, maxz = 0
    for (x, y, z) in curr:
      if x < minx: minx = x
      if y < miny: miny = y
      if z < minz: minz = z
      if x > maxx: maxx = x
      if y > maxy: maxy = y
      if z > maxz: maxz = z
    for z in minz-1..maxz+1:
      for y in miny-1..maxy+1:
        for x in minx-1..maxx+1:
          let active = curr.contains((x, y, z))
          var activeNeighbors = 0
          for dz in -1..1:
            for dy in -1..1:
              for dx in -1..1:
                if dx == 0 and dy == 0 and dz == 0:
                  continue
                if curr.contains((x + dx, y + dy, z + dz)):
                  activeNeighbors.inc
          if active and activeNeighbors in 2..3:
            next.incl((x, y, z))
          elif not active and activeNeighbors == 3:
            next.incl((x, y, z))
    curr = next
  $curr.len

proc partTwo(world: BWorld): string =
  var curr = world
  for _ in 1..6:
    var next: BWorld
    var minx, miny, minz, minw, maxx, maxy, maxz, maxw = 0
    for (x, y, z, w) in curr:
      if x < minx: minx = x
      if y < miny: miny = y
      if z < minz: minz = z
      if w < minw: minw = w
      if x > maxx: maxx = x
      if y > maxy: maxy = y
      if z > maxz: maxz = z
      if w > maxw: maxw = w
    for w in minw-1..maxw+1:
      for z in minz-1..maxz+1:
        for y in miny-1..maxy+1:
          for x in minx-1..maxx+1:
            let active = curr.contains((x, y, z, w))
            var activeNeighbors = 0
            for dw in -1..1:
              for dz in -1..1:
                for dy in -1..1:
                  for dx in -1..1:
                    if dx == 0 and dy == 0 and dz == 0 and dw == 0:
                      continue
                    if curr.contains((x + dx, y + dy, z + dz, w + dw)):
                      activeNeighbors.inc
            if active and activeNeighbors in 2..3:
              next.incl((x, y, z, w))
            elif not active and activeNeighbors == 3:
              next.incl((x, y, z, w))
    curr = next
  $curr.len

when isMainModule:
  echo "### DAY 01 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let
    inputLines = input.splitLines
    width = inputLines[0].len
    height = inputLines.len
  var
    world: World
    bworld: BWorld
  
  for y, line in inputLines:
    for x, c in line:
      if c == '#':
        world.incl((x, y, 0))
        bworld.incl((x, y, 0, 0))

  benchmark:
    echo(fmt"P1: {partOne(world)}")
    echo(fmt"P2: {partTwo(bworld)}")
