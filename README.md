# LMC emulator

This is an assembler and emulator for the Little Man Computer (LMC) model.
You can read more about the LMC on the [LMC Wikipedia page](https://en.wikipedia.org/wiki/Little_man_computer).

TL;DR: it is an as-simple-as-possible example for a von Neumann architecture using decimal numbers.

## Emulator details

### Architecture

The emulator aims to fully implement the LMC architecture.
It features:

- 100 **memory cells** numbered 0 through 99 that can each store numbers between 0 and 999 (inclusive).
- A register called **instruction pointer** that can store numbers between 0 and 99 (inclusive).
It is used to mark the next instruction.
- A register called **accumulator** that can store numbers between 0 and 999 (inclusive).
It is used for most calculations.
- A register called **carry flag** that can store either 0 or 1.
An 1 means that the result of the last arithmetic operation had an overflow or underflow.
- An **input stack** and an **output stack** of numbers between 0 and 999 (inclusive).

### Supported instructions

The formatting of the bullet points is **Opcode - mnemonic**.
`x` in the opcode represents a variable place and the mnemonics are the ones that the assembler accepts.

- **1xx - ADD** Add the value at position `xx` to the accumulator.
If the result is bigger than 999, it will be replaced by the original value mod 1000.
If the result is smaller than 999, the carry flag will be set to 1, else to 0.
- **2xx - SUB** Subtract the value at position `xx` from the accumulator.
If the result is smaller than 0, it will be replaced by the original value mod 1000.
If the result is smaller than 0, the carry flag will be set to 1, else to 0.
- **3xx - STA** Store the value of the accumulator at position `xx`.
- **5xx - LDA** Load the value at position `xx` to the accumulator.
- **6xx - BRA** Set the instruction pointer to `xx`.
- **7xx - BRZ** If the accumulator equals zero, set the instruction pointer to `xx`. *The carry flag is not taken into account.*
- **8xx - BRP** If the carry flag is set to 1, set the instruction pointer to `xx`.
- **901 - INP** Pop an input from the input stack and load it into the accumulator. Halt execution if the input stack is empty.
- **902 - OUT** Push the value from the accumulator to the output stack.
- **000 - COB** Halt execution.

## Assembler details

### Constraints

In order to make my life simple writing the assembler, it comes with the following constraints:

- Instructions are always in uppercase (ADD, STA, INP, etc.).
- Labels are always in lowercase (loop, start, outputhere).
- Comments start with a semicolon (;) and end at a newline character or the end of the file.

### Example program

This program takes two inputs and puts their difference in the outbox.
It is a slighty modified version of an example on the wikipedia page.

```
  ; store an input at position first
  INP
  STA first
  ; store an input at position second
  INP
  STA second
  ; load the first value
  LDA first
  ; subtract the second
  SUB second
  ; output the difference and halt execution
  OUT
  COB
first
  DAT
second
  DAT
```

Labels and comments can be at any position in a line, the formatting is just personal preference.
