_G._savedEnv = getfenv()
module( "purchase", package.seeall )

----------------------------------------------------------------------------------------------------

J = require( GetScriptDirectory() .. "/gxc/gxcJ" )

----------------------------------------------------------------------------------------------------

local invisibleHeroes = {
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_sand_king",
	"npc_dota_hero_treant",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_broodmother",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_mirana",
	"npc_dota_hero_nyx_assassin",
	"npc_dota_hero_riki",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_slark",
	"npc_dota_hero_sniper",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_viper",
	"npc_dota_hero_invoker"
};

----------------------------------------------------------------------------------------------------

local bDoOnce_Smoke = false;

----------------------------------------------------------------------------------------------------

function PurchaseUpgrades( shoppingCart, upgradeItemName )

	if ( upgradeItemName == "item_magic_wand" ) then

		table.insert( shoppingCart, "item_branches" );
		table.insert( shoppingCart, "item_branches" );
		table.insert( shoppingCart, "item_circlet" );
		table.insert( shoppingCart, "item_magic_stick" );

	elseif ( upgradeItemName == "item_ring_of_basilius" ) then

		table.insert( shoppingCart, "item_ring_of_protection" );
		table.insert( shoppingCart, "item_sobi_mask" );

	elseif ( upgradeItemName == "item_glimmer_cape" ) then

		table.insert( shoppingCart, "item_cloak" );
		table.insert( shoppingCart, "item_shadow_amulet" );

	elseif ( upgradeItemName == "item_hood_of_defiance" ) then

		table.insert( shoppingCart, "item_ring_of_regen" );
		table.insert( shoppingCart, "item_cloak" );
		table.insert( shoppingCart, "item_ring_of_health" );

	elseif ( upgradeItemName == "item_lesser_crit" ) then

		table.insert( shoppingCart, "item_blades_of_attack" );
		table.insert( shoppingCart, "item_broadsword" );
		table.insert( shoppingCart, "item_recipe_lesser_crit" );

	elseif ( upgradeItemName == "item_mask_of_madness" ) then

		table.insert( shoppingCart, "item_lifesteal" );
		table.insert( shoppingCart, "item_recipe_mask_of_madness" );

	elseif ( upgradeItemName == "item_null_talisman" ) then

		table.insert( shoppingCart, "item_mantle" );
		table.insert( shoppingCart, "item_circlet" );
		table.insert( shoppingCart, "item_recipe_null_talisman" );

	elseif ( upgradeItemName == "item_iron_talon" ) then

		table.insert( shoppingCart, "item_ring_of_protection" );
		table.insert( shoppingCart, "item_quelling_blade" );
		table.insert( shoppingCart, "item_recipe_iron_talon" );

	elseif ( upgradeItemName == "item_force_staff" ) then

		table.insert( shoppingCart, "item_ring_of_regen" );
		table.insert( shoppingCart, "item_staff_of_wizardry" );
		table.insert( shoppingCart, "item_recipe_force_staff" );

	elseif ( upgradeItemName == "item_vanguard" ) then

		table.insert( shoppingCart, "item_stout_shield" );
		table.insert( shoppingCart, "item_ring_of_health" );
		table.insert( shoppingCart, "item_vitality_booster" );

	elseif ( upgradeItemName == "item_armlet" ) then

		table.insert( shoppingCart, "item_blades_of_attack" );
		table.insert( shoppingCart, "item_gloves" );
		table.insert( shoppingCart, "item_helm_of_iron_will" );
		table.insert( shoppingCart, "item_recipe_armlet" );

	elseif ( upgradeItemName == "item_helm_of_the_dominator" ) then

		table.insert( shoppingCart, "item_gloves" );
		table.insert( shoppingCart, "item_recipe_helm_of_the_dominator" );

	elseif ( upgradeItemName == "item_wraith_band" ) then

		table.insert( shoppingCart, "item_slippers" );
		table.insert( shoppingCart, "item_circlet" );
		table.insert( shoppingCart, "item_recipe_wraith_band" );

	elseif ( upgradeItemName == "item_headdress" ) then

		table.insert( shoppingCart, "item_branches" );
		table.insert( shoppingCart, "item_ring_of_regen" );
		table.insert( shoppingCart, "item_recipe_headdress" );

	elseif ( upgradeItemName == "item_veil_of_discord" ) then

		table.insert( shoppingCart, "item_helm_of_iron_will" );
		table.insert( shoppingCart, "item_recipe_veil_of_discord" );

	elseif ( upgradeItemName == "item_blade_mail" ) then

		table.insert( shoppingCart, "item_robe" );
		table.insert( shoppingCart, "item_chainmail" );
		table.insert( shoppingCart, "item_broadsword" );

	elseif ( upgradeItemName == "item_invis_sword" ) then

		table.insert( shoppingCart, "item_shadow_amulet" );
		table.insert( shoppingCart, "item_claymore" );

	elseif ( upgradeItemName == "item_dragon_lance" ) then

		table.insert( shoppingCart, "item_boots_of_elves" );
		table.insert( shoppingCart, "item_boots_of_elves" );
		table.insert( shoppingCart, "item_ogre_axe" );

	elseif ( upgradeItemName == "item_poor_mans_shield" ) then

		table.insert( shoppingCart, "item_slippers" );
		table.insert( shoppingCart, "item_slippers" );
		table.insert( shoppingCart, "item_stout_shield" );

	elseif ( upgradeItemName == "item_buckler" ) then

		table.insert( shoppingCart, "item_branches" );
		table.insert( shoppingCart, "item_chainmail" );
		table.insert( shoppingCart, "item_recipe_buckler" );

	elseif ( upgradeItemName == "item_aether_lens" ) then

		table.insert( shoppingCart, "item_ring_of_health" );
		table.insert( shoppingCart, "item_energy_booster" );
		table.insert( shoppingCart, "item_recipe_aether_lens" );

	elseif ( upgradeItemName == "item_soul_booster" ) then

		table.insert( shoppingCart, "item_energy_booster" );
		table.insert( shoppingCart, "item_vitality_booster" );
		table.insert( shoppingCart, "item_point_booster" );

	elseif ( upgradeItemName == "item_basher" ) then

		table.insert( shoppingCart, "item_belt_of_strength" );
		table.insert( shoppingCart, "item_javelin" );
		table.insert( shoppingCart, "item_recipe_basher" );

	elseif ( upgradeItemName == "item_sange" ) then

		table.insert( shoppingCart, "item_belt_of_strength" );
		table.insert( shoppingCart, "item_ogre_axe" );
		table.insert( shoppingCart, "item_recipe_sange" );

	elseif ( upgradeItemName == "item_bracer" ) then

		table.insert( shoppingCart, "item_gauntlets" );
		table.insert( shoppingCart, "item_circlet" );
		table.insert( shoppingCart, "item_recipe_bracer" );

	elseif ( upgradeItemName == "item_urn_of_shadows" ) then

		table.insert( shoppingCart, "item_gauntlets" );
		table.insert( shoppingCart, "item_gauntlets" );
		table.insert( shoppingCart, "item_sobi_mask" );
		table.insert( shoppingCart, "item_recipe_urn_of_shadows" );

	elseif ( upgradeItemName == "item_necronomicon_1" ) then

		table.insert( shoppingCart, "item_belt_of_strength" );
		table.insert( shoppingCart, "item_staff_of_wizardry" );
		table.insert( shoppingCart, "item_recipe_necronomicon" );

	elseif ( upgradeItemName == "item_necronomicon_2" ) then

		table.insert( shoppingCart, "item_recipe_necronomicon" );

	elseif ( upgradeItemName == "item_necronomicon_3" ) then

		table.insert( shoppingCart, "item_recipe_necronomicon" );

	elseif ( upgradeItemName == "item_crimson_guard" ) then

		table.insert( shoppingCart, "item_recipe_crimson_guard" );

	elseif ( upgradeItemName == "item_bfury" ) then

		table.insert( shoppingCart, "item_quelling_blade" );
		table.insert( shoppingCart, "item_broadsword" );
		table.insert( shoppingCart, "item_claymore" );

	elseif ( upgradeItemName == "item_yasha" ) then

		table.insert( shoppingCart, "item_boots_of_elves" );
		table.insert( shoppingCart, "item_blade_of_alacrity" );
		table.insert( shoppingCart, "item_recipe_yasha" );

	elseif ( upgradeItemName == "item_soul_ring" ) then

		table.insert( shoppingCart, "item_ring_of_regen" );
		table.insert( shoppingCart, "item_sobi_mask" );
		table.insert( shoppingCart, "item_recipe_soul_ring" );

	elseif ( upgradeItemName == "item_tranquil_boots" ) then

		table.insert( shoppingCart, "item_boots" );
		table.insert( shoppingCart, "item_ring_of_protection" );
		table.insert( shoppingCart, "item_ring_of_regen" );

	elseif ( upgradeItemName == "item_dagon_1" ) then

		table.insert( shoppingCart, "item_staff_of_wizardry" );
		table.insert( shoppingCart, "item_recipe_dagon" );

	elseif ( upgradeItemName == "item_dagon_2" ) then

		table.insert( shoppingCart, "item_recipe_dagon" );

	elseif ( upgradeItemName == "item_dagon_3" ) then

		table.insert( shoppingCart, "item_recipe_dagon" );

	elseif ( upgradeItemName == "item_dagon_4" ) then

		table.insert( shoppingCart, "item_recipe_dagon" );

	elseif ( upgradeItemName == "item_dagon_5" ) then

		table.insert( shoppingCart, "item_recipe_dagon" );

	elseif ( upgradeItemName == "item_black_king_bar" ) then

		table.insert( shoppingCart, "item_ogre_axe" );
		table.insert( shoppingCart, "item_mithril_hammer" );
		table.insert( shoppingCart, "item_recipe_black_king_bar" );

	elseif ( upgradeItemName == "item_ethereal_blade" ) then

		table.insert( shoppingCart, "item_ghost" );
		table.insert( shoppingCart, "item_eagle" );

	elseif ( upgradeItemName == "item_echo_sabre" ) then

		table.insert( shoppingCart, "item_ogre_axe" );

	elseif ( upgradeItemName == "item_phase_boots" ) then

		table.insert( shoppingCart, "item_boots" );
		table.insert( shoppingCart, "item_blades_of_attack" );
		table.insert( shoppingCart, "item_blades_of_attack" );

	elseif ( upgradeItemName == "item_ring_of_aquila" ) then

	elseif ( upgradeItemName == "item_cyclone" ) then

		table.insert( shoppingCart, "item_wind_lace" );
		table.insert( shoppingCart, "item_void_stone" );
		table.insert( shoppingCart, "item_staff_of_wizardry" );
		table.insert( shoppingCart, "item_recipe_cyclone" );

	elseif ( upgradeItemName == "item_lotus_orb" ) then

		table.insert( shoppingCart, "item_energy_booster" );
		table.insert( shoppingCart, "item_platemail" );

	elseif ( upgradeItemName == "item_silver_edge" ) then

		table.insert( shoppingCart, "item_ultimate_orb" );
		table.insert( shoppingCart, "item_recipe_silver_edge" );

	elseif ( upgradeItemName == "item_maelstrom" ) then

		table.insert( shoppingCart, "item_gloves" );
		table.insert( shoppingCart, "item_mithril_hammer" );
		table.insert( shoppingCart, "item_recipe_maelstrom" );

	elseif ( upgradeItemName == "item_power_treads" ) then

		table.insert( shoppingCart, "item_boots" );
		table.insert( shoppingCart, "item_belt_of_strength" );
		table.insert( shoppingCart, "item_gloves" );

	elseif ( upgradeItemName == "item_medallion_of_courage" ) then

		table.insert( shoppingCart, "item_blight_stone" );
		table.insert( shoppingCart, "item_sobi_mask" );
		table.insert( shoppingCart, "item_chainmail" );

	elseif ( upgradeItemName == "item_solar_crest" ) then

		table.insert( shoppingCart, "item_talisman_of_evasion" );

	elseif ( upgradeItemName == "item_shivas_guard" ) then

		table.insert( shoppingCart, "item_platemail" );
		table.insert( shoppingCart, "item_mystic_staff" );
		table.insert( shoppingCart, "item_recipe_shivas_guard" );

	elseif ( upgradeItemName == "item_radiance" ) then

		table.insert( shoppingCart, "item_relic" );
		table.insert( shoppingCart, "item_recipe_radiance" );

	elseif ( upgradeItemName == "item_diffusal_blade_1" ) then

		table.insert( shoppingCart, "item_robe" );
		table.insert( shoppingCart, "item_blade_of_alacrity" );
		table.insert( shoppingCart, "item_blade_of_alacrity" );
		table.insert( shoppingCart, "item_recipe_diffusal_blade" );

	elseif ( upgradeItemName == "item_diffusal_blade_2" ) then

		table.insert( shoppingCart, "item_recipe_diffusal_blade" );

	elseif ( upgradeItemName == "item_oblivion_staff" ) then

		table.insert( shoppingCart, "item_sobi_mask" );
		table.insert( shoppingCart, "item_robe" );
		table.insert( shoppingCart, "item_quarterstaff" );

	elseif ( upgradeItemName == "item_arcane_boots" ) then

		table.insert( shoppingCart, "item_boots" );
		table.insert( shoppingCart, "item_energy_booster" );

	elseif ( upgradeItemName == "item_rod_of_atos" ) then

		table.insert( shoppingCart, "item_staff_of_wizardry" );
		table.insert( shoppingCart, "item_staff_of_wizardry" );
		table.insert( shoppingCart, "item_vitality_booster" );

	elseif ( upgradeItemName == "item_bloodstone" ) then

		table.insert( shoppingCart, "item_recipe_bloodstone" );

	elseif ( upgradeItemName == "item_monkey_king_bar" ) then

		table.insert( shoppingCart, "item_javelin" );
		table.insert( shoppingCart, "item_javelin" );
		table.insert( shoppingCart, "item_demon_edge" );

	elseif ( upgradeItemName == "item_desolator" ) then

		table.insert( shoppingCart, "item_blight_stone" );
		table.insert( shoppingCart, "item_mithril_hammer" );
		table.insert( shoppingCart, "item_mithril_hammer" );

	elseif ( upgradeItemName == "item_pers" ) then

		table.insert( shoppingCart, "item_ring_of_health" );
		table.insert( shoppingCart, "item_void_stone" );

	elseif ( upgradeItemName == "item_ancient_janggo" ) then

		table.insert( shoppingCart, "item_wind_lace" );
		table.insert( shoppingCart, "item_sobi_mask" );
		table.insert( shoppingCart, "item_recipe_ancient_janggo" );

	elseif ( upgradeItemName == "item_orchid" ) then

		table.insert( shoppingCart, "item_recipe_orchid" );

	elseif ( upgradeItemName == "item_manta" ) then

		table.insert( shoppingCart, "item_ultimate_orb" );
		table.insert( shoppingCart, "item_recipe_manta" );

	elseif ( upgradeItemName == "item_greater_crit" ) then

		table.insert( shoppingCart, "item_demon_edge" );
		table.insert( shoppingCart, "item_recipe_greater_crit" );

	elseif ( upgradeItemName == "item_heavens_halberd" ) then

		table.insert( shoppingCart, "item_talisman_of_evasion" );

	elseif ( upgradeItemName == "item_hand_of_midas" ) then

		table.insert( shoppingCart, "item_gloves" );
		table.insert( shoppingCart, "item_recipe_hand_of_midas" );

	elseif ( upgradeItemName == "item_mekansm" ) then

		table.insert( shoppingCart, "item_recipe_mekansm" );

	elseif ( upgradeItemName == "item_ultimate_scepter" ) then

		table.insert( shoppingCart, "item_ogre_axe" );
		table.insert( shoppingCart, "item_staff_of_wizardry" );
		table.insert( shoppingCart, "item_blade_of_alacrity" );
		table.insert( shoppingCart, "item_point_booster" );

	elseif ( upgradeItemName == "item_sphere" ) then

		table.insert( shoppingCart, "item_ultimate_orb" );
		table.insert( shoppingCart, "item_recipe_sphere" );

	elseif ( upgradeItemName == "item_butterfly" ) then

		table.insert( shoppingCart, "item_quarterstaff" );
		table.insert( shoppingCart, "item_talisman_of_evasion" );
		table.insert( shoppingCart, "item_eagle" );

	elseif ( upgradeItemName == "item_sange_and_yasha" ) then

	elseif ( upgradeItemName == "item_travel_boots_1" ) then

		table.insert( shoppingCart, "item_boots" );
		table.insert( shoppingCart, "item_recipe_travel_boots" );

	elseif ( upgradeItemName == "item_travel_boots_2" ) then

		table.insert( shoppingCart, "item_recipe_travel_boots" );

	elseif ( upgradeItemName == "item_vladmir" ) then

		table.insert( shoppingCart, "item_lifesteal" );

	elseif ( upgradeItemName == "item_refresher" ) then

		table.insert( shoppingCart, "item_recipe_refresher" );

	elseif ( upgradeItemName == "item_hurricane_pike" ) then

		table.insert( shoppingCart, "item_recipe_hurricane_pike" );

	elseif ( upgradeItemName == "item_rapier" ) then

		table.insert( shoppingCart, "item_demon_edge" );
		table.insert( shoppingCart, "item_relic" );

	elseif ( upgradeItemName == "item_skadi" ) then

		table.insert( shoppingCart, "item_orb_of_venom" );
		table.insert( shoppingCart, "item_point_booster" );
		table.insert( shoppingCart, "item_ultimate_orb" );
		table.insert( shoppingCart, "item_ultimate_orb" );

	elseif ( upgradeItemName == "item_moon_shard" ) then

		table.insert( shoppingCart, "item_hyperstone" );
		table.insert( shoppingCart, "item_hyperstone" );

	elseif ( upgradeItemName == "item_pipe" ) then

		table.insert( shoppingCart, "item_recipe_pipe" );

	elseif ( upgradeItemName == "item_sheepstick" ) then

		table.insert( shoppingCart, "item_void_stone" );
		table.insert( shoppingCart, "item_ultimate_orb" );
		table.insert( shoppingCart, "item_mystic_staff" );

	elseif ( upgradeItemName == "item_assault" ) then

		table.insert( shoppingCart, "item_chainmail" );
		table.insert( shoppingCart, "item_platemail" );
		table.insert( shoppingCart, "item_hyperstone" );
		table.insert( shoppingCart, "item_recipe_assault" );

	elseif ( upgradeItemName == "item_abyssal_blade" ) then

		table.insert( shoppingCart, "item_recipe_abyssal_blade" );

	elseif ( upgradeItemName == "item_mjollnir" ) then

		table.insert( shoppingCart, "item_hyperstone" );
		table.insert( shoppingCart, "item_recipe_mjollnir" );

	elseif ( upgradeItemName == "item_guardian_greaves" ) then

		table.insert( shoppingCart, "item_recipe_guardian_greaves" );

	elseif ( upgradeItemName == "item_octarine_core" ) then

		table.insert( shoppingCart, "item_mystic_staff" );

	elseif ( upgradeItemName == "item_heart" ) then

		table.insert( shoppingCart, "item_vitality_booster" );
		table.insert( shoppingCart, "item_reaver" );
		table.insert( shoppingCart, "item_recipe_heart" );

	elseif ( upgradeItemName == "item_bloodthorn" ) then

		table.insert( shoppingCart, "item_recipe_bloodthorn" );

	elseif ( upgradeItemName == "item_satanic" ) then

		table.insert( shoppingCart, "item_lifesteal" );
		table.insert( shoppingCart, "item_mithril_hammer" );
		table.insert( shoppingCart, "item_reaver" );

	end

