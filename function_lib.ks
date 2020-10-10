// AUTHOR: Jake Henry(Blast)
// function library
//-----------------Variables--------------------
set oldApoapsis to ship:altitude + 1000.
set mainChute to 4999. // adjust height for thes two vars, according to what you set the parachutes deployment height to.
set drogueChute to 12000. //same as above
set karminLine to 140000.
// set northDir to 0.
// set eastDir to 90.
// set southDir to 180.
// set westDir to 270.
//set thrust to ship:availablethrust.
//-------------Functions-------------------
FUNCTION Launch{
    wait 1.0.
    PRINT "TAKEOFF!".
    stage.
    wait 1.5. stage. clearScreen.
    wait 2.4. stage.
    CheckAltitude().
}
FUNCTION BumperLaunch{
    wait 0.0.
    stage.
    PRINT "TAKEOFF!".
    wait 3.5. stage. // need to fix otherwise 3.8 for Bumper with the WAC Corp.
    CheckMotion().
}
FUNCTION CheckMotion{
    local startingAltitude to ship:altitude.

    if ship:altitude <= startingAltitude { wait 2.0. }
    set runBumper to true.
    BCheckAltitude().
}
FUNCTION CheckAltitude{
    if ship:altitude < oldApoapsis {
        GetApoapsis().
    } else if ship:altitude > oldApoapsis {
        FinalSafeStage().
        DeployChute(drogueChute, mainChute). // param 1 = height for Realchute Drogue deploy that you set in the action group menu. param 2 is the height for the main chute.
    } 
}
FUNCTION BCheckAltitude{
    if ship:altitude < oldApoapsis and ship:altitude < karminLine {
        GetApoapsis().
    } else if ship:altitude > oldApoapsis or ship:altitude > karminLine {
        JBumperSafeStage().
    } 
}
FUNCTION GetApoapsis{
    FUNCTION DisplayApo{
        print"old Apoapsis " + oldApoapsis.
        print"new Apoapsis " + apoapsis.
    }
    wait 1.// 2.0
    clearscreen.
    if runBumper = true {
        set oldApoapsis to ship:apoapsis * 0.98.
        DisplayApo().
        BCheckAltitude().
    } else {
        set oldApoapsis to ship:apoapsis * 0.90.
    
        DisplayApo().
        CheckAltitude().
    }
       
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
FUNCTION Warning{
    HUDTEXT("Warning: ABORT!", 5, 2, 15, red, true).
    
    
    
}   
FUNCTION JBumperSafeStage{
     if ship:altitude < 20000 {
        Warning().
        toggle ag5. // kills main engine
        wait until stage:ready.
        stage.
        DeployChute(drogueChute, mainChute).
        print "ABORT! ABORT!".
        //toggle ag3. wait 1.0. //starts Retro rockets
        toggle ag4. 
    } else {
        stage. 
        wait until stage:ready.
        stage.
        wait 3.
        stage. 
        FinalSafeStage().
        DeployChute(drogueChute, mainChute).
    }
}
