# LMC emulator

This is an assembler and emulator for the Little Man Computer (LMC) model.
You can read more about the LMC on the [LMC Wikipedia page](https://en.wikipedia.org/wiki/Little_man_computer).

TL;DR: it is an as-simple-as-possible example for a von Neumann architecture using decimal numbers.

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
