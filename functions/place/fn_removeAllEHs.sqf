(findDisplay 46) displayRemoveEventHandler ["MouseZChanged",grad_fortifications_mousewheelEH];
(findDisplay 46) displayRemoveEventHandler ["MouseButtonUp",grad_fortifications_mousebuttonEH];
(findDisplay 46) displayRemoveEventHandler ["KeyDown",grad_fortifications_keydownEH];
(findDisplay 46) displayRemoveEventHandler ["KeyUp",grad_fortifications_keyupEH];

[grad_fortifications_updatePFH] call CBA_fnc_removePerFrameHandler;

player removeAction grad_fortifications_fireOverride;

["", ""] call ace_interaction_fnc_showMouseHint;
