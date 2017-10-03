require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_clarity",
	"item_clarity",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_circlet",

	"item_magic_stick",
	"item_boots",
	"item_energy_booster",

	"item_staff_of_wizardry",
	"item_ring_of_health",
	"item_recipe_force_staff",

	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",
	"item_point_booster",

	"item_staff_of_wizardry",
	"item_wind_lace",
	"item_void_stone",
	"item_recipe_cyclone",

	"item_mystic_staff",
	"item_ultimate_orb",
	"item_void_stone",

	"item_vitality_booster",
	"item_energy_booster",
	"item_point_booster",
	"item_mystic_staff",

	"item_ogre_axe",
	"item_boots_of_elves",
	"item_boots_of_elves",
	"item_recipe_hurricane_pike"
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
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_sheepstick" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_octarine_core" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_hurricane_pike" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_hurricane_pike" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------