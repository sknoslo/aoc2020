import
  strformat,
  strutils,
  aoc2020pkg/bench

type
  TreeMap = object
    map: string
    w, h: int

proc treeAt(t: TreeMap, x, y: int): bool =
  let 
    modx = x mod t.w
    i = modx + y * t.w

  t.map[i] == '#'

proc part_one(input: TreeMap): string =
  const
    x = 3
    y = 1

  var trees = 0

  for i in 0..<input.h:
    let
      py = i * y
      px = i * x
    
    if input.treeAt(px, py):
      trees += 1

  $trees

proc part_two(input: TreeMap): string =
  const slopes: seq[tuple[x, y: int]] = @[(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]

  var product = 1

  for slope in slopes:
    var trees = 0

    for i in 0..<(input.h div slope.y):
      let
        py = i * slope.y
        px = i * slope.x
      
      if input.treeAt(px, py):
        trees += 1

    product *= trees

  $product

when isMainModule:
  echo "### DAY 02 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let
    tmp = input.splitLines
    h = tmp.len
    map = tmp.join("")
    w = map.len div h
    treeMap = TreeMap(map: map, h: h, w: w)

  benchmark:
    echo(fmt"P1: {part_one(treeMap)}")
    echo(fmt"P2: {part_two(treeMap)}")