end

----------------------------------------------------------------------------------------------------

function ItemPurchase()

	local npcBot = GetBot();

	--------------------------------------------------------------------------

	-- make sure item purchase of several different roles or styles.
	-- TODO

	--------------------------------------------------------------------------

	npcBot.item_travel_boots_1 = J.GetItemIncludeStash( "item_travel_boots_1" );
	npcBot.item_travel_boots_2 = J.GetItemIncludeStash( "item_travel_boots_2" );

	-- sell unuse item_flying_courier
	SellUnuseFlying();

	-- use item_tome_of_knowledge
	TomeOfKnowledge();

	-- courier, ward, smoke of deceit, dust, gem of true sight and so on
	AuxiliaryItem();

	if ( npcBot.tableItemsToBuy == nil or #npcBot.tableItemsToBuy == 0 ) then
		npcBot:SetNextItemPurchaseValue( 0 );
		return;
	end

	local sNextItem = npcBot.tableItemsToBuy[1];
	npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

	if ( npcBot:GetGold() >= GetItemCost( sNextItem ) ) then

		if ( IsItemPurchasedFromSecretShop( sNextItem ) and IsItemPurchasedFromSideShop( sNextItem ) ) then
			if ( npcBot:DistanceFromSecretShop() == 0 or npcBot:DistanceFromSideShop() == 0 ) then
				if ( J.HasEmptySlotsIncludeBackpack() and npcBot:ActionImmediate_PurchaseItem( sNextItem ) == PURCHASE_ITEM_SUCCESS ) then
					table.remove( npcBot.tableItemsToBuy, 1 );
				end

				npcBot.secretShopMode = false;
				npcBot.sideShopMode = false;
			elseif ( npcBot:DistanceFromSecretShop() <= npcBot:DistanceFromSideShop() ) then
				if ( not npcBot.secretShopMode and IsSuitablePurchaseActiveMode() ) then
					npcBot.secretShopMode = true;
					npcBot.sideShopMode = false;
				end
			elseif ( npcBot:DistanceFromSecretShop() > npcBot:DistanceFromSideShop() ) then
				if ( not npcBot.sideShopMode and IsSuitablePurchaseActiveMode() ) then
					npcBot.secretShopMode = false;
					npcBot.sideShopMode = true;
				end
			end
		elseif ( IsItemPurchasedFromSecretShop( sNextItem ) and not IsItemPurchasedFromSideShop( sNextItem ) ) then
			if ( npcBot:DistanceFromSecretShop() == 0 ) then
				if ( J.HasEmptySlotsIncludeBackpack() and npcBot:ActionImmediate_PurchaseItem( sNextItem ) == PURCHASE_ITEM_SUCCESS ) then
					table.remove( npcBot.tableItemsToBuy, 1 );
				end

				npcBot.secretShopMode = false;
				npcBot.sideShopMode = false;
			else
				if ( not npcBot.secretShopMode and IsSuitablePurchaseActiveMode() ) then
					npcBot.secretShopMode = true;
					npcBot.sideShopMode = false;
				end
			end
		elseif ( not IsItemPurchasedFromSecretShop( sNextItem ) and IsItemPurchasedFromSideShop( sNextItem ) ) then
			if ( npcBot:DistanceFromSideShop() == 0 ) then
				if ( npcBot:ActionImmediate_PurchaseItem( sNextItem ) == PURCHASE_ITEM_SUCCESS ) then
					table.remove( npcBot.tableItemsToBuy, 1 );
					npcBot.secretShopMode = false;
					npcBot.sideShopMode = false;
				end
			elseif ( npcBot:DistanceFromSideShop() < 2500 ) then
				if ( not npcBot.sideShopMode and IsSuitablePurchaseActiveMode() ) then
					npcBot.secretShopMode = false;
					npcBot.sideShopMode = true;
				end
			else
				if ( npcBot:ActionImmediate_PurchaseItem( sNextItem ) == PURCHASE_ITEM_SUCCESS ) then
					table.remove( npcBot.tableItemsToBuy, 1 );
					npcBot.secretShopMode = false;
					npcBot.sideShopMode = false;
				end
			end
		else
			if ( npcBot:ActionImmediate_PurchaseItem( sNextItem ) == PURCHASE_ITEM_SUCCESS ) then
				table.remove( npcBot.tableItemsToBuy, 1 );
				npcBot.secretShopMode = false;
				npcBot.sideShopMode = false;
			end
		end
	else
		npcBot.secretShopMode = false;
		npcBot.sideShopMode = false;
	end

end

----------------------------------------------------------------------------------------------------

function SellUnuseFlying()

	local npcBot = GetBot();

	if ( not npcBot:IsAlive() or npcBot:IsUsingAbility() ) then
		return;
	end

	local item_flying_courier = J.GetItemIncludeStash( "item_flying_courier" );

	if ( npcBot:DistanceFromFountain() == 0 and item_flying_courier ~= nil ) then
		npcBot:ActionImmediate_SellItem( item_flying_courier );
	end

end

----------------------------------------------------------------------------------------------------

function TomeOfKnowledge()

	local npcBot = GetBot();

	if ( not npcBot:IsAlive() or npcBot:IsUsingAbility() ) then
		return;
	end

	local item_knowledge = J.GetItemAvailable( "item_tome_of_knowledge" );

	if ( npcBot:DistanceFromFountain() == 0 ) then
		if ( (J.HasEmptySlotsInInventory() or item_knowledge ~= nil)
			and GetItemStockCount("item_tome_of_knowledge") > 0 
			and npcBot:GetGold() >= GetItemCost("item_tome_of_knowledge") ) then

			npcBot:ActionImmediate_PurchaseItem( "item_tome_of_knowledge" );
			npcBot:ActionPush_UseAbility( item_knowledge );
		end
	end

	if ( item_knowledge ~= nil ) then
		npcBot:Action_UseAbility( item_knowledge );
	end

end

----------------------------------------------------------------------------------------------------

-- courier, ward, smoke of deceit, dust, gem of true sight and so on
function AuxiliaryItem()

	local npcBot = GetBot();
	npcBot.buyCourier = nil;

	local couriersNum = GetNumCouriers();
	if ( couriersNum > 0 ) then
		for i = 0, couriersNum - 1, 1 do
			local courier = GetCourier(i);
			if ( not IsFlyingCourier(courier) ) then
				npcBot.buyCourier = courier;
				break;
			end
		end

		for i = 0, couriersNum - 1, 1 do
			local courier = GetCourier(i);
			if ( IsFlyingCourier(courier) ) then
				npcBot.buyCourier = courier;
				break;
			end
		end
	end

	local myTeam = GetTeam();
	local enemyTeam = GetOpposingTeam();
	local allyHeroes = J.GetOurHeroes();

	-- assign the top two bot supporters
	-- carry or mid bot can't be assigned to supporter!
	local mostSuitableSupportName = "";
	local secondSuitableSupportName = "";
	local teamRoles = J.GetTeamRoles();

	local offlaneId = teamRoles["offlane"];
	local pureSupportId = teamRoles["pureSupport"];
	local semiSupportId = teamRoles["semiSupport"];

	if ( IsPlayerBot(pureSupportId) ) then
		mostSuitableSupportName = GetSelectedHeroName(pureSupportId);
	elseif ( IsPlayerBot(semiSupportId) ) then
		mostSuitableSupportName = GetSelectedHeroName(semiSupportId);
	elseif ( IsPlayerBot(offlaneId) ) then
		mostSuitableSupportName = GetSelectedHeroName(offlaneId);
	end

	if ( IsPlayerBot(pureSupportId) and GetSelectedHeroName(pureSupportId) ~= mostSuitableSupportName ) then
		secondSuitableSupportName = GetSelectedHeroName(pureSupportId);
	elseif ( IsPlayerBot(semiSupportId) and GetSelectedHeroName(semiSupportId) ~= mostSuitableSupportName ) then
		secondSuitableSupportName = GetSelectedHeroName(semiSupportId);
	elseif ( IsPlayerBot(offlaneId) and GetSelectedHeroName(offlaneId) ~= mostSuitableSupportName ) then
		secondSuitableSupportName = GetSelectedHeroName(offlaneId);
	end

	-- avoid only one bot
	if ( mostSuitableSupportName ~= "" and secondSuitableSupportName == "" ) then
		secondSuitableSupportName = mostSuitableSupportName;
	end

	-- decide if there were several invisible enemy heroes.
	local hasInvisibleEnemy = false;
	if ( enemyTeam ~= nil ) then
		for _, id in pairs( GetTeamPlayers(enemyTeam) ) do
			for _, invisibleHeroName in pairs(invisibleHeroes) do
				if ( GetSelectedHeroName(id) == invisibleHeroName ) then
					hasInvisibleEnemy = true;
					break;
				end
			end
		end
	end

	---------------------------------------------------------

	local minute = J.GetDotaMinute();

	-- share my tango with our friends for .^_^.
	-- if DotaTime < 0, the target will change to the mid-player for the future planning.
	local my_item_tango = J.GetItemInInventory( "item_tango" );
	local ally_item_tango = nil;
	local ally_item_tango_single = nil;
	if ( npcBot:GetUnitName() == mostSuitableSupportName or npcBot:GetUnitName() == secondSuitableSupportName ) then
		for _, ally in pairs(allyHeroes) do
			if ( (DotaTime() > -75 and DotaTime() < -60)
				or (DotaTime() >= 0 and my_item_tango ~= nil and my_item_tango:GetCurrentCharges() > 2 
				and GetUnitToUnitDistance(npcBot, ally) < 400) ) then

				ally_item_tango = J.GetNpcItemIncludeBackpack( ally, "item_tango" );
				ally_item_tango_single = J.GetNpcItemIncludeBackpack( ally, "item_tango_single" );

				if ( ally_item_tango == nil and ally_item_tango_single == nil ) then
					if ( not npcBot:IsUsingAbility() ) then
						npcBot:Action_UseAbilityOnEntity( my_item_tango, ally );
					end
				end
			end
		end
	end

	-- starting items supported
	if ( DotaTime() < 0 and npcBot:GetUnitName() == secondSuitableSupportName ) then
		if ( npcBot.buyCourier == nil and GetItemStockCount("item_courier") > 0 
			and npcBot:GetGold() >= GetItemCost("item_courier") ) then
			npcBot:ActionImmediate_PurchaseItem( "item_courier" );
		end
	elseif ( DotaTime() < 0 and npcBot:GetUnitName() == mostSuitableSupportName ) then
		if ( GetItemStockCount("item_ward_observer") == 2 and npcBot:GetGold() >= GetItemCost("item_ward_observer") * 2 ) then
			npcBot:ActionImmediate_PurchaseItem( "item_ward_observer" );
			npcBot:ActionImmediate_PurchaseItem( "item_ward_observer" );
		elseif ( GetItemStockCount("item_ward_observer") == 1 and npcBot:GetGold() >= GetItemCost("item_ward_observer") ) then
			npcBot:ActionImmediate_PurchaseItem( "item_ward_observer" );
		end

		if ( GetItemStockCount("item_smoke_of_deceit") > 0 and npcBot:GetGold() >= GetItemCost("item_smoke_of_deceit")
			and bDoOnce_Smoke == false ) then
			npcBot:ActionImmediate_PurchaseItem( "item_smoke_of_deceit" );
			bDoOnce_Smoke = true;
		end

		if ( DotaTime() > -65 and DotaTime() < -60 ) then
			local item_smoke_of_deceit = J.GetItemInInventory( "item_smoke_of_deceit" );
			if ( item_smoke_of_deceit ~= nil ) then
				npcBot:Action_UseAbility( item_smoke_of_deceit );
			end
		end
	elseif ( minute % 2 == 0 and npcBot:GetUnitName() == mostSuitableSupportName ) then
		local my_ward_observer_count = J.GetWardObserverCountIncludeStash();

		if ( my_ward_observer_count < 3 and GetItemStockCount("item_ward_observer") > 0 
			and npcBot:GetGold() >= GetItemCost("item_ward_observer") ) then
			npcBot:ActionImmediate_PurchaseItem( "item_ward_observer" );
		end
	elseif ( minute >= 5 and minute < 15 and npcBot:GetUnitName() == secondSuitableSupportName ) then
		if ( npcBot.buyCourier ~= nil and npcBot.buyCourier:IsAlive() and not IsFlyingCourier(npcBot.buyCourier)
			and npcBot.buyCourier:DistanceFromFountain() == 0
			and npcBot:DistanceFromFountain() > 2000
			and GetItemStockCount("item_flying_courier") > 0
			and npcBot:GetGold() >= GetItemCost("item_flying_courier") ) then

			npcBot:ActionImmediate_PurchaseItem( "item_flying_courier" );
		end

		--[[
		-- second planning
		local couriersNum = GetNumCouriers();
		if ( couriersNum > 0 ) then
			for i = 0, couriersNum - 1, 1 do
				local courier = GetCourier(i);

				if ( courier:IsAlive() and not IsFlyingCourier(courier)
					and GetCourierState(courier) == COURIER_STATE_AT_BASE
					and npcBot:DistanceFromFountain() > 2000
					and GetItemStockCount("item_flying_courier") > 0
					and npcBot:GetGold() >= GetItemCost("item_flying_courier") ) then
					
					npcBot:ActionImmediate_PurchaseItem( "item_flying_courier" );
				end
			end
		end
		]]
	elseif ( minute >= 10 and hasInvisibleEnemy == true ) then
		if ( npcBot:GetUnitName() == mostSuitableSupportName or npcBot:GetUnitName() == secondSuitableSupportName ) then
			local item_dust = J.GetItemIncludeBackpack( "item_dust" );

			if ( item_dust == nil and GetItemStockCount("item_dust") > 0 
				and npcBot:GetGold() >= GetItemCost("item_dust") ) then
				npcBot:ActionImmediate_PurchaseItem( "item_dust" );
			end
		end
	end

end

----------------------------------------------------------------------------------------------------

function NoNeedTpscrollForTravelBoots()

	local npcBot = GetBot();

	npcBot.item_travel_boots_1 = J.GetItemIncludeStash( "item_travel_boots_1" );
	npcBot.item_travel_boots_2 = J.GetItemIncludeStash( "item_travel_boots_2" );
	local item_tpscroll = J.GetItemIncludeStash( "item_tpscroll" );

	if ( npcBot.item_travel_boots_1 ~= nil or npcBot.item_travel_boots_2 ~= nil) then
		if ( item_tpscroll ~= nil and npcBot:DistanceFromFountain() == 0 ) then
			npcBot:ActionImmediate_SellItem( "item_tpscroll" );
		end
	end

end

----------------------------------------------------------------------------------------------------

function WeNeedTpscroll()

	local npcBot = GetBot();

	local item_tpscroll = J.GetItemIncludeBackpack( "item_tpscroll" );

	-- Count current number of TP scrolls
	local iScrollCount = 0;

	if ( item_tpscroll ~= nil ) then
		iScrollCount = item_tpscroll:GetCurrentCharges();
	end

	-- If we are at the sideshop or fountain with no TPs, then buy one or two
	if ( iScrollCount == 0 and npcBot.item_travel_boots_1 == nil and npcBot.item_travel_boots_2 == nil ) then

		if ( npcBot:DistanceFromSideShop() == 0 or npcBot:DistanceFromFountain() == 0 ) then

			if ( DotaTime() > 0 and DotaTime() < 20 * 60 ) then
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
			elseif ( DotaTime() >= 20 * 60 ) then
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
				npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
			end
		end
	end

end

----------------------------------------------------------------------------------------------------

function SellItemForFullInventory( item_name )

	local npcBot = GetBot();

	local itemCount = 0;
	local item = nil;

	for i = 0, 5 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil ) then
			itemCount = itemCount + 1;
		end
	end

	if ( item_name ~= nil and item_name ~= "" ) then
		item = J.GetItemIncludeStash( item_name );
	end

	if ( item ~= nil and itemCount > 5
		and npcBot:DistanceFromFountain() == 0 ) then
		npcBot:ActionImmediate_SellItem( item );
	end

