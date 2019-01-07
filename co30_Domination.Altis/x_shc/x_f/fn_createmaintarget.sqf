// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createmaintarget.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

private _selectit = {
	(ceil (random (((_this select 0) select (_this select 1)) # 1)))
};

private _selectitmen = {
	private _a_vng2 = (_this select 0) select (_this select 1);
	if (_a_vng2 # 0 > 0) then {
		private _num_ret = floor (random ((_a_vng2 # 0) + 1));
		if (_num_ret < _a_vng2 # 1) then {
			_a_vng2 # 1
		} else {
			_num_ret
		}
	} else {0}
};

private _selectitvec = {
	private _a_vng2 = ((_this select 0) select (_this select 1)) # 0;
	if (_a_vng2 # 0 > 0) then {private _num_ret = floor (random ((_a_vng2 # 0) + 1));if (_num_ret < _a_vng2 # 1) then {_a_vng2 # 1} else {_num_ret}} else {0}
};

private _type_list_guard = [
	["allmen", 0, [d_footunits_guard, 0] call _selectitmen],
	["specops", 0, [d_footunits_guard, 1] call _selectitmen],
	["tank", [d_vec_numbers_guard, 0] call _selectit, [d_vec_numbers_guard,0] call _selectitvec],
	["tracked_apc", [d_vec_numbers_guard, 1] call _selectit, [d_vec_numbers_guard,1] call _selectitvec],
	["wheeled_apc", [d_vec_numbers_guard, 2] call _selectit, [d_vec_numbers_guard,2] call _selectitvec],
	["jeep_mg", [d_vec_numbers_guard, 3] call _selectit, [d_vec_numbers_guard,3] call _selectitvec],
	["jeep_gl", [d_vec_numbers_guard, 4] call _selectit, [d_vec_numbers_guard,4] call _selectitvec]
];

private _type_list_guard_static = [
	["allmen", 0, [d_footunits_guard_static, 0] call _selectitmen],
	["specops",0, [d_footunits_guard_static, 1] call _selectitmen],
	["tank", [d_vec_numbers_guard_static, 0] call _selectit, [d_vec_numbers_guard_static,0] call _selectitvec],
	["tracked_apc", [d_vec_numbers_guard_static, 1] call _selectit, [d_vec_numbers_guard_static,1] call _selectitvec],
	["aa", [d_vec_numbers_guard_static, 2] call _selectit, [d_vec_numbers_guard_static,2] call _selectitvec]
];

private _type_list_patrol = [
	["allmen", 0, [d_footunits_patrol, 0] call _selectitmen],
	["specops", 0, [d_footunits_guard_static, 1] call _selectitmen],
	["tank", [d_vec_numbers_patrol, 0] call _selectit, [d_vec_numbers_patrol,0] call _selectitvec],
	["tracked_apc", [d_vec_numbers_patrol, 1] call _selectit, [d_vec_numbers_patrol,1] call _selectitvec],
	["wheeled_apc", [d_vec_numbers_patrol, 2] call _selectit, [d_vec_numbers_patrol,2] call _selectitvec],
	["jeep_mg", [d_vec_numbers_patrol, 3] call _selectit, [d_vec_numbers_patrol,3] call _selectitvec],
	["jeep_gl", [d_vec_numbers_patrol, 4] call _selectit, [d_vec_numbers_patrol,4] call _selectitvec]
];

private _type_list_guard_static2 = [
	["stat_mg", 1, ceil (random 4)],
	["stat_gl", 1, ceil (random 3)]
];

_selectit = nil;
_selectitmen = nil;
_selectitvec = nil;

__TRACE_1("","_type_list_guard")

params ["_trgobj", "_radius"];
private _patrol_radius = _radius + 300 + random 300;
private _trg_center = if (_trgobj isEqualType objNull) then {getPosATL _trgobj} else {_trgobj};
__TRACE_1("","_trg_center")
__TRACE_3("","_trgobj","_radius","_patrol_radius")
__TRACE_1("","_this")

#ifndef __TT__
d_num_barracks_objs = (ceil random 4) max 2;
__TRACE_1("","d_num_barracks_objs")
d_mt_barracks_obj_ar = [];
private ["_iccount", "_ecounter", "_poss"];
private _vec = [0,0,0];
private _allbars = [];
private _doexit = false;
for "_i" from 1 to d_num_barracks_objs do {
	_ecounter = 0;
	while {true} do {
		_poss = [_trg_center, _radius, 4, 1, 0.3, sizeOf d_barracks_building, 0] call d_fnc_GetRanPointCircleBig;
		if (_poss isEqualTo []) then {
			_iccount = 0;
			while {_poss isEqualTo []} do {
				_iccount = _iccount + 1;
				_poss = [_trg_center, _radius, 4, 1, 0.3, sizeOf d_barracks_building, 0] call d_fnc_GetRanPointCircleBig;
				if (_iccount >= 50 && {!(_poss isEqualTo [])}) exitWith {};
			};
		};
		_doexit = false;
		if !(_allbars isEqualTo []) then {
			if (_allbars findIf {_poss distance2D _vec >= 120} == count _allbars) then {
				_doexit = true;
			};
		} else {
			_doexit = true;
		};
		_ecounter = _ecounter + 1;
		if (_doexit || {_ecounter == 50}) exitWith {};
	};
	if (isNil "_poss" || {_poss isEqualTo []}) then {
		_poss = [_trg_center, _radius] call d_fnc_getranpointcircle;
	};
	_poss set [2, 0];

	_vec = createVehicle [d_barracks_building, _poss, [], 0, "NONE"];
	_allbars pushBack _vec;
	__TRACE_1("d_barracks_building","_vec")
	_vec setPos _poss;
	_vec setVariable ["d_v_pos", _poss];
	[_vec, 0] call d_fnc_checkmtrespawntarget;
	d_mt_barracks_obj_ar pushBack _vec;
	sleep 0.5;
};
d_num_barracks_objs = count d_mt_barracks_obj_ar;
__TRACE_1("","d_mt_barracks_obj_ar")
__TRACE_1("2","d_num_barracks_objs")
d_mt_barracks_down = false;
if (!isServer) then {
	[missionNamespace, ["d_mt_barracks_down", false]] remoteExecCall ["setVariable", 2];
};

_ecounter = 0;
	while {true} do {
	_poss = [_trg_center, _radius, 4, 1, 0.3, sizeOf d_vehicle_building, 0] call d_fnc_GetRanPointCircleBig;
	if (_poss isEqualTo []) then {
		_iccount = 0;
		while {_poss isEqualTo []} do {
			_iccount = _iccount + 1;
			_poss = [_trg_center, _radius, 4, 1, 0.3, sizeOf d_vehicle_building, 0] call d_fnc_GetRanPointCircleBig;
			if (_iccount >= 50 && {!(_poss isEqualTo [])}) exitWith {};
		};
	};
	_doexit = false;
	if !(_allbars isEqualTo []) then {
		if (_allbars findIf {_poss distance2D _vec >= 120} == count _allbars) then {
			_doexit = true;
		};
	} else {
		_doexit = true;
	};
	_ecounter = _ecounter + 1;
	if (_doexit || {_ecounter == 50}) exitWith {};
};
if (isNil "_poss" || {_poss isEqualTo []}) then {
	_poss = [_trg_center, _radius] call d_fnc_getranpointcircle;
};
_poss set [2, 0];

_vec = createVehicle [d_vehicle_building, _poss, [], 0, "NONE"];
__TRACE_1("d_vehicle_building","_vec")
_vec setPos _poss;
_vec setVectorUp [0,0,1];
_vec setVariable ["d_v_pos", _poss];
[_vec, 1] call d_fnc_checkmtrespawntarget;
d_mt_mobile_hq_down = false;
d_mt_mobile_hq_obj = _vec;
if (!isServer) then {
	[missionNamespace, ["d_mt_mobile_hq_down", false]] remoteExecCall ["setVariable", 2];
};
sleep 0.1;

//create civilian module
placeCivilianSpotsAndUnits = {
	
	//_randomPos = [[[_trg_center, 200]],[]] call BIS_fnc_randomPos;
	
	_ms1 = _grp createUnit ["ModuleCivilianPresenceSafeSpot_F", [[[_trg_center, 200]],[]] call BIS_fnc_randomPos, [], 0, "NONE"];
	_ms1 call civModuleSetVars;
	__TRACE_1("_ms1");
	
	_ms2 = _grp createUnit ["ModuleCivilianPresenceSafeSpot_F", [[[_trg_center, 200]],[]] call BIS_fnc_randomPos, [], 0, "NONE"];
	_ms2 call civModuleSetVars;
	__TRACE_1("_ms2");
	
	_ms3 = _grp createUnit ["ModuleCivilianPresenceSafeSpot_F", [[[_trg_center, 200]],[]] call BIS_fnc_randomPos, [], 0, "NONE"];
	_ms3 call civModuleSetVars;
	__TRACE_1("_ms3");

	_mu1 = _grp createUnit ["ModuleCivilianPresenceUnit_F", [[[_trg_center, 200]],[]] call BIS_fnc_randomPos, [], 0, "NONE"];
	__TRACE_1("_mu1");
	
	_mu2 = _grp createUnit ["ModuleCivilianPresenceUnit_F", [[[_trg_center, 200]],[]] call BIS_fnc_randomPos, [], 0, "NONE"];
	__TRACE_1("_mu2");
	
	_mu3 = _grp createUnit ["ModuleCivilianPresenceUnit_F", [[[_trg_center, 200]],[]] call BIS_fnc_randomPos, [], 0, "NONE"];
	__TRACE_1("_mu3");
	
};

civModuleSetVars = {
	_this setVariable ["#capacity",5];
	_this setVariable ["#usebuilding",true];
	_this setVariable ["#terminal",false];
	//_m1 setVariable ["#type",5];
};

if (d_enable_civs == 1) then {
	_grp = createGroup civilian;
	_target_name = d_target_names select d_current_target_index;
	_marker_name = Format ["d_target_%1", d_current_target_index];
	
	__TRACE_1("_this");
	__TRACE_1("d_current_target_index");
	__TRACE_1("_target_name");
	__TRACE_1("_marker_name");
	
	__TRACE_1("Placing a civilian module...");
	_this call placeCivilianSpotsAndUnits;
	
	_m = _grp createUnit ["ModuleCivilianPresence_F", [0,0,0], [], 0, "NONE"];
	
	_m setVariable ["#debug",true]; // Debug mode on
	 
	_m setVariable ["#area",[_trg_center,1000,1000,0,true,-1]];  // Fixed! this gets passed to https://community.bistudio.com/wiki/inAreaArray 
	_m setVariable ["#useagents",true];
	_m setVariable ["#usepanicmode",false];
	_m setVariable ["#unitcount",d_civ_unitcount];
	//_m setVariable ["#onCreated", { hint "created a civilian!" }];
	_m setVariable ["#onCreated", {
		_this addMPEventHandler ["MPKilled", 
		{
			params ["_cVictim", "_cKiller"];
			if (_cKiller call d_fnc_isplayer) then 
			{
				//hint formatText ["%1 killed a civilian!", name _cKiller];
				private _topicside = d_kb_topic_side;
				private _topicside = d_kb_topic_side;
				private _logic = d_kb_logic2;
				private _logic1 = d_kb_logic1;
				private _channel = d_kbtel_chan;
				d_hq_logic_blufor1 kbTell [
					//_logic,
					d_hq_logic_blufor2,
					//_topicside,
					"HQ_W",
					"PenaltyKilledCivilian",
					["1", "", name _cKiller, []],
					["2", "", str d_sub_kill_civ_points, []],
					 _channel
				];
	
				//subtract penalty for killing a civilian
				[player, d_sub_kill_civ_points * -1] remoteExecCall ["addScore", 2]
			};
		}];
	}];
	//_m setVariable ["#onDeleted", { hint "deleted a civilian!" }];
 };
//end create civilian module
#endif

#ifdef __DEBUG__
if (!d_tt_ver) then {
	{
		[str _x, getPos _x, "ICON", "ColorBlack", [0.5, 0.5], "Barracks", 0, "mil_dot"] call d_fnc_CreateMarkerLocal;
	} forEach d_mt_barracks_obj_ar;
	[str d_mt_mobile_hq_obj, getPos d_mt_mobile_hq_obj, "ICON", "ColorBlack", [0.5, 0.5], "Mobile forces HQ", 0, "mil_dot"] call d_fnc_CreateMarkerLocal;
};
#endif

private _wp_array_inf = [_trg_center, _radius, 0, 0, 0.7, 2] call d_fnc_getwparray;
private _wp_array_vecs = [_trg_center, _radius, 0, 2] call d_fnc_getwparray;
private _wp_array_pat_inf = [_trg_center, _patrol_radius, 0, 0, 0.7, 2] call d_fnc_getwparray;
private _wp_array_pat_vecs = [_trg_center, _patrol_radius, 0, 2] call d_fnc_getwparray;

sleep 0.112;

{
	private _curar = [_wp_array_vecs, _wp_array_inf] select (_x # 1 == 0);
	for "_xxx" from 1 to (_x # 2) do {
		private _wp_ran = (count _curar) call d_fnc_RandomFloor;
		[_x # 0, [_curar select _wp_ran], _trg_center, _x # 1, "guard", d_enemy_side_short, 0, -1.111, 1, [_trg_center, _radius]] call d_fnc_makegroup;
		_curar deleteAt _wp_ran;
		sleep 0.4;
	};
} forEach (_type_list_guard select {_x # 2 > 0});

sleep 0.233;

{
	private _curar = [_wp_array_vecs, _wp_array_inf] select (_x # 1 == 0);
	for "_xxx" from 1 to (_x # 2) do {
		private _wp_ran = (count _curar) call d_fnc_RandomFloor;
		[_x # 0, [_curar select _wp_ran], _trg_center, _x # 1, "guardstatic", d_enemy_side_short, 0, -1.111, 1, [_trg_center, _radius]] call d_fnc_makegroup;
		_curar deleteAt _wp_ran;
		sleep 0.4;
	};
} forEach (_type_list_guard_static select {_x # 2 > 0});

{
	for "_xxx" from 1 to (_x # 2) do {
		private _wp_ran = (count _wp_array_inf) call d_fnc_RandomFloor;
		[_x # 0, [_wp_array_inf select _wp_ran], _trg_center, _x # 1, "guardstatic2", d_enemy_side_short, 0, -1.111, 1, [_trg_center, _radius]] call d_fnc_makegroup;
		_wp_array_inf deleteAt _wp_ran;
		sleep 0.1;
	};
} forEach (_type_list_guard_static2 select {_x # 2 > 0});

d_del_mtd_objects = [];

{
	private _curar = [_wp_array_pat_vecs, _wp_array_pat_inf] select (_x # 1 == 0);
	for "_xxx" from 1 to (_x # 2) do {
		private _wp_ran = (count _curar) call d_fnc_RandomFloor;
		[_x # 0, [_curar select _wp_ran], _trg_center, _x # 1, ["patrol", "patrol2mt"] select (_x # 0 == "allmen" || {_x # 0 == "specops"}), d_enemy_side_short, 0, -1.111, 1, [_trg_center, _patrol_radius]] call d_fnc_makegroup;
		_curar deleteAt _wp_ran;
		sleep 0.4;
};
} forEach (_type_list_patrol select {_x # 2 > 0});

_type_list_guard = nil;
_type_list_guard_static = nil;
_type_list_guard_static2 = nil;
_type_list_patrol = nil;

sleep 2.124;

if (!d_no_more_observers) then {
	d_nr_observers = floor random 4;
	if (d_nr_observers < 2) then {d_nr_observers = 2};
	d_obs_array = [];
	d_obs_array resize d_nr_observers;
	private _unit_array = ["arti_observer", d_enemy_side_short] call d_fnc_getunitlistm;
	for "_xx" from 0 to d_nr_observers - 1 do {
		private _agrp = [d_side_enemy] call d_fnc_creategroup;
		private _xx_ran = (count _wp_array_inf) call d_fnc_RandomFloor;
		private _xpos = _wp_array_inf select _xx_ran;
		_wp_array_inf deleteAt _xx_ran;
		__TRACE("from createmaintarget 1")
		private _observer = ([_xpos, _unit_array, _agrp] call d_fnc_makemgroup) # 0;
		_agrp deleteGroupWhenEmpty true;
		[_agrp, _xpos, [_trg_center, _radius], [5, 20, 40], "", 0] spawn d_fnc_MakePatrolWPX;
		_agrp setVariable ["d_PATR", true];
		if (d_with_dynsim == 0) then {
			_agrp enableDynamicSimulation true;
		};
		_observer addEventHandler ["killed", {d_nr_observers = d_nr_observers - 1;
			if (d_nr_observers == 0) then {
#ifndef __TT__
				[3] remoteExecCall ["d_fnc_DoKBMsg", 2];
#else
				[4] remoteExecCall ["d_fnc_DoKBMsg", 2];
#endif
			};
			(_this select 0) removeAllEventHandlers "killed";
		}];
		d_obs_array set [_xx, _observer];
		sleep 0.4;
	};
	_unit_array = nil;

#ifndef __TT__
	[6, d_nr_observers] remoteExecCall ["d_fnc_DoKBMsg", 2];
#else
	[7, d_nr_observers] remoteExecCall ["d_fnc_DoKBMsg", 2];
#endif
	d_handleobservers_handle = 0 spawn d_fnc_handleobservers;
	sleep 1.214;
};

[_wp_array_vecs, d_cur_target_radius, _trg_center] spawn d_fnc_createsecondary;

_wp_array_pat = nil;
