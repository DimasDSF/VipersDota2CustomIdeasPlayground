require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_clarity",
	"item_clarity",
	"item_tango",
	"item_stout_shield",
	"item_branches",
	"item_branches",

	"item_magic_stick",
	"item_circlet",

	"item_boots",
	"item_belt_of_strength",
	"item_gloves",

	"item_ring_of_health",
	"item_vitality_booster",

	"item_robe",
	"item_chainmail",
	"item_broadsword",

	"item_chainmail",
	"item_branches",
	"item_recipe_buckler",

	"item_recipe_crimson_guard",

	"item_vitality_booster",
	"item_energy_booster",
	"item_point_booster",
	"item_mystic_staff",

	"item_vitality_booster",
	"item_reaver",
	"item_vitality_booster",

	"item_chainmail",
	"item_platemail",
	"item_hyperstone",
	"item_recipe_assault",

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard"
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
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_octarine_core" );

	-- sell item for specifiedItem
	purchase.SellItemForSpecifiedItem( "item_crimson_guard", "item_shivas_guard" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_assault" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_shivas_guard" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_shivas_guard" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------