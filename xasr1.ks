//XASR-1 Launch has parachute
// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO NOT uncomment it or it breaks the code.
//------------- Special Directive-------------//
// #include func_lib.ks
//--------------------------------------------//
MAIN().
//Variables
set oldApoapsis to ship:altitude + 1000.
set mainChute to 4999. // adjust height for thes two vars, according to what you set the parachutes deployment height to.
set drogueChute to 12000. //same as above
set stageDone to false.
//Functions
local FUNCTION XasrLaunch{

    PRINT "TAKEOFF!".
    STAGE.
    Wait 3.2. STAGE.
    wait 0.8. STAGE.
    CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Close Terminal").
}
//MAIN
local FUNCTION MAIN{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    XasrLaunch().
    CheckAltitude().

}
//Todo