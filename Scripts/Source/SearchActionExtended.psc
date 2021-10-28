scriptName SearchActionExtended extends SearchAction

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
