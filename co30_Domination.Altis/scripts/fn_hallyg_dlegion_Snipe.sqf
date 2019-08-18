params ["_unit", "_targetSide"];

private _Dlos = {
	params ["_looker", "_target", "_FOV"];
    
    if ([position _looker, getDir _looker, _FOV, position _target] call BIS_fnc_inAngleSector) then {
    	_lineIntersections = lineIntersectsSurfaces [(AGLtoASL (_looker modelToWorldVisual (_looker selectionPosition "pilot"))), getPosASL _target, _target, _looker, true, 1,"GEOM","NONE"];
    	if (count (_lineIntersections) > 0) exitWith { false };
    	true
    } else {
    	false
    };
};

sleep random 1;

_unit disableAI "PATH";
_unit disableAI "AIMINGERROR";
_unit disableAI "TARGET";
_unit forceSpeed 0;

player sideChat format ["start sniper aware loop for unit %1", _unit];

//sniper aware loop
while { 1 == 1 } do {
	
		_Dtargets = [];
		
		{
			if ((_x distance2D _unit) < 2000 && (side _x == _targetSide) && (_x isKindOf "CAManBase") && (alive _x)) then {
				_unit reveal [_x,4];
				_Dtargets pushBack _x;
			};
		} forEach allunits;
		
		_Tcount = count _Dtargets;
	   
	   if (_Tcount > 0) then {
			player sideChat "found a target";
			//one or more targets found
			_Target = (selectRandom _Dtargets);
			_unit doTarget _Target;
			_unit doSuppressiveFire _Target;
			sleep 0;
			if ([_unit, _Target, 130] call _Dlos) then {
				player sideChat "shooting!";
				_unit forceWeaponFire [(currentWeapon _unit), "Single"];
			};
		};
	
	_unit setVehicleAmmo 1;
	sleep 5;
	
};