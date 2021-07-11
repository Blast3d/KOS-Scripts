//XASR-1 Launch has parachute
// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO NOT uncomment it or it breaks the code.
//------------- Special Directive-------------//
// #include func_lib/function_lib.ks
//--------------------------------------------//
runoncepath("0:/func_lib/function_lib").
MAIN().
//Variables
set oldApoapsis to ship:altitude + 1000.
set mainChute to 4999. // adjust height for thes two vars, according to what you set the parachutes deployment height to.
set drogueChute to 12000. //same as above
//set stageDone to false.
//Functions
FUNCTION XasrLaunch{

    PRINT "TAKEOFF!".
    STAGE.
    Wait 3.2. STAGE.
    wait 0.8. STAGE.
}

FUNCTION ifTwoStageXasrLaunch{

    PRINT "TAKEOFF!".
    STAGE.
    Wait 5.0. STAGE.
    Wait 3.2. STAGE.
    wait 0.8. STAGE.
}
//MAIN
FUNCTION MAIN{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    //XasrLaunch().
    ifTwoStageXasrLaunch().
    //CheckAltitude().

}
//Todo