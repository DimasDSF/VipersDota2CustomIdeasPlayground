require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_clarity",
	"item_clarity",
	"item_flask",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_circlet",

	"item_magic_stick",
	"item_boots",

	"item_ring_of_regen",
	"item_sobi_mask",
	"item_enchanted_mango",

	"item_energy_booster",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",

	"item_branches",
	"item_chainmail",
	"item_recipe_buckler",

	"item_recipe_mekansm",

	"item_recipe_guardian_greaves",

	"item_ogre_axe",
	"item_staff_of_wizardry",
	"item_blade_of_alacrity",
	"item_point_booster",

	"item_cloak",
	"item_ring_of_health",
	"item_ring_of_regen",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",

	"item_recipe_pipe",

	"item_chainmail",
	"item_platemail",
	"item_hyperstone",
	"item_recipe_assault",

	"item_void_stone",
	"item_ultimate_orb",
	"item_mystic_staff",

	"item_reaver",
	"item_vitality_booster",
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

	-- sell item_magic_wand
	purchase.SellItemForFull( "item_magic_wand" );

	-- sell item_soul_ring
	purchase.SellItemForFull( "item_soul_ring" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_heart" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_heart" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_heart" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------