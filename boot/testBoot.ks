CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
MainBoot().

//VARS
SET inputText TO terminal:input:getchar().
//---------------------MAIN BOOT-----------------------------

FUNCTION MainBoot {
    Warning().
    Activate().
<<<<<<< HEAD
    Archive().
=======
    //Archive(). Handled in SimpleBoot.ks for now
>>>>>>> 014ccad20548abaed00e79937a6a1182f4cae89a

}