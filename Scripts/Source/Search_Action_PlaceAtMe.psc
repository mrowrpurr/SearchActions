scriptName Search_Action_PlaceAtMe extends SearchActionExtended

event OnAction(int actionInfo)
    ShowOkMessage("Enter how many to place at player")
    int count = GetUserText(1) as int
    if count
        PlayerRef.PlaceAtMe(GetForm(actionInfo), count)
    endIf
endEvent