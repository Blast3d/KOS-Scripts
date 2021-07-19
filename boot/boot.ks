// Controlled  boot
// Author: Blast
//----------------------------------------------------------------------------------------//


//Initiialize
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

//Ask if you want to continue with Boot
FUNCTION bootInput{
    //TO DO
}
// Check for File 
FUNCTION fileCheck {
    //TO DO
}
//If the file exists already delete it and replace with the new version
// if it doesn't exist download it.
FUNCTION DOWNLOAD {
    //TO DO
}
// start new program
FUNCTION boot {
    //TO DO
}
 //------------------------Temp--------------------------------
 //Initiialize
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
MainBoot().

//VARS
SET inputText TO terminal:input:getchar().

FUNCTION Warning{
    HUDTEXT("Warning: CHECK STAGING!", 5, 2, 15, red, true).
    WAIT 3.0.
    CLEARSCREEN.
}

FUNCTION Activate {
    HUDTEXT("Press y to boot local script or press n to abort launch.", 5, 2, 15, yellow, true).
    IF inputText = terminal:input:"y" {
        PRINT "it works!". //DEBUG, this needs to go away
    }ELSE{
        PRINT"You gay fucker". //DEBUG
    }
}

FUNCTION Archive {
SWITCH TO 0. 
COPYPATH("launch.ks","1").
RUNPATH("launch.ks").
}


//---------------------MAIN BOOT-----------------------------

FUNCTION MainBoot {
    Warning().
    Activate().
    //Archive(). Handled in SimpleBoot.ks for now

} // just added this for testing remote connection to Github