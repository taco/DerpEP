

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

	print(GetInstanceInfo())
end

function Derp:Debug(...)
	print('==== DERP DEBUG ====')
	print(arg)
	print('====================')
end
