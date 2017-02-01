params ["_caller","_container","_type","_mode"];

_containerForts = _container getVariable ["grad_fortifications_myFortsHash",[[],0] call CBA_fnc_hashCreate];
_containerStock = [_containerForts,_type] call CBA_fnc_hashGet;

_callerForts = _caller getVariable ["grad_fortifications_myFortsHash",[[],0] call CBA_fnc_hashCreate];
_callerStock = [_callerForts,_type] call CBA_fnc_hashGet;

switch (_mode) do {
    case ("BUILD"): {
        if (_containerStock > 0) then {
            [_container,_type] call grad_fortifications_fnc_removeFort;
            [_container] remoteExec ["grad_fortifications_fnc_updateItemList",0,false];
            [_type,"DROPPED",_caller] remoteExec ["grad_fortifications_fnc_startPlacement",0,false];
        };
    };
    case ("STORE"): {
        if ([_container,_type] call grad_fortifications_fnc_canTake) then {
            [_container,_type] call grad_fortifications_fnc_addFort;
            [_container] remoteExec ["grad_fortifications_fnc_updateItemList",0,false];
        } else {
            //reimburse
            [_caller,_type] call grad_fortifications_fnc_addFort;
        };
    };
    case ("TAKE"): {
        if (_containerStock > 0) then {
            [_container,_type] call grad_fortifications_fnc_removeFort;
            [_caller,_type] call grad_fortifications_fnc_addFort;
            [_caller,_container] remoteExec ["grad_fortifications_fnc_receiveFort",0,false];
        };
    };
};