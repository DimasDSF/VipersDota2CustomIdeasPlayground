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
	"item_boots_of_elves",
	"item_gloves",

	"item_ogre_axe",
	"item_boots_of_elves",
	"item_boots_of_elves",

	"item_shadow_amulet",
	"item_claymore",

	"item_gloves",
	"item_mithril_hammer",
	"item_recipe_maelstrom",

	"item_hyperstone",
	"item_recipe_mjollnir",

	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",

	"item_ultimate_orb",
	"item_recipe_silver_edge",

	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",

	"item_recipe_hurricane_pike",

	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit",

	"item_demon_edge",
	"item_recipe_greater_crit"
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

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_hurricane_pike" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_greater_crit" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_greater_crit" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------