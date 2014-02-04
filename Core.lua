local derps = { 
	{ source = "Arcing Smash", spell = "Breath of Y'Shaarj", event = "SPELL_DAMAGE", amount = 25},
	{ source = "Rook Stonetoe", spell = "Corrupted Brew", event = "SPELL_DAMAGE", amount = 25},
	{ source = "Thok the Bloodthirsty", spell = "Chomp", event = "SPELL_DAMAGE", amount = 25},
	{ source = nil, spell = "Matter Purification Beam", event = "SPELL_DAMAGE", amount = 25},

	-- Shamans
	{ source = "Toxic Tornado", spell = "Toxic Tornado", event = "SPELL_DAMAGE", amount = 25},
	{ source = "Toxic Tornado", spell = "Toxic Tornado", event = "SPELL_PERIODIC_DAMAGE", amount = 25},
	{ source = "Wavebinder Kardis", spell = "Foul Geyser", event = "SPELL_DAMAGE", amount = 25},
	{ source = "Earthbreaker Haromm", spell = "Foul Stream", event = "SPELL_PERIODIC_DAMAGE", amount = 25},
	{ source = nil, spell = "Iron Tomb", event = "SPELL_DAMAGE", amount = 25},

	{ source = "Git", spell = "Devastate", event = "SPELL_DAMAGE", amount = 25},

	-- Paragons
	{ source = "Ka'roz the Locust", spell = "Whirling", event = "SPELL_DAMAGE", amount = 25},
	{ source = "Hisek the Swarmkeeper", spell = "Sonic Pulse", event = "SPELL_PERIODIC_DAMAGE", amount = 25},
	--{ source = "Ka'roz the Locust", spell = "Caustic Amber", event = "SPELL_PERIODIC_DAMAGE", amount = 25},
	{ source = nil, spell = "Matter Purification Beam", event = "SPELL_DAMAGE", amount = 25},
};

local derpCount = 0
local derpTable = {}

local derpAmount = -10

Derp = CreateFrame("Frame")

LibStub("AceConsole-3.0"):Embed(Derp)
LibStub("AceTimer-3.0"):Embed(Derp)

function Derp:Initialize()
	print("DerpEP: Welcome to Derpville. Please enjoy your stay!")
	
	self.tracking = false
	
	self:RegisterChatCommand("derp", "Slash")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("CHAT_MSG_WHISPER")

	self:SetScript("OnEvent", self.HandleEvent)
end

function Derp:Slash(msg)
	if msg == "farm" then
		EPGP:StopRecurringEP();
		EPGP:RecurringEPPeriodMinutes(10);
		EPGP:StartRecurringEP("Farm", 2);
	end
	if msg == "ot" then
		EPGP:StopRecurringEP();
		EPGP:RecurringEPPeriodMinutes(2);
		EPGP:StartRecurringEP("Overtime", 3);
	end
	if msg == "prog" then
		EPGP:StopRecurringEP();
		EPGP:RecurringEPPeriodMinutes(10);
		EPGP:StartRecurringEP("Progression", 10);
	end
	if msg == "repair" then
		GuildBankRepairToggle:EnableRepairs()
	end
	if msg == "start" then
		EPGP:IncMassEPBy("Start of Raid", 50);
		EPGP:StopRecurringEP();
		EPGP:RecurringEPPeriodMinutes(10);
		EPGP:StartRecurringEP("Farm", 2);
	end
	if msg == "end" then
		EPGP:IncMassEPBy("End of Raid", 50);
		EPGP:StopRecurringEP();
		EPGP:DecayEPGP()
	end
	if msg == "export" then
		EPGP:ExportRoster()
	end

	if msg == "pull" then
		self:StartCombat()
	end
	if msg == "wipe" then
		self:OnWipe()
	end
	if msg == "check" then
		self:CheckWipe()
	end
	if msg == "undo" then
		EPGP:IncEPBy(UnitName("target"), "Undo Derp", 10);
	end
	local ep, gp, main = EPGP:GetEPGP(msg)

	if ep then
		EPGP:IncEPBy(msg, "Derp", -25)
	end

	if msg == nil then
		print("DERP: nil")
	end

	if msg == "" then
		EPGP:IncEPBy(UnitName("target"), "Derp", -10);
	end
end

function Derp:CheckWipe()
	local wipe = true
	local num = GetNumGroupMembers()
	for i = 1, num do
		local name = GetRaidRosterInfo(i)
		if name then
			if UnitAffectingCombat(name) ~= nil then
				wipe = false
			end
		end
	end
	return wipe
end

function Derp:StartCombat()
	print("DERP - START COMBAT")
	derpTable = {}
	derpCount = 1
	self.tracking = true
	self.wipeTimer = self:ScheduleRepeatingTimer("TimerFeedback", 5)
end

function Derp:CombatDerp(player, spell, dmg, amount)
	if not self.tracking or not UnitIsPlayer(player) then
		return
	end

	local fullMsg = player .. ": " .. spell

	if derpTable[spell] ~= nil then
		if derpTable[spell][player] ~= nil then
			derpTable[spell][player].count = derpTable[spell][player].count + 1
			derpTable[spell][player].damage = derpTable[spell][player].damage + dmg
		else
			derpTable[spell][player] = { player = player, spell = spell, amount = amount, fullMsg = fullMsg, count = 1, damage = dmg }
		end
	else
		derpTable[spell] = {}
		derpTable[spell][player] = { player = player, spell = spell, amount = amount, fullMsg = fullMsg, count = 1, damage = dmg }
	end

	SendChatMessage(fullMsg .. " count - " .. derpCount, "GUILD")
	derpCount = derpCount + 1
end

function Derp:OnWipe()
	self:CancelTimer(self.wipeTimer)
	print("DERP - ON WIPE")
	self.tracking = false
	local msg

	SendChatMessage("Wipe has been called! End of Derp!", "RAID_WARNING")

	if derpCount > 1 then
		for k1,v1 in pairs(derpTable) do
			msg = ""
			SendChatMessage("Derp for **" .. k1 .. "** ", "GUILD")
			for k2,v2 in pairs(derpTable[k1]) do
				SendChatMessage(" - " .. derpTable[k1][k2].player .. " (" .. derpTable[k1][k2].count .. "x " .. math.ceil(derpTable[k1][k2].damage/1000) .. "k) ", "GUILD")
			end
			SendChatMessage(msg, "GUILD")
		end
	end
end

function Derp:TimerFeedback()
	if self:CheckWipe() then
		self:CancelTimer(self.wipeTimer)
		--self:OnWipe()
	end
	return
end

function Derp:HandleEvent(event, timeStamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local dmg, spellName = ...;

	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" and timeStamp == "repair" then
		if timeStamp == "repair" then
			GuildBankRepairToggle:EnableRepairs()
		elseif timeStamp == "wipe" then
			Derp:OnWipe()
		end
		return
	end

	-- Get out if not tracking
	if not self.tracking then
		return
	end

	if subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" then
		for _, v in pairs(derps) do
			if v.source == sourceName and v.spell == spellName and v.event == subEvent then
				Derp:CombatDerp(destName, spellName, dmg, v.amount)
				break
			end
		end
		return
	end

	if subEvent == "UNIT_DIED" then
		Derp:CombatDerp(destName, "Death", 0, 10)
	end

end

Derp:Initialize()