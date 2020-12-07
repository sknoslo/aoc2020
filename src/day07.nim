import
  strformat,
  strutils,
  parseutils,
  tables,
  aoc2020pkg/bench

type InnerBag = tuple[q: int, c: string] # maybe?

# why write regex when you can write bad parsers?
proc parseBags(s: string): Table[string, seq[InnerBag]] =
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

proc partOne(input: string): string =
  "INCOMPLETE"

proc partTwo(input: string): string =
  "INCOMPLETE"

when isMainModule:
  echo "### DAY 01 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  # do parsing here
  echo parseBags(input)

  benchmark:
    echo(fmt"P1: {partOne(input)}")
    echo(fmt"P2: {partTwo(input)}")
