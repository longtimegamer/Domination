// by Xeno (modified by Longtime)
//#define __DEBUG__
#include "..\..\x_setup.sqf"

// Rescue captive friendly soldiers guarded by specops.  If the specops are injured they will detonate a bomb and kill the hostages.

#ifdef __TT__
//do not run this event in TvT (for now)
if (true) exitWith {};
#endif

if (!isServer) exitWith {};

params ["_target_radius", "_target_center"];

private _mt_event_key = format ["d_X_MTEVENT_%1_%2", d_cur_tgt_name, "POW_RESCUE"];

diag_log [format ["start event: %1", _mt_event_key]];
 
//position the event site at max distance 50% of target radius and min 5% of target radius
private _poss = [[[_target_center, (d_cur_target_radius * 0.50)]],[[_target_center, (d_cur_target_radius * 0.05)]]] call BIS_fnc_randomPos;
private _x_mt_event_ar = [];

private _trigger = [_poss, [160,160,0,false,30], ["ANYPLAYER","PRESENT",true], ["this","thisTrigger setVariable ['d_event_start', true]",""]] call d_fnc_CreateTriggerLocal;

waitUntil {sleep 0.1;!isNil {_trigger getVariable "d_event_start"}};

private _eventDescription = localize "STR_DOM_MISSIONSTRING_1805_MILITARY";
d_mt_event_messages_array pushBack _eventDescription;
publicVariable "d_mt_event_messages_array";

d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTEventSidePrisoners",d_kbtel_chan];
d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTEventDetonatePresent",d_kbtel_chan];

private _prisonerGroup = [d_own_side] call d_fnc_creategroup;

private _distance_to_rescue = 3.5; //in meters
private _event_succeed_points = 10;
private _allActors = [];

__TRACE_1("","_prisonerGroup")
// select a starting point, units will be moved later to occupy a building if possible
private _nposss = _poss findEmptyPosition [0, 99, d_sm_pilottype];
if (_nposss isEqualTo []) then {_nposss = _poss};

// create pilot1
private _pilot1 = _prisonerGroup createUnit [d_sm_pilottype, _nposss, [], 0, "NONE"];
_x_mt_event_ar pushBack _pilot1;
_allActors pushBack _pilot1;
[_pilot1, 30] call d_fnc_nodamoffdyn;
__TRACE_1("","_pilot1")
_pilot1 call d_fnc_removenvgoggles_fak;
removeHeadgear _pilot1;
_pilot1 unlinkItem (hmd _pilot1); //remove nvgs
[_pilot1, getPos _pilot1] call d_fnc_setposagls;

removeAllWeapons _pilot1;
_pilot1 setCaptive true;
_pilot1 enableStamina false;
_pilot1 enableFatigue false;
_pilot1 disableAI "PATH";
_pilot1 disableAI "RADIOPROTOCOL";
_pilot1 forceSpeed 0;
(leader _prisonerGroup) setSkill 1;
_prisonerGroup allowFleeing 0;

if (d_with_dynsim == 0) then {
	[_prisonerGroup] spawn d_fnc_enabledynsim;
};

sleep 2.333;

// create 3 enemy guards with unusual hat/bandanna to help players identify them
// enemy guards should always be standing and should not fire
private _hat_type = selectRandom ["H_Cap_red", "H_Shemag_olive_hs", "H_Bandanna_surfer"];
private _enemyGuardGroup = (["specops", 0, "allmen", 1, _nposss , 5, false, true, 3] call d_fnc_CreateInf) # 0;
{
	[_x, 30] call d_fnc_nodamoffdyn;
	_x forceSpeed 0;
	_x unlinkItem (hmd _x); //remove nvgs
	removeHeadgear _x;
	_x addHeadgear _hat_type;
	_x removeWeapon (secondaryWeapon _x); //remove launcher
	removeBackpack _x;
	_allActors pushBack _x;
	_x_mt_event_ar pushBack _x;
	_x disableAI "AUTOTARGET";
	_x setCombatMode "BLUE";
	_x setUnitPos "UP";
	_x setVariable ["d_unit_hold_fire", true]; // TODO
} forEach (units _enemyGuardGroup);

