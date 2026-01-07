using Godot;
using System;
using System.Collections.Generic;
using Godot.Collections;

public partial class CS_FileSystem : RefCounted
{
    private static readonly StringName resPath = "res://";
    private static readonly StringName userPath = "user://";

public static Array<string> GetFiles(string dir, string[] extensions = null, bool recursively = true)
{
    Array<string> fileList = new Array<string>();
    
    using var dirAccess = DirAccess.Open(dir);
    if (dirAccess == null) 
    {
        GD.PushError($"Failed to open directory: {dir}");
        return fileList;
    }

    // 1. Get all files in the current directory
    foreach (string fileName in dirAccess.GetFiles())
    {
        if (extensions == null || extensions.Length == 0)
        {
            fileList.Add(dir.PathJoin(fileName));
        }
        else
        {
            foreach (string ext in extensions)
            {
                if (fileName.EndsWith(ext, StringComparison.OrdinalIgnoreCase))
                {
                    fileList.Add(dir.PathJoin(fileName));
                    break;
                }
            }
        }
    }

    // 2. Recursively search subdirectories
    if (recursively)
    {
        foreach (string subDir in dirAccess.GetDirectories())
        {
            string fullSubPath = dir.PathJoin(subDir);
            Array<string> subDirFiles = GetFiles(fullSubPath, extensions, true);
            foreach (string subFile in subDirFiles)
            {
                fileList.Add(subFile);
            }
        }
    }

    return fileList;
}

public static string[] GetDirs(string dir, bool recursively = true)
{
    List<string> result = new List<string>();
    
    using var dirAccess = DirAccess.Open(dir);
    if (dirAccess == null) return new string[0];

    string[] subDirs = dirAccess.GetDirectories();
    foreach (string subDir in subDirs)
    {
        string fullPath = dir.PathJoin(subDir);
        result.Add(fullPath);
        
        if (recursively)
        {
            result.AddRange(GetDirs(fullPath, true));
        }
    }

    return result.ToArray();
}


}
