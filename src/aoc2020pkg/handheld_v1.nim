import
  strutils,
  npeg

# Types and a parser for the day08 iteration of the handheld gaming device.

type
  Instruction* = tuple[op: string, arg: int]
  Program* = seq[Instruction]

const parser = peg("instructions", data: Program):
  instructions <- *instruction * !1
  instruction <- >op * ' ' * >arg * "\p":
    data.add(($1, parseInt($2)))
  op <- "nop"|"jmp"|"acc"
  arg <- {'-','+'} * +Digit

# REQUIRES A NEW LINE AT EOF, DON'T STRIP IT!!!
proc parseProgram*(input: string): Program =
  var program: Program

  echo parser.match(input, program)
  program