end

----------------------------------------------------------------------------------------------------

function SellItemForFull( item_name )

	local npcBot = GetBot();

	local itemCount = 0;
	local item = nil;

	for i = 0, 8 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil ) then
			itemCount = itemCount + 1;
		end
	end

	if ( item_name ~= nil and item_name ~= "" ) then
		item = J.GetItemIncludeStash( item_name );
	end

	if ( item ~= nil and itemCount > 8
		and npcBot:DistanceFromFountain() == 0 ) then
		npcBot:ActionImmediate_SellItem( item );
	end

end

----------------------------------------------------------------------------------------------------

function SellItemForSpecifiedItem( item_name, specified_name )

	local npcBot = GetBot();

	local item = nil;
	local specified = nil;

	if ( item_name ~= nil and item_name ~= "" ) then
		item = J.GetItemIncludeStash( item_name );
	end

	if ( specified_name ~= nil and specified_name ~= "" ) then
		specified = J.GetItemIncludeStash( specified_name );
	end

	if ( item ~= nil and specified ~= nil
		and npcBot:DistanceFromFountain() == 0 ) then
		npcBot:ActionImmediate_SellItem( item );
	end

end

----------------------------------------------------------------------------------------------------

function BuyTravelBootsSinceHasSpecifiedItem( specified_name )

	local npcBot = GetBot();

	local item_boots = nil;
	local item_travel_boots1 = nil;
	local specified = nil;

	for i = 0, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil ) then
			if ( sCurItem:GetName() == "item_power_treads"
				or sCurItem:GetName() == "item_arcane_boots"
				or sCurItem:GetName() == "item_phase_boots"
				or sCurItem:GetName() == "item_tranquil_boots" ) then
				item_boots = sCurItem;
			end
		end

		if ( sCurItem ~= nil and sCurItem:GetName() == "item_travel_boots1" ) then
			item_travel_boots1 = sCurItem;
		end

		if ( sCurItem ~= nil and sCurItem:GetName() == specified_name ) then
			specified = sCurItem;
		end
	end

	if ( item_travel_boots1 == nil and item_boots ~= nil and  specified ~= nil and npcBot:DistanceFromFountain() == 0 
		and npcBot:GetGold() > (GetItemCost("item_recipe_travel_boots") + GetItemCost("item_boots") - GetItemCost(item_boots:GetName()) / 2) ) then
		npcBot:ActionImmediate_SellItem( item_boots );
		npcBot:ActionImmediate_PurchaseItem( "item_recipe_travel_boots" );
		npcBot:ActionImmediate_PurchaseItem( "item_boots" );
	end

	if ( item_travel_boots1 ~= nil and npcBot:DistanceFromFountain() == 0 and npcBot:GetGold() > GetItemCost("item_recipe_travel_boots") ) then
		npcBot:ActionImmediate_PurchaseItem( "item_recipe_travel_boots" );
	end

