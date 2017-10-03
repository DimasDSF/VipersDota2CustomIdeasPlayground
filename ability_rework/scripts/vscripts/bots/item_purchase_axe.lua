require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_stout_shield",
	"item_tango",
	"item_flask",
	"item_branches",
	"item_branches",

	"item_boots",
	"item_ring_of_protection" ,
	"item_ring_of_regen",

	"item_blink",

	"item_robe",
	"item_chainmail",
	"item_broadsword",

	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",

	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",

	"item_reaver",
	"item_vitality_booster",
	"item_vitality_booster",

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

	-- sell item_branches
	purchase.SellItemForFullInventory( "item_branches" );
	purchase.SellItemForFullInventory( "item_branches" );

	-- sell item_stout_shield
	purchase.SellItemForFullInventory( "item_stout_shield" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_shivas_guard" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_travel_boots1" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_travel_boots1" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------