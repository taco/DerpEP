

LibStub("AceConsole-3.0"):Embed(Derp)
LibStub("AceTimer-3.0"):Embed(Derp)

function Derp:Initialize()
	self.loaded = false
	self:ScheduleTimer("OnLoaded", 5)
end

function Derp:OnLoaded()
	if EPGP == nil then
		self:ScheduleTimer("OnLoaded", 5)
		print("waiting for EPGP")
		return
	end
	if self.loaded then
		return
	end

	self:RegisterChatCommand("derp", "Slash")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_EMOTE")
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_OFFICER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")

	self:SetScript("OnEvent", self.HandleEvent)

	self.JSON = LibStub("LibJSON-1.0")
	self.AceGUI = LibStub("AceGUI-3.0")

	self.loaded = true

	print("DerpEP: Welcome to Derpville. Please enjoy your stay!")
	
	self.tracking = false

	if (not DerpDB) then
		DerpDB = { data = {}, session = false }
	end

	self.db = DerpDB
end

Derp:Initialize()