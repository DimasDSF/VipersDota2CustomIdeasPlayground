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
	"item_blades_of_attack",
	"item_blades_of_attack",

	"item_wind_lace",
	"item_void_stone",
	"item_staff_of_wizardry",
	"item_recipe_cyclone",

	"item_ring_of_regen",
	"item_sobi_mask",
	"item_enchanted_mango",

	"item_point_booster",
	"item_vitality_booster",
	"item_energy_booster",

	"item_recipe_bloodstone",
	
	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",

	"item_mystic_staff",
	"item_vitality_booster",
	"item_energy_booster",
	"item_point_booster",

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard"
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
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_black_king_bar" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_octarine_core" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_shivas_guard" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_shivas_guard" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------