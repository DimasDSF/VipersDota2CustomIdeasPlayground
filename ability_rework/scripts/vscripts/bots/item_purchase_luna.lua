require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_circlet",
	"item_slippers",

	"item_boots",

	"item_recipe_wraith_band",
	"item_ring_of_protection",
	"item_sobi_mask",

	"item_boots_of_elves",
	"item_gloves",

	"item_lifesteal",

	"item_blade_of_alacrity",
	"item_boots_of_elves",
	"item_recipe_yasha",

	"item_ultimate_orb",
	"item_recipe_manta",

	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",

	"item_mithril_hammer",
	"item_reaver",

	"item_eagle",
	"item_quarterstaff",
	"item_talisman_of_evasion",

	"item_orb_of_venom",
	"item_point_booster",
	"item_ultimate_orb",
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

	-- sell item for specifiedItem
	purchase.SellItemForSpecifiedItem( "item_ring_of_aquila", "item_butterfly" );

	-- sell item for specifiedItem
	--purchase.SellItemForSpecifiedItem( "item_helm_of_the_dominator", "item_skadi" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_satanic" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_skadi" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_skadi" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------