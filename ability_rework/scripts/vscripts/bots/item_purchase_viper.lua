require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_tango",
	"item_slippers",
	"item_circlet",
	"item_recipe_wraith_band",

	"item_boots",
	"item_boots_of_elves",
	"item_gloves",

	"item_ring_of_protection",
	"item_sobi_mask",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",

	"item_branches",
	"item_chainmail",
	"item_recipe_buckler",

	"item_recipe_mekansm",

	"item_ogre_axe",
	"item_boots_of_elves",
	"item_boots_of_elves",

	"item_mithril_hammer",
	"item_ogre_axe",
	"item_recipe_black_king_bar",

	"item_blade_of_alacrity",
	"item_boots_of_elves",
	"item_recipe_yasha",

	"item_ultimate_orb",
	"item_recipe_manta",

	"item_ring_of_health",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",

	"item_recipe_hurricane_pike",

	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit",

	"item_demon_edge",
	"item_recipe_greater_crit",

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

	-- sell item_ring_of_aquila
	purchase.SellItemForFull( "item_ring_of_aquila" );

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_greater_crit" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_monkey_king_bar" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_monkey_king_bar" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------