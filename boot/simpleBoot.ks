
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
FUNCTION dir { // just a simple container for the runpath command to shorten when calling in multiple locations
    RUNPATH("0:/bumper.ks").
}
FUNCTION Activate { // activates the launch when certain keys pressed
    local inputText TO terminal:input:getchar().
   
    IF inputText = "y" {
        print"Launch initialized.".
        dir().
         
    } ELSE if inputText = "n" { // added this just to be interactive really you can ommit anything on this line and below and it will just wait until you press y. but incase you accidently hit the wrong key the else statement will let you know which is nice!
        
        Print"press y when ready to Launch".
        local newInputText TO terminal:input:getchar().
        if newInputText = "y"{
            dir().
        } else {
            Print "Press y when ready".
            Activate().
        }
        
        
    } else {
       Print "You need to type y or n, try again".
       Activate().
    }
}
wait 2.0.
clearscreen.
HUDTEXT("Press y to boot local script or press n to abort launch.", 5, 2, 15, yellow, true).
Activate().
//RUNPATH("0:/bumper.ks").
