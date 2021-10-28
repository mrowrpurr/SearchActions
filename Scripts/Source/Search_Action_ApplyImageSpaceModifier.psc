scriptName Search_Action_ApplyImageSpaceModifier extends SearchAction

event OnAction(int actionInfo)
    ImageSpaceModifier ism = GetForm(actionInfo) as ImageSpaceModifier
    if ism
        ism.Apply(1.0) ; TODO prompt user for the strength
    endIf
endEvent
