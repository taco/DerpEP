

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



function Derp:GuildStatus(player)
	local guildName, guildRankName, guildRankIndex = GetGuildInfo(player)

	if guildName ~= "Lusting on Trash" then return "" end

	return guildName == "Lusting on Trash", guildRankName ~= "Recruit"
end


function Derp:ZoneInfo()
	local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID = GetInstanceInfo()

	print(name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID)
end