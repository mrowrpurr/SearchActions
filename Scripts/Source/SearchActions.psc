scriptName SearchActions extends SearchActionBase
{Implementations for all actions built into the `SearchActions.esp` mod}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Full Supported Action List
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

event OnSearchActionBaseInit()
    ListenForSearchAction("CenterOnCell")
    ListenForSearchAction("ApplyImageSpaceModifier")
    ListenForSearchAction("ChangeWeather")
    ListenForSearchAction("PlayIdle")
    ListenForSearchAction("SendAnimationEvent")
    ListenForSearchAction("PlaceAtMe")
    ListenForSearchAction("ShowGlobalVariable")
    ListenForSearchAction("InventoryBrowser")
endEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Properties
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Actor property InventoryContainer auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Action Handlers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
