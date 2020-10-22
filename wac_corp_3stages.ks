//3 stage WAC Corporal launch script
// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO not uncomment it or it breaks.
//------------- Special Directive-------------//
// #include func_lib.ks
//--------------------------------------------//
Main().
//Variables
//Functions
local FUNCTION WacLaunch{
    CLEARSCREEN.
    SET count TO 10.
        UNTIL count < 1 {
    SET count TO count - 1.
    PRINT "COUNTDOWN T- " + count +"seconds".
    WAIT 1.0.
    CLEARSCREEN.
    }

    PRINT "TAKEOFF!".
    stage.
    wait 1.5. stage. clearScreen.
    wait 0.6. stage.
}
//Main
 local FUNCTION Main{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
   WacLAUNCH().
}