internal abstract class AocPuzzle<TInput, TResult> where TResult : struct
{
    public void Run()
    {
        Func<TResult>? runPuzzle = Environment.GetEnvironmentVariable("part") switch
        {
            "part1" or "" or null => RunPartOne,
            "part2" => RunPartTwo,
            _ => null
        };

        if (runPuzzle is not null)
        {
            string filename = $"{(Environment.GetEnvironmentVariable("mode") == "test" ? "input-test" : "input")}.txt";
            _input = ParseInput(File.ReadAllLines(filename));
            Console.WriteLine($"Result: {runPuzzle()}");
        }
        else
        {
            Console.WriteLine("Unknown part");
        }
    }

    protected abstract TInput[] ParseInput(string[] lines);
    protected abstract TResult RunPartOne();
    protected abstract TResult RunPartTwo();

    protected TInput[] _input = Array.Empty<TInput>();
}
