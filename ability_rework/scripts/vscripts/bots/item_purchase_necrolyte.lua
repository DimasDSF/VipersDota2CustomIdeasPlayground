require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_clarity",
	"item_clarity",
	"item_flask",
	"item_tango",
	"item_branches",

	"item_ring_of_regen",
	"item_recipe_headdress",

	"item_boots",
	"item_energy_booster",

	"item_chainmail",
	"item_branches",
	"item_recipe_buckler",

	"item_recipe_mekansm",

	"item_ogre_axe",
	"item_staff_of_wizardry",
	"item_blade_of_alacrity",
	"item_point_booster",

	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",

	"item_recipe_pipe",

	"item_mystic_staff",
	"item_platemail",
	"item_recipe_shivas_guard",

	"item_recipe_guardian_greaves",

	"item_void_stone",
	"item_ultimate_orb",
	"item_mystic_staff",

	"item_vitality_booster",
	"item_energy_booster",
	"item_point_booster",
	"item_mystic_staff"
};

----------------------------------------------------------------------------------------------------

npcBot = GetBot();

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

	-- if we have travel boots, no need item_tpscroll
	purchase.NoNeedTpscrollForTravelBoots();

	-- buy item_tpscroll
	purchase.WeNeedTpscroll();

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_octarine_core" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_octarine_core" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_octarine_core" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------