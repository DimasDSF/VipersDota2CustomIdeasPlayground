"use strict";

function Selection_Reset()
{
    var playerID = Players.GetLocalPlayer()
    var heroIndex = Players.GetPlayerHeroEntityIndex(playerID)
    GameUI.SelectUnit(heroIndex, false)
}

(function()
{
	GameEvents.Subscribe( "selection_reset", Selection_Reset);
})();