//3 stage WAC Corporal launch script
Main().
//Variables
//Functions
FUNCTION Launch{
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
FUNCTION Main{
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    LAUNCH().
}