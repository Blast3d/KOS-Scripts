// Bumper w/ WAC Corpoaral script 
// Author: Jake Henry(Blast)
// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO not uncomment it or it breaks.
//------------- Special Directive-------------//
// #include func_lib.ks
//--------------------------------------------//
//@lazyGlobal off.
runoncepath("0:/function_lib").
//-----------------Variables------------------
Main().

//-------------Functions-----------------------


//-------------------Main----------------------
local FUNCTION Main{
    set SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    FinalSafeStage().
    wait 3.8. stage.
    CheckAltitude().
}