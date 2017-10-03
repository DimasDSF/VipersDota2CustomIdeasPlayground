require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_wind_lace",

	"item_circlet",
	"item_magic_stick",

	"item_boots",
	"item_ring_of_regen",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler",
	"item_recipe_mekansm",

	"item_ogre_axe",
	"item_staff_of_wizardry",
	"item_blade_of_alacrity",
	"item_point_booster",

	"item_blink",

	"item_void_stone",
	"item_mystic_staff",
	"item_ultimate_orb",

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard",

	"item_quarterstaff",
	"item_sobi_mask",
	"item_robe",
	"item_quarterstaff",
	"item_sobi_mask",
	"item_robe",
	"item_recipe_orchid",

	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit",
	"item_recipe_bloodthorn"
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
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_sheepstick" );

	-- sell item for specifiedItem
	purchase.SellItemForSpecifiedItem( "item_mekansm", "item_shivas_guard" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_shivas_guard" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_bloodthorn" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_bloodthorn" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------