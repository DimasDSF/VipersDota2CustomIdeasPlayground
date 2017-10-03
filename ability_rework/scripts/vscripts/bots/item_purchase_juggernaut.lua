require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_orb_of_venom",

	"item_magic_stick",
	"item_circlet",

	"item_boots",
	"item_blades_of_attack",
	"item_blades_of_attack",

	"item_blade_of_alacrity",
	"item_boots_of_elves",
	"item_recipe_yasha",

	"item_ultimate_orb",
	"item_recipe_manta",

	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",

	"item_javelin",
	"item_belt_of_strength",
	"item_recipe_basher",

	"item_point_booster",
	"item_ultimate_orb",
	"item_ultimate_orb",

	"item_stout_shield",
	"item_ring_of_health",
	"item_vitality_booster",

	"item_recipe_abyssal_blade",

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

	-- sell item for specifiedItem
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_skadi" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_abyssal_blade" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_monkey_king_bar" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_monkey_king_bar" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------