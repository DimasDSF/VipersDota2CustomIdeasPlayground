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
	"item_blades_of_attack",
	"item_blades_of_attack",

	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",

	"item_point_booster",
	"item_staff_of_wizardry",
	"item_ogre_axe",
	"item_blade_of_alacrity",

	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",

	"item_void_stone",
	"item_mystic_staff",
	"item_ultimate_orb",

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard",

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
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_shivas_guard" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_hurricane_pike" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_hurricane_pike" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------