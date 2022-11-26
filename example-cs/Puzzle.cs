internal class Puzzle : AocPuzzle<int, int>
{
    protected override int[] ParseInput(string[] lines) => lines.Select(int.Parse).ToArray();

    protected override int RunPartOne() => _input.Sum();

    protected override int RunPartTwo() => _input.Aggregate((prev, cur) => prev * cur);
}
