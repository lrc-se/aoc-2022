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

While this was supposed to be a learning experience, I've largely refrained from going back to improve previous days afterwards when I've learnt something new, so the quality (or at least idiomacy) of the succession of solutions could be viewed as a record of my progress. Or something.

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

Rewrote this several times to get sensible run times. It could probably be improved further still, but my latest scan line approach keeps part 2 under 2 seconds, which feels good enough. I also had to make some adjustments to the base code in order to handle the test cases correctly this time around.
*__Update:__ Came up with a way to reduce the search space in part 2, which knocked two thirds off the execution time.*

### Day 16 (Nim)

This was a tough one. After a while I took to POC-ing in JS, and eventually came upon a solution based on precomputing optimal paths between working valves.
For part 2 I had a good number of false starts before realizing that I could frame the problem as a linear combination of partial solutions to part 1.
Then I "just" had to translate back to Nim, which took some doing, but the end result is rather fast.

### Day 17 (Nim)

Sets, ordinals and stateful custom objects to the rescue, employing custom hashes to find the cycle in part 2.

### Day 18 (Nim)

Using a generic flood fill algorithm for part 2, with conservative limits. It's not the fastest, but it does the job.

### Day 19 (Nim)

The toughest of the bunch, this had me racking my brain for ways to limit the growth of possible combinations generated by each successive minute, using breadth-first traversal like for day 24 (which I solved first). It's not the prettiest, nor the fastest, but it does finish in a reasonable span of time and – most importantly – provides the correct answers for both parts. As this was the final hurdle to attain all stars this year, I'll take it.

### Day 20 (Nim)

Nim's built-in doubly-linked ring data structure came in very handy here, together with some more periodic thinking.

### Day 21 (Nim)

Good fit for Nim's object variants and case syntax.

### Day 22 (Nim)

Playing around with more object variants and cases, as well as enums and rotations. The algorithm for determining face rotations in part 2 is surely on the cumbersome side, but it does work and is also rather fast, so I'll leave it.

### Day 23 (Nim)

Hash tables and hash sets all the way.
*__Update:__ Employed an iterator to keep internal track of the offset instead.*

### Day 24 (Nim)

Another stateful object made this rather an efficient affair (after a very inefficient, but working, first attempt), using breadth-first traversal of possible moves.

### Day 25 (F#)

Finally back to F#, pattern matching and recursion. Also, longs.


Conclusion
----------

So, how did it go? Let's break it down:

### F#

Coming from the .NET world as I did, the choice of F# for a first serious foray into the functional realm was pretty much a given. That said, if one keeps to the functional side of the language/platform most things are markedly different, so in most respects it was a fresh experience.

#### Functionality

Thinking in a purely functional way is a sharp departure from how the majority of us write the majority of our code. Many languages provide access to functional tools and concepts to varying degrees – some much more than others – so it's not like it's entirely alien, but to make the switch *in full* is another beast.

Some things fit very well with the functional model – many of which are, as it happens, frequent constituents of AoC puzzles. Function composition, partial application, pattern matching, algebraic data types, recursion and pipelines are very handy and often result in quite readable first-and-then-and-then-or-else kind of code – once you get a hang of the syntax. I've especially liked the power of the `match` expression, which simplifies many a test that would otherwise span multiple lines and conditions, and there's a certain aesthetic quality to a logical succession of pipes that eventually yields the desired result.

Other things fit more badly, and some are outright... well, not *impossible*, but highly questionable in a functional formulation for a multitude of reasons. Especially things like iterating over collections while continuously both updating and querying some sort of index or cache is rather cumbersome in a functional setting, but quite common and highly performant in a more imperative one – and that type of thing *also* happens to be a frequent constituent of AoC puzzles.

In summary, I've quite enjoyed molding my mind in a more functional direction – something which, to be sure, was already underway due to those aforementioned representations in other languages – and I'm now more in tune with other ways of doing things, especially in the context of F#. The language as such I've found to be expressive and terse, and the heavy reliance on/support for type inference is quite nice, saving a lot of explicit generic annotations. Good show!

#### Performance

On the other hand, my F# solutions have consistently placed themselves near the bottom of the performance charts. While some of this may be due to startup time in the CLR, and some due to my inexperience resulting in suboptimal implementations, there's no escaping the fact that a fully functional approach with pure functions and immutable values will always be slower than a mutable counterpart, even with the aid of persistent data structures under the hood. Here one simply has to decide whether the performance penalty is large enough to call the whole choice of paradigm into question or not.

### Nim

By and large I've really liked Nim, which on the surface feels like a mix between Python and TypeScript, with a bit of F# thrown in – *and* with the performance of C. Here follow some specific observations:

#### Mutable vs. immutable

Nim offers lexical declaration of mutability, and all function arguments and iteration variables are immutable by default unless explicitly marked otherwise.
Immutability is also enforced in full: given the assignment `let foo = @[1, 2, 3]`, subsequent calls like `foo.add(4)` or `foo[0] = 5` will raise a compiler error since Nim guards against mutations of the whole underlying data structure, and not just the variable handle itself. This is in contrast to, for example, JavaScript, where after `const foo = [1, 2, 3];`, `foo.push(4);` and `foo[0] = 5;` will work just fine since the `const` keyword there only means that the `foo` variable cannot be reassigned, while the array reached through it remains fully mutable. This takes some getting used to, but I think it's a much better model.

