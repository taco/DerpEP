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
		EPGP:StartRecurringEP("Progression", 10)

	elseif cmd == "end" then
		EPGP:IncMassEPBy("End of Raid", 50)
		EPGP:StopRecurringEP();
		EPGP:DecayEPGP()

	elseif cmd == "export" then
		self:Export()

	elseif cmd == "print" then
		self:PrintSession()

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
