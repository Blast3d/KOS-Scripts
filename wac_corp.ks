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
    Wait 1.6. STAGE.
}
//MAIN
local FUNCTION MAIN{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LAUNCH().
}
//Todo