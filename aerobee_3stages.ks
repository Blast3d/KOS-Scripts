// 3 stage Aerobee launch script 
// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO not uncomment it or it breaks.
//------------- Special Directive-------------//
// #include func_lib.ks
//--------------------------------------------//
//-----------------Variables--------------------
set oldApoapsis to ship:altitude + 1000.
set mainChute to 4999. // adjust height for thes two vars, according to what you set the parachutes deployment height to.
set drogueChute to 12000. //same as above
set stageDone to false.
//set thrust to ship:availablethrust.
Main().

//-------------Functions-------------------
FUNCTION Launch{
    wait 1.0.
    stage. 
    wait 1.6. stage.
    // stage.
    // wait 0.8. stage.
    CheckAltitude().
}




//-------------------Main-------------------------
FUNCTION Main{
    set SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LAUNCH().
}