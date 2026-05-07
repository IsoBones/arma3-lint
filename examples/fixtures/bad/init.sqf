// Intentionally broken SQF to exercise the linter.
// Hits: E001 (unbalanced braces), E010 (if without then), E001 again
params ["_vehicle"];

if (alive _vehicle) {
    _vehicle setFuel 1;
};

private _x = 5
if (_x = 10) then {
    diag_log "broken";
;
