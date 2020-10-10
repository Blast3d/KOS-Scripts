// Bumper w/ WAC Corpoaral script 
// Author: Jake Henry(Blast)
//@lazyGlobal off.
runoncepath("0:/function_lib").
//-----------------Variables--------------------
Main().

//-------------Functions-------------------





//-------------------Main-------------------------
FUNCTION Main{
    set SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    BumperLaunch().
}