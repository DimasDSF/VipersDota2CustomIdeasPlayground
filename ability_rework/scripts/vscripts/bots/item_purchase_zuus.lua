require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_clarity",
	"item_clarity",
	"item_tango",

	"item_magic_stick",
	"item_boots",

	"item_ring_of_regen",
	"item_sobi_mask",
	"item_enchanted_mango",

	"item_energy_booster" ,

	"item_blink",

	"item_vitality_booster",
	"item_energy_booster",
	"item_point_booster",
	"item_recipe_bloodstone",
	
	"item_energy_booster",
	"item_void_stone",
	"item_recipe_aether_lens",
	
	"item_void_stone",
	"item_ring_of_health",
	"item_pers",
	"item_void_stone",
	"item_ring_of_health",
	"item_pers",
	"item_recipe_refresher",
	
	"item_void_stone",
	"item_mystic_staff",
	"item_ultimate_orb"
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
	purchase.SellItemForFullInventory( "item_magic_wand" );

	-- sell item_soul_ring
	purchase.SellItemForFullInventory( "item_soul_ring" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_sheepstick" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_travel_boots" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_travel_boots" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------