// AUTHOR: Jake Henry(Blast)
// function library

//################  Variables  ################//
set oldApoapsis to ship:altitude + 1000.
set mainChute to 4999. // adjust height for thes two vars, according to what you set the parachutes deployment height to.
set drogueChute to 12000. //same as above
set karminLine to 100000.
set Reentry to 140000.
set ableStage to 140000.
set bumperFinalStage to 140000. // change to aprop height (70k is default)
// set northDir to 0.
// set eastDir to 90.
// set southDir to 180.
// set westDir to 270.
//set thrust to ship:availablethrust.

//################  Functions  ################//
FUNCTION Launch{ // launches WAC Corporal and Aerobeee type sounding rockets that neeed timed stages.
    wait 1.0.
    PRINT "TAKEOFF!".
    stage.
    wait 1.5. stage. clearScreen.
    wait 2.4. stage.
    CheckAltitude().
}
FUNCTION AbleStarLaunch{

    wait 0.1. stage.
    PRINT "Ignition!".
    wait 3.5. stage. // need to fix otherwise 3.8 for Bumper with the WAC Corp.
    clearScreen.
    wait until stage:ready. 
    stage.
    PRINT "Launch!".
    CheckMotionAble().
}

FUNCTION BumperLaunch{
    SAS ON. 
    wait 0.1.
    stage.
    PRINT "TAKEOFF!".
    wait 3.5. stage. // need to fix otherwise 3.8 for Bumper with the WAC Corp.
    CheckMotion().
}

FUNCTION checkConnection{
    if CONTROLCONNECTION = false {DeployChute().}
}
FUNCTION CheckMotionAble{ // check to see if moving in the right direction or not
    local startingAltitude to ship:altitude.

    if ship:altitude <= startingAltitude { wait 8.0. } // change for slower ships (default is 2.0)
    CheckAltitudeAble(). //TODO: Create if else to change from Bcheck if bumper or checkAltitude if something else
    //TODO:
    //create a function to check for each ships status so as to not have to change Bool for each ship when runningh a new type
}
FUNCTION CheckMotion{ // check to see if moving in the right direction or not
    local startingAltitude to ship:altitude.

    if ship:altitude <= startingAltitude { wait 8.0. } // change for slower ships (default is 2.0)
    set runBumper to true. // change to true if using Bumper class
    set runV2 to false. // change this back to false if using bumper class
    set jupiterA to false.
    CheckAltitude(). //TODO: Create if else to change from Bcheck if bumper or checkAltitude if something else
    //TODO:
    //create a function to check for each ships status so as to not have to change Bool for each ship when runningh a new type
}

FUNCTION CheckAltitude{ // checks ships current alt against old apo
    if ship:altitude < oldApoapsis {
        GetApoapsis().
    } else if ship:altitude > oldApoapsis {
        clearscreen.
        print"Vessel has reached Apoapsis".
        FinalSafeStage().
        DeployChute(drogueChute, mainChute). // param 1 = height for Realchute Drogue deploy that you set in the action group menu. param 2 is the height for the main chute.
    } 
}
function DoAbleStage {
    Wait 30.
    Stage.
    RCS ON.
    wait until stage:ready.
    stage.
    wait 3.5.

    wait until Maxthrust = 0. Stage.
    RCS off.
    
}
FUNCTION CheckAltitudeAble{ // checks ships current alt against old apo 
    if ship:altitude < oldApoapsis and ship:altitude >= AbleStage {
        wait until Maxthrust = 0. Stage.
        DoAbleStage().
        wait until ship:altitude > ship:apoapsis.
        clearscreen.
        print"Vessel has reached old Apoapsis".
        wait until ship:altitude < Reentry.
        clearScreen.
        RCS on.
        toggle ag3. print"Rentry Program initialized". // gets ready for reentry
        DeployChute(drogueChute, mainChute). // param 1 = height for Realchute Drogue deploy that you set in the action group menu. param 2 is the height for the main chute.
    }
    else if ship:altitude < oldApoapsis {
        GetApoapsisAble().
    } else {
        print"error in Checkaltitude function".
        abort().
    }
}
FUNCTION BCheckAltitude{ //bumper and Jbumper exclusive. checks ship altittude against old apo and karmin line to verify if things are working.
    if ship:altitude < oldApoapsis and ship:altitude < bumperFinalStage {
        GetApoapsis().
    } else if ship:altitude > oldApoapsis or ship:altitude > bumperFinalStage { // if using new bumper set this var to bumperFinalStage else set to karminLine
        V2ClassCheck().
    } 
}

FUNCTION JFinalStage{
    wait until ship:altitude < 10000. 
        stage. 
    DeployChute(drogueChute, mainChute).
}
FUNCTION JStaging{
        wait until stage:ready.
        stage.
        wait until stage:ready.
        stage. 
        wait until stage:ready.
        stage.
    }
