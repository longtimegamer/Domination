// by Xeno
//#define __DEBUG__
#include "..\x_setup.sqf"

params ["_centerPos",
	"_maxNumUnits",			// limits but does not increase the size of the team, -1 for no max
	"_fillRadius",
	"_fillRoof",
	"_fillEvenly",
	"_fillTopDown",
	"_disableTeleport",
	"_unitMovementMode",		// passed to zen_occupyhouse and also used in this script to determine which units to create
							// if (_unitMovementMode == 2) then "sniper" else "allmen"
	["_targetBuilding", objNull]   // (optional) target building
];

__TRACE("from createmaintarget garrison function")

__TRACE_1("_garrisonUnits","_this")

private _unitlist = [["allmen", "sniper"] select (_unitMovementMode == 2), d_enemy_side_short] call d_fnc_getunitlistm;

__TRACE_1("","_unitlist")

if (_maxNumUnits > 0 && {count _unitlist > _maxNumUnits}) then {
	while {count _unitlist > _maxNumUnits} do {
		_unitlist deleteAt (ceil (random (count _unitlist - 1)));
	};
};

private _newgroup = [d_side_enemy] call d_fnc_creategroup;

private _units_to_garrison = [_centerPos, _unitlist, _newgroup, false, true] call d_fnc_makemgroup;

if (_unitMovementMode == 2) then {
	{
		_x disableAI "PATH";
		_x forceSpeed 0;
		_x setUnitPos "UP";
		_x setVariable ["d_is_sniper", true];
	} forEach _units_to_garrison;
};
sleep 0.2;
//_newgroup allowFleeing 0;
//_newgroup setVariable ["d_defend", true];
//[_newgroup, _poss] spawn d_fnc_taskDefend;
if (d_with_dynsim == 0) then {
	[_newgroup, 0] spawn d_fnc_enabledynsim;
};

_units_to_garrison = _units_to_garrison - [objNull];
__TRACE_1("","_units_to_garrison")

//AI soldiers will be garrisoned in a building (window/roof)
__TRACE("Placing units in a building...")
//occupy a building using Zenophon script
_unitsNotGarrisoned = [
	_centerPos,											// Params: 1. Array, the building(s) nearest this position is used
	_units_to_garrison,									//         2. Array of objects, the units that will garrison the building(s)
	_fillRadius,										//  (opt.) 3. Scalar, radius in which to fill building(s), -1 for only nearest building, (default: -1)
	_fillRoof,											//  (opt.) 4. Boolean, true to put units on the roof, false for only inside, (default: false)
	_fillEvenly,										//  (opt.) 5. Boolean, true to fill all buildings in radius evenly, false for one by one, (default: false)
	_fillTopDown,										//  (opt.) 6. Boolean, true to fill from the top of the building down, (default: false)
	_disableTeleport,									//  (opt.) 7. Boolean, true to order AI units to move to the position instead of teleporting, (default: false)
	_unitMovementMode,   								//  (opt.) 8. Scalar, 0 - unit is free to move immediately (default: 0) 1 - unit is free to move after a firedNear event is triggered 2 - unit is static, no movement allowed
	false, //true                                                //  (opt.) 9. Boolean, true to force position selection such that the unit has a roof overhead // todo - fix the roof check, currently disqualifies many top floor position when set to true
	false,												//  (opt.) 10. _isAllowSpawnNearEnemy Boolean, true to allow the selected position to be near an enemy (default: false)
	false,												//  (opt.) 11. _isDryRun Boolean, true to dry run, for testing only no units are moved, still returns array of units that could not be garrisoned at given pos (default: false)
	-1,													//  (opt.) 12. _distanceFromBuildingCenter Scalar, distance a unit may be placed from the center of a building (usually safer) or -1 for any (default: -1)
	_targetBuilding //true                                       //  (opt.) 13. Object, target building may be passed
] call d_fnc_Zen_OccupyHouse;
sleep 0.01;
__TRACE_1("1","_unitsNotGarrisoned")
_units_to_garrison = _units_to_garrison - _unitsNotGarrisoned;
_unitsNotGarrisoned = _unitsNotGarrisoned - [objNull];
_units_to_garrison = _units_to_garrison - [objNull];
__TRACE_1("1","_units_to_garrison")
__TRACE_1("2","_unitsNotGarrisoned")
if (_unitsNotGarrisoned isNotEqualTo []) then {
	diag_log [format ["units not garrisoned and will be deleted: %1", _unitsNotGarrisoned joinString "/"]];
	deleteVehicle _unitsNotGarrisoned;
};
if (_units_to_garrison isEqualTo []) exitWith {
	__TRACE("Deleting new group")
	deleteGroup _newgroup;
};
__TRACE("after deleting new group")
/* Removed for now, garrison groups should not respawn at main target respawn barracks (it's getting too much when there are about 40 players on the server)
if (d_mt_respawngroups == 0) then {
	{
		[_x, 3] call d_fnc_setekmode;
	} forEach _units_to_garrison;
	_newgroup setVariable ["d_respawninfo", ["specops", [], _centerPos, 0, "patrol2", d_side_enemy, 0, 0, 1, [_centerPos, _radius], false, []]];
};*/

if (d_ai_persistent_corpses != 0) then {
	// delete a unit which was spawned inside a building shortly after it was killed if players are about 30 m away; Lots of dropped bombs at Dorph server which kills those units
	{
		[_x, 20] call d_fnc_setekmode;
	} forEach (_units_to_garrison select {!isNull _x});
};
if (!isNull _newgroup) then {
	__TRACE("new group not null adding to HC")
	_newgroup call d_fnc_addgrp2hc;
};
__TRACE_1("","_newgroup")
__TRACE_1("3","_units_to_garrison")

_units_to_garrison
