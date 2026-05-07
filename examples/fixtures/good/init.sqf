// Example init script - syntactically clean
params ["_vehicle", "_role"];

private _crew = crew _vehicle;
private _maxFuel = 1.0;

if (count _crew == 0) then {
    diag_log format ["[example] Empty crew on %1", _vehicle];
} else {
    {
        private _unit = _x;
        _unit setVariable ["example_role", _role, true];
    } forEach _crew;
};

_vehicle setFuel _maxFuel;

private _i = 0;
while {_i < 3} do {
    _i = _i + 1;
};

true
