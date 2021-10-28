scriptName Search_Action_Ok_Message extends Quest

Form property SearchActions_MessageText_BaseForm auto
Message property SearchActions_OkMessage auto

function ShowOkMessage(string text)
    SearchActions_MessageText_BaseForm.SetName(text)
    SearchActions_OkMessage.Show()
endFunction
