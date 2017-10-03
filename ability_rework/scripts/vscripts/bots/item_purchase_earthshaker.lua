require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_gauntlets",
	"item_gauntlets",
	"item_tango",
	"item_flask",

	"item_boots",
	"item_energy_booster",

	"item_blink",

	"item_sobi_mask",
	"item_recipe_urn_of_shadows",

	"item_staff_of_wizardry",
	"item_void_stone",
	"item_wind_lace",
	"item_recipe_cyclone",

	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",

	"item_ogre_axe",
	"item_blade_of_alacrity",
	"item_staff_of_wizardry",
	"item_point_booster",

	"item_void_stone",
	"item_ultimate_orb",
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

	-- sell item for specifiedItem
	purchase.SellItemForSpecifiedItem( "item_recipe_urn_of_shadows", "item_sheepstick" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_ultimate_scepter" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_sheepstick" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_sheepstick" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------