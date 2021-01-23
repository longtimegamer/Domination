// by Xeno
#define THIS_FILE "fn_dfps.sqf"
#include "..\x_setup.sqf"

if (!hasInterface || {d_force_isstreamfriendlyui == 1 || {isStreamFriendlyUIEnabled}}) exitWith {};

disableSerialization;
private _disp = uiNamespace getVariable "d_fpsresource";
if (isNil "_disp" || {isNull _disp}) then {
	"d_fpsresource" cutRsc ["d_fpsresource", "PLAIN"];
	_disp = uiNamespace getVariable "d_fpsresource";
};
(_disp displayCtrl 50) ctrlSetText str _this;
(_disp displayCtrl 51) ctrlSetText str (round diag_fps);
(_disp displayCtrl 52) ctrlSetText format ["%1 %2:%3", d_yt_loc2037, systemTime # 3, systemTime # 4];