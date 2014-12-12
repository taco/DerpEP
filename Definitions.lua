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
			status = "progression",
			Normal = "farm",
			Heroic = "progression",
			Mythic = "farm",
			status = "progression",
			encounters = {
			{
				name = "Kargath Bladefise",
				abilities = {
					{ source = "Fire Pillar", spell = "Flame Gout", event = "SPELL_DAMAGE", amount = 1}
				}
			
			}, {
				name = "The Butcher",
				abilities = {
				}
			
			}, {
				name = "Tectus",
				abilities = {
				}
			
			}, {
				name = "Brackenspore",
				abilities = {
				}
			
			}, {
				name = "Twin Ogron",
				abilities = {
					{ source = "Phemos", spell = "Blaze", event = "SPELL_AURA_APPLIED_DOSE", stacks = 3, amount = 0},
					{ source = "Phemos", spell = "Blaze", event = "SPELL_AURA_APPLIED_DOSE", stacks = 5, amount = 5},
					{ source = "Phemos", spell = "Blaze", event = "SPELL_AURA_APPLIED_DOSE", stacks = 10, amount = 10},
					{ source = "Pol", spell = "Shield Charge", event = "SPELL_DAMAGE", amount = 2}
				}
			}, {
				name = "Ko'ragh",
				abilities = {

				}
			}, {
				name = "Imperator Mar'gok",
				Heroic = "farm",
				abilities = {
						{ emote = true, source = "Destructive Resonance", spell = "Destructive Resonance", event = "CHAT_MSG_MONSTER_EMOTE" },
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
						{ emote = true, source = "Git", spell = "Git", event = "CHAT_MSG_MONSTER_EMOTE" },
						{ source = "Git", spell = "Unyielding Strikes", event = "SPELL_AURA_APPLIED_DOSE", stacks = 3},
						{ source = "Git", spell = "Unyielding Strikes", event = "SPELL_AURA_APPLIED_DOSE", stacks = 6}
					}
				}
			}
		}
	}
}