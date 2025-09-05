// Generic Sounding Rocket launcher
// Works for 1–3 stage solid stacks (e.g., Aerobee, WAC)
// Detects engines/decouplers by stage, supports solid hot-staging when staged as Engine -> Decoupler



// ----------------- Tips --------------------

// !!!!!!!!!!!!!!!!CHECK STAGIN!!!!!!!!!!!!!
//If your craft won’t Hotstage or Stages unwanted parts , try increasing HOTSTAGE_THRUST_RATIO to 0.5–0.6 so you light earlier in the SRB tail-off.
//If you need even tighter timing, reduce HOTSTAGE_SEP_DELAY to 0.02–0.03.

//------------------ Config ------------------
SET HOTSTAGE_THRUST_RATIO TO 0.40.    // When current stage thrust <= 40% of stage baseline, pre-light next engine (helps ullage)
SET HOTSTAGE_SEP_DELAY TO 0.05.       // Minimal delay between lighting next engine and separating to preserve acceleration
SET IGNITION_SETTLE_WAIT TO 0.2.      // Small wait after any STAGE event
SET MIN_SAFE_STAGE_ALT TO 100000.     // Meters AMSL (RSS): default 100 km safe separation altitude

//------------------ Utilities ------------------

FUNCTION SolidFuelPresent {
    // Returns true if any solid propellant is present in current stage
    // More robust than checking only "SolidFuel" (handles PSolidFuel, etc.)
    LOCAL resLex IS STAGE:RESOURCESLEX.
    IF resLex:HASKEY("SolidFuel") { RETURN TRUE. }.
    IF resLex:HASKEY("PSolidFuel") { RETURN TRUE. }.
    // Fallback: substring match for anything containing "solid"
    FOR k IN resLex:KEYS {
        IF k:TOLOWER():CONTAINS("solid") { RETURN TRUE. }.
    }.
    RETURN FALSE.
}.

FUNCTION NextStageHasEngine {
    // Returns true if the next stage in the staging stack contains an engine
    LOCAL cur IS STAGE:NUMBER.
    LOCAL nextStage IS cur - 1.
    LIST PARTS IN plist.
    FOR p IN plist {
        IF p:HASMODULE("ModuleEngines") OR p:HASMODULE("ModuleEnginesFX") OR p:HASMODULE("ModuleEnginesRF") {
            IF p:STAGE = nextStage { RETURN TRUE. }.
        }.
    }.
    RETURN FALSE.
}.

FUNCTION NextStageHasNonProp {
    // Returns true if the next stage contains a decoupler/fairing-jettison (non-prop event)
    LOCAL cur IS STAGE:NUMBER.
    LOCAL nextStage IS cur - 1.
    LIST PARTS IN plist.
    FOR p IN plist {
        IF p:STAGE = nextStage {
            IF p:HASMODULE("ModuleDecouple") OR p:HASMODULE("ModuleAnchoredDecoupler") OR p:HASMODULE("ModuleProceduralFairing") OR p:HASMODULE("ModuleJettison") OR p:HASMODULE("ModuleCargoBay") OR p:HASMODULE("ModuleParachute") {
                RETURN TRUE.
            }.
        }.
    }.
    RETURN FALSE.
}.

FUNCTION StageHasNonProp {
    PARAMETER stageNum.
    LIST PARTS IN plist2.
    FOR p2 IN plist2 {
        IF p2:STAGE = stageNum {
            IF p2:HASMODULE("ModuleDecouple") OR p2:HASMODULE("ModuleAnchoredDecoupler") OR p2:HASMODULE("ModuleProceduralFairing") OR p2:HASMODULE("ModuleJettison") OR p2:HASMODULE("ModuleCargoBay") OR p2:HASMODULE("ModuleParachute") {
                RETURN TRUE.
            }.
        }.
    }.
    RETURN FALSE.
}.

