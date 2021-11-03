scriptName Search_Action_InventoryBrowser extends SearchActionExtended

Actor property InventoryContainer auto

event OnAction(int actionInfo)

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
