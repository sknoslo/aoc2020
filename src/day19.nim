import
  strformat,
  strutils,
  tables,
  npeg,
  regex,
  aoc2020pkg/bench

type
  RuleKind = enum
    Terminal,
    Link
  Rule = object
    case kind: RuleKind
    of Terminal:
      term: string
    of Link:
      links: seq[string]
  RuleSet = Table[string, seq[Rule]]

proc expand(ruleset: RuleSet, link: string): string

proc expand(rule: Rule, rules: RuleSet): string =
  if rule.kind == Terminal:
    return rule.term
  result = ""
  for link in rule.links:
    result.add(rules.expand(link))

proc expand(ruleset: RuleSet, link: string): string =
  let rules = ruleset[link]
  if rules.len == 1:
    return rules[0].expand(ruleset)
  result = "("
  for i, rule in rules:
    if i > 0:
      result.add("|")
    result.add(rule.expand(ruleset))
  result.add(")")

proc partOne(messages: seq[string], ruleset: RuleSet): string =
  var matches = 0
  let regex = re(ruleset.expand("0"))
  for message in messages:
    if message.match(regex):
      matches.inc
  $matches

proc expand2(ruleset: RuleSet, link: string): string

proc expand2(rule: Rule, rules: RuleSet): string =
  if rule.kind == Terminal:
    return rule.term
  result = ""
  for link in rule.links:
    if link == "8":
      # 8: 42 | 42 8 is the same as (42)+
      result.add("(")
      result.add(rules.expand2("42"))
      result.add(")+")
    elif link == "11":
      # 11: 42 31 | 42 11 31 is the same as 42{n}31{n}, which is not possible... but for some depth,
      # can be estimated as 42(42(..)?31)?31
      # big oof.
      let hopefullydeepenough = 4
      result.add("(")
      let fortytwo = rules.expand2("42")
      result.add(fortytwo)
      for _ in 0..hopefullydeepenough:
        result.add("(")
        result.add(fortytwo)
      let thirtyone = rules.expand2("31")
      for _ in 0..hopefullydeepenough:
        result.add(thirtyone)
        result.add(")?")
      result.add(thirtyone)
      result.add(")")
    else:
      result.add(rules.expand2(link))

proc expand2(ruleset: RuleSet, link: string): string =
  let rules = ruleset[link]
  if rules.len == 1:
    return rules[0].expand2(ruleset)
  result = "("
  for i, rule in rules:
    if i > 0:
      result.add("|")
    result.add(rule.expand2(ruleset))
  result.add(")")


proc partTwo(messages: seq[string], ruleset: RuleSet): string =
  var matches = 0
  echo ruleset.expand2("0")
  let regex = re(ruleset.expand2("0"))
  for message in messages:
    if message.match(regex):
      matches.inc
  $matches

when isMainModule:
  echo "### DAY 01 ###"

  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  # do parsing here
  let
    parts = input.split("\p\p")
    messages = parts[1].splitLines

  var
    curr: string
    rules: RuleSet

  let parser = peg "rules":
    rules <- rule * *("\p" * rule) * !1
    rule <- key * ": " * patterns
    key <- >+Digit:
      curr = $1
      rules[curr] = @[]
    patterns <- pattern * *(" | " * pattern)
    pattern <- link | terminal
    link <- >(+Digit * *(' ' * +Digit)):
      let links = splitWhitespace($1)
      rules[curr].add(Rule(kind: Link, links: links))
    terminal <- "\"" * >Alpha * "\"":
      rules[curr].add(Rule(kind: Terminal, term: $1))

  doAssert parser.match(parts[0]).ok

  benchmark:
    echo(fmt"P1: {partOne(messages, rules)}")
    echo(fmt"P2: {partTwo(messages, rules)}")
