import
  strformat,
  strutils,
  sequtils,
  sets,
  deques,
  npeg,
  aoc2020pkg/bench

proc partOne(me, crab: seq[int]): string =
  var
    me = me.toDeque
    crab = crab.toDeque
  while me.len > 0 and crab.len > 0:
    let
      mine = me.popFirst
      crabs = crab.popFirst
    if mine > crabs:
      me.addLast(mine)
      me.addLast(crabs)
    elif crabs > mine:
      crab.addLast(crabs)
      crab.addLast(mine)
    else:
      me.addLast(mine)
      crab.addLast(crabs)
  let winner = if me.len > crab.len: me else: crab
  var total = 0
  for i, card in winner:
    total += (winner.len - i) * card
  $total

proc playGame(me, crab: Deque[int]): tuple[iwin: bool, me, crab: Deque[int]] =
  var
    me = me
    crab = crab
    seen: HashSet[tuple[me, crab: seq[int]]]
  while me.len > 0 and crab.len > 0:
    if seen.containsOrIncl((me.toSeq, crab.toSeq)):
      return (true, me, crab)
    let
      mine = me.popFirst
      crabs = crab.popFirst
    if mine <= me.len and crabs <= crab.len:
      let (iwin, sm, sc) = playGame(me.toSeq[0..<mine].toDeque, crab.toSeq[0..<crabs].toDeque)
      if iwin:
        me.addLast(mine)
        me.addLast(crabs)
      else:
        crab.addLast(crabs)
        crab.addLast(mine)
    elif mine > crabs:
      me.addLast(mine)
      me.addLast(crabs)
    elif crabs > mine:
      crab.addLast(crabs)
      crab.addLast(mine)
    else:
      me.addLast(mine)
      crab.addLast(crabs)
  (me.len != 0, me, crab)

proc partTwo(me, crab: seq[int]): string =
  let (iwin, me, crab) = playGame(me.toDeque, crab.toDeque)
  let winner = if iwin: me else: crab
  var total = 0
  for i, card in winner:
    total += (winner.len - i) * card
  $total

when isMainModule:
  echo "### DAY 22 ###"

  let input = stdin.readAll

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  var tmp, p1, p2: seq[int]

  let parser = peg "decks":
    decks <- p1deck * "\p" * p2deck * !1
    p1deck <- "Player 1:\p" * cards:
      p1 = tmp
      tmp = @[]
    p2deck <- "Player 2:\p" * cards:
      p2 = tmp
    cards <- +(card * "\p")
    card <- >+Digit:
      tmp.add(parseInt($1))

  doAssert parser.match(input).ok

  benchmark:
    echo(fmt"P1: {partOne(p1, p2)}")
    echo(fmt"P2: {partTwo(p1, p2)}")
