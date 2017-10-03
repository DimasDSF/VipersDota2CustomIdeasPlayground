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
	"item_energy_booster",

	"item_staff_of_wizardry",
	"item_belt_of_strength",
	"item_recipe_necronomicon",

	"item_void_stone",
	"item_ultimate_orb",
	"item_mystic_staff",

	"item_recipe_necronomicon",
	"item_recipe_necronomicon",

	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard",

	"item_circlet",
	"item_mantle",
	"item_recipe_null_talisman",
	"item_staff_of_wizardry",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon"
};

----------------------------------------------------------------------------------------------------

npcBot = GetBot();

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

	-- if we have travel boots, no need item_tpscroll
	purchase.NoNeedTpscrollForTravelBoots();

	-- buy item_tpscroll
	purchase.WeNeedTpscroll();

	-- sell item_magic_ward for item_black_king_bar
	purchase.SellItemForSpecifiedItem( "item_magic_ward", "item_black_king_bar" );

	-- buy item_shivas_guard
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_shivas_guard" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_dagon_5" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_dagon_5" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------