end

----------------------------------------------------------------------------------------------------

function BuyTravelBootsSinceHasSpecifiedItems( specified_name1, specified_name2 )

	local npcBot = GetBot();

	local item_boots = nil;
	local item_travel_boots1 = nil;
	local specified1 = nil;
	local specified2 = nil;

	for i = 0, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil ) then
			if ( sCurItem:GetName() == "item_power_treads"
				or sCurItem:GetName() == "item_arcane_boots"
				or sCurItem:GetName() == "item_phase_boots"
				or sCurItem:GetName() == "item_tranquil_boots" ) then
				item_boots = sCurItem;
			end
		end

		if ( sCurItem ~= nil and sCurItem:GetName() == "item_travel_boots1" ) then
			item_travel_boots1 = sCurItem;
		end

		if ( sCurItem ~= nil and sCurItem:GetName() == specified_name1 ) then
			specified1 = sCurItem;
		end

		if ( sCurItem ~= nil and sCurItem:GetName() == specified_name2 ) then
			specified2 = sCurItem;
		end
	end

	if ( item_travel_boots1 == nil and item_boots ~= nil and specified1 ~= nil and npcBot:DistanceFromFountain() == 0 
		and npcBot:GetGold() > (GetItemCost("item_recipe_travel_boots") + GetItemCost("item_boots") - GetItemCost(item_boots:GetName()) / 2) ) then
		npcBot:ActionImmediate_SellItem( item_boots );
		npcBot:ActionImmediate_PurchaseItem( "item_recipe_travel_boots" );
		npcBot:ActionImmediate_PurchaseItem( "item_boots" );
	end

	if ( item_travel_boots1 ~= nil and specified2 ~= nil 
		and npcBot:DistanceFromFountain() == 0 and npcBot:GetGold() > GetItemCost("item_recipe_travel_boots") ) then
		npcBot:ActionImmediate_PurchaseItem( "item_recipe_travel_boots" );
	end

