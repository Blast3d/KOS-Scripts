//WAC Corporal Launch
MAIN().
//Variables
//Functions
local FUNCTION Launch{

    PRINT "TAKEOFF!".
    STAGE.
    Wait 1.5. STAGE.
}
//MAIN
local FUNCTION MAIN{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LAUNCH().
}
//Todo