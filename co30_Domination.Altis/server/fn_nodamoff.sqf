// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_nodamoff.sqf"
#include "..\x_setup.sqf"

_this allowDamage false;
_this spawn {sleep 10; _this allowDamage true};