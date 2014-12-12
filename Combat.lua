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

	_, _, _, self.currentDifficulty = GetInstanceInfo()

	self.encounters = {}

	for __, zone in pairs(self.derpDefinitions.zones) do
		print(zone.name, self.currentZoneText)
		if zone.name == self.currentZoneText then
			print('zone match', zone.name)
			self.currentZone = zone
			self.encounters = zone.encounters
			break
		end
	end

	if self.encounters == nil or table.getn(self.encounters) < 1 then
		print('===== DERPER =====')
		print('No encounters found for this zone: ' .. self.currentZoneText .. ' @ ' .. self.currentDifficulty)
		print('===== DERPER =====')
		return
	end

	self.db.pull = {}

	
	print('===== DERPER =====')
	print(string.format('Found %s encounters for %s on %s', table.getn(self.encounters), self.currentZoneText, self.currentDifficulty))
	print('===== DERPER =====')

	self.dataQueue = {}

	self.tracking = true
	--self.wipeTimer = self:ScheduleRepeatingTimer("TimerFeedback", 5)
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

function Derp:PrintSession()
	local s = self.db.session
	print('=== Derp Print Sessions ===')
	print(s.time, table.getn(s.derps))
	for _, d in pairs(s.derps) do
		print(d.spell, d.player, d.amount)
	end

	print('=== Derp Print Sessions ===')
	for _, z in pairs(self.db.sessions) do
		print(z.time, table.getn(z.derps))
		for _, d in pairs(z.derps) do
			print(d.spell, d.player, d.amount)
		end
	end
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

function Derp:OnWipe()
	if not self.tracking then
		return
	end

	self:CancelTimer(self.wipeTimer)
	print("DERP - ON WIPE")
	self.tracking = false
	local msg

	SendChatMessage("Wipe has been called! End of Derp!", "RAID_WARNING")

	
	if table.getn(self.db.pull) == 0 then return end
	
	SendChatMessage("=== Derp Report ===", "RAID")
	for _, pullSpell in pairs(self.db.pull) do
		
		SendChatMessage(string.format("%s (%s): ", pullSpell.key, pullSpell.count), "RAID")
		
		local counter = 0
		local output = ""
		
		for _, player in pairs(pullSpell.players) do
			counter = counter + 1
			output = output .. string.format("%s (%s), ", player.key, player.count)

			if counter == 8 then
				SendChatMessage("       " .. string.sub(output, 1, -3), "RAID")
				counter = 0
				output = ""
			end
			
		end

		if counter > 0 then
			SendChatMessage("       " .. string.sub(output, 1, -3), "RAID")
		end
	end

end


--/script c={asd = 1, xcv = 2, zpo = 3};table.sort(c); for a, b in pairs(c) do print(a, b) end