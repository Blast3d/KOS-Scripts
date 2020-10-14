// Bumper w/ WAC Corpoaral script 
// Author: Jake Henry(Blast)

//@lazyGlobal off.
runoncepath("0:/function_lib").
//-----------------Variables------------------
Main().

//-------------Functions-----------------------


//-------------------Main----------------------
local FUNCTION Main{
    set SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    SafeStage().
    wait 3.8. stage.
    CheckAltitude().
}