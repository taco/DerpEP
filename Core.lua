local derpsOld = { 
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

local derps = {
	amount = 5,
	defaultBuffer = 0,
	zones = {
		{
			name = "*",
			encounters = {
				name = "*",
				status = "farm",
				abilities = {
					{ spell = "Derp", event = "derp", amount = 10 },
					{ spell = "Face pull", event = "fp", amount = 50  },
					{ spell = "AFK outside of break", event = "afk1", amount = 25  },
					{ spell = "AFK on bench", event = "afk2", amount = 50 }
				}
			}
		}, {
			name = "Highmaul",
			encounters = {
				{
					name = "Kargath Bladefist",
					status = "progression",
					abilities = {
						{ source = "Ka'roz the Locust", spell = "Whirling", event = "SPELL_DAMAGE" },
						{ source = "Hisek the Swarmkeeper", spell = "Sonic Pulse", event = "SPELL_PERIODIC_DAMAGE"}
					}
				}, {
					name = "The Butcher",
					status = "progression",
					abilities = {
						{ source = "Ka'roz the Locust", spell = "Whirling", event = "SPELL_DAMAGE" },
						{ source = "Hisek the Swarmkeeper", spell = "Sonic Pulse", event = "SPELL_PERIODIC_DAMAGE"}
					}
				}
			},
		}, {
			name = "Blackrock Foundry",
			encounters = {}
		}, {
			name = "Frostwall",
			encounters = {
				{
					name = "Git da Boss",
					status = "progression",
					abilities = {
						{ source = "Git", spell = "Devastate", event = "SPELL_DAMAGE" }
					}
				}
			}
		}
	}
}

local derpCount = 0
local derpTable = {}

local derpAmount = -10
local deathDerp = 0

Derp = CreateFrame("Frame")

LibStub("AceConsole-3.0"):Embed(Derp)
LibStub("AceTimer-3.0"):Embed(Derp)
local AceGUI = LibStub("AceGUI-3.0")
local JSON, DLG

function Derp:Initialize()
	
	self.loaded = false
	self:RegisterChatCommand("derp", "Slash")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_OFFICER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("ADDON_LOADED")

	self:SetScript("OnEvent", self.HandleEvent)
end

function Derp:OnLoaded()
	if (EPGP == nil) then
		self:ScheduleTimer("OnLoaded", 1)
		print("waiting for EPGP")
		return
	end
	if (self.loaded) then
		return
	end

	JSON = LibStub("LibJSON-1.0")
	DLG = LibStub("LibDialog-1.0")

	self.loaded = true

	self:RegisterPopups()

	print("DerpEP: Welcome to Derpville. Please enjoy your stay!")
	
	self.tracking = false

	if (not DerpDB) then
		DerpDB = { data = {}, counter = 0, session = false }
	end

	self.db = DerpDB

	self.db.counter = self.db.counter + 1

	print('Visits ' .. self.db.counter)

	--DerpDB = self.db
end

function Derp:Split(inputstr, sep)
    if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function Derp:Slash(msg)
	local m = self:Split(msg, " ")

	local cmd = m[1]

	if cmd == "farm" then
		EPGP:StopRecurringEP()
		EPGP:RecurringEPPeriodMinutes(10)
		EPGP:StartRecurringEP("Farm", 2)

	elseif cmd == "ot" then
		EPGP:StopRecurringEP()
		EPGP:RecurringEPPeriodMinutes(2)
		EPGP:StartRecurringEP("Overtime", 3)

	elseif cmd == "prog" then
		EPGP:StopRecurringEP()
		EPGP:RecurringEPPeriodMinutes(10)
		EPGP:StartRecurringEP("Progression", 10)

	elseif cmd == "repair" then
		GuildBankRepairToggle:EnableRepairs()

	elseif cmd == "start" then
		EPGP:IncMassEPBy("Start of Raid", 50)
		EPGP:StopRecurringEP()
		EPGP:RecurringEPPeriodMinutes(10)
		EPGP:StartRecurringEP("Farm", 2)

	elseif cmd == "end" then
		EPGP:IncMassEPBy("End of Raid", 50)
		EPGP:StopRecurringEP();
		EPGP:DecayEPGP()

	elseif cmd == "export" then
		self:Export()

	elseif cmd == "session" then
		self:StartSession()

	elseif cmd == "sessionstop" then
		self:StopSession()

	elseif cmd == "pull" then
		self:StartCombat()

	elseif cmd == "wipe" then
		self:OnWipe()

	elseif cmd == "check" then
		self:CheckWipe()

	elseif cmd == "silent" then
		self.silent = true

	elseif cmd == "loud" then
		self.silent = false

	elseif cmd == "undo" then
		self:Undo(m[2])

	elseif cmd == "push" then
		self:Push()

	elseif cmd == "info" then
		self:ZoneInfo()

	elseif cmd == "test" then
		self:Test()

	elseif cmd == "cleardata" then
		self:ClearData()

	elseif cmd == "manual" then
		self:Manual(m[2])


	else
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
end

function Derp:Push()
	print(self.db.counter)
	print(self.db.data)
	if self.db.data then
		for i=1,10 do
			table.insert(self.db.data, {name = "Git", event = "SPELL_DAMAGE", ability = "Fire Zone", amount = 50})
		end
	end
end

function Derp:Export()
	local textStore

	local text = JSON.Serialize(self.db.sessions)

	local frame = AceGUI:Create("Frame")
	frame:SetTitle("Example Frame")
	frame:SetStatusText("AceGUI-3.0 Example Container Frame")
	frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
	frame:SetLayout("Flow")

	local editbox = AceGUI:Create("MultiLineEditBox")
	editbox:SetLabel("Insert text:")
	editbox:SetWidth(400)
	editbox:SetText(text)
	editbox:SetNumLines(15)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) textStore = text end)
	frame:AddChild(editbox)

	local button = AceGUI:Create("Button")
	button:SetText("Click Me!")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() print(textStore) end)
	frame:AddChild(button)
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
	self.currentZoneText = GetZoneText()

	self.encounters = {}

	for _, zone in pairs(derps.zones) do
		if zone.name == self.currentZoneText then
			self.currentZone = zone
			self.encounters = zone.encounters
			break
		end
	end

	if self.encounters == nil or table.getn(self.encounters) < 1 then
		print('No encounters found for this zone: ' .. self.currentZone)
		return
	end

	print('Starting combat, found ' .. table.getn(self.encounters) .. ' encounters')

	self.dataQueue = {}

	self.tracking = true
	self.wipeTimer = self:ScheduleRepeatingTimer("TimerFeedback", 5)
