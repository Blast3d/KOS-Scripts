// 3 stage Down Range Aerobee launch script 
// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO not uncomment it or it breaks.
//------------- Special Directive-------------//
// #include func_lib.ks
//--------------------------------------------//
runoncepath("0:/func_lib").
//-----------------Variables--------------------
set oldApoapsis to 1000. //ship:altitude + ship:altitude * 0.05.

Main().

//-------------Functions-------------------
FUNCTION Launch{
    wait 1.0.
    PRINT "TAKEOFF!".
    stage.
    wait 1.5. stage. clearScreen.
    wait 2.4. stage.
    CheckAltitude().
}

//-------------------Main-------------------------
FUNCTION Main{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LAUNCH().
} 