local derps = { 
	"Arcing Smash - Breath of Y'Shaarj1",
	"Rook Stonetoe - Corrupted Brew1",
	"nil - Arcing Smash1"
};

local derpAmount = -5

Derp = CreateFrame("Frame")

LibStub("AceConsole-3.0"):Embed(Derp)

function Derp:Initialize()
	print("DerpEP: Welcome to Derpville. Please enjoy your stay!")
	Derp:RegisterChatCommand("derp", "Slash");
	Derp:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	Derp:RegisterEvent("CHAT_MSG_WHISPER");
	Derp:RegisterEvent("CHAT_MSG_BN_WHISPER");
	Derp:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE");
	Derp:RegisterEvent("CHAT_MSG_MONSTER_EMOTE");
	Derp:RegisterEvent("CHAT_MSG_MONSTER_SAY");
	Derp:RegisterEvent("CHAT_MSG_MONSTER_YELL");
	Derp:RegisterEvent("CHAT_MSG_EMOTE");
	Derp:RegisterEvent("CHAT_MSG_TEXT_EMOTE");

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
	local ep, gp, main = EPGP:GetEPGP(msg)

	if ep then
		EPGP:IncEPBy(msg, "Derp", -25)
	end

	if msg == nil then
		print("DERP: nil")
	end

	if msg == "" then
		EPGP:IncEPBy(UnitName("target"), "Derp", -25);
	end
end

Derp:SetScript("OnEvent", function(self, event, timeStamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local amount, spellName = ...;

	if event == "CHAT_MSG_RAID_BOSS_EMOTE" or evnt == "CHAT_MSG_MONSTER_EMOTE" or event == "CHAT_MSG_MONSTER_SAY" or event == "CHAT_MSG_MONSTER_YELL" or event == "CHAT_MSG_EMOTE" or event == "CHAT_MSG_TEXT_EMOTE" then
		print(event)
		print(timeStamp)
		print(subEvent)
		return
	end

	if (event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER") and timeStamp == "repair" then
		--local msg = "===== " .. subEvent .. " Enabled Repairs =====";
		--SendChatMessage(msg, "GUILD");
		GuildBankRepairToggle:EnableRepairs();
	end
	
	if subEvent ~= "SPELL_DAMAGE" then return end

	if spellName == "Arcing Smash" then print("Arcing", sourceName, 'c'); end

	local key = sourceName .. " - " .. spellName

	for _, v in pairs(derps) do
		if v == key then

			EPGP:IncEPBy(destName, "Derp - " .. spellName, derpAmount)
			break
		end
	end
end)

Derp:Initialize()