end

function Derp:StartSession()
	if self.db.session then
		print('Already running Session')
		return
	end

	print('Derp: Starting new Session')

	if not self.db.sessions then
		self.db.sessions = {}
	end

	self.db.session = {
		time = time(),
		derps = {}
	}

	table.insert(self.db.sessions, self.db.session)
end

function Derp:StopSession()
	self.db.session = nil
	print('Derp: Stoping Session')
end

function Derp:ClearData()
	self.db.session = nil
	self.db.sessions = {}
	print("Derp: Clearing all data")
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

function Derp:Undo(n)
	if not self.db.session then
		print('Derp: no session is running')
		return
	end

	local player
	local count = 1
	local i = table.getn(self.db.session.derps)

	n = tonumber(n)



	if not n then
		n = 1
	end

	if UnitIsPlayer("target") then
		player = UnitName("target")
	end

	print('Undo', player, n)

	while i > 0 and count <= n do
		local d = self.db.session.derps[i]

		if player == nil or player == d.player then
			table.remove(self.db.session.derps, i)
			self:UndoQueue(d)
			count = count + 1
		end

		i = i - 1
	end

end

function Derp:UndoQueue(record)
	if not self.undoQueue then
		self.undoQueue = {}
	end

	table.insert(self.undoQueue, record)

	if not self.undoQueueRunning then
		self:UndoLog()
	end
