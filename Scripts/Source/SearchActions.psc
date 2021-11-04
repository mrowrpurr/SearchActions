scriptName SearchActions extends SearchActionBase
{Implementations for all actions built into the `SearchActions.esp` mod}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Full Supported Action List
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

event OnSearchActionBaseInit()
    ListenForSearchAction("LearnSpell")
    ListenForSearchAction("CenterOnCell")
    ListenForSearchAction("ApplyImageSpaceModifier")
    ListenForSearchAction("ChangeWeather")
    ListenForSearchAction("PlayIdle")
    ListenForSearchAction("SendAnimationEvent")
    ListenForSearchAction("PlaceAtMe")
    ListenForSearchAction("ShowGlobalVariable")
    ListenForSearchAction("InventoryBrowser")
    ListenForSearchAction("ViewQuest")
endEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Properties
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Actor property InventoryContainer auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Action Handlers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

event OnLearnSpell(int actionInfo)
    if IsSearchResult(actionInfo)
        Spell theSpell = GetForm(actionInfo) as Spell
        if theSpell
            PlayerRef.AddSpell(theSpell)
        endIf
    else
        Form[] theSpells = GetAllForms(actionInfo)
        int i = 0
        while i < theSpells.Length
            Spell theSpell = theSpells[i] as Spell
            if theSpell && ! PlayerRef.HasSpell(theSpell)
                PlayerRef.AddSpell(theSpell)
            endIf
            i += 1
        endWhile
    endIf
endEvent

event OnCenterOnCell(int actionInfo)
    Debug.CenterOnCell(GetEditorId(actionInfo))
endEvent

event OnApplyImageSpaceModifier(int actionInfo)
    ImageSpaceModifier ism = GetForm(actionInfo) as ImageSpaceModifier
    if ism
        ism.Apply(1.0)
    endIf
endEvent

event OnChangeWeather(int actionInfo)
    Weather theWeather = GetForm(actionInfo) as Weather
    if theWeather
        theWeather.ForceActive(abOverride = true)
    endIf
endEvent

event OnPlayIdle(int actionInfo)
    Idle theIdle = GetForm(actionInfo) as Idle
    if theIdle
        PlayerRef.PlayIdle(theIdle)
    endIf
endEvent

event OnPlaceAtMe(int actionInfo)
    ShowOkMessage("Enter how many to place at player")
    int count = GetUserText(1) as int
    if count
        PlayerRef.PlaceAtMe(GetForm(actionInfo), count)
    endIf
endEvent

event OnSendAnimationEvent(int actionInfo)
    Debug.SendAnimationEvent(PlayerRef, GetEditorId(actionInfo))
endEvent

; ~ WIP ~
event OnShowGlobalVariable(int actionInfo)
    string globalName = GetDisplayText(actionInfo)
    ; showglobalvars ~ run and parse etc!
endEvent

event OnInventoryBrowser(int actionInfo)
    if IsSearchResult(actionInfo)
        ShowOkMessage("Enter number of items to add to inventory")
        int count = GetUserText(1) as int
        if count
            PlayerRef.AddItem(GetForm(actionInfo), count)
        endIf
        return
    endIf

    InventoryContainer.RemoveAllItems()
    Form[] items = GetAllForms(actionInfo)
    int i = 0
    while i < items.Length
        Form theItem = items[i]
        int itemType = theItem.GetType()
        int count    = 1
        if itemType == 42 || itemType == 52 ; Ammo and Soul Gems
            count = 100
        endIf
        InventoryContainer.AddItem(items[i], count)
        i += 1
    endWhile
    InventoryContainer.GetActorBase().SetName("Items")
    InventoryContainer.OpenInventory(abForceOpen = true)
endEvent

event OnViewQuest(int actionInfo)
    Quest theQuest = GetForm(actionInfo) as Quest
    if theQuest
        UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu

        listMenu.AddEntryItem("Viewing Quest: " + GetDisplayText(actionInfo))
        int changeCurrentStage = listMenu.AddEntryItem("Current Stage: " + theQuest.GetCurrentStageID())
        listMenu.AddEntryItem("Completed: " + theQuest.IsCompleted())
        listMenu.AddEntryItem(" ")

        int start    = listMenu.AddEntryItem("Start")
        int stop     = listMenu.AddEntryItem("Stop")
        int reset    = listMenu.AddEntryItem("Reset")
        int complete = listMenu.AddEntryItem("Complete")

        listMenu.AddEntryItem(" ")

        int setStage = listMenu.AddEntryItem("Set Stage")

        listMenu.AddEntryItem(" ")

        int showObjective         = listMenu.AddEntryItem("Show Objective")
        int failObjective         = listMenu.AddEntryItem("Fail Objective")
        int failAllObjectives     = listMenu.AddEntryItem("Fail All Objectives")
        int completeObjective     = listMenu.AddEntryItem("Complete Objective")
        int completeAllObjectives = listMenu.AddEntryItem("Complete All Objectives")

        listMenu.OpenMenu()

        int result = listMenu.GetResultInt()
        if result > -1
            if result == start
                theQuest.Start()
            elseIf result == stop
                theQuest.Stop()
            elseIf result == reset
                theQuest.Reset()
            elseIf result == complete
                theQuest.CompleteQuest()
            elseIf result == setStage || result == changeCurrentStage
                int stageId = GetUserText(theQuest.GetCurrentStageID()) as int
                theQuest.SetCurrentStageID(stageId)
            elseIf result == showObjective
                theQuest.SetObjectiveDisplayed(GetUserText() as int)
            elseIf result == failObjective
                theQuest.SetObjectiveFailed(GetUserText() as int)
            elseIf result == failAllObjectives
                theQuest.FailAllObjectives()
            elseIf result == completeObjective
                theQuest.SetObjectiveCompleted(GetUserText() as int)
            elseIf result == completeAllObjectives
                theQuest.CompleteAllObjectives()
            endIf
            OnViewQuest(actionInfo)
        endIf
    endIf
endEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function ShowOkMessage(string text)
    (GetOwningQuest() as Search_Action_Ok_Message).ShowOkMessage(text)
endFunction

string function GetUserText(string defaultText = "")
    UITextEntryMenu textEntry = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
    if defaultText
        textEntry.SetPropertyString("text", defaultText)
    endIf
    textEntry.OpenMenu()
    return textEntry.GetResultString()
endFunction
