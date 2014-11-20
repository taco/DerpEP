local derps = { 
	{ source = "Arcing Smash", spell = "Breath of Y'Shaarj", event = "SPELL_DAMAGE", amount = 0},
	{ source = "Rook Stonetoe", spell = "Corrupted Brew", event = "SPELL_DAMAGE", amount = 0},
	{ source = "Thok the Bloodthirsty", spell = "Chomp", event = "SPELL_DAMAGE", amount = 0},
	{ source = nil, spell = "Matter Purification Beam", event = "SPELL_DAMAGE", amount = 0},

	-- Shamans
	{ source = "Toxic Tornado", spell = "Toxic Tornado", event = "SPELL_DAMAGE", amount = 0},
	{ source = "Toxic Tornado", spell = "Toxic Tornado", event = "SPELL_PERIODIC_DAMAGE", amount = 0},
	{ source = "Wavebinder Kardis", spell = "Foul Geyser", event = "SPELL_DAMAGE", amount = 0},
	{ source = "Earthbreaker Haromm", spell = "Foul Stream", event = "SPELL_PERIODIC_DAMAGE", amount = 0},
	{ source = nil, spell = "Iron Tomb", event = "SPELL_DAMAGE", amount = 0},

	{ source = "Git", spell = "Devastate", event = "SPELL_DAMAGE", amount = 0},

	-- Paragons
	{ source = "Ka'roz the Locust", spell = "Whirling", event = "SPELL_DAMAGE", amount = 5},
	{ source = "Hisek the Swarmkeeper", spell = "Sonic Pulse", event = "SPELL_PERIODIC_DAMAGE", amount = 5},
	--{ source = "Ka'roz the Locust", spell = "Caustic Amber", event = "SPELL_PERIODIC_DAMAGE", amount = 25},
	{ source = nil, spell = "Matter Purification Beam", event = "SPELL_DAMAGE", amount = 0},
};

local derpCount = 0
local derpTable = {}

local derpAmount = -10
local deathDerp = 0

Derp = CreateFrame("Frame")

LibStub("AceConsole-3.0"):Embed(Derp)
LibStub("AceTimer-3.0"):Embed(Derp)

function Derp:Initialize()
	print("DerpEP: Welcome to Derpville. Please enjoy your stay!")
	
	self.tracking = false
	
	self:RegisterChatCommand("derp", "Slash")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_OFFICER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")

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
	if msg == "silent" then
		self.silent = true
	end
	if msg == "loud" then
		self.silent = false
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
	if self.silent then
		return
	end
	print("DERP - START COMBAT")
	derpTable = {}
	derpCount = 1
	self.tracking = true
	self.wipeTimer = self:ScheduleRepeatingTimer("TimerFeedback", 5)
end

function Derp:AutoDerp()
	local data = self.autoQueue[self.autoIndex]

	if data == nil or data.name == nil then
		self:CancelTimer(self.autoTimer)
		return
	end

	EPGP:IncEPBy(data.name, "Derp: " .. data.spell, data.amount * -1);

	self.autoIndex = self.autoIndex + 1
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
	if not self.tracking then
		return
	end

	self:CancelTimer(self.wipeTimer)
	print("DERP - ON WIPE")
	self.tracking = false
	local msg

	SendChatMessage("Wipe has been called! End of Derp!", "RAID_WARNING")

	self.autoQueue = {}
	self.autoIndex = 1
	self.autoCount = 1

	if derpCount > 1 then
		for k1,v1 in pairs(derpTable) do
			msg = ""
			SendChatMessage("Derp for **" .. k1 .. "** ", "GUILD")
			for k2,v2 in pairs(derpTable[k1]) do
				
				local data = derpTable[k1][k2]

				SendChatMessage(" - " .. data.player .. " (" .. data.count .. "x) ", "GUILD")
				
				if data.amount > 0 then
					self.autoQueue[self.autoCount] = { name = data.player, spell = data.spell, amount = data.amount }
					self.autoCount = self.autoCount + 1
				end
			end
			SendChatMessage(msg, "GUILD")
		end
	end

	self.autoTimer = self:ScheduleRepeatingTimer("AutoDerp", 1)
end

function Derp:TimerFeedback()
	if self:CheckWipe() then
		self:CancelTimer(self.wipeTimer)
		--self:OnWipe()
	end
	return
end
-- 11/16 17:20:51.898  SPELL_INTERRUPT,Player-69-08560956,"Git-Arthas",0x511,0x0,Creature-0-69-1116-16-84894-0000693033,"Snow Fury",0x10a48,0x0,6552,"Pummel",0x1,165416,"Icy Gust",16
function Derp:HandleEvent(event, timeStamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local dmg, spellName, a, b, intSpellName = ...;

	local destTypeFlags = bit.band(destFlags, COMBATLOG_OBJECT_TYPE_MASK)
	local isDestPlayer = destTypeFlags == COMBATLOG_OBJECT_TYPE_PLAYER

	local sourceTypeFlags = bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_MASK)
	local isSourcePlayer = sourceTypeFlags == COMBATLOG_OBJECT_TYPE_PLAYER

	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" and timeStamp == "repair" then
		if timeStamp == "repair" then
			GuildBankRepairToggle:EnableRepairs()
		elseif timeStamp == "wipe" then
			Derp:OnWipe()
		end
		return
	end

	if event == "CHAT_MSG_OFFICER" and timeStamp == "wipe" then
		Derp:OnWipe()
		return
	end

	if subEvent == "SPELL_INTERRUPT" and isSourcePlayer then
		SendChatMessage(sourceName .. " interrupted " .. intSpellName, "YELL")
		return
	end

	-- Get out if not tracking
	if not self.tracking or not isDestPlayer then
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
		Derp:CombatDerp(destName, "Death", 0, deathDerp)
	end

end

Derp:Initialize()