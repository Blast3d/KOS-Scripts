// Controlled  boot
// Author: Blast
//----------------------------------------------------------------------------------------//


// Initialize: open the kOS terminal reliably when vessel loads
FUNCTION SafeOpenTerminal {
    PARAMETER attempts.
    IF attempts = 0 { SET attempts TO 8. }.
    // Give the flight scene a tick to settle
    WAIT 0.
    LOCAL i IS 0.
    UNTIL i >= attempts {
        // Attempt to open the terminal repeatedly (no try/catch in kOS)
        CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
        WAIT 0.2.
        SET i TO i + 1.
    }.
} 

// (removed old placeholders: bootInput, fileCheck, DOWNLOAD, boot)

FUNCTION Warning{
    HUDTEXT("Warning: CHECK STAGING!", 5, 2, 15, red, true).
    WAIT 3.0.
    CLEARSCREEN.
}

FUNCTION Activate {
    HUDTEXT("Press y to boot local script or press n to abort launch.", 5, 2, 15, yellow, true).
    WAIT UNTIL terminal:input:haschar.
    LOCAL inputText IS terminal:input:getchar().
    IF inputText = "y" {
        PRINT "Launch initialized.".
        // After confirming, show selection menu (Archive first, then Local) and run chosen script
        SelectAndRunScript().
    } ELSE IF inputText = "n" {
        PRINT "Launch aborted.".
    } ELSE {
        PRINT "Please press y to run or n to abort.".
        Activate().
    }
}

FUNCTION RunHardcodedLaunch {
     //Backward-compatible hardcoded launcher
    // Copy from archive to local CPU, then run from local
    COPYPATH("0:/aerobee_3stages.ks", "1:/aerobee_3stages.ks").
    RUNPATH("1:/aerobee_3stages.ks").
}

// Utility: run a script by name from Archive (volume 0)
FUNCTION RunScriptByName {
    PARAMETER scriptName.
    // Copy from archive root to local root using absolute paths, then run locally
    COPYPATH("0:/" + scriptName, "1:/" + scriptName).
    RUNPATH("1:/" + scriptName).
}

// Build lists for Archive and Local volumes
FUNCTION ListKsFilesArchive {
    LOCAL ksFiles IS LIST().
    LOCAL rootdir IS ARCHIVE:ROOT.
    FOR f IN rootdir {
        IF f:ISFILE AND (f:EXTENSION = "ks" OR f:EXTENSION = "KS") {
            ksFiles:ADD(f:NAME).
        }
    }.
    RETURN ksFiles.
}

FUNCTION ListKsFilesLocal {
    LOCAL ksFiles IS LIST().
    LOCAL localVol IS VOLUME(1).
    LOCAL rootdir IS localVol:ROOT.
    FOR f IN rootdir {
        IF f:ISFILE AND (f:EXTENSION = "ks" OR f:EXTENSION = "KS") {
            ksFiles:ADD(f:NAME).
        }
    }.
    RETURN ksFiles.
}

// Interactive menu with Archive+Local fallback
FUNCTION SelectAndRunScript {
    LOCAL origin IS 0.
    LOCAL files IS ListKsFilesArchive().
    IF files:LENGTH = 0 {
        SET files TO ListKsFilesLocal().
        SET origin TO 1.
    }.
    IF files:LENGTH = 0 {
        PRINT "No .ks files found on Archive or Local.".
        PRINT "Falling back to hardcoded launch...".
        RunHardcodedLaunch().
        RETURN.
    }.

    CLEARSCREEN.
    IF origin = 0 {
        PRINT "Available .ks scripts on Archive:".
    } ELSE {
        PRINT "Available .ks scripts on Local (1:/):".
    }.
    LOCAL i IS 0.
    UNTIL i >= files:LENGTH {
        PRINT (i+1) + ". " + files[i].
        SET i TO i + 1.
    }.
    PRINT "".
    HUDTEXT("Press number for script to run", 5, 2, 15, yellow, true).

    LOCAL selection IS 0.
    WAIT UNTIL terminal:input:haschar.
    LOCAL key IS terminal:input:getchar().
    IF key = "1" SET selection TO 1.
    ELSE IF key = "2" SET selection TO 2.
    ELSE IF key = "3" SET selection TO 3.
    ELSE IF key = "4" SET selection TO 4.
    ELSE IF key = "5" SET selection TO 5.
    ELSE IF key = "6" SET selection TO 6.
    ELSE IF key = "7" SET selection TO 7.
    ELSE IF key = "8" SET selection TO 8.
    ELSE IF key = "9" SET selection TO 9.

    IF selection < 1 OR selection > files:LENGTH {
        PRINT "Invalid selection. Try again.".
        WAIT 0.5.
        SelectAndRunScript().
        RETURN.
    }.

    LOCAL chosenName IS files[selection-1].
    PRINT "Running: " + chosenName.
    IF origin = 0 {
        RunScriptByName(chosenName).
    } ELSE {
        RUNPATH("1:/" + chosenName).
    }.
}

//---------------------MAIN BOOT-----------------------------

FUNCTION MainBoot {
    Warning().
    Activate().
}

// Entry points (placed after function definitions)
SafeOpenTerminal(8).
MainBoot().
