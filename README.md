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

There are also some re-implementations of puzzles from previous years, to get the hang of it before this year's event starts.


Puzzles
-------

TBA