FUNCTION StageHasEngine {
    PARAMETER stageNum.
    LIST PARTS IN plist3.
    FOR p3 IN plist3 {
        IF p3:STAGE = stageNum {
            IF p3:HASMODULE("ModuleEngines") OR p3:HASMODULE("ModuleEnginesFX") OR p3:HASMODULE("ModuleEnginesRF") { RETURN TRUE. }.
        }.
    }.
    RETURN FALSE.
}.

FUNCTION PreflightInspect {
    PARAMETER span.
    LOCAL cur IS STAGE:NUMBER.
    LOCAL shown IS 0.
    LOCAL i IS cur.
    PRINT "[PF] --- Staging Summary ---".
    UNTIL i < 0 OR shown > span {
        // Collect parts in stage i
        LIST PARTS IN plistpf.
        LOCAL engTitles IS LIST().
        LOCAL npTitles IS LIST().
        FOR p IN plistpf {
            IF p:STAGE = i {
                IF p:HASMODULE("ModuleEngines") OR p:HASMODULE("ModuleEnginesFX") OR p:HASMODULE("ModuleEnginesRF") {
                    engTitles:ADD(p:TITLE).
                } ELSE IF p:HASMODULE("ModuleDecouple") OR p:HASMODULE("ModuleAnchoredDecoupler") OR p:HASMODULE("ModuleProceduralFairing") OR p:HASMODULE("ModuleJettison") OR p:HASMODULE("ModuleCargoBay") OR p:HASMODULE("ModuleParachute") {
                    npTitles:ADD(p:TITLE).
                }.
            }.
        }.
        PRINT "[PF] Stage " + i + ": engines=" + engTitles:LENGTH() + ", non-prop=" + npTitles:LENGTH() + ".".
        // List titles for clarity
        IF engTitles:LENGTH() > 0 {
            FOR t IN engTitles { PRINT "      ENG: " + t. }.
        }.
        IF npTitles:LENGTH() > 0 {
            FOR t2 IN npTitles { PRINT "      NP : " + t2. }.
        }.
        SET i TO i - 1.
        SET shown TO shown + 1.
    }.
    PRINT "[PF] ------------------------".
}.

FUNCTION AnyActiveEngines {
    // True if vessel is currently producing thrust (engine-agnostic)
    RETURN SHIP:THRUST > 0.
}.

//------------------ Main sequence ------------------

