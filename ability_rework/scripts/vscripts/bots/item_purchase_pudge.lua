require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_circlet",

	"item_bottle",
	"item_boots",
	"item_magic_stick",

	"item_ring_of_regen",
	"item_wind_lace",

	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",

	"item_blink",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",

	"item_recipe_pipe",

	"item_reaver",
	"item_vitality_booster",
	"item_vitality_booster",

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard",

	"item_ogre_axe",
	"item_blade_of_alacrity",
	"item_staff_of_wizardry",
	"item_point_booster"
};

----------------------------------------------------------------------------------------------------

npcBot = GetBot();

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

	-- if we have travel boots, no need item_tpscroll
	purchase.NoNeedTpscrollForTravelBoots();

	-- buy item_tpscroll
	purchase.WeNeedTpscroll();

	-- sell item_magic_wand
	purchase.SellItemForFull( "item_magic_wand" );

	-- sell item_bottle
	purchase.SellItemForFull( "item_bottle" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_shivas_guard" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_ultimate_scepter" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_ultimate_scepter" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------