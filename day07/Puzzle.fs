module Puzzle

type Directory =
    {
        Name: string
        mutable Size: int
        Parent: Directory option
    }

let private getMatchingSizes filter (directories: Directory list) =
    directories
    |> List.map (fun dir -> dir.Size)
    |> List.filter filter


let parseInput (lines: string[]) =
    let rootDir: Directory =
        {
            Name = "/"
            Size = 0
            Parent = None
        }

    let mutable dirs = [rootDir]
    let mutable curDir = rootDir
    for line in lines do
        match line.Split(' ') with
        | [| "$"; "cd"; dir |] ->
            match dir with
            | "/" -> curDir <- rootDir
            | ".." -> curDir <- curDir.Parent.Value
            | name ->
                let newDir: Directory =
                    {
                        Name = name
                        Size = 0
                        Parent = Some(curDir)
                    }

                curDir <- newDir
                dirs <- newDir :: dirs
        | [| "$"; "ls" |] | [| "dir"; _ |] -> ()
        | [| size; _ |] ->
            let fileSize = int size
            curDir.Size <- curDir.Size + fileSize

            let mutable parentDir = curDir.Parent
            while parentDir.IsSome do
                parentDir.Value.Size <- parentDir.Value.Size + fileSize
                parentDir <- parentDir.Value.Parent
        | _ -> ()

    dirs

let runPartOne (input: Directory list) =
    input
    |> getMatchingSizes (fun size -> size <= 100_000)
    |> List.sum

let runPartTwo (input: Directory list) =
    let neededSize = 30_000_000 - (70_000_000 - (List.last input).Size)
    input
    |> getMatchingSizes (fun size -> size >= neededSize)
    |> List.min
