scriptName Search_Action_ApplyImageSpaceModifier extends SearchAction

event OnAction(int actionInfo)
    Debug.MessageBox("Image Space Modifier! " + GetFormId(actionInfo))
    ImageSpaceModifier ism = GetForm(actionInfo) as ImageSpaceModifier
    if ism
        Debug.MessageBox(ism)
        ism.Apply(1.0) ; TODO prompt user for the strength
    endIf
endEvent
