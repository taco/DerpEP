Derp.derpDefinitions = {
	amount = 5,
	defaultBuffer = 0,
	zones = {
		{
			name = "*",
			encounters = {
				name = "*",
				status = "farm",
				abilities = {
					{ spell = "Derp", event = "derp", amount = 10 },
					{ spell = "Face pull", event = "fp", amount = 50  },
					{ spell = "AFK outside of break", event = "afk1", amount = 25  },
					{ spell = "AFK on bench", event = "afk2", amount = 50 }
				}
			}
		}, {
			name = "Highmaul",
			encounters = {
				{
					name = "Kargath Bladefist",
					status = "progression",
					abilities = {
						{ source = "Ka'roz the Locust", spell = "Whirling", event = "SPELL_DAMAGE" },
						{ source = "Hisek the Swarmkeeper", spell = "Sonic Pulse", event = "SPELL_PERIODIC_DAMAGE"}
					}
				}, {
					name = "The Butcher",
					status = "progression",
					abilities = {
						{ source = "Ka'roz the Locust", spell = "Whirling", event = "SPELL_DAMAGE" },
						{ source = "Hisek the Swarmkeeper", spell = "Sonic Pulse", event = "SPELL_PERIODIC_DAMAGE"}
					}
				}, {
				name = "Imperator Mar'gok",
				status = "progression",
				abilities = {
						{ emote = true, source = "Destructive Resonance", spell = "Destructive Resonance", event = "CHAT_MSG_MONSTER_EMOTE" },
						{ emote = true, source = "Git-Arthas", spell = "Git-Arthas", event = "CHAT_MSG_EMOTE", buffer = 5 }
					}
				}
			},
		}, {
			name = "Blackrock Foundry",
			encounters = {}
		}, {
			name = "Frostwall",
			encounters = {
				{
					name = "Training Dummy",
					status = "progression",
					abilities = {
						{ source = "Dungeoneer's Training Dummy", spell = "Dummy Strike", event = "SPELL_DAMAGE" },
						{ emote = true, source = "Git", spell = "Git", event = "CHAT_MSG_MONSTER_EMOTE" }
					}
				}
			}
		}
	}
}