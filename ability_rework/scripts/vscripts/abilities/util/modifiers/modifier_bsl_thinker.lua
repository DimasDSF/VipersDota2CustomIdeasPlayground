--A modifier used as a visualisation for a custom spell

modifier_bsl_thinker = class({})

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_bsl_thinker:IsHidden()
	return true
end

function modifier_bsl_thinker:IsPurgable()
	return false
end

function modifier_bsl_thinker:RemoveOnDeath()
	return false
end

function modifier_bsl_thinker:DestroyOnExpire()
	return true
end

function modifier_bsl_thinker:OnCreated(kv)
	if IsServer() then
		self.functionid = kv.functionid
		self.endfunctionid = kv.endfunctionid
		self.interval = kv.interval
		if kv.timeout ~= nil then
			self:SetDuration(kv.timeout, true)
		end
		if kv.autostart then
			self:StartIntervalThink(self.interval)
		end
	end
end

function modifier_bsl_thinker:StartIntervalThinkWithPresetInterval()
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_bsl_thinker:OnRemoved()
	if IsServer() then
		if self.endfunctionid ~= nil then
			local f = BotSupportLib:IntervalFunctionCall(self:GetParent(), self.endfunctionid)
			if f ~= nil then
				if f == 1 then
					print("BotSupportLib::IntervalFunctionCall::OnRemoved Function called an incorrect functionID: "..self.endfunctionid)
				end
			end
		end
	end
end

function modifier_bsl_thinker:OnIntervalThink()
	if IsServer() then
		local f = BotSupportLib:IntervalFunctionCall(self:GetParent(), self.functionid)
		if f ~= nil then
			if f == 1 then
				LogLib:WriteLog("error", 0, true, "BotSupportLib::IntervalFunctionCall::Missing function id: "..self.functionid.." - Destroying Think Modifier on ("..self:GetParent():GetName()..", EntIndex: "..self:GetParent():entindex()..") Immidiately!!!")
				print("BotSupportLib::IntervalFunctionCall::Missing function id: "..self.functionid.." - Destroying Think Modifier on ("..self:GetParent():GetName()..", EntIndex: "..self:GetParent():entindex()..") Immidiately!!!")
			elseif f == 2 then
				LogLib:WriteLog("error", 0, true, "BotSupportLib::IntervalFunctionCall::Incorrect Hero for: "..self.functionid.." - Destroying Think Modifier on ("..self:GetParent():GetName()..", EntIndex: "..self:GetParent():entindex()..") Immidiately!!!")
				print("BotSupportLib::IntervalFunctionCall::Incorrect Hero for: "..self.functionid.." - Destroying Think Modifier on ("..self:GetParent():GetName()..", EntIndex: "..self:GetParent():entindex()..") Immidiately!!!")
			elseif f == 3 then
				LogLib:WriteLog("error", 0, true, "BotSupportLib::IntervalFunctionCall::Missing Unit! - Destroying Think Modifier Immidiately!!!")
				print("BotSupportLib::IntervalFunctionCall::Missing Unit! - Destroying Think Modifier Immidiately!!!")
			end
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------