//find a suitable building and occupy
private _buildings_array_sorted_by_distance = [];
_buildings_array_sorted_by_distance = [[_nposss, 200] call d_fnc_getbldgswithpositions, _nposss] call d_fnc_sortarraybydistance;
private _unitsNotGarrisoned = [];
private _bldg = nil;
private _marker = nil;
private _spawnpos = _nposss;
if !(_buildings_array_sorted_by_distance isEqualTo []) then {
	_spawnpos = getPos (_buildings_array_sorted_by_distance # 0);
	_unitsNotGarrisoned = [_spawnpos, [_pilot1], 199, false, false, false, false, 2, false, true, false, -1, _buildings_array_sorted_by_distance # 0] call d_fnc_Zen_OccupyHouse;
};

private _use_starting_pos = false;
{
	_use_starting_pos = true;
	_spawnpos = _nposss;
	diag_log [format ["fn_event_sideprisoners: failed to garrison and will remain in starting position: %1", _x]];
} forEach _unitsNotGarrisoned;

_marker = ["d_mt_event_marker_sideprisoners", _spawnpos, "ICON","ColorBlack", [1, 1], localize "STR_DOM_MISSIONSTRING_PRISONERSANDEXPLOSIVES", 0, "mil_triangle"] call d_fnc_CreateMarkerGlobal;
[_marker, "STR_DOM_MISSIONSTRING_PRISONERSANDEXPLOSIVES"] remoteExecCall ["d_fnc_setmatxtloc", [0, -2] select isDedicated];

if !(_use_starting_pos) then {
	_unitsNotGarrisoned = [_spawnpos, units _enemyGuardGroup, 199, false, false, false, false, 2, false, true, false, -1, _buildings_array_sorted_by_distance # 0] call d_fnc_Zen_OccupyHouse;
};

{
	deleteVehicle _x;
} forEach _unitsNotGarrisoned;


private _all_dead = false;
private _is_rescued = false;

while {sleep 3.14; !d_mt_done; !_is_rescued} do {
	if (!alive _pilot1) exitWith { _all_dead = true };
	
	if (({alive _x} count units _enemyGuardGroup) > 0) then {
		if ((units _enemyGuardGroup) findIf {(damage _x) > 0.05} != -1) then {
			// a unit in enemyGuardGroup was wounded, soon guards will shoot prisoner and a bomb will explode
			// brief delay until the guards are free to move and attempt to execute the prisoner
			sleep 3;
			_pilot1 setCaptive false;
			{	
				//todo - play a sound?
				_x forceSpeed -1;
			} forEach (units _enemyGuardGroup);
			// another brief delay, players must kill all guards or an explosion will occur
			sleep 7;
			if (({alive _x} count units _enemyGuardGroup) > 0) then {
				// not all of the guards were killed so a suicide bomb is triggered
				_bomb_type = "Rocket_04_HE_F"; //TODO: bigger??
				_bomb = _bomb_type createVehicle [0,0,5000];
				_bomb setPosASL eyePos _pilot1;
				// inform the players of the failure
				sleep 7;
				d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTEventDetonateFail",d_kbtel_chan];
			};
		};
	} else {
		// all enemy guards have been killed, pilot can now be "rescued" if players are near
		private _nobjs = (_pilot1 nearEntities ["CAManBase", _distance_to_rescue]) select {alive _x && {(isPlayer _x) && {!(_x getVariable ["xr_pluncon", false]) && {!(_x getVariable ["ace_isunconscious", false])}}}};
		if (_nobjs isNotEqualTo []) exitWith {
			__TRACE("rescued _pilot1")
			_is_rescued = true;
			_pilot1 setDamage 0;
			sleep 12;
			deleteVehicle _pilot1;
			// todo announce player
		};
	};
};

if (_all_dead) then {
	d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTEventSidePrisonersFail",d_kbtel_chan];
} else {
	d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTEventSidePrisonersSucceed",d_kbtel_chan];
	d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTEventDetonateSuccess",d_kbtel_chan];
	d_kb_logic1 kbTell [
		d_kb_logic2,
		d_kb_topic_side,
		"EventSucceed",
		["1", "", str _event_succeed_points, []],
		d_kbtel_chan
	];
	{
		_x addScore _event_succeed_points;
	} forEach ((allPlayers - entities "HeadlessClient_F") select {!(_x isKindOf "VirtualMan_F")});
};

d_mt_event_messages_array deleteAt (d_mt_event_messages_array find _eventDescription);
publicVariable "d_mt_event_messages_array";

deleteVehicle _trigger;
deleteMarker _marker;

if (d_ai_persistent_corpses == 0) then {
	waitUntil {sleep 10; d_mt_done};
} else {
	sleep 120;
};

// cleanup
diag_log [format ["cleanup of event: %1", _mt_event_key]];
_x_mt_event_ar call d_fnc_deletearrayunitsvehicles;
