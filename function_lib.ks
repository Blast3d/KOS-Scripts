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
FUNCTION Launch{ // launches WAC Corporal and Aerobeee type sounding rockets that neeed timed stages.
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
FUNCTION CheckMotion{ // check to see if moving in the right direction or not
    local startingAltitude to ship:altitude.

    if ship:altitude <= startingAltitude { wait 2.0. }
    set runBumper to true.
    BCheckAltitude().
}
FUNCTION CheckAltitude{ // checks ships current alt against old apo 
    if ship:altitude < oldApoapsis {
        GetApoapsis().
    } else if ship:altitude > oldApoapsis {
        FinalSafeStage().
        DeployChute(drogueChute, mainChute). // param 1 = height for Realchute Drogue deploy that you set in the action group menu. param 2 is the height for the main chute.
    } 
}
FUNCTION BCheckAltitude{ //bumper and Jbumper exclusive. checks ship altittude against old apo and karmin line to verify if things are working.
    if ship:altitude < oldApoapsis and ship:altitude < karminLine {
        GetApoapsis().
    } else if ship:altitude > oldApoapsis or ship:altitude > karminLine {
        JBumperSafeStage().
    } 
}
FUNCTION GetApoapsis{ //prints old and new apo and if moving in the right direction sets the old apo 
                    //to the new apo causing 98%(90% if a faster moving rocket like a wac or aerobee )
                    // difference in actual apoapsis so that the old apo is always trailing the actual apo. when rocket is higher than old apo then it moves on
    FUNCTION DisplayApo{
        print"old Apoapsis " + oldApoapsis.
        print"new Apoapsis " + apoapsis.
    }
    wait 1.// 2.0
    clearscreen.
    if runBumper = true { // decides if the bumper is active rocket
        set oldApoapsis to ship:apoapsis * 0.98.
        DisplayApo().
        BCheckAltitude().
    } else {
        set oldApoapsis to ship:apoapsis * 0.90.
    
        DisplayApo().
        CheckAltitude().
    }
       
}

FUNCTION DeployChute{ //Deploys parachutes and takes two parameters for realchute settings done in action groups for realchute.
    parameter drogueDeployHeight.
    parameter mainDeployHeight.
    wait until ship:altitude < drogueDeployHeight. 
    toggle ag1. print"Drogue parachute deployed". // ag1 = Drogue.
    wait until ship:altitude < mainDeployHeight.
    clearScreen.
    toggle ag2. print" main parachute deployed". // ag2 = Main chute.
}  
FUNCTION FinalSafeStage{ //  this seperates nose cone and Avionics in atmosphere (note probably don't need to wait and can lower the alt to 55 or so, also deterined based on rocket )
     when ship:altitude < 65000 then {
        print "stage". 
        wait 5.0. 
        stage.
    }
} 
FUNCTION Warning{ // creates an alert on the main screen to notify that something went wrong if terminal not open
    HUDTEXT("Warning: ABORT!", 5, 2, 15, red, true).
    //TODO: 
    // need to make letters easier to see, too small
}   
FUNCTION JBumperSafeStage{ //exclusive to the Jumbo Bumper and Bumper. checks to see if ship alt is higher than the old apo below too soon or not.
     if ship:altitude < 20000 {
        Warning().
        toggle ag5. // kills main engine and no longer need retro rockets on the smaller stage
        wait until stage:ready.
        stage.
        DeployChute(drogueChute, mainChute).
        print "ABORT! ABORT!".
        //toggle ag3. wait 1.0. //starts Retro rockets (DEPRECATED)
        toggle ag4. //skips all other stages and seperates Avionics package for retrieval
        // TODO 
        // can probally move ag4 in front of the call to deploy chute. need to test
    } else { // this is for all cases that are nominal.
        stage. 
        wait until stage:ready.
        stage.
        wait 3.
        stage. 
        FinalSafeStage().
        DeployChute(drogueChute, mainChute).
    }
}
// TODO