end

----------------------------------------------------------------------------------------------------

function PurchaseMoonShardSinceHasSpecifiedItem( specified_name )

	local npcBot = GetBot();

	local item_moon_shard = nil;
	local specified = nil;

	item_moon_shard = J.GetItemIncludeBackpack( "item_moon_shard" );
	specified = J.GetItemIncludeBackpack( specified_name );

	if ( not npcBot:HasModifier("modifier_item_moon_shard_consumed") and npcBot:DistanceFromSecretShop() == 0
		and item_moon_shard == nil and specified ~= nil and J.HasEmptySlotsIncludeBackpack()
		and npcBot:GetGold() > GetItemCost("item_hyperstone") ) then
		npcBot:ActionImmediate_PurchaseItem( "item_hyperstone" );
	end

end

----------------------------------------------------------------------------------------------------

function DevourMoonShardSinceHasSpecifiedItem( specified_name )

	local npcBot = GetBot();

	local item_moon_shard1 = nil;
	local item_moon_shard2 = nil;
	local specified = nil;

	item_moon_shard1 = J.GetItemInInventory( "item_moon_shard" );
	item_moon_shard2 = J.GetItemInBackpack( "item_moon_shard" );
	specified = J.GetItemIncludeBackpack( specified_name );

	if ( not npcBot:HasModifier("modifier_item_moon_shard_consumed") and specified ~= nil ) then
		if ( item_moon_shard1 ~= nil and item_moon_shard2 ~= nil ) then
			npcBot:Action_UseAbilityOnEntity( item_moon_shard1, npcBot );
		elseif ( item_moon_shard1 == nil and item_moon_shard2 ~= nil ) then

			if ( not J.HasEmptySlotsInInventory() ) then
				local cheapestItem = J.GetCheapestItemInInventory();
				local cheapestItemSlot = npcBot:FindItemSlot( cheapestItem:GetName() );
				local moonShardSlot = npcBot:FindItemSlot( "item_moon_shard" );

				npcBot:ActionImmediate_SwapItems( cheapestItemSlot, moonShardSlot );
				npcBot:Action_UseAbilityOnEntity( item_moon_shard2, npcBot );
			end
		
		elseif ( item_moon_shard1 ~= nil and item_moon_shard2 == nil ) then
			npcBot:Action_UseAbilityOnEntity( item_moon_shard1, npcBot );
		end
	end

