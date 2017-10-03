require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_quelling_blade",

	"item_circlet",
	"item_magic_stick",

	"item_boots",
	"item_belt_of_strength",
	"item_gloves",

	"item_gloves",
	"item_mithril_hammer",
	"item_recipe_maelstrom",

	"item_hyperstone",
	"item_recipe_mjollnir",

	"item_blink",

	"item_javelin",
	"item_belt_of_strength",
	"item_recipe_basher",

	"item_stout_shield",
	"item_ring_of_health",
	"item_vitality_booster",

	"item_recipe_abyssal_blade",

	"item_chainmail",
	"item_platemail",
	"item_hyperstone",
	"item_recipe_assault",

	--"item_ogre_axe",
	--"item_mithril_hammer",
	--"item_recipe_black_king_bar",

	"item_vitality_booster",
	"item_reaver",
	"item_vitality_booster"
};

----------------------------------------------------------------------------------------------------

npcBot = GetBot();

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

	-- if we have travel boots, no need item_tpscroll
	purchase.NoNeedTpscrollForTravelBoots();

	-- buy item_tpscroll
	purchase.WeNeedTpscroll();

	-- sell item_quelling_blade
	purchase.SellItemForFull( "item_quelling_blade" );

	-- sell item_magic_wand
	purchase.SellItemForFull( "item_magic_wand" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_assault" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_heart" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_heart" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------