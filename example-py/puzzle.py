from functools import reduce
from operator import mul


def parse_input(lines: list[str]) -> list[int]:
  return [int(line) for line in lines]

def run_part_one(input: list[int]) -> int:
  return sum(input)

def run_part_two(input: list[int]) -> int:
  return reduce(mul, input)
