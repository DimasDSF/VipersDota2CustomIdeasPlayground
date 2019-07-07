if not InvManager then
	InvManager = class({})
end

function InvManager:Init()
	
end

function InvManager:HeroHasUsableItemInInventory( hero, item, mutedallowed, backpackallowed, stashallowed )
	if not hero then return false end
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return false
	end
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						return true
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return true
					elseif i >= 9 and stashallowed == true then
						return true
					else 
						return false
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						return true
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return true
					elseif i >= 9 and stashallowed == true then
						return true
					else 
						return false
					end
				else
					return false
				end
			end
		end
	end
end

function InvManager:HeroHasReadyItemInInventory( hero, item, mutedallowed, backpackallowed, stashallowed )
	if not hero then return false end
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return false
	end
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item and slotitem:GetCooldownTimeRemaining() <= 0 then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						return true
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return true
					elseif i >= 9 and stashallowed == true then
						return true
					else 
						return false
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						return true
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return true
					elseif i >= 9 and stashallowed == true then
						return true
					else 
						return false
					end
				else
					return false
				end
			end
		end
	end
end

function InvManager:GetItemFromInventoryByName( hero, item, mutedallowed, backpackallowed, stashallowed )
	if not hero then return nil end
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return nil
	end
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						return slotitem
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return slotitem
					elseif i >= 9 and stashallowed == true then
						return slotitem
					else 
						return nil
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						return slotitem
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return slotitem
					elseif i >= 9 and stashallowed == true then
						return slotitem
					else 
						return nil
					end
				else
					return nil
				end
			end
		end
	end
	return nil
end

function InvManager:GetItemSlotFromInventoryByItemName( hero, item, mutedallowed, backpackallowed, stashallowed )
	if not hero then return -1 end
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return -1
	end
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						return i
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return i
					elseif i >= 9 and stashallowed == true then
						return i
					else 
						return -1
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						return i
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return i
					elseif i >= 9 and stashallowed == true then
						return i
					else 
						return -1
					end
				else
					return -1
				end
			end
		end
	end
end

function InvManager:CountUsableItemsInHeroInventory( hero, item, mutedallowed, backpackallowed, stashallowed )
	if not hero then return 0 end
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return 0
	end
	local itemcount = 0
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						itemcount = itemcount + 1
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						itemcount = itemcount + 1
					elseif i >= 9 and stashallowed == true then
						itemcount = itemcount + 1
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						itemcount = itemcount + 1
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						itemcount = itemcount + 1
					elseif i >= 9 and stashallowed == true then
						itemcount = itemcount + 1
					end
				end
			end
		end
	end
	return itemcount
end

function InvManager:CountUsableItemChargesInHeroInventory( hero, item, mutedallowed, backpackallowed, stashallowed )
	if not hero then return 0 end
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return 0
	end
	local itemcount = 0
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			local charges = 1
			if slotitem:GetName() == item then
				if slotitem:GetCurrentCharges() > 1 then
					charges = slotitem:GetCurrentCharges()
				end
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						itemcount = itemcount + charges
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						itemcount = itemcount + charges
					elseif i >= 9 and stashallowed == true then
						itemcount = itemcount + charges
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						itemcount = itemcount + charges
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						itemcount = itemcount + charges
					elseif i >= 9 and stashallowed == true then
						itemcount = itemcount + charges
					end
				end
			end
		end
	end
	return itemcount
end

function InvManager:GetHeroInventoryItemsNum( hero, mutedallowed, inventoryallowed, backpackallowed, stashallowed )
	if not hero then return 0 end
	local itemcount = 0
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:IsMuted() and mutedallowed == true then
				if i <= 5 and inventoryallowed then
					itemcount = itemcount + 1
				elseif i >= 6 and i <= 8 and backpackallowed == true then
					itemcount = itemcount + 1
				elseif i >= 9 and stashallowed == true then
					itemcount = itemcount + 1
				end
			elseif not slotitem:IsMuted() then
				if i <= 5 and inventoryallowed then
					itemcount = itemcount + 1
				elseif i >= 6 and i <= 8 and backpackallowed == true then
					itemcount = itemcount + 1
				elseif i >= 9 and stashallowed == true then
					itemcount = itemcount + 1
				end
			end
		end
	end
	return itemcount
end

function InvManager:RemoveNItemsInInventory( hero, item, num )
	local removeditemsnum = 0
	for i = 0, 14 do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item and removeditemsnum < num then
				hero:RemoveItem(slotitem)
				removeditemsnum = removeditemsnum + 1
			elseif removeditemsnum >= num then
				break
			end
		end
	end
	return
end

function InvManager:HeroHasAllItemsFromListWMultiple( hero, itemlist, backpack )
	if not hero then return false end
	for i=1,#itemlist.itemnames do
		if InvManager:CountUsableItemsInHeroInventory( hero, itemlist.itemnames[i], false, backpack, false) < itemlist.itemnum[i] then
			return false
		end
	end
	return true
end

function InvManager:GetHeroFreeInventorySlots( hero, inventoryallowed, backpackallowed, stashallowed )
	if not hero then return 0 end
	local slotcount = 0
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot, 1 do
		if hero:GetItemInSlot(i) == nil then
			if i <= 5 and inventoryallowed then
				slotcount = slotcount + 1
			elseif i >= 6 and i <= 8 and backpackallowed == true then
				slotcount = slotcount + 1
			elseif i >= 9 and stashallowed == true then
				slotcount = slotcount + 1
			end
		end
	end
	return slotcount
end

function InvManager:GetHeroFirstFreeInventorySlot( hero, inventoryallowed, backpackallowed, stashallowed )
	if not hero then return nil end
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot, 1 do
		if hero:GetItemInSlot(i) == nil then
			if i <= 5 and inventoryallowed == true then
				return i
			elseif i >= 6 and i <= 8 and backpackallowed == true then
				return i
			elseif i >= 9 and stashallowed == true then
				return i
			end
		end
	end
	return nil
end

function InvManager:GetHeroInventoryItemsCost( hero, inventoryallowed, backpackallowed, stashallowed )
	if not hero then return 0 end
	local price = 0
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot, 1 do
		local item = hero:GetItemInSlot(i)
		if item ~= nil then
			local itemprice = item:GetCost()
			if item:GetCurrentCharges() > 1 then
				itemprice = item:GetCost() * item:GetCurrentCharges()
			end
			if i <= 5 and inventoryallowed == true then
				price = price + itemprice
			elseif i >= 6 and i <= 8 and backpackallowed == true then
				price = price + itemprice
			elseif i >= 9 and stashallowed == true then
				price = price + itemprice
			end
		end
	end
	return price
end

GameRules.InvManager = InvManager