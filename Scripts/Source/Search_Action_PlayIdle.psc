scriptName Search_Action_PlayIdle extends SearchActionExtended

event OnAction(int actionInfo)
    Idle theIdle = GetForm(actionInfo) as Idle
    if theIdle
        PlayerRef.PlayIdle(theIdle)
    endIf
endEvent
