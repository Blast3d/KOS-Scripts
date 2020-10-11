//WAC Corporal Launch
MAIN().
//Variables
//Functions
FUNCTION Launch{

    PRINT "TAKEOFF!".
    STAGE.
    Wait 1.5. STAGE.
}
//MAIN
FUNCTION MAIN{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LAUNCH().
}
//Todo