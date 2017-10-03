require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_clarity",
	"item_clarity",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_circlet",

	"item_magic_stick",

	"item_boots",
	"item_belt_of_strength",
	"item_gloves",

	"item_blight_stone",
	"item_sobi_mask",
	"item_chainmail",

	"item_staff_of_wizardry",
	"item_ring_of_health",
	"item_recipe_force_staff",

	"item_sobi_mask",
	"item_gauntlets",
	"item_gauntlets",
	"item_recipe_urn_of_shadows",
	
	"item_ogre_axe",
	"item_blade_of_alacrity",
	"item_staff_of_wizardry",
	"item_point_booster",

	"item_blight_stone",
	"item_mithril_hammer",
	"item_mithril_hammer",

	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",

	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",

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

	-- sell item_magic_wand
	purchase.SellItemForFull( "item_magic_wand" );

	-- sell item_medallion_of_courage
	purchase.SellItemForFull( "item_medallion_of_courage" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_black_king_bar" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_hurricane_pike" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_hurricane_pike" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------