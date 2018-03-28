--Purges Specific spells from dominated creeps

modifier_vgmar_util_give_debugitems = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_util_give_debugitems:GetTexture()
	return "custom/dev"
end

--------------------------------------------------------------------------------

function modifier_vgmar_util_give_debugitems:IsHidden()
    return false
end

function modifier_vgmar_util_give_debugitems:IsPurgable()
	return false
end

function modifier_vgmar_util_give_debugitems:RemoveOnDeath()
	return false
end

function modifier_vgmar_util_give_debugitems:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_vgmar_util_give_debugitems:OnCreated( kv )
	self.items = {}
	if kv.item1 ~= nil then
		table.insert(self.items, kv.item1)
	end
	if kv.item2 ~= nil then 
		table.insert(self.items, kv.item2)
	end
	if kv.item3 ~= nil then
		table.insert(self.items, kv.item3)
	end
	if kv.item4 ~= nil then 
		table.insert(self.items, kv.item4)
	end
	if kv.item5 ~= nil then
		table.insert(self.items, kv.item5)
	end
	if kv.item6 ~= nil then 
		table.insert(self.items, kv.item6)
	end
	if kv.item7 ~= nil then
		table.insert(self.items, kv.item7)
	end
	if kv.item8 ~= nil then 
		table.insert(self.items, kv.item8)
	end
	if kv.item9 ~= nil then
		table.insert(self.items, kv.item9)
	end
	if kv.item10 ~= nil then 
		table.insert(self.items, kv.item10)
	end
	if kv.item11 ~= nil then
		table.insert(self.items, kv.item11)
	end
	if kv.item12 ~= nil then 
		table.insert(self.items, kv.item12)
	end
	if kv.item13 ~= nil then
		table.insert(self.items, kv.item13)
	end
	if kv.item14 ~= nil then 
		table.insert(self.items, kv.item14)
	end
	if kv.item15 ~= nil then
		table.insert(self.items, kv.item15)
	end
	if kv.item16 ~= nil then 
		table.insert(self.items, kv.item16)
	end
	if kv.item17 ~= nil then
		table.insert(self.items, kv.item17)
	end
	if kv.item18 ~= nil then 
		table.insert(self.items, kv.item18)
	end
	if kv.item19 ~= nil then
		table.insert(self.items, kv.item19)
	end
	if kv.item20 ~= nil then 
		table.insert(self.items, kv.item20)
	end
	if kv.item21 ~= nil then
		table.insert(self.items, kv.item21)
	end
	if kv.item22 ~= nil then 
		table.insert(self.items, kv.item22)
	end
	if kv.item23 ~= nil then
		table.insert(self.items, kv.item23)
	end
	if kv.item24 ~= nil then 
		table.insert(self.items, kv.item24)
	end
	if kv.item25 ~= nil then
		table.insert(self.items, kv.item25)
	end
	if kv.item26 ~= nil then 
		table.insert(self.items, kv.item26)
	end
	if kv.item27 ~= nil then
		table.insert(self.items, kv.item27)
	end
	if kv.item28 ~= nil then 
		table.insert(self.items, kv.item28)
	end
	if kv.item29 ~= nil then
		table.insert(self.items, kv.item29)
	end
	if kv.item30 ~= nil then 
		table.insert(self.items, kv.item30)
	end
	if kv.item31 ~= nil then 
		table.insert(self.items, kv.item31)
	end
	if kv.item32 ~= nil then 
		table.insert(self.items, kv.item32)
	end
	if kv.item33 ~= nil then 
		table.insert(self.items, kv.item33)
	end
	if kv.item34 ~= nil then 
		table.insert(self.items, kv.item34)
	end
	if kv.item35 ~= nil then 
		table.insert(self.items, kv.item35)
	end
	if kv.item36 ~= nil then 
		table.insert(self.items, kv.item36)
	end
	if kv.item37 ~= nil then 
		table.insert(self.items, kv.item37)
	end
	if kv.item38 ~= nil then 
		table.insert(self.items, kv.item38)
	end
	if kv.item39 ~= nil then 
		table.insert(self.items, kv.item39)
	end
	if kv.item40 ~= nil then 
		table.insert(self.items, kv.item40)
	end
	if kv.item41 ~= nil then 
		table.insert(self.items, kv.item41)
	end
	if kv.item42 ~= nil then 
		table.insert(self.items, kv.item42)
	end
	if kv.item43 ~= nil then 
		table.insert(self.items, kv.item43)
	end
	if kv.item44 ~= nil then 
		table.insert(self.items, kv.item44)
	end
	if kv.item45 ~= nil then 
		table.insert(self.items, kv.item45)
	end
	if kv.item46 ~= nil then 
		table.insert(self.items, kv.item46)
	end
	if kv.item47 ~= nil then 
		table.insert(self.items, kv.item47)
	end
	if kv.item48 ~= nil then 
		table.insert(self.items, kv.item48)
	end
	if kv.item49 ~= nil then 
		table.insert(self.items, kv.item49)
	end
	if kv.item50 ~= nil then 
		table.insert(self.items, kv.item50)
	end

	if IsServer() then
		self:SetStackCount( #self.items )
		local gamestartdelay = GameRules:GetDOTATime(false, true) * -1
		self:SetDuration( gamestartdelay, true )
		self:StartIntervalThink( gamestartdelay )
	end
end

--------------------------------------------------------------------------------

function modifier_vgmar_util_give_debugitems:OnIntervalThink()
	local parent = self:GetParent()
	if IsServer() then
		if #self.items < 1 then
			for i=0,8,1 do
				local item = parent:GetItemInSlot(i)
				if item ~= nil then
					if item:IsCombinable() == true then
						ExecuteOrderFromTable({UnitIndex = parent:GetEntityIndex(), OrderType = 32, AbilityIndex = item:entindex()})
					end
				end
			end
			self:Destroy()
		end
		if GameRules.VGMAR:GetHeroFreeInventorySlots( parent, true, false ) > 0 then
			if self.items[1] ~= nil then
				local item = parent:AddItemByName(self.items[1])
				if item ~= nil then
					--Locking Combination of items
					ExecuteOrderFromTable({UnitIndex = parent:GetEntityIndex(), OrderType = 32, AbilityIndex = item:entindex()})
					table.remove(self.items, 1)
					self:SetStackCount( #self.items )
					self:SetDuration( 0.5, true )
					self:StartIntervalThink( 0.5 )
				else
					self:SetDuration( 1, true )
					self:StartIntervalThink( 1 )
				end
			end
		else
			self:SetDuration( 1, true )
			self:StartIntervalThink( 1 )
		end
	end
end