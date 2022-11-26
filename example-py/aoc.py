import os
from puzzle import parse_input, run_part_one, run_part_two


with open(("input-test" if os.getenv("mode") == "test" else "input") + ".txt") as f:
    input = parse_input(f.readlines())

match os.getenv("part"):
  case "part1" | "" | None:
    result = run_part_one(input)
  case "part2":
    result = run_part_two(input)
  case _:
    result = None

print(f"Result: {result}" if result is not None else "Unknown part")
