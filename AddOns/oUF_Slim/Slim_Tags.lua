local addon, ns = ...
local oUF = ns.oUF or oUF
local cfg = ns.cfg
local tags = CreateFrame("Frame") 

local utf8sub = function(string, i, dots)
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 240 then
				pos = pos + 4
			elseif c > 225 then
				pos = pos + 3
			elseif c > 192 then
				pos = pos + 2
			else
				pos = pos + 1
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

-----------------
-- custom tags --
-----------------
oUF.Tags.Methods["afkdnd"] = function(unit)
	if unit then
		return UnitIsAFK(unit) and "|cffffffff<AFK>|r " or UnitIsDND(unit) and "|cffffffff<DND>|r "
	end
end
oUF.Tags.Events["afkdnd"] = "PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods["abbrevname"] = function(unit)
	local oldName = UnitName(unit)
	local newName = (string.len(oldName) > 14) and string.gsub(oldName, "%s?(.[\128-\191]*)%S+%s", "%1. ") or oldName
	
	if not UnitIsPlayer(unit) then
		return utf8sub(newName, 14, false)
	else
		return oldName
	end
end
oUF.Tags.Events["abbrevname"] = "UNIT_NAME_UPDATE"

if (not oUF.Tags.Methods["shortname"]) then
	oUF.Tags.Methods["shortname"] = function(unit)
		local oldName = UnitName(unit)
		local newName = (string.len(oldName) > 6) and string.gsub(oldName, "%s?(.[\128-\191]*)%S+%s", "%1. ") or oldName
		return utf8sub(newName, 6, false)
	end
end
oUF.Tags.Events["shortname"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["raidhpname"] = function(u)
local name = UnitName(u)
local c, m = UnitHealth(u), UnitHealthMax(u) 
if c == 0 then return "RIP" elseif(UnitIsGhost(u)) then return "GHO" elseif(not UnitIsConnected(u)) then return "OFF" elseif c < m then return oUF.Tags.Methods["missinghp"](u) else return utf8sub(name, 6, false) end end
oUF.Tags.Events["raidhpname"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION"

oUF.Tags.Methods["druidPower"] = function(unit)
	local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
	return UnitPowerType(unit) ~= 0 and format('|cff0ff0ff %d|r', min)
end
oUF.Tags.Events["druidPower"] = 'UNIT_MAXPOWER UNIT_POWER UPDATE_SHAPESHIFT_FORM'

oUF.Tags.Methods["holyPower"] = function(unit)
local hp = UnitPower('player', SPELL_POWER_HOLY_POWER)
	if hp > 0 then
		return string.format("|CFFfcf514%d|r",hp)	
	end
end
oUF.Tags.Events["holyPower"] = "UNIT_POWER"
	
oUF.Tags.Methods["soulShards"] = function(unit)
local sn = UnitPower('player', SPELL_POWER_SOUL_SHARDS)
	if sn == 3 then 
		return	-- only show shard number for less than 3 shards
	else
		return string.format("|CFF911fff%d|r",sn)	
	end
end
oUF.Tags.Events["soulShards"] = "UNIT_POWER"

local EVANGELISM = GetSpellInfo(81661) or GetSpellInfo(81660)
local DARK_EVANGELISM = GetSpellInfo(87118) or GetSpellInfo(87117)
oUF.Tags.Methods["evangelism"] = function(unit)
	if unit == "player" then
		local name, _, icon, count = UnitBuff("player", EVANGELISM)
		if name then return count end
		name, _, icon, count = UnitBuff("player", DARK_EVANGELISM)
		return name and count
	end
end
oUF.Tags.Events["evangelism"] = "UNIT_AURA"

local SHADOW_ORB = GetSpellInfo(77487)
oUF.Tags.Methods["shadoworbs"] = function(unit)
	if unit == "player" then
		local name, _, icon, count = UnitBuff("player", SHADOW_ORB)
		return name and count
	end
end
oUF.Tags.Events["shadoworbs"] = "UNIT_AURA"

local MAELSTROM_WEAPON = GetSpellInfo(53817)
oUF.Tags.Methods["maelstrom"] = function(unit)
	if unit == "player" then
		local name, _, icon, count = UnitBuff("player", MAELSTROM_WEAPON)
		return name and count
	end
end	
oUF.Tags.Events["maelstrom"] = "UNIT_AURA"

-- xp/rep
oUF.Tags.Events["SlimExp"] = "PLAYER_XP_UPDATE UPDATE_EXHAUSTION UNIT_LEVEL"
oUF.Tags.Methods["SlimExp"] = function(unit)
	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		if GetXPExhaustion() then
			return ("XP: %s/%s (%.1f%% R)"):format(CoolNumber(UnitXP("player")), CoolNumber(UnitXPMax("player")), (GetXPExhaustion() or 0) / UnitXPMax("player") * 100)
		else
			return ("XP: %s/%s"):format(CoolNumber(UnitXP("player")), CoolNumber(UnitXPMax("player")))
		end
	else 
		return
	end
end

oUF.Tags.Events["SlimRep"] = "UNIT_LEVEL UPDATE_FACTION CHAT_MSG_COMBAT_FACTION_CHANGE"
oUF.Tags.Methods["SlimRep"] = function(unit)
	local faction, lvl, min, max, val = GetWatchedFactionInfo()
	if faction then
		local color = oUF.colors.reaction[lvl] or cfg.colors.text
		return ("|cFF%.2x%.2x%.2x%s: %s/%s|r"):format(color[1] * 255, color[2] * 255, color[3] * 255, faction, val - min, CoolNumber(max - min))
	else
		return
	end
end

---------------
-- raid tags --
---------------

-- priest
oUF.Tags.Methods["NivPWS"] = function(u) 
	if UnitAura(u, GetSpellInfo(17) or "Power Word: Shield") then return "|cffFFD800S|r" end end
oUF.Tags.Methods["NivRenew"] = function(u) 
	local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, GetSpellInfo(139) or "Renew")
	if not (fromwho == "player") then return end
	if UnitAura(u, GetSpellInfo(139) or "Renew") then return "|cff00FF10R|r" end end
oUF.Tags.Methods["NivPoM"] = function(u) local c = select(4, UnitAura(u, GetSpellInfo(33076) or "Prayer of Mending")) if c then return "|cffFFCF7FPoM("..c..")|r" end end
oUF.Tags.Methods["NivGS"] = function(u) if UnitAura(u, GetSpellInfo(47788) or "Guardian Spirit") then return "|cffFFD800G|r" end end
oUF.Tags.Methods["NivWS"] = function(u) if UnitDebuff(u, GetSpellInfo(6788) or "Weakened Soul") then return "|cffFF0000 W|r" end end
oUF.Tags.Methods["NivFW"] = function(u) if UnitAura(u, GetSpellInfo(6346) or "Fear Ward") then return "|cffFF0000 FW|r" end end

oUF.Tags.Events["NivPWS"] = "UNIT_AURA"
oUF.Tags.Events["NivPWB"] = "UNIT_AURA"
oUF.Tags.Events["NivRenew"] = "UNIT_AURA"
oUF.Tags.Events["NivPoM"] = "UNIT_AURA"
oUF.Tags.Events["NivGS"] = "UNIT_AURA"
oUF.Tags.Events["NivWS"] = "UNIT_AURA"
oUF.Tags.Events["NivFW"] = "UNIT_AURA"

-- paladin
oUF.Tags.Methods["NivBoL"] = function(u) if UnitAura(u, GetSpellInfo(53563) or "Beacon of Light") then return "|cffFFD800BoL|r" end end

oUF.Tags.Events["NivBoL"] = "UNIT_AURA"

-- druid
oUF.Tags.Methods["NivRej"] = function(u) 
	local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, GetSpellInfo(774) or "Rejuvenation")
	if not (fromwho == "player") then return end
	if UnitAura(u, GetSpellInfo(774) or "Rejuvenation") then return "|cff00FEBFRj|r" end end