#### Values vs. references

In Nim, most things follow value semantics by default. This includes data structures that in other languages would be reference types, such as objects and hashmaps.
This comes in rather handy for many AoC applications, which often involve testing many variations of a base setup, which in turn involves a lot of copying of data – and by using value types, this heavy lifting is performed automatically by Nim. Another advantage is automatic equality and hash checks, simplifying the handling of things like coordinates and arbitrarily large grids, to take another common AoC example.

The drawback is that it's easy to forget that you're *not* dealing with a reference when you actually want one – or think that you *have* one, out of habit – which can have a drastic impact on performance when the underlying data structure is large. There are also several instances of central behavior or functionality that just work with value types but have no provided default implementation for the corresponding reference types, such as hashing or the `$` operator for debug logging.

#### Performance

Nim's objective is to be as fast as C (which it achieves by actually *being* C, as an intermediate step), and from what I've seen this is largely met. While there is some variance due to the choice of algorithm, not to mention the actual implementation thereof, my Nim solutions have consistently been on par with languages such as C/C++ or Rust, and the release mode is considerably faster than the debug mode (which is often fast enough for development). No complaints here.

#### Other stuff

Things I haven't delved too deeply into, or decided upon a strategy for, but which have piqued my interest:

- __Uniform function call syntax__  
  This is, pretty much, .NET's extension methods taken to the concept's full, well, extent, but without the connection to classes or interfaces.
  I like the idea, which is also quite similar to Python's take on OOP – again minus the actual classes – but leans more heavily towards pure functions.
  I haven't quite settled on a convention as to when to use which style, but I've found that mimicking object methods and fields where it feels appropriate enhances readability, especially when coming from an object-based (which does not necessarily equal *class*-based) language.

- __Implicit result variable__  
  This seemed quaint to me at first, but after a very short time I grew quite fond of it as it saves a fair bit of typing. Still haven't decided quite when to use last-expression returns or explicit return statements instead, though.

- __New types of types__  
  Ordinal types and named tuples I've found to be very, very useful. Nim also has the concept of distinct types, which could be seen as lightweight value objects where the compiler will enforce constraints placed on otherwise overly broad types; there are a good number of built-in examples, such as `Natural` which is equal to the set of all non-negative `int`s, or `Positive` which also removes zero as a valid value. Object variants are also a nice feature with some clear use cases, which together with support for type classes and sum types bring the language closer to F# and other functionals.

- __Side effect tracking__  
  This was also something new to take into consideration, but like the mutability thing it's for the better. So far I've found it best to start with `func`s all the way and only change to `proc`s if it's truly necessary – which has been very seldom.

- __Templates and macros__  
  These are obviously very powerful and much of the standard library is built on them. Don't like how the language does something? Rewrite it! The drawback is that they can lead to a good deal of implicit magic which makes reasoning about the code from a lexical standpoint harder.

#### Negatives

- __IDE integration__  
  This is what I've found most lacking. I've been using VSCode and the official Nim extension, but the experience has been bumpy. For one thing one has to save the file before getting any feedback, such as syntax or type errors or code completion, which slows down rapid development. For another, code completion is sketchy at best, with many things (such as properties, function arguments, UFCS-methods etc.) that simply *work* with other languages working only partially, delayed, or not at all here. Room for improvement, to say the least.

- __Compiler errors__  
  These are often hard to read and decipher to get at the actual underlying problem, and, most importantly, what one should do to fix it. More room for improvement.

### All in all

Alrighty then. F# is clearly a mature language, being backed by a large corporate entity and a very popular and powerful framework to boot, and from what I've seen it holds the functional torch high without undue ceremony. Nim, while being rather impressive in and of itself, doesn't feel *quite* production ready yet in a broad sense – but it's very close, and I've very much enjoyed discovering all the things it does differently and the reasons behind them. Something to keep an eye on, for sure.

I think the main takeaway is, once again, that one should choose the right tool for the right job – if that isn't a law of software engineering, it should be. In this context it extends to the choice of paradigm based on what you're trying to solve at the moment – and here I will reiterate my appreciation for multi-paradigm languages which allow such choices to be made repeatedly within the same application, or in some cases even the same *function*. Some things are much more readable, accessible and maintainable in a functional formulation, or an object-oriented one, while others are much less so, so having the ability to switch back and forth can be very rewarding – especially when there are performance metrics to consider as well.

Languages such as JavaScript and Python – and, in latter years, C# – are often lauded for their functional parts, but there it is often a matter of using existing language constructs to express functional concepts rather than those concepts being a core part of the language itself like in F#. For example, implementing currying in JS is very easy, but in F# it's simply the default mode of function calling – no extra code required. Looking from the opposite perspective, while F# is primarily functional it is not *exclusively* so, meaning that it also offers mutable data types, control flow statements et cetera, so a mix is quite possible from that direction as well. And, of course, Nim's templates and macros could well be used to further enhance whatever aspect of the language one finds lacking given the problem at hand, functional or otherwise.

The key notion here is whether a language offers enough freedom to cover all approaches mandated – or hinted at – by the needs of the application under development, while at the same time upholding enough safeguards and restrictions to prevent as many footguns as possible. And I don't think the optimal balance has been found just yet, but we're getting closer.

In any case, it's certainly been a joy learning a whole boatload of new stuff, large and small. See you next year!
