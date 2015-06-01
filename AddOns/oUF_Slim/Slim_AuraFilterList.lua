--[[	
		aura filter - buffs/debuffs listed here will be visible on party, arena and raid, everything else is hidden! 
		feel free to add some/more and share the love with a pm/comment on wowinterface.com
		... wall of text inc ...
--]]

Whitelist = { 
   auras = { 
      ---------   
      -- PvE-- 
      --------- 
             
      -- Baradin Hold 
      --Argaloth 
      [GetSpellInfo(88954) or "Consuming Darkness"] = true, 
             
      -- The Bastion of Twilight 
      -- Halfus Wyrmbreaker 
      [GetSpellInfo(83908) or "Malevolent Strikes"] = true, 
             
      -- Valiona and Theralion 
      [GetSpellInfo(86844) or "Devouring Flames"] = true, 
      [GetSpellInfo(86788) or "Blackout"] = true, 
      [GetSpellInfo(95639) or "Engulfing Magic"] = true, 
      [GetSpellInfo(86013) or "Twilight Meteorite"] = true, 
             
      -- Ascendant Council 
      [GetSpellInfo(92486) or "Gravity Crush"] = true, 
      [GetSpellInfo(83099) or "Lightning Rod"] = true, 
      [GetSpellInfo(82660) or "Burning Blood"] = true, 
      [GetSpellInfo(82665) or "Heart of Ice"] = true, 
      [GetSpellInfo(82762) or "Waterlogged"] = true, 
      [GetSpellInfo(83581) or "Grounded"] = true, 
             
      -- Blackwing Descent 
      -- Omnotron Defense System 
      [GetSpellInfo(80011) or "Soaked in Poison"] = true, 
      [GetSpellInfo(91533) or "Flamethrower"] = true, 
      ["Chemical Cloud"] = true, 
      [GetSpellInfo(91431) or "Lightning Conductor"] = true, 
      [GetSpellInfo(92035) or "Acquiring Target"] = true, 
             
       
      -- The Ruby Sanctum 
      [GetSpellInfo(74562)] = true,-- Fiery Combustion 
      --[GetSpellInfo(75883)] = true,-- Combustion 
      [GetSpellInfo(74792)] = true,-- Soul Consumption 
      --[GetSpellInfo(75876)] = true,-- Consumption 
               
      -- Icecrown Citadel 
      --The Lower Spire 
      [GetSpellInfo(38028)] = true,-- Web Wrap 
      [GetSpellInfo(69483)] = true,-- Dark Reckoning 
      --[GetSpellInfo(71124)] = true,-- Curse of Doom 
               
      --The Plagueworks 
      [GetSpellInfo(71089)] = true,-- Bubbling Pus 
      [GetSpellInfo(71127)] = true,-- Mortal Wound 
      [GetSpellInfo(71163)] = true,-- Devour Humanoid 
      [GetSpellInfo(71103)] = true,-- Combobulating Spray 
      [GetSpellInfo(71157)] = true,-- Infested Wound 
               
      --The Crimson Hall 
      [GetSpellInfo(70645)] = true,-- Chains of Shadow 
      [GetSpellInfo(70671)] = true,-- Leeching Rot 
      [GetSpellInfo(70432)] = true,-- Blood Sap 
      [GetSpellInfo(70435)] = true,-- Rend Flesh 
               
      --Frostwing Hall 
      [GetSpellInfo(71257)] = true,-- Barbaric Strike 
      [GetSpellInfo(71252)] = true,-- Volley 
      [GetSpellInfo(71327)] = true,-- Web 
      [GetSpellInfo(36922)] = true,-- Bellowing Roar 
               
      --Lord Marrowgar 
      --[GetSpellInfo(70823)] = true,-- Coldflame 
      [GetSpellInfo(69065)] = true,-- Impaled 
      --[GetSpellInfo(70835)] = true,-- Bone Storm 
               
      --Lady Deathwhisper 
      --[GetSpellInfo(72109)] = true,-- Death and Decay 
      [GetSpellInfo(71289)] = true,-- Dominate Mind 
      [GetSpellInfo(71204)] = true,-- Touch of Insignificance 
      --[GetSpellInfo(67934)] = true,-- Frost Fever 
      [GetSpellInfo(71237)] = true,-- Curse of Torpor 
      --[GetSpellInfo(72491)] = true,-- Necrotic Strike 
               
      --Gunship Battle 
      [GetSpellInfo(69651)] = true,-- Wounding Strike 
               
      --Deathbringer Saurfang 
      [GetSpellInfo(72293)] = true,-- Mark of the Fallen Champion 
      --[GetSpellInfo(72442)] = true,-- Boiling Blood 
      --[GetSpellInfo(72449)] = true,-- Rune of Blood 
      [GetSpellInfo(72769)] = true,-- Scent of Blood (heroic) 
               
      --Rotface 
      --[GetSpellInfo(71224)] = true,-- Mutated Infection 
      --[GetSpellInfo(71215)] = true,-- Ooze Flood 
      [GetSpellInfo(69774)] = true,-- Sticky Ooze 
               
      --Festergut 
      [GetSpellInfo(69279)] = true,-- Gas Spore 
      --[GetSpellInfo(71218)] = true,-- Vile Gas 
      [GetSpellInfo(72219)] = true,-- Gastric Bloat 
               
      --Professor 
      [GetSpellInfo(70341)] = true,-- Mysterye Puddle 
      --[GetSpellInfo(72549)] = true,-- Malleable Goo 
      [GetSpellInfo(71278)] = true,-- Choking Gas Bomb 
      [GetSpellInfo(70215)] = true,-- Gaseous Bloat 
      [GetSpellInfo(70447)] = true,-- Volatile Ooze Adhesive 
      [GetSpellInfo(72454)] = true,-- Mutated Plague 
      [GetSpellInfo(70405)] = true,-- Mutated Transformation 
      --[GetSpellInfo(72856)] = true,-- Unbound Plague 
      [GetSpellInfo(70953)] = true,-- Plague Sickness 
               
      --Blood Princes 
      --[GetSpellInfo(72796)] = true,-- Glittering Sparks 
      [GetSpellInfo(71822)] = true,-- Shadow Resonance 
               
      --Blood-Queen Lana'thel 
      [GetSpellInfo(70838)] = true,-- Blood Mirror 
      --[GetSpellInfo(72265)] = true,-- Delirious Slash 
      --[GetSpellInfo(71473)] = true,-- Essence of the Blood Queen 
      --[GetSpellInfo(71474)] = true,-- Frenzied Bloodthirst 
      [GetSpellInfo(73070)] = true,-- Incite Terror 
      [GetSpellInfo(71340)] = true,-- Pact of the Darkfallen 
      [GetSpellInfo(71265)] = true,-- Swarming Shadows 
      [GetSpellInfo(70923)] = true,-- Uncontrollable Frenzy 
               
      --Valithria Dreamwalker 
      [GetSpellInfo(70873)] = true,-- Emerald Vigor 
      --[GetSpellInfo(71746)] = true,-- Column of Frost 
      --[GetSpellInfo(71741)] = true,-- Mana Void 
      --[GetSpellInfo(71738)] = true,-- Corrosion 
      --[GetSpellInfo(71733)] = true,-- Acid Burst 
      --[GetSpellInfo(71283)] = true,-- Gut Spray 
      [GetSpellInfo(71941)] = true,-- Twisted Nightmares 
               
      --Sindragosa 
      [GetSpellInfo(69762)] = true,-- Unchained Magic 
      [GetSpellInfo(69766)] = true,-- Instability 
      [GetSpellInfo(70126)] = true,-- Frost Beacon 
      [GetSpellInfo(70157)] = true,-- Ice Tomb 
       
      --The Lich King 
      [GetSpellInfo(70337)] = true,-- Necrotic plague 
      [GetSpellInfo(72149)] = true,-- Shockwave 
      [GetSpellInfo(70541)] = true,-- Infest 
      [GetSpellInfo(69242)] = true,-- Soul Shriek 
      [GetSpellInfo(69409)] = true,-- Soul Reaper 
      [GetSpellInfo(72762)] = true,-- Defile 
      [GetSpellInfo(68980)] = true,-- Harvest Soul   
       
               
      -- Trial of the Crusader 
      ["Impale"] = true,-- Impale   
      ["Snobolled!"] = true,-- Snobolled! 
      ["Acidic Spew"] = true,-- Acidic Spew 
      ["Molten Spew"] = true,-- Molten Spew 
      ["Paralytic Toxin"] = true,-- Paralytic Toxin 
      ["Fel Fireball"] = true,-- Fel Fireball 
      ["Incinerate Flesh"] = true,-- Incinerate Flesh 
      ["Burning Inferno"] = true,-- Burning Inferno       
      ["Legion Flame"] = true,-- Legion Flame 
      ["Spinning Pain Spike"] = true,-- Spinning Pain Spike 
      ["Touch of Jaraxxus"] = true,-- Touch of Jaraxxus 
      ["Curse of the Nether"] = true,-- Curse of the Nether   
      ["Mistress' Kiss"] = true,-- Mistress' Kiss   
      ["Unstable Affliction"] = true,-- Unstable Affliction 
      ["Touch of Darkness"] = true,-- Touch of Darkness 
      ["Touch of Light"] = true,-- Touch of Light   
      ["Twin Spike"] = true,-- Twin Spike 
      ["Dark Essence"] = true,-- Dark Essence 
      ["Light Essence"] = true,-- Light Essence 
      ["Pursued by Anub'arak"] = true,-- Pursued by Anub'arak 
      ["Penetrating Cold"] = true,-- Penetrating Cold 
      ["Expose Weakness"] = true,-- Expose Weakness 
      ["Freezing Slash"] = true,-- Freezing Slash 
      ["Acid-Drenched Mandibles"] = true,-- Acid-Drenched Mandibles 
         
      -- Vault of Archavon 
      ["Flaming Cinder"] = true,-- Flaming Cinder 
      ["Frostbite"] = true,-- Frostbite 
         
      -- Ulduar 
      [GetSpellInfo(64412) or "Phase Punch"] = true,-- Phase Punch 
      ["Lightning Brand"] = true,-- Lightning Brand 
      ["Ravage Armor"] = true,-- Ravage Armor   
      ["Iron Roots"] = true,-- Iron Roots 
      ["Petrify Joints"] = true,-- Petrify Joints 
      ["Fuse Armor"] = true,-- Fuse Armor   
      ["Scorch"] = true,-- Scorch 
      ["Flame Jets"] = true,-- Flame Jets 
      ["Slag Pot"] = true,-- Slag Pot   
      ["Gravity Bomb"] = true,-- Gravity Bomb 
      ["Searing Light"] = true,-- Searing Light 
      ["Overwhelming Power"] = true,-- Overwhelming Power   
      ["Rune of Death"] = true,-- Rune of Death 
      ["Fusion Punch"] = true,-- Fusion Punch 
      ["Static Disruption"] = true,-- Static Disruption   
      ["Stone Grip"] = true,-- Stone Grip 
      ["Crunch Armor"] = true,-- Crunch Armor 
      ["Brittle Skin"] = true,-- Brittle Skin 
      ["Freeze"] = true,-- Freeze 
      ["Flash Freeze"] = true,-- Flash Freeze 
      ["Biting Cold"] = true,-- Biting Cold 
      ["Stormhammer"] = true,-- Stormhammer 
      ["Unbalancing Strike"] = true,-- Unbalancing Strike 
      ["Rune Detonation"] = true,-- Rune Detonation 
      ["Deafening Thunder"] = true,-- Deafening Thunder 
      ["Conservator's Grip"] = true,-- Conservator's Grip 
      ["Nature's Fury"] = true,-- Nature's Fury 
      ["Iron Roots"] = true,-- Iron Roots 
      ["Napalm Shell"] = true,-- Napalm Shell 
      ["Plasma Blast"] = true,-- Plasma Blast 
      ["Magnetic Field"] = true,-- Magnetic Field 
      ["Mark of the Faceless"] = true,-- Mark of the Faceless 
      ["Saronite Vapors"] = true,-- Saronite Vapors 
      ["Sara's Anger"] = true,-- Sara's Anger 
      ["Sara's Blessing"] = true,-- Sara's Blessing 
      ["Sara's Fervor"] = true,-- Sara's Fervor 
      ["Malady of the Mind"] = true,-- Malady of the Mind 
      ["Brain Link"] = true,-- Brain Link 
      ["Dominate Mind"] = true,-- Dominate Mind 
      ["Draining Poison"] = true,-- Draining Poison 
      ["Black Plague"] = true,-- Black Plague 
      ["Squeeze"] = true,-- Squeeze   
      ["Apathy"] = true,-- Apathy 
      ["Curse of Doom"] = true,-- Curse of Doom 
         
      ---------   
      -- PvP-- 
      --------- 
      --[GetSpellInfo(11196) or "Recently Bandaged"] = true,-- Recently Bandaged (debug ...) 
             
      -- Priest 
      [GetSpellInfo(6346) or "Fear Ward"] = true,-- Fear Ward 
      [GetSpellInfo(605) or "Mind Control"] = true,-- Mind Control 
      [GetSpellInfo(34914) or "Vampiric Touch"] = true,-- Vampiric Touch   
      [GetSpellInfo(2944) or "Devouring Plague"] = true,-- Devouring Plague 
      [GetSpellInfo(589) or "Shadow Word: Pain"] = true,-- Shadow Word: Pain 
      [GetSpellInfo(8122) or "Psychic Scream"] = true,-- Psychic Scream 
      [GetSpellInfo(64044) or "Psychic Horror"] = true,-- Psychic Horror   
      [GetSpellInfo(69910) or "Pain Suppression"] = true,-- Pain Suppression 
      [GetSpellInfo(15487) or "Silence"] = true,-- Silence 
      [GetSpellInfo(15473) or "Shadowform"] = true,-- Shadowform   
      [GetSpellInfo(47585) or "Dispersion"] = true,-- Dispersion   
      [GetSpellInfo(17) or "Power Word: Shield"] = true,-- Power Word: Shield 
      [GetSpellInfo(139) or "Renew"] = true,-- Renew 
      [GetSpellInfo(33076) or "Prayer of Mending"] = true,-- Prayer of Mending 
      [GetSpellInfo(88625) or "Holy Word: Chastise"] = true,-- Holy Word: Chastise 
      [GetSpellInfo(6788) or "Weakened Soul"] = true,-- Weakened Soul 
         
      -- Paladin 
      [GetSpellInfo(25771) or "Forbearance"] = true,-- Forbearance 
      [GetSpellInfo(642) or "Divine Shield"] = true,-- Divine Shield 
      [GetSpellInfo(10278) or "Hand of Protection"] = true,-- Hand of Protection 
      [GetSpellInfo(1044) or "Hand of Freedom"] = true,-- Hand of Freedom 
      [GetSpellInfo(6940) or "Hand of Sacrifice"] = true,-- Hand of Sacrifice   
      [GetSpellInfo(10308) or "Hammer of Justice"] = true,-- Hammer of Justice 
      [GetSpellInfo(20066)] = true,-- Repentance 
      [GetSpellInfo(53563) or "Beacon of Light"] = true,-- Beacon of Light 
         
      -- Rogue 
      [GetSpellInfo(31224) or "Cloak of Shadows"] = true,-- Cloak of Shadows 
      [GetSpellInfo(5277) or "Evasion"] = true,-- Evasion 
      [GetSpellInfo(43235) or "Wound Poison"] = true,-- Wound Poison 
      [GetSpellInfo(2094)] = true,-- Blind 
      [GetSpellInfo(3776) or "Crippling Poison"] = true,-- Crippling Poison 
      [GetSpellInfo(6770) or "Sap"] = true,-- Sap 
      [GetSpellInfo(408) or "Kidney Shot"] = true,-- Kidney Shot 
      [GetSpellInfo(1776) or "Gouge"] = true,-- Gouge   
      --[GetSpellInfo(51722)] = true,-- Dismantle 
      [GetSpellInfo(703)] = true,-- Garrote 
      [GetSpellInfo(76577)] = true,-- Smoke Bomb 
      --[GetSpellInfo(18425)] = true,-- Improved Kick   
             
      -- Warrior 
      [GetSpellInfo(12294) or "Mortal Strike"] = true,-- Mortal Strike 
      [GetSpellInfo(1715)] = true,-- Hamstring 
      [GetSpellInfo(871)] = true,-- Shield Wall   
      [GetSpellInfo(18499) or "Berserker Rage"] = true,-- Berserker Rage 
      --[GetSpellInfo(676)] = true,-- Disarm 
      --[GetSpellInfo(85388)] = true,-- Throwdown 
      [GetSpellInfo(5246)] = true,-- Intimidating Shout-- Shield Wall   
         
      -- Druid 
      [GetSpellInfo(33786)] = true,-- Cyclone 
      [GetSpellInfo(339)] = true,-- Entangling Roots 
      --[GetSpellInfo(29166)] = true,-- Innervate 
      [GetSpellInfo(2637) or "Hibernate"] = true,-- Hibernate 
      [GetSpellInfo(774) or "Rejuvenation"] = true,-- Rejuvenation 
      [GetSpellInfo(8936) or "Regrowth"] = true,-- Regrowth 
      [GetSpellInfo(33763) or "Lifebloom"] = true,-- Lifebloom 
      --[GetSpellInfo(80964)] = true,-- Skull Bash 
      --[GetSpellInfo(9005)] = true,-- Pounce 
      [GetSpellInfo(22570)] = true,-- Maim 
      [GetSpellInfo(5211)] = true,-- Bash 
         
      -- Warlock 
      [GetSpellInfo(5782) or "Fear"] = true,-- Fear 
      [GetSpellInfo(5484) or "Howl of Terror"] = true,-- Howl of Terror 
      [GetSpellInfo(6358)] = true,-- Seduction 
      [GetSpellInfo(30108) or "Unstable Affliction"] = true,-- Unstable Affliction       
      [GetSpellInfo(1714) or "Curse of Tongues"] = true,-- Curse of Tongues 
      [GetSpellInfo(18223) or "Curse of Exhaustion"] = true,-- Curse of Exhaustion 
      [GetSpellInfo(6789) or "Death Coil"] = true,-- Death Coil 
      [GetSpellInfo(30283) or "Shadowfury"] = true,-- Shadowfury 
         
      -- Shaman 
      [GetSpellInfo(51514) or "Hex"] = true,-- Hex 
      [GetSpellInfo(974) or "Earth Shield"] = true,-- Earth Shield 
      [GetSpellInfo(61295) or "Riptide"] = true,-- Riptide 
         
      -- Mage 
      --[GetSpellInfo(18469)] = true,-- Silenced- Improved Counterspell- Rank1 
      --[GetSpellInfo(55021)] = true,-- Silenced- Improved Counterspell- Rank2 
      [GetSpellInfo(2139)] = true,-- Counterspell 
      [GetSpellInfo(118) or "Polymorph"] = true,-- Polymorph 
      [GetSpellInfo(61305) or "Polymorph"] = true,-- Polymorph Black Cat 
      [GetSpellInfo(28272) or "Polymorph"] = true,-- Polymorph Pig 
      [GetSpellInfo(61721) or "Polymorph"] = true,-- Polymorph Rabbit 
      [GetSpellInfo(61780) or "Polymorph"] = true,-- Polymorph Turkey 
      [GetSpellInfo(28271) or "Polymorph"] = true,-- Polymorph Turtle 
      [GetSpellInfo(61025)] = true,-- Polymorph serpent 
      [GetSpellInfo(44572)] = true,-- Deep Freeze 
      [GetSpellInfo(45438)] = true,-- Ice Block   
      [GetSpellInfo(122) or "Frost Nova"] = true,-- Frost Nova 
      --[GetSpellInfo(80353) or "Time Warp"] = true,-- Time Warp 
      --[GetSpellInfo(82676)] = true,-- Ring of Frost 
         
      -- Hunter 
      [GetSpellInfo(82928) or "Aimed Shot"] = true,-- Aimed Shot 
      --[GetSpellInfo(19503)] = true,-- Scatter Shot 
      [GetSpellInfo(55041) or "Freezing Trap Effect"] = true,-- Freezing Trap Effect 
      [GetSpellInfo(3355)] = true,-- Freezing Trap Effect (trap launcher)   
      --[GetSpellInfo(2974)] = true,-- Wing Clip 
      [GetSpellInfo(19263)] = true, 
      [GetSpellInfo(1130)] = true,-- 标记 
      --[GetSpellInfo(34692)] = true,-- The Beast Within 
      --[GetSpellInfo(34490)] = true,-- Silencing Shot 
      [GetSpellInfo(19386) or "Wyvern Sting"] = true,-- Wyvern Sting 
      [GetSpellInfo(19577) or "Intimidation"] = true,-- Intimidation 
      --[GetSpellInfo(90337)] = true,-- Bad Manner (monkey) 
         
      -- Death Knight 
      [GetSpellInfo(45524)] = true,-- Chains of Ice 
      [GetSpellInfo(48707)] = true,-- Anti-Magic Shell 
      [GetSpellInfo(47476) or "Strangulate"] = true,-- Strangulate   
      [GetSpellInfo(47481)] = true,-- Gnaw 
      --[GetSpellInfo(49203)] = true,-- Hungering Cold 
      [GetSpellInfo(49039)] = true,-- Lichborn 
   }, 
} 