scriptName Search_Action_CenterOnCell extends SearchAction  

event OnAction(int actionInfo)
    Debug.CenterOnCell(GetEditorId(actionInfo))
endEvent
