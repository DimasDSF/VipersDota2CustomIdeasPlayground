require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_quelling_blade",
	"item_branches",
	"item_branches",

	"item_magic_stick",
	"item_circlet",
	
	"item_boots",
	"item_gloves",
	"item_belt_of_strength",

	"item_blade_of_alacrity",
	"item_blade_of_alacrity",
	"item_robe",
	"item_recipe_diffusal_blade",

	"item_blade_of_alacrity",
	"item_boots_of_elves",
	"item_recipe_yasha",

	"item_ultimate_orb",
	"item_recipe_manta",

	"item_vitality_booster",
	"item_reaver",
	"item_vitality_booster",

	"item_platemail",
	"item_hyperstone",
	"item_chainmail",
	"item_recipe_assault",

	"item_javelin",
	"item_belt_of_strength",
	"item_recipe_basher",

	"item_stout_shield",
	"item_ring_of_health",
	"item_vitality_booster",

	"item_recipe_abyssal_blade"
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
	purchase.SellItemForSpecifiedItem( "item_quelling_blade", "item_manta" );

	-- sell item for specifiedItem
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_heart" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_assault" );

	-- buy item_diffusal_blade_2
	purchase.BuyDiffusalBlade2();

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_abyssal_blade" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_abyssal_blade" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------