import
  strformat,
  strutils,
  tables,
  algorithm,
  npeg,
  intsets,
  aoc2020pkg/bench

type
  Rule = tuple[label: string, ranges: seq[tuple[b, e: int]]]
  Ticket = seq[int]

proc partOne(rules: seq[Rule], nearby: seq[Ticket]): string =
  var invalid = 0
  for t in nearby:
    for v in t:
      var valid = false
      for r in rules:
        for rng in r.ranges:
          if v in rng.b..rng.e:
            valid = true
      if not valid:
        invalid += v
  $invalid

proc partTwo(rules: seq[Rule], mine: Ticket, nearby: seq[Ticket]): string =
  var validTickets: seq[Ticket]
  for t in nearby:
    var ticketValid = true
    for v in t:
      var valid = false
      for r in rules:
        for rng in r.ranges:
          if v in rng.b..rng.e:
            valid = true
      if not valid:
        ticketValid = false
    if ticketValid:
      validTickets.add(t)

  var rulePositions: seq[tuple[k: string, v: IntSet]]
  for r in rules:
    var rulePos = (k: r.label, v: initIntSet())
    for p in 0..<mine.len:
      var allValid = true
      for t in validTickets:
        let v = t[p]
        var valid = false
        for rng in r.ranges:
          if v in rng.b..rng.e:
            valid = true
        if not valid:
          allValid = false
      if allValid:
        rulePos.v.incl(p)
    rulePositions.add(rulePos)
  var
    sRules = rulePositions.sortedByIt(it.v.len)
    seen: IntSet
    total = 1
  for pos in sRules:
    var v = pos.v
    v.excl(seen)
    if v.len > 1:
      echo "f"
    seen.incl(v)
    if pos.k.startsWith("departure "):
      for x in v:
        total *= mine[x]
  $total

when isMainModule:
  echo "### DAY 16 ###"

  let input = stdin.readAll

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  var
    rules: seq[Rule]
    myTicket: Ticket
    nearby: seq[Ticket]
    tmp: Ticket

  let parser = peg "notes":
    notes <- rules * "\p" * mine * "\p" * others * "\p" * !1
    rules <- +rule
    rule <- >label * ": " * range * " or " * range * "\p":
      rules.add(($1, @[(parseInt($2), parseInt($3)), (parseInt($4), parseInt($5))]))
    label <- +(Alpha | ' ')
    range <- >+Digit * "-" * >+Digit
    mine <- "your ticket:\p" * mticket
    others <- "nearby tickets:\p" * tickets
    tickets <- +oticket
    mticket <- ticket:
      myTicket = tmp
      tmp = @[]
    oticket <- ticket:
      nearby.add(tmp)
      tmp = @[]
    ticket <- value * *("," * value) * "\p"
    value <- >+Digit:
      tmp.add(parseInt($1))
  
  discard parser.match(input)

  benchmark:
    echo(fmt"P1: {partOne(rules, nearby)}")
    echo(fmt"P2: {partTwo(rules, myTicket, nearby)}")
