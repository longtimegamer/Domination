if !(isServer) exitWith {};

sleep random 1;

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
               
_S1 = (_this select 0);

_S1 disableAI "PATH";

//_S1 setUnitPos "DOWN";

_S1 disableAI "AIMINGERROR";

//_S1 disableAI "FSM";

//sniper aware loop
while { 1 == 1 } do {
	
		_Dtargets = [];
		
		{
			if ((_x distance2D _S1) < 2000 && (side _x == _targetSide) && (_x isKindOf "CAManBase") && (alive _x)) then {
				_S1 reveal [_x,4];
				_Dtargets pushBack _x;
			};
		} forEach allunits;
		
		_Tcount = count _Dtargets;
	   
	   if (_Tcount > 0) then {
			//one or more targets found
			_Target = (selectRandom _Dtargets);
			_S1 doTarget _Target;
			_S1 doSuppressiveFire _Target;
			sleep 0;
			if ([_S1, _Target, 130] call _Dlos) then {
				_S1 forceWeaponFire [(currentWeapon _S1), "Single"];
			};
		};
	
	_S1 setVehicleAmmo 1;   	
	sleep 5;
	
};