"use strict";

var util = GameUI.CustomUIConfig().Util;

function toggleChangelog(arg){
	$("#changelogDisplay").SetHasClass("changelogDisplayHidden", !$("#changelogDisplay").BHasClass("changelogDisplayHidden"))

	if (arg) { //shortcut to open panel and select specific tab
		arg();
	}
	if (!$("#changelogDisplay").BHasClass("changelogDisplayHidden")) {
		$("#changelogDisplay").SetFocus();
	}
}

function hideChangelog(){
	$("#changelogDisplay").SetHasClass("changelogDisplayHidden", true)
}

function displayChangelog(){
	$("#changelogDisplay").SetHasClass("changelogDisplayHidden", !$("#changelogDisplay").BHasClass("changelogDisplayHidden"))
	if (!$("#changelogDisplay").BHasClass("changelogDisplayHidden")) {
		$("#changelogDisplay").SetFocus();
	}
}

function ChangelogGiveFocus(){
	if (!$("#changelogDisplay").BHasClass("changelogDisplayHidden")) {
		$("#changelogDisplay").SetFocus();
	}
}

function toggleInformation(arg){
	$("#descriptionDisplay").visible = true
	$("#updateDisplay").visible = false
	$("#creditsDisplay").visible = false
	$("#showDescriptionButton").checked = true;
	if (!$("#changelogDisplay").BHasClass("changelogDisplayHidden")) {
		$("#changelogDisplay").SetFocus();
	}
}

function toggleHeroes(arg){
	$("#descriptionDisplay").visible = false
	$("#updateDisplay").visible = true
	$("#creditsDisplay").visible = false
	$("#showUpdatesButton").checked = true;
	if (!$("#changelogDisplay").BHasClass("changelogDisplayHidden")) {
		$("#changelogDisplay").SetFocus();
	}
}

function toggleItems(arg){
	$("#descriptionDisplay").visible = false
	$("#updateDisplay").visible = false
	$("#creditsDisplay").visible = true
	$("#showCreditsButton").checked = true;
	if (!$("#changelogDisplay").BHasClass("changelogDisplayHidden")) {
		$("#changelogDisplay").SetFocus();
	}
}

(function() {
	$("#descriptionDisplay").visible = true;
	$("#showDescriptionButton").checked = true;
	
	util.blockMouseWheel($("#changelogDisplay"));
	if (!$("#changelogDisplay").BHasClass("changelogDisplayHidden")) {
		$("#changelogDisplay").SetFocus();
	}

	GameEvents.Subscribe( "vgmarOnInfo", displayChangelog );
})();