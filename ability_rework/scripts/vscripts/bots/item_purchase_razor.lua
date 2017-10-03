require( GetScriptDirectory().."/item_purchase_generic" )

----------------------------------------------------------------------------------------------------

local tableItemsToBuy = { 
	"item_flask",
	"item_tango",
	"item_branches",
	"item_branches",
	"item_circlet",

	"item_boots",
	"item_magic_stick",

	"item_stout_shield",
	"item_ring_of_health",
	"item_vitality_booster",

	"item_blade_of_alacrity",
	"item_boots_of_elves",
	"item_recipe_yasha",

	"item_robe",
	"item_chainmail",
	"item_broadsword",

	"item_ogre_axe",
	"item_belt_of_strength",
	"item_recipe_sange",

	"item_ogre_axe",
	"item_mithril_hammer",
	"item_recipe_black_king_bar",

	"item_recipe_travel_boots",

	"item_reaver",
	"item_vitality_booster",
	"item_vitality_booster",

	"item_quarterstaff",
	"item_eagle",
	"item_talisman_of_evasion",

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

	"item_recipe_travel_boots"
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

	-- sell item_vanguard
	purchase.SellItemForFull( "item_vanguard" );

	-- we need item_moon_shard
	purchase.PurchaseMoonShardSinceHasSpecifiedItem( "item_bloodthorn" );
	purchase.DevourMoonShardSinceHasSpecifiedItem( "item_bloodthorn" );

	--------------------------------------------------------------------------

	npcBot.tableItemsToBuy = tableItemsToBuy;
	purchase.ItemPurchase();

end

----------------------------------------------------------------------------------------------------