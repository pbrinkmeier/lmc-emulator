# LMC emulator

This is an assembler and emulator for the Little Man Computer (LMC) model.
You can read more about the LMC on the [LMC Wikipedia page](https://en.wikipedia.org/wiki/Little_man_computer).

TL;DR: it is an as-simple-as-possible example for a von Neumann architecture using decimal numbers.

## Assembler details

In order to make my life simple writing the assembler, it comes with the following constraints:

- Instructions are always in uppercase (ADD, STA, INP, etc.).
- Labels are always in lowercase (loop, start, outputhere).
- Comments start with a semicolon (;) and end at a newline character or the end of the file.
