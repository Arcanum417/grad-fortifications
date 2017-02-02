params ["_unit","_type",["_amount",1]];

if !(local _unit) exitWith {};

_myForts = _unit getVariable ["grad_fortifications_myFortsHash",[[],0] call CBA_fnc_hashCreate];

_stock = [_myForts,_type] call CBA_fnc_hashGet;
if (_stock+_amount <= 0) then {
    [_myForts,_type] call CBA_fnc_hashRem;
} else {
    [_myForts,_type,_stock+_amount] call CBA_fnc_hashSet;
};

_size = [_type] call grad_fortifications_fnc_getObjectSize;
if (_amount < 0) then {_size = -_size};
if (_stock+_amount >= 0) then {
    _unit setVariable ["grad_fortifications_inventoryCargo",(_unit getVariable ["grad_fortifications_inventoryCargo",0]) + _size, true];
};

_isPublic = !(_unit isKindOf "Man");
_unit setVariable ["grad_fortifications_myFortsHash",_myForts,_isPublic];
if (_isPublic) then {
    [_unit,_myForts] remoteExec ["grad_fortifications_fnc_updateItemList",0,false];
} else {
    [] call grad_fortifications_fnc_updateItemList;
};
