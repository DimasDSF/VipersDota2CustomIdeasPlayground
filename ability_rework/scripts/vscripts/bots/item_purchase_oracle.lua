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

	"item_wind_lace",
	"item_void_stone",
	"item_staff_of_wizardry",
	"item_recipe_cyclone",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",

	"item_branches",
	"item_chainmail",
	"item_recipe_buckler",

	"item_recipe_mekansm",

	"item_recipe_guardian_greaves",

	"item_staff_of_wizardry",
	"item_ring_of_health",
	"item_recipe_force_staff",

	"item_ultimate_orb",
	"item_void_stone",
	"item_mystic_staff",

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

	"item_recipe_bloodthorn",

	"item_circlet",
	"item_mantle",
	"item_recipe_null_talisman",
	"item_staff_of_wizardry",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",

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

	-- buy item_travel_boots
	purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_hurricane_pike" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_hurricane_pike" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_hurricane_pike" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------