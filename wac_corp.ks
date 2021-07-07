//WAC Corporal Launch
// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO NOT uncomment it or it breaks the code.
//------------- Special Directive-------------//
// #include func_lib.ks
//--------------------------------------------//
MAIN().
//Variables
//Functions
local FUNCTION Launch{

    PRINT "TAKEOFF!".
    STAGE.
    Wait 3.2. STAGE.
    wait 0.8. STAGE.
    CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Close Terminal").
}
//MAIN
local FUNCTION MAIN{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LAUNCH().
}
//Todo