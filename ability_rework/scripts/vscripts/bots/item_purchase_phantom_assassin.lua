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
	"item_gloves",
	"item_boots_of_elves",

	"item_lifesteal",

	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",

	"item_javelin",
	"item_belt_of_strength",
	"item_recipe_basher",

	"item_stout_shield",
	"item_ring_of_health",
	"item_vitality_booster",

	"item_recipe_abyssal_blade",

	"item_mithril_hammer",
	"item_reaver",

	"item_platemail",
	"item_hyperstone",
	"item_chainmail",
	"item_recipe_assault",

	"item_javelin",
	"item_javelin",
	"item_demon_edge"
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
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_assault" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_satanic" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_assault" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------