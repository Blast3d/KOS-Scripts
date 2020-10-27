// 3 stage Aerobee launch script

// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO not uncomment it or it breaks.
//------------- Special Directive-------------//
// #include func_lib.ks
//--------------------------------------------//
runoncepath("0:/func_lib.ks").

//-----------------Variables--------------------

set oldApoapsis to ship:altitude + 1000.
set mainChute to 4999. // adjust height for thes two vars, according to what you set the parachutes deployment height to.
set drogueChute to 12000. //same as above
//set runAerobee to true.
set runBumper to false.
set jupiterA to false.
set runV2 to false.

//set thrust to ship:availablethrust.
Main().

//-------------Functions-------------------
 
FUNCTION LaunchHi3Double{
    wait 1.0.
    stage. 
    //wait 1.6. stage. //uncomment for regular tiny tim 3 stage aero Hi
    wait 2.0. stage.
    wait 0.8. stage. // aerojet if not comment out
    when ResourceAmount("aeroBoostTank","ANILINE") < 3 then{ // aerojet if not comment out
        stage.
        wait 0.8.
        stage.
    }

    FUNCTION ResourceAmount {
        parameter tankTag,resName.
        local taggedTank IS ship:partstagged(tankTag)[0].
        for res IN taggedTank:resources {
            if res:name = resName {
                return res:AMOUNT.
            }
        }
        return 0.
    }
    CheckAltitude().
}
FUNCTION LaunchHi3{
    wait 1.0.
    stage. 
    wait 2.6. stage. 
    wait 2.0. stage.
    wait 0.6. stage.
    CheckAltitude().
}

FUNCTION LaunchAero{
    wait 1.0.
    stage. 
    wait 1.6. stage.
    stage.
    wait 1.8. stage.
    CheckAltitude().
}


//-------------------Main-------------------------
FUNCTION Main{
    set SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LaunchHi3Double().
}