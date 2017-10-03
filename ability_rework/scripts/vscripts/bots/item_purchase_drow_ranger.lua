require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_circlet",

	"item_boots",
	"item_lifesteal",
	"item_magic_stick",
	
	"item_ring_of_protection",
	"item_sobi_mask",
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",

	"item_gloves",
	"item_boots_of_elves",

	"item_shadow_amulet",
	"item_claymore",

	"item_blade_of_alacrity",
	"item_boots_of_elves",
	"item_recipe_yasha",

	"item_ultimate_orb",
	"item_recipe_manta",

	"item_ultimate_orb",
	"item_recipe_silver_edge",

	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",
	
	"item_mithril_hammer",
	"item_reaver",
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion"
};

----------------------------------------------------------------------------------------------------

local tableItemsToBuy2 = { 
	"item_flask",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_circlet",

	"item_boots",
	"item_lifesteal",
	"item_magic_stick",

	"item_gloves",
	"item_boots_of_elves",

	"item_ogre_axe",
	"item_blade_of_alacrity",
	"item_staff_of_wizardry",
	"item_point_booster",

	"item_gloves",
	"item_mithril_hammer",
	"item_recipe_maelstrom",

	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",

	"item_hyperstone",
	"item_recipe_mjollnir",
	
	"item_mithril_hammer",
	"item_reaver",
	
	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion"
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
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_manta" );

	-- sell item for specifiedItem
	purchase.SellItemForSpecifiedItem( "item_ring_of_aquila", "item_black_king_bar" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_satanic" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_butterfly" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_butterfly" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------