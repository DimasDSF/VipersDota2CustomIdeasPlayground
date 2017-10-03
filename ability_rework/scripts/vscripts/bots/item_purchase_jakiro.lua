require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_clarity",
	"item_clarity",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_circlet",

	"item_boots",
	"item_magic_stick",
	"item_energy_booster",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler",
	"item_recipe_mekansm",

	"item_ogre_axe",
	"item_staff_of_wizardry",
	"item_blade_of_alacrity",
	"item_point_booster",

	"item_recipe_guardian_greaves",

	"item_void_stone",
	"item_ultimate_orb",
	"item_mystic_staff",

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard",

	"item_vitality_booster",
	"item_energy_booster",
	"item_point_booster",
	"item_mystic_staff",

	"item_void_stone",
	"item_ring_of_health",
	"item_pers",
	"item_void_stone",
	"item_ring_of_health",
	"item_pers",
	"item_recipe_refresher"
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
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_shivas_guard" );

	-- buy item_travel_boots
	--purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_shivas_guard" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_refresher" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_refresher" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------