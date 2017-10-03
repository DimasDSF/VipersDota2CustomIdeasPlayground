require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_stout_shield",
	"item_branches",
	"item_branches",

	"item_boots",

	"item_slippers",
	"item_slippers",

	"item_magic_stick",
	"item_circlet",

	"item_blades_of_attack",
	"item_blades_of_attack",

	"item_chainmail",
	"item_sobi_mask",
	"item_blight_stone",

	"item_blight_stone",
	"item_mithril_hammer",
	"item_mithril_hammer",

	"item_quarterstaff",
	"item_sobi_mask",
	"item_robe",

	"item_quarterstaff",
	"item_sobi_mask",
	"item_robe",

	"item_recipe_orchid",

	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",

	"item_talisman_of_evasion",
	"item_solar_crest",

	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit",

	"item_recipe_bloodthorn",

	"item_quarterstaff",
	"item_talisman_of_evasion",
	"item_eagle"
};

----------------------------------------------------------------------------------------------------

npcBot = GetBot();

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

	-- if we have travel boots, no need item_tpscroll
	purchase.NoNeedTpscrollForTravelBoots();

	-- buy item_tpscroll
	purchase.WeNeedTpscroll();

	-- sell item_poor_mans_shield for item_desolator
	purchase.SellItemForSpecifiedItem( "item_poor_mans_shield", "item_desolator" );

	-- sell item_magic_wand for item_orchid
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_orchid" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_bloodthorn" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_butterfly" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_butterfly" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------