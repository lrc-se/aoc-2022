export function parseInput(lines) {
  return lines.map(line => parseInt(line));
}

export function runPartOne(input) {
  return input.reduce((prev, cur) => prev + cur);
}

export function runPartTwo(input) {
  return input.reduce((prev, cur) => prev * cur);
}