FUNCTION JCheckAltitude{ //Jupiter exclusive. checks ship altittude against old apo and karmin line to verify if things are working.
    if ship:altitude < oldApoapsis and ship:altitude < karminLine {
        GetApoapsis().
    } else if ship:altitude > oldApoapsis or ship:altitude > karminLine {
        JStaging().
        SateliteDeployment().
    } 
}

FUNCTION SateliteDeployment{
    wait until ship:availablethrust < 0.01. 
        stage.
        JFinalStage().      
    
}
FUNCTION GetApoapsisAble{ //prints old and new apo and if moving in the right direction sets the old apo 
                    //to the new apo causing 98%(90% if a faster moving rocket like a wac or aerobee )
                    // difference in actual apoapsis so that the old apo is always trailing the actual apo. when rocket is higher than old apo then it moves on
    FUNCTION DisplayApo{
        print"old Apoapsis " +  CEILING(oldApoapsis).
        print"new Apoapsis " +  CEILING(apoapsis).
    }
    wait 4.// 2.0
    clearscreen.

    set oldApoapsis to ship:apoapsis * 0.98.
            DisplayApo().
            CheckAltitudeAble().
}
FUNCTION GetApoapsis{ //prints old and new apo and if moving in the right direction sets the old apo 
                    //to the new apo causing 98%(90% if a faster moving rocket like a wac or aerobee )
                    // difference in actual apoapsis so that the old apo is always trailing the actual apo. when rocket is higher than old apo then it moves on
    FUNCTION DisplayApo{
        print"old Apoapsis " +  CEILING(oldApoapsis).
        print"new Apoapsis " +  CEILING(apoapsis).
    }
    wait 1.// 2.0
    clearscreen.

    FUNCTION ShipClassCheck{
        if runBumper = true or runV2 = true { // decides if the bumper is active rocket
            set oldApoapsis to ship:apoapsis * 0.98.
            DisplayApo().
            BCheckAltitude().

        }else if jupiterA = true {
            set oldApoapsis to ship:apoapsis * 0.98.
            DisplayApo().
            JCheckAltitude().

        } else {
            set oldApoapsis to ship:apoapsis * 0.90.
        
            DisplayApo().
            CheckAltitude().
        }
    }
    ShipClassCheck().
}

FUNCTION DeployChute{ //Deploys parachutes and takes two parameters for realchute settings done in action groups for realchute.
    parameter drogueDeployHeight.
    parameter mainDeployHeight.
    wait until ship:altitude < drogueDeployHeight. 
    toggle ag1. print"Drogue parachute deployed". // ag1 = Drogue.
    wait until ship:altitude < mainDeployHeight.
    clearScreen.
    toggle ag2. print" main parachute deployed". // ag2 = Main chute.
    TerminateProgram().
} 
FUNCTION TerminateProgram{
    clearscreen.
    print"Staging complete, Standby for program termination". wait 2.0.
    SET count TO 10.
        UNTIL count < 1 {
    SET count TO count - 1.
    PRINT "Program Termination in " + count +" seconds".
    WAIT 1.0.
    CLEARSCREEN.
    }
    CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Close Terminal").
}

FUNCTION FinalSafeStage{ //  this seperates nose cone and Avionics in atmosphere (note probably don't need to wait and can lower the alt to 55 or so, also deterined based on rocket )
    when ship:altitude < 60000 then { 
        wait until stage:ready. 
        stage.
    }
   
}

FUNCTION Abort{
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
}
FUNCTION Warning{ // creates an alert on the main screen to notify that something went wrong if terminal not open
    HUDTEXT("Warning: ABORT!", 5, 2, 15, red, true).
    //TODO: 
    // need to make letters easier to see, too small
}

FUNCTION BumperStaging{
    //stage. 
        wait until stage:ready.
        //stage.
        wait 3.
        stage. 
        FinalSafeStage().
        DeployChute(drogueChute, mainChute).
}

FUNCTION V2Staging{
    stage. 
        wait until stage:ready.
        FinalSafeStage().
        DeployChute(drogueChute, mainChute).
}  

FUNCTION V2ClassCheck{ //exclusive to the V2Class. checks to see if ship alt is higher than the old apo below too soon or not.
     if ship:altitude < 20000 {
        Abort().
    } else if runBumper = true { // this is for all cases that are nominal.
        BumperStaging().
    } else if runV2 = true {
        V2Staging().
    } else {
        print"ERROR: you should not see this!". // Need to write a better handler for multiple rockets but this will do for now.
    }
    
}

//################  BOOT FUNCTIONS  #################//
FUNCTION BootWarning{
        HUDTEXT("Warning: CHECK STAGING!", 5, 2, 15, red, true).
        WAIT 3.0.
        CLEARSCREEN.
}

FUNCTION Archive {
    RUNPATH("0:/wac_corp.ks").
}

