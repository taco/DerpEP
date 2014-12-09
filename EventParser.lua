-- /script EPGP:IncEPBy("Gittdabank", "no reason", 5)

-- 11/16 17:20:51.898  SPELL_INTERRUPT,Player-69-08560956,"Git-Arthas",0x511,0x0,Creature-0-69-1116-16-84894-0000693033,"Snow Fury",0x10a48,0x0,6552,"Pummel",0x1,165416,"Icy Gust",16
function Derp:HandleEvent(event, timeStamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local dmg, spellName, a, b, intSpellName = ...

	--print(event, subEvent)

	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" and timeStamp == "repair" then
		if timeStamp == "repair" then
			GuildBankRepairToggle:EnableRepairs()
		elseif timeStamp == "wipe" then
			Derp:OnWipe()
		end
		return
	end

	if event == "CHAT_MSG_OFFICER" and timeStamp == "wipe" then
		Derp:OnWipe()
		return
	end













	if event == "CHAT_MSG_MONSTER_EMOTE" or event == "CHAT_MSG_EMOTE" then

		--self.Debug('CHAT_MSG_MONSTER_EMOTE')
		--print(event, subEvent, self.tracking, self.encounters)

		--Get out if not tracking
		if not self.tracking or not self.encounters then
			return
		end

		sourceName = subEvent
		spellName = subEvent
		destName = self:Split(timeStamp, " ")[1]

		--print(sourceName, spellName, destName)

		for _, encounter in pairs(self.encounters) do

			for _, ability in pairs(encounter.abilities) do

				if ability.emote and ability.source == sourceName and ability.spell == spellName then

					--print('ability detected', destName, ability, encounter, self.currentZone)
					Derp:AddDerp(destName, ability, encounter, self.currentZone)
					return

				end
			end

		end

		return
	end












	if event == "COMBAT_LOG_EVENT_UNFILTERED" then

		local destTypeFlags = bit.band(destFlags, COMBATLOG_OBJECT_TYPE_MASK)
		local isDestPlayer = destTypeFlags == COMBATLOG_OBJECT_TYPE_PLAYER

		local sourceTypeFlags = bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_MASK)
		local isSourcePlayer = sourceTypeFlags == COMBATLOG_OBJECT_TYPE_PLAYER

		if subEvent == "SPELL_INTERRUPT" and isSourcePlayer then
			SendChatMessage(sourceName .. " interrupted " .. intSpellName, "YELL")
			return
		end

		--Get out if not tracking
		if not self.tracking or not self.encounters then
			return
		end

		if subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" or subEvent == "SPECIAL_EVENT" then

			for _, encounter in pairs(self.encounters) do

				for _, ability in pairs(encounter.abilities) do

					if not ability.emote and ability.source == sourceName and ability.spell == spellName and ability.event == subEvent then

						print('ability detected', destName, ability, encounter, self.currentZone)
						Derp:AddDerp(destName, ability, encounter, self.currentZone)
						return

					end
				end

			end
			return
		end

		-- if subEvent == "UNIT_DIED" then
		-- 	Derp:CombatDerp(destName, "Death", 0, deathDerp)
		-- end

	end


end