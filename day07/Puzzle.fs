module Puzzle

type File = { Name: string; Size: int }

type Directory =
    {
        Name: string
        Parent: Directory option
        mutable Directories: Directory list
        mutable Files: File list
    }

let rec private getTotalSize (directory: Directory) =
    (directory.Files |> List.sumBy (fun file -> file.Size)) + (directory.Directories |> List.sumBy getTotalSize)


let parseInput (lines: string[]) =
    let rootDir: Directory =
        {
            Name = "/"
            Parent = None
            Directories = []
            Files = []
        }

    let mutable dirs = [rootDir]
    let mutable curDir = rootDir
    for line in lines do
        match line.Split(' ') with
        | [| "$"; "cd"; dir |] ->
            match dir with
            | "/" -> curDir <- rootDir
            | ".." ->
                match curDir.Parent with
                | Some(parentDir) -> curDir <- parentDir
                | None -> ()
            | name ->
                let subDir: Directory =
                    {
                        Name = name
                        Parent = Some(curDir)
                        Directories = []
                        Files = []
                    }

                curDir.Directories <- subDir :: curDir.Directories
                curDir <- subDir
                dirs <- subDir :: dirs
        | [| "$"; "ls" |] | [| "dir"; _ |] -> ()
        | [| size; name |] -> curDir.Files <- { Name = name; Size = int size } :: curDir.Files
        | _ -> ()

    dirs

let runPartOne (input: Directory list) =
    input
    |> List.map getTotalSize
    |> List.filter (fun size -> size <= 100_000)
    |> List.sum

let runPartTwo (input: Directory list) =
    let sizes = input |> List.map getTotalSize
    let neededSize = 30_000_000 - (70_000_000 - (List.last sizes))

    sizes
    |> List.filter (fun size -> size >= neededSize)
    |> List.min