end

----------------------------------------------------------------------------------------------------

function BuyDiffusalBlade2()

	local npcBot = GetBot();

	local item_diffusal_blade_1 = nil;
	local item_diffusal_blade_2 = nil;
	
	item_diffusal_blade_1 = J.GetItemIncludeStash( "item_diffusal_blade_1" );
	item_diffusal_blade_2 = J.GetItemIncludeStash( "item_diffusal_blade_2" );

	if ( item_diffusal_blade_1 ~= nil and item_diffusal_blade_2 == nil 
		and item_diffusal_blade_1:GetCurrentCharges() < 2 and npcBot:GetGold() > GetItemCost("item_recipe_diffusal_blade") ) then
		npcBot:ActionImmediate_PurchaseItem( "item_recipe_diffusal_blade" );
	end

end

----------------------------------------------------------------------------------------------------

-- cant go to secretShop or sideShop in the following active mode
function IsSuitablePurchaseActiveMode()

	local npcBot = GetBot();

	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT
		or npcBot:GetActiveMode() == BOT_MODE_ATTACK
		or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY
		or npcBot:GetActiveMode() == BOT_MODE_ROSHAN
		or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
		or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
		or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT 
		or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
		or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
		or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT ) then
		return false;
	end

	return true;

end

----------------------------------------------------------------------------------------------------

for k,v in pairs( purchase ) do	_G._savedEnv[k] = v end

----------------------------------------------------------------------------------------------------