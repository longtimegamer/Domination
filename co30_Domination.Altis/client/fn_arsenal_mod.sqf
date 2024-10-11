// by Xeno
//#define __DEBUG__
#include "..\x_setup.sqf"

private _mods = _this apply {toLowerANSI _x};
__TRACE_1("","_mods")

private _items_no = if (!d_vn) then {
	["ItemMap", "ItemRadio", "ToolKit", "MineDetector"]
} else {
	["MineDetector"]
};

if (!d_gmcwg && {!d_vn && {!d_spe}}) then {
	_items_no append ["FirstAidKit", "Medikit", "ItemCompass", "ItemWatch"];
};

if (!d_ifa3 && {!d_gmcwg && {!d_unsung && {!d_csla && {!d_vn && {!d_spe}}}}}) then {
	_items_no append ["LaserDesignator", "Rangefinder", "NVGoggles", "NVGoggles_OPFOR", "NVGoggles_INDEP", "ItemGPS", "arifle_SDAR_F"];
};

if (d_cup || {d_rhs} || {d_pracs} || {d_jsdf}) then {
	_items_no append ["B_UavTerminal", "O_UavTerminal", "I_UavTerminal"];
};

if (d_cup) then {
	_items_no append ["SmokeShell", "SmokeShellGreen", "SmokeShellRed", "SmokeShellYellow", "SmokeShellPurple", "SmokeShellBlue"];
};

_items_no = _items_no apply {toLowerANSI _x};

#ifdef __DEBUG__
private _sourceaddonlistar = [];
#endif

private _findmodfnc = {
	__TRACE_1("_findmodfnc","_this")
	params ["_csal"];
	private _res = -1;
	private _csallow = toLowerANSI (_csal # 0);
	__TRACE_1("_findmodfnc","_csallow")
	__TRACE_1("_findmodfnc","_mods")
	_mods findIf {
		__TRACE_1("_findmodfnc","_x")
		__TRACE_1("_findmodfnc","count _x")
		__TRACE_1("_findmodfnc","count _csallow")
		_ret = if (count _x >= count _csallow) then {
			_x find _csallow == 0
		} else {
			_csallow find _x == 0
		};
		if (_ret) then {
			_res = 1;
		};
		_ret
	};
	_res
};

{
	private _ar = _x;
	__TRACE_1("","_x")
	private ["_item", "_kind", "_ok"];
	{
		_item = toLowerANSI _x;
		_ok = call {
			if (_item in _items_no) exitWith {false};
			if (d_with_ace && {_item find "ace_" == 0}) exitWith {false};
			if (!d_ifa3 && {!d_vn && {!d_spe && {"wetsuit" in _item || {"diving" in _item || {"rebreather" in _item}}}}}) exitWith {false};
			true
		};
		if (_ok) then {
			_kind = call {
				if (isClass (configFile >> "CfgWeapons" >> _x)) exitWith {
					"CfgWeapons"
				};
				if (isClass (configFile >> "CfgMagazines" >> _x)) exitWith {
					"CfgMagazines"
				};
				if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith {
					"CfgVehicles"
				};
				if (isClass (configFile >> "CfgGlasses" >> _x)) exitWith {
					"CfgGlasses"
				};
				"";
			};
			__TRACE_1("","_kind")
#ifdef __DEBUG__
			private _helpercsal = configSourceAddonList (configFile >> _kind >> _x);
			__TRACE_1("","_helpercsal")
			{
				if (_x find "WW2_SPE" == 0) then {
					_csalar pushBackUnique _x;
				};
			} forEach _helpercsal;
#endif
			__TRACE_1("","configSourceAddonList (configFile >> _kind >> _x)")
#ifdef __DEBUG__
			{
				if ("viet" in _x) then {
					_sourceaddonlistar pushBackUnique _x;
				};
			} forEach (configSourceAddonList (configFile >> _kind >> _x));
#endif
			if (_kind isNotEqualTo "" && {([configSourceAddonList (configFile >> _kind >> _x)] call _findmodfnc) == -1}) then {
				__TRACE_1("","_ar select _forEachIndex")
				_ar set [_forEachIndex, -1];
			};
		};
	} forEach _ar;
	_ar = _ar - [-1];
	bis_fnc_arsenal_data set [_forEachIndex, _ar];
} forEach bis_fnc_arsenal_data;

#ifdef __DEBUG__
	__TRACE("######################### configSourceAddonList #########################")
	{
		diag_log _x;
	} forEach _sourceaddonlistar;
	__TRACE("######################### configSourceAddonList #########################")
#endif