FUNCTION SR_Main {
    PRINT "[SR] Sounding rocket sequence start.".

    // Ask user for safe altitude for late-stage separations (RSS-friendly presets)
    PRINT "".
    PRINT "[SR] Select minimum safe separation altitude (RSS):".
    PRINT "    1) 80 km    2) 100 km    3) 120 km    4) 150 km    (D=default)".
    PRINT "    Press 1-4 to choose, or D to use default (" + ROUND(MIN_SAFE_STAGE_ALT/1000,0) + " km).".
    LOCAL selKey IS "".
    WAIT UNTIL TERMINAL:INPUT:HASCHAR.
    SET selKey TO TERMINAL:INPUT:GETCHAR().
    IF selKey = "1" { SET MIN_SAFE_STAGE_ALT TO 80000. }.
    IF selKey = "2" { SET MIN_SAFE_STAGE_ALT TO 100000. }.
    IF selKey = "3" { SET MIN_SAFE_STAGE_ALT TO 120000. }.
    IF selKey = "4" { SET MIN_SAFE_STAGE_ALT TO 150000. }.
    // Any other key keeps the configured default
    PRINT "[SR] Using safe separation altitude: " + ROUND(MIN_SAFE_STAGE_ALT/1000,0) + " km.".

    // Preflight inspection of upcoming stages (current and next 3)
    PreflightInspect(3).
    PRINT "[SR] Press any key to proceed to arming...".
    WAIT UNTIL TERMINAL:INPUT:HASCHAR.
    SET selKey TO TERMINAL:INPUT:GETCHAR().

    // Countdown and initial light
    PRINT "[SR] Arming...".
    SAS OFF.
    RCS OFF.
    LOCK THROTTLE TO 1.
    PRINT "3...". WAIT 1.
    PRINT "2...". WAIT 1.
    PRINT "1...". WAIT 1.
    PRINT "Ignition!".
    STAGE. WAIT IGNITION_SETTLE_WAIT.

    LOCAL curStage IS -999.
    LOCAL stageMaxThrust IS 0.
    LOCAL NO_THRUST_EPS IS 0.1. // kN threshold to consider thrust effectively zero
    // waitReason removed (unused)
    LOCAL nonPropArmed IS FALSE.
    LOCAL hotstageActive IS FALSE.
    LOCAL waitNotified IS FALSE.
    UNTIL FALSE {
        LOCAL s IS STAGE:NUMBER.

        // Active stage snapshot
        LOCAL hasSolids IS SolidFuelPresent().
        LIST ENGINES IN el.
        LOCAL hasEngines IS FALSE.
        IF el:LENGTH() > 0 { SET hasEngines TO TRUE. }.

        // HUD countdown disabled to reduce lag

        // Pre-check next stage contents and mark non-prop-only groups for safe-altitude staging (do not block hotstage)
        IF NOT hotstageActive {
            LOCAL nextHasEngine IS NextStageHasEngine().
            LOCAL nextHasNonProp IS NextStageHasNonProp().
            IF NOT nextHasEngine AND nextHasNonProp AND SHIP:ALTITUDE < MIN_SAFE_STAGE_ALT {
                SET nonPropArmed TO TRUE.
                IF NOT waitNotified { PRINT "[SR] Staging deferred until safe altitude.". SET waitNotified TO TRUE. }.
            }.
        }.
        // If we armed a non-prop-only stage, only execute it at safe altitude when thrust is effectively zero
        IF nonPropArmed AND SHIP:ALTITUDE >= MIN_SAFE_STAGE_ALT AND STAGE:READY AND NOT AnyActiveEngines() {
            PRINT "[SR] Safe altitude reached: staging deferred non-prop group.".
            STAGE. WAIT IGNITION_SETTLE_WAIT.
            SET nonPropArmed TO FALSE.
            SET waitNotified TO FALSE.
        }.

        // When stage changes, recompute max thrust baseline for this stage
        IF s <> curStage {
            SET curStage TO s.
            // Prefer actual thrust snapshot (good for SRBs). Fallback to vessel max thrust.
            SET stageMaxThrust TO SHIP:THRUST.
            IF stageMaxThrust <= 0 { SET stageMaxThrust TO SHIP:MAXTHRUST. }.
        }.

        // Termination: no engines remain and no thrust
        IF NOT hasEngines AND NOT AnyActiveEngines() {
            PRINT "[SR] No active engines remaining. Sequence complete.".
            BREAK.
        }.

        // Compute thrust ratio relative to this stage's baseline (use SHIP:THRUST so SRBs aren't zero)
        LOCAL denom IS stageMaxThrust.
        IF denom <= 0 { SET denom TO 1. }.
        LOCAL thrustRatio IS SHIP:THRUST / denom.

        IF hasSolids {
            // Hotstage when current thrust has tailed off
            IF thrustRatio <= HOTSTAGE_THRUST_RATIO AND STAGE:READY {
                SET hotstageActive TO TRUE.
                // Detect next-stage pattern first
                LOCAL nextIsEng IS NextStageHasEngine().
                LOCAL nextIsNP IS NextStageHasNonProp().
                LOCAL afterNextEng IS StageHasEngine(s-2).
                LOCAL afterNextNP IS StageHasNonProp(s-2).

                // Only defer if next stage is non-prop and there is no engine immediately after it
                IF nextIsNP AND NOT afterNextEng AND SHIP:ALTITUDE < MIN_SAFE_STAGE_ALT {
                    IF NOT waitNotified { PRINT "[SR] Hotstage deferred: next stage non-prop with no following engine; waiting for safe altitude.". SET waitNotified TO TRUE. }.
                    // keep nonPropArmed true; it executes at safe altitude when thrust ~ 0
                    SET hotstageActive TO FALSE.
                } ELSE {
                    PRINT "[SR] Hotstaging (thrust ratio " + ROUND(thrustRatio*100,1) + "%).".
                    // Handle two possible interstage orderings:
                    // A) next = engine, then next-next = decoupler (preferred)
                    // B) next = decoupler, then next-next = engine (acceptable for SRBs)
                    IF nextIsEng {
                        // Light next engine first
                        STAGE.
                        WAIT HOTSTAGE_SEP_DELAY.
                        UNTIL STAGE:READY { WAIT 0. }.
                        // Then separate only if the following stage holds NP
                        // If NP was in the same stage as the engine, it already fired
                        IF afterNextNP {
                            PRINT "[SR] Hotstage: separating interstage (engine-first).".
                            STAGE. WAIT IGNITION_SETTLE_WAIT.
                        }.
                    } ELSE IF nextIsNP AND afterNextEng {
                        // Decoupler comes first, then engine - do both quickly
                        PRINT "[SR] Hotstage: decouple-then-ignite pattern.".
                        STAGE. // interstage decouple
                        WAIT 0.03.
                        UNTIL STAGE:READY { WAIT 0. }.
                        STAGE. // ignite next SRB
                        WAIT HOTSTAGE_SEP_DELAY.
                    } ELSE {
                        PRINT "[SR] Hotstage: cannot determine interstage pattern; skipping automatic separation/ignite.".
                    }.
                    SET hotstageActive TO FALSE.
                }.
            }.
            // Burnout fallback for SRBs: if thrust is effectively zero, stage forwards
            IF SHIP:THRUST <= NO_THRUST_EPS AND STAGE:READY {
                IF NextStageHasEngine() {
                    PRINT "[SR] SRB burnout detected: staging to next engine.".
                    STAGE. WAIT IGNITION_SETTLE_WAIT.
                } ELSE IF NextStageHasNonProp() {
                    IF SHIP:ALTITUDE >= MIN_SAFE_STAGE_ALT {
                        PRINT "[SR] SRB burnout: staging non-prop (safe altitude).".
                        STAGE. WAIT IGNITION_SETTLE_WAIT.
                    } ELSE {
                        PRINT "[SR] SRB burnout: non-prop staging deferred until safe altitude.".
                    }.
                }.
            }.
        } ELSE {
            // Liquid or mixed: stage when thrust goes to near-zero
            IF SHIP:AVAILABLETHRUST < 0.1 AND STAGE:READY {
                // Hard guard: never stage non-prop events below safe altitude when thrust ~ 0
                IF SHIP:THRUST <= NO_THRUST_EPS AND SHIP:ALTITUDE < MIN_SAFE_STAGE_ALT {
                    PRINT "[SR] Thrust ~0: staging deferred until safe altitude.".
                } ELSE {
                    IF NextStageHasEngine() {
                        // If next stage mixes engine with non-prop, enforce altitude first
                        IF SHIP:ALTITUDE < MIN_SAFE_STAGE_ALT AND NextStageHasNonProp() {
                            PRINT "[SR] Mixed engine/non-prop next stage: waiting for safe altitude.".
                        } ELSE {
                        PRINT "[SR] Low thrust: staging to next engine.".
                        STAGE. WAIT IGNITION_SETTLE_WAIT.
                        }.
                    } ELSE {
                        // Next stage is likely separation/fairing – guard by altitude
                        IF SHIP:ALTITUDE >= MIN_SAFE_STAGE_ALT {
                            PRINT "[SR] Low thrust: staging non-prop event (safe altitude).".
                            STAGE. WAIT IGNITION_SETTLE_WAIT.
                        } ELSE {
                            PRINT "[SR] Non-prop staging deferred until safe altitude.".
                        }.
                    }.
                }.
            }.
        }.

        WAIT 0.
    }.

    PRINT "[SR] Program end.".
}.

SR_Main().
