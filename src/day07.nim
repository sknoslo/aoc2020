import
  strformat,
  strutils,
  sequtils,
  parseutils,
  sets,
  tables,
  aoc2020pkg/bench

type
  InnerBag = tuple[q: int, c: string] # maybe?
  Regulations = Table[string, seq[InnerBag]]

# why write regex when you can write bad parsers?
proc parseRegs(s: string): Regulations =
  var pos = 0
  while pos < s.len:
    var
      bagColor: string
      contents: seq[InnerBag]
    pos += parseUntil(s, bagColor, " bags", pos)
    pos += skip(s, " bags contain ", pos)
    if s[pos] in Digits:
      while true:
        let
          numEnd = skipWhile(s, Digits, pos)
        let
          q = parseInt(s[pos..pos+numEnd-1])

        pos += numEnd + 1
        var iBagColor: string
        pos += parseUntil(s, iBagColor, " bag", pos)
        contents.add((q, iBagColor))
        pos += skipUntil(s, {',', '.'}, pos)
        if s[pos] == '.':
          break
        pos += skip(s, ", ", pos)

    result[bagColor] = contents
    pos += skipUntil(s, '.', pos) + 1
    pos += skipWhitespace(s, pos)

proc partOne(input: Regulations): string =
  var inverted: Table[string, seq[string]]
  for k in input.keys:
    for inner in input[k]:
      if not inverted.hasKey(inner.c):
        inverted[inner.c] = @[]
      inverted[inner.c].add(k)

  var toVisit: seq[string]
  for v in inverted["shiny gold"]:
    toVisit.add(v)

  var visited: HashSet[string]
  while toVisit.len != 0:
    let k = toVisit.pop
    if visited.contains(k):
      continue
    visited.incl(k)
    if not inverted.contains(k):
      continue
    for v in inverted[k]:
      toVisit.add(v)

  $visited.len

proc partTwo(input: Regulations): string =
  var
    count = 0
    toVisit = @[("shiny gold", 1)]

  while toVisit.len != 0:
    let (k, c) = toVisit.pop
    for inner in input[k]:
      count += c * inner.q
      toVisit.add((inner.c, c * inner.q))
  $count

when isMainModule:
  echo "### DAY 01 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let regs = parseRegs(input)

  benchmark:
    echo(fmt"P1: {partOne(regs)}")
    echo(fmt"P2: {partTwo(regs)}")
