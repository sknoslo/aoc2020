import
  strformat,
  strutils,
  tables,
  npeg,
  aoc2020pkg/bench

type
  Kind = enum
    Mask,
    Write
  Inst = ref object
    case kind: Kind
    of Mask:
      bits: string
    of Write:
      loc, val: int

proc `$`(i: Inst): string =
  case i.kind
  of Mask:
    fmt"mask = {i.bits}"
  of Write:
    fmt"mem[{i.loc}] = {i.val}"

proc newMask(bits: string): Inst =
  Inst(kind: Mask, bits: bits)

proc newWrite(loc, val: int): Inst =
  Inst(kind: Write, loc: loc, val: val)

proc partOne(input: seq[Inst]): string =
  var
    mask = ""
    mem: Table[int, int]
  for i in input:
    case i.kind
    of Mask:
      mask = i.bits
    of Write:
      var v = i.val
      for o, c in mask:
        let bit = 35 - o
        case c
        of '1':
          v = v or (1 shl bit)
        of '0':
          v = v and not(1 shl bit)
        else: discard
      mem[i.loc] = v
  var sum = 0
  for v in mem.values:
    sum += v
  $sum

proc splitTheUniverse(mask: string, loc, val, bit: int, mem: var Table[int, int]) =
  if bit < 0:
    mem[loc] = val
    return
  case mask[35 - bit]
  of '0':
    splitTheUniverse(mask, loc, val, bit - 1, mem)
  of '1':
    let l = loc or (1 shl bit)
    splitTheUniverse(mask, l, val, bit - 1, mem)
  of 'X':
    let
      l1 = loc or (1 shl bit)
      l2 = loc and not (1 shl bit)
    splitTheUniverse(mask, l1, val, bit - 1, mem)
    splitTheUniverse(mask, l2, val, bit - 1, mem)
  else: discard

proc partTwo(input: seq[Inst]): string =
  var
    mask = ""
    mem: Table[int, int]
  for i in input:
    case i.kind
    of Mask:
      mask = i.bits
    of Write:
      splitTheUniverse(mask, i.loc, i.val, 35, mem)
  var sum = 0
  for v in mem.values:
    sum += v
  $sum

when isMainModule:
  echo "### DAY 14 ###"

  let input = stdin.readAll

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  var inst: seq[Inst]

  let parser = peg "insts":
    insts <- *inst * ?"\p" * !1
    inst <- (mem | mask) * "\p"
    mask <- "mask = " * >+{'X', '1', '0'}:
      inst.add(newMask($1))
    mem <- "mem[" * >+Digit * "] = " * >+Digit:
      inst.add(newWrite(parseInt($1), parseInt($2)))

  discard parser.match(input)

  benchmark:
    echo(fmt"P1: {partOne(inst)}")
    echo(fmt"P2: {partTwo(inst)}")
