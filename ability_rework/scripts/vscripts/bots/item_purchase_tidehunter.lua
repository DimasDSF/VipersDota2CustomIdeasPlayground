require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_circlet",

	"item_magic_stick",

	"item_boots",
	"item_energy_booster",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",

	"item_branches",
	"item_chainmail",
	"item_recipe_buckler",

	"item_recipe_mekansm",

	"item_blink",

	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",

	"item_recipe_pipe",

	"item_recipe_guardian_greaves",

	"item_void_stone",
	"item_ring_of_health",
	"item_void_stone",
	"item_ring_of_health",
	"item_recipe_refresher",

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard",

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

	-- sell item_magic_wand
	purchase.SellItemForFull( "item_magic_wand" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_sheepstick" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_sheepstick" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_sheepstick" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------