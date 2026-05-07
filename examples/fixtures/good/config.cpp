class CfgPatches
{
    class example_addon
    {
        units[] = {"example_unit"};
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"A3_Soft_F"};
        author = "Example";
    };
};

class CfgVehicles
{
    class Car_F;
    class example_unit: Car_F
    {
        scope = 2;
        displayName = "Example Unit";
        side = 1;
        faction = "BLU_F";
    };
};
