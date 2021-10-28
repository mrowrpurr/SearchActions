scriptName Search_Action_ChangeWeather extends SearchAction

event OnAction(int actionInfo)
    Weather theWeather = GetForm(actionInfo) as Weather
    if theWeather
        theWeather.ForceActive(abOverride = true) ; Add option for override?
    endIf
endEvent
