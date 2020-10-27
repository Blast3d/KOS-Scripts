//Redstone class
// Author: Jake Henry(Blast)
//@lazyGlobal off.
// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO not uncomment it or it breaks.
//------------- Special Directive-------------//
// #include func_lib.ks
//--------------------------------------------//
runoncepath("0:/func_lib").
set runBumper to false. // change to true if using Bumper class
set jupiterA to false.
lock runRedstone to true.
Main().
//-----------------Variables--------------------


//-------------Functions-------------------
FUNCTION RedstoneLaunch {
    wait 0.0.
    stage.
    PRINT "TAKEOFF!".
    wait 3.8. stage.
    CheckMotion().
}



//-------------------Main-------------------------
local FUNCTION Main{
    set SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    RedstoneLaunch().
}