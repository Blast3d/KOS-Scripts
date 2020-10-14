CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
MainBoot().

//VARS
SET inputText TO terminal:input:getchar().
//---------------------MAIN BOOT-----------------------------

FUNCTION MainBoot {
    Warning().
    Activate().
    Archive().

}