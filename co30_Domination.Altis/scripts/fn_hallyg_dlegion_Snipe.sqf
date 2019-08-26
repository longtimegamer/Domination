#define __DEBUG__
#define THIS_FILE "fn_hallyg_dlegion_Snipe.sqf"
#include "..\x_setup.sqf"

#define EYE_HEIGHT 1.53

params ["_unit", "_targetSide"];

//by HallyG, dlegion
private _isLOS = {
	params ["_looker", "_target", "_FOV"];
    
    if ([position _looker, getDir _looker, _FOV, position _target] call BIS_fnc_inAngleSector) then {
    	_lineIntersections = lineIntersectsSurfaces [(AGLtoASL (_looker modelToWorldVisual (_looker selectionPosition "pilot"))), getPosASL _target, _target, _looker, true, 1,"GEOM","NONE"];
#ifdef __DEBUG__
	__TRACE_1("", format ["lineIntersections: %1", _lineIntersections ]);
#endif
    	if (count (_lineIntersections) > 0) exitWith {
    		false
		};
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
    _visibleThreshold = 0.015;
    _targetEye = eyepos _target;
    _unitEye = eyepos _unit;

    //vector origins are half meter away from looker and target (uses 0.5 of a normalized vector which by definition is 1 meter)
    _unit_in_dir = _unitEye vectorAdd ((_unitEye vectorFromTo _targetEye) vectorMultiply 0.5);
    _target_in_dir = _targetEye vectorAdd ((_targetEye vectorFromTo _unitEye) vectorMultiply 0.5);

    _visiblity = parseNumber str ([objNull, "VIEW"] checkVisibility [_target_in_dir, _unit_in_dir]);
    
#ifdef __DEBUG__
	_mgs = format ["isVisible value: %1 threshold: %2 target: %3", _visiblity, _visibleThreshold, _target];
	__TRACE_1("", _msg);
#endif

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
_unit setCombatMode "RED";

#ifdef __DEBUG__
	_msg = format ["unit combatMode: %1", combatMode _unit];
	__TRACE_1("", _msg);
#endif

//sniper aware loop
while { 1 == 1 } do {
	
    _Dtargets = [];

    {
        if (
            (_x distance2D _unit) < _detectionRadius && (side _x == _targetSide) && (_x isKindOf "CAManBase") && (alive _x)
             //&& (isTouchingGround (vehicle player) && !(vehicle _unit isKindOf "Air"))
        ) then {
#ifdef __DEBUG__
	_msg = format ["found eligible target: %1", _x];
	__TRACE_1("", _msg);
#endif
            _unit reveal [_x,4];
            _Dtargets pushBack _x;
        };
    } forEach allunits;
    
    _fired = false;
    _targetUnit = nil;
    {
        if (([_unit, _x] call _isVisible) || ([_unit, _x, 360] call _isLOS)) exitWith {
        	//to check if unit actually fired
        	_ammoCount = _unit ammo primaryWeapon _unit;
#ifdef __DEBUG__
	_msg = format ["shooting at %1 with %2", _x, currentWeapon _unit];
	__TRACE_1("", _msg);
#endif
			_targetUnit = _unit;
            _unit doTarget _x;
            _unit doSuppressiveFire _x;
			//_unit forceWeaponFire [(currentWeapon _unit), "Single"];
			sleep 3;
			if (_ammoCount > _unit ammo primaryWeapon _unit) then {
				//yes the unit actually fired
				_fired = true;
			};
        };
#ifdef __DEBUG__
	_msg = format ["found eligible target but cannot shoot it: %1", _x];
	__TRACE_1("", _msg);
#endif
    } forEach ([_Dtargets, getPos _unit] call _sortArrayByDistance);

	if (_fired) then {
#ifdef __DEBUG__
	_msg = format ["fired at: %1", _targetUnit];
	__TRACE_1("", _msg);
#endif
	    _unit setVehicleAmmo 1;
	} else {
#ifdef __DEBUG__
	_msg = format ["did not fire at: %1", _targetUnit];
	__TRACE_1("", _msg);
#endif
		switch (toUpper (unitPos _unit)) do {
			case "AUTO";
			case "UP": {
				_unit setCombatMode "BLUE";
				_unit setUnitPos "DOWN";
				//sleep ((ceil random 30) max 10);
				sleep 3;
				_unit setCombatMode "RED";
			};
			case "DOWN": {
				_unit setCombatMode "BLUE";
				_unit setUnitPos "MIDDLE";
				sleep 3;
				_unit setCombatMode "RED";
			};
			case "MIDDLE": {
				_unit setCombatMode "BLUE";
            	_unit setUnitPos "UP";
            	_unit setCombatMode "RED";	
            	sleep 3;			
			};
		};
	}	
};