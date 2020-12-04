import
  strformat,
  strutils,
  sequtils,
  tables,
  regex,
  aoc2020pkg/bench

type
  Passport = Table[string, string]
  Validation = tuple[key: string, pattern: Regex]

const validations: seq[Validation] =
  @[
    ("byr", re"^(19[2-9][0-9])|(200[0-2])$"),
    ("iyr", re"^(201[0-9])|2020$"),
    ("eyr", re"^(202[0-9])|2030$"),
    ("hgt", re"^((1[5-8][0-9]|19[0-3])cm)|((59|6[0-9]|7[0-6])in)$"),
    ("hcl", re"^#[0-9a-f]{6}$"),
    ("ecl", re"^(amb|blu|brn|gry|grn|hzl|oth)$"),
    ("pid", re"^[0-9]{9}$")
  ]

proc partOne(input: seq[Passport]): string =
  proc valid(p: Passport): bool =
    result = validations.all(proc (v: Validation): bool = p.hasKey(v.key))

  $input.filter(valid).len

proc partTwo(input: seq[Passport]): string =
  proc valid(p: Passport): bool =
    validations.all(proc (v: Validation): bool =
      p.hasKey(v.key) and p[v.key].match(v.pattern))

  $input.filter(valid).len

when isMainModule:
  echo "### DAY 04 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  let
    normalized = input.splitLines().join(" ").split("  ") # couldn't figure out how to split by blank lines in a cross-platform way 🙃
    passports = normalized.map(proc (s: string): Passport =
      var passport: Passport

      for pairs in s.split(" "):
        let parts = pairs.split(':')
        passport[parts[0]] = parts[1]

      passport
    )

  benchmark:
    echo(fmt"P1: {partOne(passports)}")
    echo(fmt"P2: {partTwo(passports)}")
