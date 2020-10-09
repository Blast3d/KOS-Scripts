// 3 stage Down Range Aerobee launch script 
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
FUNCTION CheckAltitude {
    if ship:altitude < oldApoapsis {
        GetApoapsis().
    } else if ship:altitude > oldApoapsis {
        DeployChute().
    } 
}
FUNCTION GetApoapsis{
    wait 2.0.
    clearscreen.
    set oldApoapsis to ship:apoapsis * 0.97.
    print"old Apoapsis " + oldApoapsis.
    print"new Apoapsis " + apoapsis.
    CheckAltitude().
}
FUNCTION DeployChute {
    stage.
    // wait until ship:altitude < 21000.  remove comments and this text if recovering 
    // toggle ag1. print"Drogue parachute deployed".
    wait until ship:altitude < 4999.
    clearScreen.
    toggle ag2. print" main parachute deployed".
}
//-------------------Main-------------------------
FUNCTION Main{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LAUNCH().
}