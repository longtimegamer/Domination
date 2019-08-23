#define EYE_HEIGHT 1.53

params ["_unit", "_targetSide"];

//by HallyG, dlegion
private _isLOS = {
	params ["_looker", "_target", "_FOV"];
    
    if ([position _looker, getDir _looker, _FOV, position _target] call BIS_fnc_inAngleSector) then {
    	_lineIntersections = lineIntersectsSurfaces [(AGLtoASL (_looker modelToWorldVisual (_looker selectionPosition "pilot"))), getPosASL _target, _target, _looker, true, 1,"GEOM","NONE"];
		//player sideChat format ["lineIntersections: %1", _lineIntersections ];
    	if (count (_lineIntersections) > 0) exitWith { false };
    	true
    } else {
    	false
    };
};

//by Jezuro
private _sortArrayByDistance = {
    params ["_unitArray", "_fromPosition"];
    _unsorted = _unitArray;
    _sorted = [];
    _pos = _fromPosition;

    {
        _closest = _unsorted select 0;
        {if ((getPos _x distance _pos) < (getPos _closest distance _pos)) then {_closest = _x}} forEach _unsorted;
        _sorted = _sorted + [_closest];
        _unsorted = _unsorted - [_closest]
    } forEach _unsorted;

    _sorted
};

//by sarogahtyp
private _isVisible = {
    params ["_unit", "_target"];
    _visibleThreshold = 0.02;
    _targetEye = eyepos _target;
    _unitEye = eyepos _unit;

    //vector origins are half meter away from looker and target (uses 0.5 of a normalized vector which by definition is 1 meter)
    _unit_in_dir = _unitEye vectorAdd ((_unitEye vectorFromTo _targetEye) vectorMultiply 0.5);
    _target_in_dir = _targetEye vectorAdd ((_targetEye vectorFromTo _unitEye) vectorMultiply 0.5);

    _visiblity = parseNumber str ([objNull, "VIEW"] checkVisibility [_target_in_dir, _unit_in_dir]);

    //player sideChat format ["isVisible value: %1", _visiblity];

    if (_visiblity > _visibleThreshold) then {
        true
    } else {
        false
    };
};

//in meters
_detectionRadius = 2000;

sleep random 1;

_unit disableAI "PATH";
_unit disableAI "AIMINGERROR";
_unit disableAI "TARGET";
_unit forceSpeed 0;

//sniper aware loop
while { 1 == 1 } do {
	
    _Dtargets = [];

    {
        if (
            (_x distance2D _unit) < _detectionRadius && (side _x == _targetSide) && (_x isKindOf "CAManBase") && (alive _x)
             && (isTouchingGround (vehicle player) && !(vehicle _unit isKindOf "Air"))
        ) then {
            //player sideChat format ["found eligible target: %1", _x];
            _unit reveal [_x,4];
            _Dtargets pushBack _x;
        };
    } forEach allunits;

    //player sideChat format ["target list _Dtargets: %1", _Dtargets];

    {
        if (([_unit, _x] call _isVisible) || ([_unit, _x, 360] call _isLOS)) exitWith {
            //player sideChat format ["shooting at %1 with %2", _x, currentWeapon _unit];
            _unit doTarget _x;
            _unit doSuppressiveFire _x;
            //_unit forceWeaponFire [(currentWeapon _unit), "Single"];
        };
        //player sideChat format ["found eligible target but cannot shoot it: %1", _x];

    } forEach ([_Dtargets, getPos _unit] call _sortArrayByDistance);
	
	_unit setVehicleAmmo 1;
	sleep 10;
	
};