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

	for _, zone in pairs(self.derpDefinitions.zones) do
		if zone.name == self.currentZoneText then
			self.currentZone = zone
			self.encounters = zone.encounters
			break
		end
	end

	if self.encounters == nil or table.getn(self.encounters) < 1 then
		print('===== DERPER =====')
		print('No encounters found for this zone: ' .. self.currentZone)
		print('===== DERPER =====')
		return
	end

	
	print('===== DERPER =====')
	print('Starting combat, found ' .. table.getn(self.encounters) .. ' encounters')
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
end