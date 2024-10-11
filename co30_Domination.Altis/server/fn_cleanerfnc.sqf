// by Xeno
//#define __DEBUG__
#include "..\x_setup.sqf"

private _cfunc = {
	if (!isNil "d_delstuff_run") then {
		waitUntil {sleep 1; isNil "d_delstuff_run"};
	};
	if (!isNil "d_delempty_run") then {
		waitUntil {sleep 1; isNil "d_delempty_run"};
	};
	sleep 0.1;
};

while {true} do {
	sleep (300 + random 150);
	call _cfunc;
	private _allmisobjs =+ d_cleaner_array;
	d_cleaner_array = [];
	call _cfunc;
	if (d_chem_objs_ar isNotEqualTo []) then {
		_allmisobjs append d_chem_objs_ar;
		d_chem_objs_ar = [];
	};
	sleep 8;
	call _cfunc;
	if (_allmisobjs isNotEqualTo []) then {
		call _cfunc;
		{
			if (!isNull _x) then {
				private _ct = _x getVariable ["d_checktime", -1];
				if (_ct == -1) then {
					_x setVariable ["d_checktime", time];
				} else {
#ifndef __TT__
					if (_x distance2D d_FLAG_BASE < 20) then {
#else
					if (_x distance2D d_WFLAG_BASE < 20 || {_x distance2D d_EFLAG_BASE < 20}) then {
#endif
						deleteVehicle _x;
					} else {
						if ((_x nearEntities ["CAManBase", 50]) findIf {isPlayer _x} == -1 && {_x getVariable "d_do_not_delete" != 1}) then {
							deleteVehicle _x;
						};
					};
				};
				sleep 0.212;
			};
		} forEach (_allmisobjs select {!isNull _x});
	};
	_allmisobjs = nil;
	sleep 4;
	if (!isNil "d_player_created") then {
		call _cfunc;
		{
			if (!isNull _x) then {
				private _hastime = _x getVariable "d_end_time";
				if (!isNil "_hastime" && {time > _hastime}) then {
					if ((crew _x) findIf {alive _x} == -1) then {
						deleteVehicle _x;
					} else {
						if ((crew _x) findIf {isPlayer _x} > -1) then {
							_x setVariable ["d_end_time", time + 600];
						};
					};
				};
			};
			sleep 0.01;
		} forEach (d_player_created select {!isNull _x});
		d_player_created = d_player_created - [objNull];
	};
	sleep 4;
	if (!isNil "d_airboxes" && {d_airboxes isNotEqualTo []}) then {
		call _cfunc;
		{
			if (!isNull _x) then {
				private _mname = _x getVariable "d_mname";
				if (!isNil "_mname") then {
					deleteMarker _mname;
				};
				deleteVehicle _x;
			};
			sleep 0.01;
		} forEach (d_airboxes select {time > _x getVariable ["d_airboxtime", -1]});
		d_airboxes = d_airboxes - [objNull];
	};
};