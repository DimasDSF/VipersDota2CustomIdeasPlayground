--A modifier used as a visualisation for a custom spell

modifier_vgmar_bam_blade_mail = class({})

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_vgmar_bam_blade_mail:IsHidden()
    return true
end

function modifier_vgmar_bam_blade_mail:IsDebuff()
	return false
end

function modifier_vgmar_bam_blade_mail:IsPurgable()
	return false
end

function modifier_vgmar_bam_blade_mail:RemoveOnDeath()
	return true
end

function modifier_vgmar_bam_blade_mail:DestroyOnExpire()
	return true
end
--------------------------------------------------------------------------------

function modifier_vgmar_bam_blade_mail:OnCreated( kv )
	if IsServer() then
		self.damage_perc = kv.damage_perc
	end
end

function modifier_vgmar_bam_blade_mail:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end


function modifier_vgmar_bam_blade_mail:OnTakeDamage( event )
	if IsServer() then
		if event.unit == self:GetParent() then
			if event.attacker:IsHero() and event.attacker:IsAlive() and event.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(event.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == 0 then
				local damage = math.max(0, event.damage * self.damage_perc/100)
				local damage_table = {
					victim = event.attacker,
					attacker = self:GetParent(),
					ability = self:GetAbility(),
					damage = damage,
					damage_type = event.damage_type,
					damage_flags = event.damage_flags + DOTA_DAMAGE_FLAG_REFLECTION
				}
				--print(self:GetParent():GetName().."'s BladeMailMod Dealing "..damage.." damage to "..event.attacker:GetName())
				--print("BaseDMG: "..event.damage.." Modifier: "..self.damage_perc/100)
				ApplyDamage(damage_table)
			end
		end
	end
end

--------------------------------------------------------------------------------