end

function Derp:UndoLog()
	if table.getn(self.undoQueue) == 0 then
		self.undoQueueRunning = false
		return
	end

	self.undoQueueRunning = true

	local max = 3
	local n = 1

	while table.getn(self.undoQueue) > 0 and n <= max do
		local record = table.remove(self.undoQueue, 1)
		local msg = string.format("UNDO Derp: %s", record.spell)
		n = n + 1

		record.amount = record.amount * -1

		if record.amount == 0 then
			SendChatMessage("EPGP: 0 EP (" .. msg .. ") to " .. record.player, "GUILD")
		else
			EPGP:IncEPBy(record.player, msg, record.amount)
		end
	end

	self:ScheduleTimer("UndoLog", 1)
end

function Derp:Test()
	self:AddDerp("Gittdabank", {spell="Spell1", amount= 40, buffer = nil, source = "shit"}, {}, {})
end

function Derp:GuildStatus(player)
	local guildName, guildRankName, guildRankIndex = GetGuildInfo(player)

	if guildName ~= "Lusting on Trash" then return "" end

	return guildName == "Lusting on Trash", guildRankName ~= "Recruit"
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

	SendChatMessage(fullMsg .. " count - " .. derpCount, "SAY")
	derpCount = derpCount + 1
end

function Derp:Manual(key) 
	local player = UnitName("target")
	local zone = derps.zones[1]
	local encounter = zone.encounters[1]

	for _, ability in pairs(encounter.abilities) do
		if ability.spell == key then
			self:AddDerp(player, ability, encounter, zone)
			break
		end
	end
end

function Derp:AddDerp(player, ability, encounter, zone)
	local inGuild, isDerpable = self:GuildStatus(player)

	local record = { player = player }

	--if not inGuild then return end

	record.amount = ability.amount or encounter.amount or derps.amount
	record.status = ability.status or encounter.status or zone.status


	if record.status == "progression" or not isDerpable then
		record.amount = 0
	end

	record.player = player
	record.spell = ability.spell
	record.source = ability.source
	record.event = ability.event
	record.encounter = encounter.name
	record.zone = zone.name
	record.time = time()


	if ability.buffer ~= nil then
		self:Buffer(record, ability)
	else
		self:Queue(record)
	end
end

function Derp:Buffer(record, ability)
	local key = string.format("%s-%s-%s", record.player, record.spell, record.source or 'no-source')
	local time = time()

	if not self.dataBuffer then
		self.dataBuffer = {}
	end

	local b = self:FindBuffer(key)

	print("found b?", b)

	if not b or time - ability.buffer > b.time then
		b = {
			key = key,
			record = record,
			ability = ability,
			time = time
		}
		table.insert(self.dataBuffer, b)
	else
		b.time = time
	end

	if not self.bufferRunning then
		self:CheckBuffer()
	end
end

function Derp:FindBuffer(key)
	for _,b in pairs(self.dataBuffer) do
		if (b.key == key) then
			return b
		end
	end
	return nil
end

function Derp:CheckBuffer()
	if table.getn(self.dataBuffer) == 0 then
		self.bufferRunning = false
		--print('buffer stopped')
		return
	end

	--print('checking buffer', table.getn(self.dataBuffer))

	self.bufferRunning = true

	local time = time()

	local i = 1

	while i <= table.getn(self.dataBuffer) do
		local b = self.dataBuffer[i]

		if (time - b.ability.buffer > b.time) then
			table.remove(self.dataBuffer, i)
			--print('adding to queue', i)
			self:Queue(b.record)
		else
			i = i + 1
		end
	end

	self:ScheduleTimer("CheckBuffer", 1)
end


