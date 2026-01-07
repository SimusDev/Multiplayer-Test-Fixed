using Godot;
using System;

[GlobalClass]
public partial class CS_Types : RefCounted
{
    public static StringName GetType(Resource resource)
    {
        if (resource == null)
        {
            return string.Empty;
        }

        Variant scriptVariant = resource.GetScript();
        if (scriptVariant.VariantType == Variant.Type.Nil)
        {
            return string.Empty;
        }

        Script script = scriptVariant.As<Script>();
        if (script == null)
        {
            return string.Empty;
        }

        return script.GetGlobalName();
    }
    public static bool IsType(Resource resource, string className)
{
    if (resource == null || string.IsNullOrEmpty(className))
        return false;

    if (resource.IsClass(className))
        return true;

    Variant scriptVariant = resource.GetScript();
    if (scriptVariant.VariantType == Variant.Type.Nil)
        return false;

    Script script = scriptVariant.As<Script>();
    while (script != null)
    {
        if (script.GetGlobalName() == className)
            return true;
        
        script = script.GetBaseScript();
    }

    return false;
}
}