oUF.Tags.Methods["NivReg"] = function(u) 
	local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, GetSpellInfo(8936) or "Regrowth")
	if not (fromwho == "player") then return end
	if UnitAura(u, GetSpellInfo(8936) or "Regrowth") then return "|cff00FF10Rg|r" end end
oUF.Tags.Methods["NivLB"] = function(u) 
	local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, GetSpellInfo(33763) or "Lifebloom")
	if not (fromwho == "player") then return end
	local c = select(4, UnitAura(u, GetSpellInfo(33763) or "Lifebloom")) if c then return "|cffA7FD0ALB("..c..")|r" end end
oUF.Tags.Methods["NivInn"] = function(u) if UnitAura(u, GetSpellInfo(29166) or "Innervate") then return "|cff3c3be7Iv|r" end end
oUF.Tags.Methods["NivWG"] = function(u) if UnitAura(u, GetSpellInfo(53251) or "Wild Growth") then return "|cff33FF33WG|r" end end

oUF.Tags.Events["NivRej"] = "UNIT_AURA"
oUF.Tags.Events["NivReg"] = "UNIT_AURA"
oUF.Tags.Events["NivLB"] = "UNIT_AURA"
oUF.Tags.Events["NivInn"] = "UNIT_AURA"
oUF.Tags.Events["NivWG"] = "UNIT_AURA"

-- shaman
oUF.Tags.Methods["NivES"] = function(u) local c = select(4, UnitAura(u, GetSpellInfo(974) or "Earth Shield")) if c then return "|cffFFCF7FES("..c..")|r" end end
oUF.Tags.Methods["NivRipT"] = function(u) 
	local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, GetSpellInfo(61295) or "Riptide")
	if not (fromwho == "player") then return end
	if UnitAura(u, GetSpellInfo(61295) or "Riptide") then return "|cff00FEBFR|r" end end
oUF.Tags.Methods["NivErLiv"] = function(u) 
	local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, GetSpellInfo(52000) or "Earthliving")
	if not (fromwho == "player") then return end
	if UnitAura(u, GetSpellInfo(51945) or "Earthliving") then return "|cff00FEBFErEL|r" end end

oUF.Tags.Events["NivES"] = "UNIT_AURA"
oUF.Tags.Events["NivRipT"] = "UNIT_AURA"
oUF.Tags.Events["NivErLiv"] = "UNIT_AURA" 	

ns.tags = tags