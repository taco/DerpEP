local derps = { 
	"Boss - spell2",
	"Vestige of Pride - Consuming Pride",
	"Boss - Spell1"
};

local derpAmount = 0

Derp = CreateFrame("Frame")

LibStub("AceConsole-3.0"):Embed(Derp)

local i = 0;

function Derp:Initialize()
	print("DerpEP: Welcome to Derpville. Please enjoy your stay!")
	Derp:RegisterChatCommand("derp", "Slash");
	Derp:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

function Derp:Slash(msg)

end

Derp:SetScript("OnEvent", function(self, event, timeStamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local amount, spellName = ...;
	
	if subEvent ~= "SPELL_DAMAGE" then return end

	local key = sourceName .. " - " .. spellName

	for _, v in pairs(derps) do
		if v == key then
			EPGP:IncEPBy(destName, "Derp - " .. spellName, derpAmount)
			break
		end
	end
end)

Derp:Initialize()