// Bumper w/ WAC Corpoaral script 
// Author: Jake Henry(Blast)
//@lazyGlobal off.
runoncepath("0:/func_lib/function_lib").
Main().
//-----------------Variables--------------------


//-------------Functions-------------------





//-------------------Main-------------------------
local FUNCTION Main{
    set SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    BumperLaunch().
}