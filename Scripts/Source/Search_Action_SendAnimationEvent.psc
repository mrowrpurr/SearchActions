scriptName Search_Action_SendAnimationEvent extends SearchActionExtended

event OnAction(int actionInfo)
    Debug.SendAnimationEvent(PlayerRef, GetEditorId(actionInfo))
endEvent
