scriptName Search_Action_CenterOnCell extends SearchAction  

event OnAction(int id)
    Debug.CenterOnCell(GetEditorId(id))
endEvent
