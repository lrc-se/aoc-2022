internal class Puzzle : AocPuzzle<int[], int>
{
    protected override int[] ParseInput(string[] lines) => lines.Select(int.Parse).ToArray();

    protected override int RunPartOne() => Input.Sum();

    protected override int RunPartTwo() => Input.Aggregate((prev, cur) => prev * cur);
}
