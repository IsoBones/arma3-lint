// Intentionally broken config to exercise the linter.
// Hits: E007 (array missing []), E008 (class missing ;), E010 (missing ;)

class CfgPatches
{
    class broken_addon
    {
        units = {"broken_unit"}
        weapons[] = {};
        requiredVersion = 1.0
        requiredAddons[] = {"A3_Soft_F"};
    }
};
