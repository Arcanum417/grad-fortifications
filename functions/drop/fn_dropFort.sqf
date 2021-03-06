#include "..\..\dialog\menu\defines.hpp"

params ["_type",["_mode","NORMAL"],"_pos"];
private ["_crateType"];

if (_mode == "NORMAL") then {
    [player,_type] call grad_fortifications_fnc_removeFort;
};

_crateType = if (isClass (configfile >> "CfgPatches" >> "CUP_Core")) then {"Fort_Crate_wood"} else {"Land_WoodenCrate_01_F"};
_crate = createVehicle [_crateType,[0,0,0],[],0,"NONE"];
_crate setDir (random 360);

if (isNil "_pos") then {
    _pos = (player getRelPos [2.5,0]) findEmptyPosition [0, 10, _crateType];
    if (count _pos == 0) exitWith {};
    _crate setPos _pos;
} else {
    _crate setPosASL _pos;
};

if (count _pos == 0) exitWith {systemChat "No position found. Fortification added to inventory."; player say2d "AddItemFailed"; [player,_type] call grad_fortifications_fnc_addFort};
[_crate,_type] remoteExec ["grad_fortifications_fnc_initDropCrate",0,true];


disableSerialization;
_dialog = findDisplay grad_fortifications_DIALOG;
_listCtrl = _dialog displayCtrl grad_fortifications_ITEMLIST;
[] call grad_fortifications_fnc_updateItemList;
