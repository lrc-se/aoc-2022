Advent of Code 2022
===================

Solutions for the 2022 edition of the [Cygnified Advent of Code](https://aoc-2022.cygni.se/).

This year's goal will be to learn two new languages which I have been curious about for some time, namely
[Nim](https://nim-lang.org/) and [F#](https://fsharp.org/). Both offer marked differences compared to what and how I normally code,
so here's hoping it will prove enlightening in a "broaden your horizons" kind of way.

Bases for a few previously known languages have been prepared as well (see below), just in case.


Examples
--------

This repo includes examples for Nim, F#, C#, JavaScript and Python, which include variations on the same basic setup with no external dependencies. The idea is to reuse common infrastructure code between solutions, only modifying functions in the puzzle file (and adding more files when necessary). Compared to [last year](https://github.com/lrc-se/aoc-2021), the common code has been simplified and some things moved to run scripts (see below).

The following environment variables are recognized:

#### `part`

- `part1`: only runs part one
- `part2`: only runs part two

An empty value will run part one, and any other value will abort the execution.

#### `mode`

- `test`: reads input from *input-test.txt*

Any other value, including an empty one, will use *input.txt*.

### Run script

All examples also include a shell script *run.sh*, which will time the execution of the solution. It has the following syntax:

`run.sh [part] [mode]`

- `part`: which part to run (sets the `part` environment variable accordingly)
- `mode`:
  - `test`: sets the `mode` environment variable to `test`
  - `rel`: builds the solution in release mode (where applicable)
  - `test-rel`: combines `test` and `rel`

If both arguments are omitted, the puzzle will be run in normal mode without release optimizations.
Note that the JavaScript and Python versions have no build step and so do not recognize the `rel` and `test-rel` modes.


Exercises
---------

There are also some re-implementations of puzzles from previous years, to get the hang of it before this year's event starts:

### 2020: Day 4 (F#)

Good match for pattern matching. Trying to maintain the functional approach as much as possible, with an alternative implementation using a discriminated union to enforce exhaustive matching at the price of longer code.

### 2021: Day 14 (Nim)

The `CountTable` type is very convenient for a common class of AoC problems. Nim does seem to enable quite compact code, but switching between value and reference semantics takes some getting used to.

Puzzles
-------

### Day 1 (F#)

Still getting used to F# syntax, but otherwise a nice functional start.

### Day 2 (Nim)

Rewrote solution after part 2 for better typing, apart from which the previously alluded-to compactness continues to apply.

### Day 3 (Nim)

Good problem for Nim's native set operations.

### Day 4 (F#)

Trying out F#'s sets for comparison, plus lambdas for terseness.

### Day 5 (Nim)

Sequences and backward indices all the way. The solution is (I hope) general and should handle any (valid) input.
I also discovered and fixed a defect in the base code having to do with reading the input file.

### Day 6 (Nim)

Back to bit sets again. They're fast.

### Day 7 (F#)

Wanted to use F# for better pattern matching, but came up against the functional wall. The current solution is therefore half-imperative and half-mutable and takes a number of shortcuts when traversing the input, only considering lines that actually matter, but at least it's pretty fast...
*__Update:__ Partially rewrote the solution to calculate total sizes recursively afterwards instead of during parsing, so it's at least a bit more functional now, and performance is equivalent. Input traversal is still handled linearly in a mutable fashion, though.*

### Day 8 (Nim)

Mmm, loops.

### Day 9 (Nim)

Still getting tripped up by Nim's mutability handling, but it turned out pretty well.

### Day 10 (F#)

This time it's fully functional, as it were.

### Day 11 (Nim)

Using OO-style Nim, with modulo arithmetic for part 2. Input parsing again takes a number of shortcuts, relying on consistent entry format.

### Day 12 (Nim)

Repurposed and simplified my JS cost-distance solution to [day 15 from 2021](https://github.com/lrc-se/aoc-2021/tree/main/day15), using coordinate tuple indexing.

### Day 13 (F#)

Well this was really something. Had to wrap my head around linear parsing in a functional setting, but it turned out rather well in the end with a good deal of pattern matching, and the actual comparing step could be delegated to a library function. There's a small shortcut in the tokenizer, but otherwise the solution is, again, "fully functional".

### Day 14 (Nim)

Today was mostly about getting the halting conditions right. Run times in debug mode are also starting to creep upwards for part 2, but release mode is still very performant.

### Day 15 (Nim)

Rewrote this several times to get sensible run times. It could probably be improved further still, but my latest scan line approach keeps part 2 under 2 seconds, which feels good enough.