function Derp:Queue(record)
	--print("Adding to queue")

	if not self.dataQueue then
		self.dataQueue = {}
	end

	table.insert(self.dataQueue, record)

	if not self.queueRunning then
		self:CheckQueue()
	end
end

function Derp:CheckQueue()
	local count = table.getn(self.dataQueue)
	

	if count == 0 then
		self.queueRunning = false
		--print('queue stopped')
		return
	end

	self.queueRunning = true

	local max = 3
	local n = 1

	while table.getn(self.dataQueue) > 0 and n <= max do
		local record = table.remove(self.dataQueue, 1)
		self:Log(record)
		--print('unshifting first item', record.player)
		n = n + 1
	end

	

	self:ScheduleTimer("CheckQueue", 1)
end

function Derp:Log(record) 
	local msg = string.format("Derp: %s", record.spell)

	if not self.db.session or not self.db.session.derps then
		print("Cannot log, no session running")
		return
	end

	table.insert(self.db.session.derps, record)
	
	if record.amount == 0 then
		SendChatMessage("EPGP: 0 EP (" .. msg .. ") to " .. record.player, "GUILD")
	else
		EPGP:IncEPBy(record.player, msg, record.amount)
	end
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

function Derp:ZoneInfo()
	local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID = GetInstanceInfo()

	print(name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID)
end

function Derp:TimerFeedback()
	if self:CheckWipe() then
		self:CancelTimer(self.wipeTimer)
		--self:OnWipe()
	end
	return
end
-- /script EPGP:IncEPBy("Gittdabank", "no reason", 5)

-- 11/16 17:20:51.898  SPELL_INTERRUPT,Player-69-08560956,"Git-Arthas",0x511,0x0,Creature-0-69-1116-16-84894-0000693033,"Snow Fury",0x10a48,0x0,6552,"Pummel",0x1,165416,"Icy Gust",16
function Derp:HandleEvent(event, timeStamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local dmg, spellName, a, b, intSpellName = ...

	if (event == "ADDON_LOADED") then
		self:OnLoaded()
		return
	end

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

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then

		local destTypeFlags = bit.band(destFlags, COMBATLOG_OBJECT_TYPE_MASK)
		local isDestPlayer = destTypeFlags == COMBATLOG_OBJECT_TYPE_PLAYER

		local sourceTypeFlags = bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_MASK)
		local isSourcePlayer = sourceTypeFlags == COMBATLOG_OBJECT_TYPE_PLAYER

		if subEvent == "SPELL_INTERRUPT" and isSourcePlayer then
			SendChatMessage(sourceName .. " interrupted " .. intSpellName, "YELL")
			return
		end

		-- Get out if not tracking
		-- if not self.tracking or not isDestPlayer then
		-- 	return
		-- end

		if subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" then

			if (not self.encounters) then return end

			for _, encounter in pairs(self.encounters) do

				for _, ability in pairs(encounter.abilities) do

					if ability.source == sourceName and ability.spell == spellName and ability.event == subEvent then

						print('ability detected')
						Derp:CombatDerp(destName, ability, encounter, self.currentZone)
						return

					end
				end
				-- if v.source == sourceName and v.spell == spellName and v.event == subEvent then

				-- 	Derp:CombatDerp(destName, spellName, dmg, v.amount)
				-- 	break
				-- end
			end
			return
		end

		-- if subEvent == "UNIT_DIED" then
		-- 	Derp:CombatDerp(destName, "Death", 0, deathDerp)
		-- end

	end


end

function Derp:RegisterPopups()
	DLG:Register("DERP_CONFIRM", {
	  text = "Are you sure you meant to derp?",
	  buttons = {
	    {
	      text = "Accept",
	      on_click = function(self, data, reason)
	        print("Accepted")
	      end,
	    },
	    {
	      text = "Cancel",
	    },
	  },
	  on_update = function(self, elapsed)
	    
	  end,
	  hide_on_escape = true,
	  show_while_dead = true,
	})

end


Derp:Initialize()