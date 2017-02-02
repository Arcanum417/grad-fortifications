/*  Updates itemlist based on chosen category
*
*/

#define PREFIX grad
#define COMPONENT fortifications
#include "\x\cba\addons\main\script_macros_mission.hpp"

#include "..\..\dialog\menu\defines.hpp"
#include "..\..\dialog\vehicle\defines.hpp"

params [["_container",player getVariable ["grad_fortifications_currentContainer", player]],"_containerFortsHash"];
private ["_containerFortsHash"];

disableSerialization;

if (player getVariable ["grad_fortifications_currentContainer", player] != _container && player !=_container) exitWith {};

_dialog = findDisplay grad_fortifications_DIALOG;
_listCtrl = _dialog displayCtrl grad_fortifications_ITEMLIST;
_vehicleListCtrl = _dialog displayCtrl grad_fortifications_vehicle_ITEMLIST;
if (isNull _listCtrl) exitWith {};

if !([player getVariable ["grad_fortifications_myFortsHash",[[],0] call CBA_fnc_hashCreate]] call CBA_fnc_isHash) exitWith {ERROR("Player does not have myFortsHash.")};

_myFortsHash = player getVariable ["grad_fortifications_myFortsHash",[[],0] call CBA_fnc_hashCreate];
if (isNil "_containerFortsHash") then {
    _containerFortsHash = _container getVariable ["grad_fortifications_myFortsHash",[[],0] call CBA_fnc_hashCreate];
};


{
    _x params ["_control","_hash"];
    if (isNull _control) exitWith {};

    lnbClear _control;
    _listIndex = 0;
    _updateList = {
        _displayName = [_key] call grad_fortifications_fnc_getDisplayName;

        if (_value > 0) then {
            _control lnbAddRow [str _value, _displayName];
            _control lnbSetData [[_listIndex,0], _key];
            _listIndex = _listIndex + 1;
        };
    };
    [_hash, _updateList] call CBA_fnc_hashEachPair;

} forEach [[_listCtrl,_myFortsHash],[_vehicleListCtrl,_containerFortsHash]];

_itemCount = if (isNull _vehicleListCtrl) then {lnbSize _listCtrl select 0} else {(lnbSize _listCtrl select 0) + (lnbSize _vehicleListCtrl select 0)};
if (_itemCount == 0) exitWith {closeDialog grad_fortifications_DIALOG};

_lastSelectedContainer = player getVariable ["grad_fortifications_ui_lastSelectedContainer", player];
_listToSelect = switch (true) do {
    case (isNull _vehicleListCtrl): {0};
    case ((lnbSize _listCtrl select 0) == 0): {1};
    case (_lastSelectedContainer == player): {0};
    case ((lnbSize _vehicleListCtrl select 0) == 0): {0};
    default {1};
};

if (_listToSelect == 0) then {
    _lastSel = player getVariable ["grad_fortifications_ui_lastSelectedItem",0];
    _curSel = if (_lastSel > (lnbSize _listCtrl select 0)) then {0} else {_lastSel};
    _listCtrl lnbSetCurSelRow _curSel;
} else {
    _lastSel = _container getVariable ["grad_fortifications_ui_lastSelectedItem",0];
    _curSel = if (_lastSel > (lnbSize _vehicleListCtrl select 0)) then {-1} else {_lastSel};
    _vehicleListCtrl lnbSetCurSelRow _curSel;
};
