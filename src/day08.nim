import
  strformat,
  strutils,
  sequtils,
  sets,
  aoc2020pkg/bench,
  aoc2020pkg/handheld_v1

# type
#   Instruction = tuple[op: string, arg: int]

proc getInst(s: string): Instruction =
  let parts = s.split(' ')
  (parts[0], parts[1].parseInt)

proc partOne(input: seq[Instruction]): string =
  var
    seen: HashSet[int]
    ip = 0
    acc = 0

  while true:
    if seen.containsOrIncl(ip):
      break
    let inst = input[ip]
    var offset = 1
    case inst.op
    of "acc": acc += inst.arg
    of "jmp": offset = inst.arg
    of "nop": discard
    else: raise newException(Defect, "bad code is bad")
    ip += offset

  $acc

proc getNext(input: seq[Instruction], ip: int, next: var seq[Instruction]): bool =
  let inst = input[ip]
  if inst.op == "acc":
    return false
  next = input
  let flipped = if inst.op == "jmp": "nop" else: "jmp"
  next[ip].op = flipped
  true

proc partTwo(orig: seq[Instruction]): string =
  for nextToFlip in 0..<orig.len:
    var
      seen: HashSet[int]
      ip = 0
      acc = 0
      input: seq[Instruction]
    if not getNext(orig, nextToFlip, input):
      continue

    while true:
      if ip >= input.len:
        return $acc
      if seen.containsOrIncl(ip):
        break
      let inst = input[ip]
      var offset = 1
      case inst.op
      of "acc": acc += inst.arg
      of "jmp": offset = inst.arg
      of "nop": discard
      else: raise newException(Defect, "bad code is bad")
      ip += offset
  "no answer"

when isMainModule:
  echo "### DAY 08 ###"

  let input = stdin.readAll

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  # let program = input.splitLines.map(getInst)
  let program = parseProgram(input)

  benchmark:
    echo(fmt"P1: {partOne(program)}")
    echo(fmt"P2: {partTwo(program)}")
