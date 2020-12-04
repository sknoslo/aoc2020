import
  strformat,
  strutils,
  sequtils,
  tables,
  aoc2020pkg/bench

type
  Passport = Table[string, string]

proc simpleValid(p: Passport): bool =
  ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"].all(proc (key: string): bool =
    p.hasKey(key)
  )

proc partOne(input: seq[Passport]): string =
  $input.filter(simpleValid).len

proc partTwo(input: seq[Passport]): string =
  "INCOMPLETE"

when isMainModule:
  echo "### DAY 04 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let passports = input.split("\n\n").map(proc (s: string): Passport =
    var passport: Passport

    for pairs in s.splitWhitespace():
      let parts = pairs.split(':')
      passport[parts[0]] = parts[1]

    passport
  )

  benchmark:
    echo(fmt"P1: {partOne(passports)}")
    echo(fmt"P2: {partTwo(passports)}")
