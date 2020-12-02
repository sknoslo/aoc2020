import
  strformat,
  strutils,
  sequtils,
  aoc2020pkg/bench

type
  Requirement = object
    min, max: int
    c: char
  PasswordReq = tuple[r: Requirement, p: string]

proc part_one(input: openArray[PasswordReq]): string =
  var valid = 0

  for req in input:
    if req.p.count(req.r.c) in req.r.min..req.r.max:
      valid.inc

  $valid

proc part_two(input: openArray[PasswordReq]): string =
  var valid = 0

  for req in input:
    let
      p1 = req.p[req.r.min - 1] == req.r.c
      p2 = req.p[req.r.max - 1] == req.r.c

    if p1 xor p2:
      valid.inc

  $valid

proc parseReq(s: string): Requirement =
  let parts = s.split(" ")
  result.c = parts[1][0]
  let range = parts[0].split("-").map(parseInt)
  result.min = range[0]
  result.max = range[1]

when isMainModule:
  echo "### DAY 02 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let reqs = input.splitLines(false).map(proc (line: string): PasswordReq =
    let parts = line.split(": ")
    (parseReq(parts[0]), parts[1])
  )

  benchmark:
    echo(fmt"P1: {part_one(reqs)}")
    echo(fmt"P2: {part_two(reqs)}")
