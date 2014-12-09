function Derp:Manual(key) 
	local player = UnitName("target")
	local zone = self.derpDefinitions.zones[1]
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

	record.amount = ability.amount or encounter.amount or self.derpDefinitions.amount
	record.status = ability.status or ability[self.currentDifficulty] or encounter.status or zone.status


	if record.status == "progression" or not isDerpable then
		record.amount = 0
	end

	record.amount = record.amount * -1

	record.player = player
	record.spell = ability.spell
	if ability.stacks then
		record.spell = string.format("%s %s stacks", record.spell, ability.stacks)
	end
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

	--print("found b?", b)

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

	local max = 1
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

	local max = 1
	local n = 1

	while table.getn(self.undoQueue) > 0 and n <= max do
		local record = table.remove(self.undoQueue, 1)
		local msg = string.format("UNDO Derp: %s", record.spell)
		n = n + 1

		record.amount = record.amount * -1

		if record.amount == 0 then
			SendChatMessage("EPGP: 0 EP (" .. msg .. ") to " .. record.player, "PARTY")
		else
			EPGP:IncEPBy(record.player, msg, record.amount)
		end
	end

	self:ScheduleTimer("UndoLog", 1)
end

function Derp:Export()
	local textStore

	local text = self.JSON.Serialize(self.db.session)

	local frame = self.AceGUI:Create("Frame")
	frame:SetTitle("Example Frame")
	frame:SetStatusText("AceGUI-3.0 Example Container Frame")
	frame:SetCallback("OnClose", function(widget) self.AceGUI:Release(widget) end)
	frame:SetLayout("Flow")

	local editbox = self.AceGUI:Create("MultiLineEditBox")
	editbox:SetLabel("Insert text:")
	editbox:SetWidth(400)
	editbox:SetText(text)
	editbox:SetNumLines(15)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) textStore = text end)
	frame:AddChild(editbox)

	local button = self.AceGUI:Create("Button")
	button:SetText("Click Me!")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() print(textStore) end)
	frame:AddChild(button)
end