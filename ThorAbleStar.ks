// Bumper w/ WAC Corpoaral script 
// Author: Jake Henry(Blast)
//@lazyGlobal off.
// the directive below although commented is used with the KOS extension for VScode and is used by the extension to include <filename>. DO not uncomment it or it breaks.
//------------- Special Directive-------------//
// #include func_lib/function_lib.ks
//--------------------------------------------//
//runoncepath("0:/func_lib/function_lib").
runpath("0:/func_lib/function_lib").
Main().
//-----------------Variables--------------------


//-------------Functions-------------------





//-------------------Main-------------------------
local FUNCTION Main{
    set SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.0.
    AbleStarLaunch().
}