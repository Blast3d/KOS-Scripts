// 3 stage Aerobee launch script 
//-----------------Variables--------------------
set oldApoapsis to ship:altitude + 1000.
set mainChute to 4999. // adjust height for thes two vars, according to what you set the parachutes deployment height to.
set drogueChute to 12000. //same as above
//set thrust to ship:availablethrust.
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
FUNCTION CheckAltitude{
    if ship:altitude < oldApoapsis {
        GetApoapsis().
    } else if ship:altitude > oldApoapsis {
        FinalSafeStage().
        DeployChute(drogueChute, mainChute). // param 1 = height for Realchute Drogue deploy that you set in the action group menu. param 2 is the height for the main chute.
    } 
}
FUNCTION GetApoapsis{
    wait 2.0.
    clearscreen.
    set oldApoapsis to ship:apoapsis * 0.90.
    print"old Apoapsis " + oldApoapsis.
    print"new Apoapsis " + apoapsis.
    CheckAltitude().
}
FUNCTION DeployChute{
    parameter drogueDeployHeight.
    parameter mainDeployHeight.
    wait until ship:altitude < drogueDeployHeight. 
    toggle ag1. print"Drogue parachute deployed".
    wait until ship:altitude < mainDeployHeight.
    clearScreen.
    toggle ag2. print" main parachute deployed".
}  
FUNCTION FinalSafeStage{
     when ship:altitude < 65000 then {
        print "stage". 
        wait 5.0. 
        stage.
    }

}


//-------------------Main-------------------------
FUNCTION Main{
    set SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LAUNCH().
}