import
  strformat,
  strutils,
  deques,
  npeg,
  aoc2020pkg/bench

proc partOne(input: seq[seq[string]]): string =
  var total = 0
  for eq in input:
    var
      post: Deque[string]
      ops: seq[string]
    for token in eq:
      case token
      of "(": ops.add(token)
      of "+", "*":
        while ops.len > 0 and ops[^1] != "(":
          post.addLast(ops.pop)
        ops.add(token)
      of ")":
        while ops[^1] != "(":
          post.addLast(ops.pop)
        discard ops.pop
      else:
        post.addLast(token)
    while ops.len > 0:
      post.addLast(ops.pop)
    var
      vals: seq[int]
    while post.len > 0:
      let token = post.popFirst
      case token
      of "+":
        vals.add(vals.pop + vals.pop)
      of "*":
        vals.add(vals.pop * vals.pop)
      else:
        vals.add(token.parseInt)
    total += vals.pop
  $total

proc precLte(a, b: string): bool =
  a == "*" or a == b

proc partTwo(input: seq[seq[string]]): string =
  var total = 0
  for eq in input:
    var
      post: Deque[string]
      ops: seq[string]
    for token in eq:
      case token
      of "(": ops.add(token)
      of "+", "*":
        while ops.len > 0 and ops[^1] != "(" and precLte(token, ops[^1]):
          post.addLast(ops.pop)
        ops.add(token)
      of ")":
        while ops[^1] != "(":
          post.addLast(ops.pop)
        discard ops.pop
      else:
        post.addLast(token)
    while ops.len > 0:
      post.addLast(ops.pop)
    var
      vals: seq[int]
    while post.len > 0:
      let token = post.popFirst
      case token
      of "+":
        vals.add(vals.pop + vals.pop)
      of "*":
        vals.add(vals.pop * vals.pop)
      else:
        vals.add(token.parseInt)
    total += vals.pop
  $total

when isMainModule:
  echo "### DAY 18 ###"

  let input = stdin.readAll

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  var
    equations: seq[seq[string]]
    equation: seq[string]
  let parser = peg "eqs":
    eqs <- +eq * !1
    eq <- +(token * ?' ') * "\p":
      equations.add(equation)
      equation = @[]
    token <- >(num|op):
      equation.add($1)
    num <- +Digit
    op <- {'+','*','(',')'}

  discard parser.match(input)
  benchmark:
    echo(fmt"P1: {partOne(equations)}")
    echo(fmt"P2: {partTwo(equations)}")
