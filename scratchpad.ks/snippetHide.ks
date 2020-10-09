
    // SET count TO 10.
    //     UNTIL count < 1 {
    // SET count TO count - 1.
    // PRINT "COUNTDOWN T- " + count +"seconds".
    // WAIT 1.0.
    // CLEARSCREEN.
    // } 

    g = 9.807 // gravity
    isp * g * ln(wetMass/dryMass) // rocket equation
    FUNCTION GetIsp{
    list engines in myShip.
    for eng in myShip
    print"ISP: " + eng:isp.
}
    GetIsp().
    FUNCTION GetDv{ 
        set ln to wMass/dMass. 
        g*Isp*ln.
    }w