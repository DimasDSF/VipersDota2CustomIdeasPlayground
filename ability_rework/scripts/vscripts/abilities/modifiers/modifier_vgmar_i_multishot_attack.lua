--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_multishot_attack = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_multishot_attack:GetTexture()
	return "medusa_split_shot"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_multishot_attack:IsHidden()
    return false
end

function modifier_vgmar_i_multishot_attack:IsDebuff()
	return false
end

function modifier_vgmar_i_multishot_attack:IsPurgable()
	return false
end

function modifier_vgmar_i_multishot_attack:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_multishot_attack:DestroyOnExpire()
	return true
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_multishot_attack:OnCreated( kv )
	if IsServer() then
		self.provider = self:GetParent():FindModifierByName("modifier_vgmar_i_multishot")
		self.shotspercap = self.provider.shotspercap
		self.attackduration = self.provider.attackduration
		self:SetStackCount( self.shotspercap )
		self:SetDuration( self.attackduration + 0.5, true )
		self:StartIntervalThink(self.attackduration / self.shotspercap )
	end
end

function modifier_vgmar_i_multishot_attack:OnIntervalThink()
	if self:GetParent():IsRangedAttacker() == false then
		self:SetStackCount( 0 )
		self:Destroy()
	end
	if self:GetStackCount() > 0 and self:GetRemainingTime() > 0 then
		if #self.provider.enemies > 0 then
			local enemy = nil
			local enemy1 = nil
			local enemy2 = nil
			for i=1,#self.provider.enemies do
				if enemy ~= nil and enemy1 ~= nil and enemy2 ~= nil then
					break
				end
				if self.provider.enemies[i]:IsNull() == false and self.provider.enemies[i]:IsAlive() and (self:GetParent():GetAbsOrigin() - self.provider.enemies[i]:GetAbsOrigin()):Length2D() <= self:GetParent():GetAttackRange() + 200 then
					if enemy == nil then
						enemy = self.provider.enemies[i]
					elseif enemy ~= nil and enemy1 == nil then
						enemy1 = self.provider.enemies[i]
					elseif enemy ~= nil and enemy1 ~= nil and enemy2 == nil then
						enemy2 = self.provider.enemies[i]
					end
				end
			end
			if not (self:GetParent():IsStunned() or self:GetParent():IsHexed() or self:GetParent():IsDisarmed()) then
				if enemy ~= nil then 
					self:GetParent():PerformAttack(enemy, true, true, true, false, true, false, false)
				end
				if enemy1 ~= nil then
					self:GetParent():PerformAttack(enemy1, true, true, true, false, true, false, false)
				end
				if enemy2 ~= nil then
					self:GetParent():PerformAttack(enemy2, true, true, true, false, true, false, false)
				end
			end
			self:SetStackCount( self:GetStackCount() - 1 )
		else
			self:SetStackCount( 0 )
		end
	else
		self.provider.enemies = {}
		self:StartIntervalThink( -1 )
		self:Destroy()
	end
end

--------------------------------------------------------------------------------