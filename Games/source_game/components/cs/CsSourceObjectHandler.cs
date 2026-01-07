using Godot;
using System;
using System.Diagnostics;
using System.Threading.Tasks;

[GlobalClass]
public partial class CsSourceObjectHandler : Node
{

    Signal loading_finished;

    [Export(PropertyHint.Dir)]
    private string baseDir = "";
    [Export]
    private string[] objectDirs = [];
    [Export]
    private Godot.Collections.Array<Resource> initResources = new();

    private readonly Godot.Collections.Array<Resource> resources = new();
    private readonly object _lock = new object();

    public override void _Ready()
    {
        if (string.IsNullOrEmpty(baseDir))
        {
            GD.PushWarning($"{Name}: baseDir is empty.");
            return;
        }

        Task.Run(() => LoadResourcesAsync());
    }

    private void LoadResourcesAsync()
    {
        Stopwatch sw = Stopwatch.StartNew();
        int totalFilesProcessed = 0;
        int successfullyLoaded = 0;

        foreach (string dir in objectDirs)
        {
            string dirPath = baseDir.PathJoin(dir);

            if (!DirAccess.DirExistsAbsolute(dirPath))
            {
                GD.PrintErr($"{Name}: Directory not found: {dirPath}");
                continue;
            }

            var files = CS_FileSystem.GetFiles(dirPath, ["res", "tres"]);

            foreach (string file in files)
            {
                totalFilesProcessed++;
                try
                {
                    Resource resource = ResourceLoader.Load(file);

                    if (resource == null)
                    {
                        GD.PrintErr($"{Name}: Can't load resource: {file}");
                        continue;
                    }

                    if (CS_Types.IsType(resource, "R_SourceWorldObject"))
                    {
                        lock (_lock)
                        {
                            resources.Add(resource);
                        }
                        successfullyLoaded++;

                        if (resource.HasMethod("register"))
                        {
                            resource.CallDeferred("register");
                        }
                    }
                }
                catch (Exception ex)
                {
                    GD.PrintErr($"{Name}: Exception loading {file}: {ex.Message}");
                }
            }
        }

        sw.Stop();

        double avg = totalFilesProcessed > 0 ? (double)sw.ElapsedMilliseconds / totalFilesProcessed : 0;
        
        Callable.From(() => {
            GD.PrintRich($"[color=green]--- Benchmark Results for {Name} (Async) ---[/color]");
            GD.Print($"Total time: {sw.ElapsedMilliseconds} ms");
            GD.Print($"Files scanned: {totalFilesProcessed}");
            GD.Print($"Resources loaded: {successfullyLoaded}");
            GD.Print($"Average per file: {avg:F2} ms");
            GD.PrintRich("[color=green]-----------------------------------[/color]");
        }).CallDeferred();
    }

    public override void _ExitTree()
    {
        foreach (Resource res in initResources)
        {
            if (res == null) continue;

            try
            {
                lock (_lock)
                {
                    resources.Add(res);
                }
                
                if (res.HasMethod("register"))
                {
                    res.Call("register");
                }
            }
            catch { /* ignored */ }
        }
    }
}
