

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

function Derp:PairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do
		table.insert(a, n)
	end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	return iter
end


-- /script for _, n in pairs({{k = 1}, {k = 3}}) do print(n.k) end

function Derp:FindByKey (tbl, key)
	for _, n in pairs(tbl) do
		if n.key == key then
			return n
		end
	end
	return nil
end

function Derp:FindOrInit(tbl, cfg)
	local result = self:FindByKey(tbl, cfg.key)

	if result ~= nil then
		return result
	end

	table.insert(tbl, cfg)

	return cfg
end
