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

	"item_circlet",
	"item_ring_of_protection",
	"item_recipe_urn_of_shadows",
	"item_infused_raindrop",

	"item_energy_booster",

	"item_staff_of_wizardry",
	"item_belt_of_strength",
	"item_recipe_necronomicon",

	"item_branches",
	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_branches",
	"item_chainmail",
	"item_recipe_buckler",
	"item_recipe_mekansm",

	"item_recipe_guardian_greaves",

	"item_staff_of_wizardry",
	"item_bracer",
	"item_bracer",
	"item_recipe_rod_of_atos",

	"item_recipe_necronomicon",
	"item_recipe_necronomicon",

	"item_void_stone",
	"item_ultimate_orb",
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

	-- sell item_magic_wand
	purchase.SellItemForSpecifiedItem( "item_magic_wand", "item_rod_of_atos" );

	-- buy item_travel_boots
	--purchase.BuyTravelBootsSinceHasSpecifiedItem( "item_sheepstick" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_bloodthorn" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_bloodthorn" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------