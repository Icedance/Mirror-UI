local addon, ns = ...
local oUF = ns.oUF or oUF
local cfg = ns.cfg
local tags = ns.tags
local _, playerClass = UnitClass('player')

local blankTex = "Interface\\Buttons\\WHITE8x8"
local backdrop = {edgeFile = blankTex, edgeSize = 1}
local backdrop2 = {bgFile = blankTex}
--backdrop3 = {bgFile = blankTex, edgeFile = blankTex, edgeSize = 1, insets = { left = -1, right = -1, top = -1, bottom = -1}}
local backdrop3 = {bgFile = blankTex, insets = { left = -1, right = -1, top = -1, bottom = -1}}
local backdrop4 = {bgFile = blankTex, edgeFile = blankTex, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1}}

local CreateBorder_Small = function(self,parent)
	if not parent then parent = self end
	if not self.border then
		local bd = CreateFrame("Frame",nil,parent)
		bd:SetPoint("TOPLEFT",self,-1,1)
		bd:SetPoint("BOTTOMRIGHT",self,1,-1)
		bd:SetBackdrop(backdrop4)
		bd:SetBackdropColor(0,0,0,0.72)
		bd:SetBackdropBorderColor(0,0,0)
		bd:SetFrameLevel(0)
		
		self.border = bd
	end
	return self.border
end

-- change some colors
local colors = setmetatable({
	power = setmetatable({
	["MANA"] = {0.36, 0.65, 0.88},
	["RAGE"] = {0.8, 0.21, 0.31},
	["FUEL"] = {0, 0.55, 0.5},
	["FOCUS"] = {0.71, 0.43, 0.27},
	["ENERGY"] = {0.85, 0.83, 0.35},
	["AMMOSLOT"] = {0.8, 0.6, 0},
	["RUNIC_POWER"] = {0, 0.82, 1},
	["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
	["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

-- format numbers
function round(num, idp)
  if idp and idp > 0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function CoolNumber(num)
	if(num >= 1e6) then
		return round(num/1e6,cfg.Numberzzz).."m"
	elseif(num >= 1e3) then
		return round(num/1e3,cfg.Numberzzz).."k"
	else
		return num
	end
end

-- health update
local PostUpdateHealth = function(Health, unit, min, max)
	local self = Health:GetParent()
    local d =(round(min/max, 2)*100)
	local c = UnitClassification(unit)
	
	if(UnitIsDead(unit)) then
		Health:SetValue(0)
		Health.value:SetText"RIP"	
		Health.PERvalue:SetText(" ")
	elseif(UnitIsGhost(unit)) then
		Health:SetValue(0)
		Health.value:SetText"GHO"
		Health.PERvalue:SetText(" ")
	elseif(not UnitIsConnected(unit)) then	
		Health.value:SetText"OFF"	
		Health.PERvalue:SetText(" ")
	elseif(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
		Health.value:SetText"TPD"		
		Health.PERvalue:SetText(" ")
	elseif(unit == "player") or (unit == "target") then
		if(d < 100) then
			Health.PERvalue:SetText((round(min/max, 2)*100).."%")
			Health.PERvalue:Show()			
		else
		    Health.PERvalue:SetText(" ")
			Health.PERvalue:Hide()		
		end
        Health.value:SetText(CoolNumber(min))	
	else
		Health.value:SetText(CoolNumber(min))
	end

	-- set text color
	if(unit) then
		if(d <= 35 and d >= 25) then
			Health.value:SetTextColor(253/255, 238/255, 80/255)
		elseif(d < 25 and d >= 20) then
			Health.value:SetTextColor(250/255, 130/255, 0/255)
		elseif(d < 20) then
			Health.value:SetTextColor(200/255, 20/255, 40/255)
		else
			Health.value:SetTextColor(unpack(cfg.sndcolor))
		end
		Health.PERvalue:SetTextColor(unpack(cfg.sndcolor))
	end	
end

-- health update transparency mode
local PostUpdateHealthTM = function(Health, unit, min, max)
	local self = Health:GetParent()
    local d =(round(min/max, 2)*100)
	local c = UnitClassification(unit)
	
	local HPheight = Health:GetHeight()
	self.Health.bg:SetPoint('LEFT', Health:GetStatusBarTexture(), 'RIGHT')	
	self.Health.bg:SetHeight(HPheight)	
		
	if(UnitIsDead(unit)) then
		Health:SetValue(0)
		Health.value:SetText"RIP"	
		Health.PERvalue:SetText(" ")
	elseif(UnitIsGhost(unit)) then
		Health:SetValue(0)
		Health.value:SetText"GHO"
		Health.PERvalue:SetText(" ")
	elseif(not UnitIsConnected(unit)) then	
		Health.value:SetText"OFF"	
		Health.PERvalue:SetText(" ")
	elseif(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
		Health.value:SetText"TPD"		
		Health.PERvalue:SetText(" ")
	elseif(unit == "player") or (unit == "target") then
		if(d < 100) then
			Health.PERvalue:SetText((round(min/max, 2)*100).."%")
			Health.PERvalue:Show()			
		else
		    Health.PERvalue:SetText(" ")
			Health.PERvalue:Hide()		
		end
        Health.value:SetText(CoolNumber(min))	
	else
		Health.value:SetText(CoolNumber(min))
	end

	-- set health background color
	local _, class = UnitClass(unit)
	local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]		

	if UnitIsPlayer(unit) and color then
		self.Health.bg:SetVertexColor(color.r, color.g, color.b, 0.9)
	else
		local r, g, b = UnitSelectionColor(unit)
		self.Health.bg:SetVertexColor(r, g, b, 0.9)	
	end
	
	if UnitLevel(unit) == 0 then
		self.Health.bg:SetVertexColor(0, 0, 0, 0.5)
	elseif UnitIsConnected(unit) ~= true then
		self.Health.bg:SetVertexColor(0, 0, 0, 0.5)
	elseif UnitIsDeadOrGhost(unit) == true then
		self.Health.bg:SetVertexColor(200/255, 20/255, 40/255, 0.5)
	end	
	
	-- set text color
	if(unit) then
		if(d <= 35 and d >= 25) then
			Health.value:SetTextColor(253/255, 238/255, 80/255)
		elseif(d < 25 and d >= 20) then
			Health.value:SetTextColor(250/255, 130/255, 0/255)
		elseif(d < 20) then
			Health.value:SetTextColor(200/255, 20/255, 40/255)
		else
			Health.value:SetTextColor(unpack(cfg.sndcolor))
		end
		Health.PERvalue:SetTextColor(unpack(cfg.sndcolor))
	end
end

-- power update
local PostUpdatePower = function(Power, unit, min, max)
	local dp =(round(min/max, 2)*100)
	
	if(min == 0 or max == 0 or not UnitIsConnected(unit)) then
		Power.value:SetText()
		Power:SetValue(0)
	elseif(UnitIsDead(unit) or UnitIsGhost(unit)) then
		Power:SetValue(0)
		Power.value:SetText()
	elseif(unit == "player") then
		if(dp < 100) then
			Power.value:Show()
			--.value:SetText(CoolNumber(min))
			Power.value:SetText(CoolNumber(min).."  "..(round(min/max, 2)*100).."%") --蓝条百分比形式
		else
			Power.value:Hide()
		end	
	else
		Power.value:SetText(CoolNumber(min))
	end
	
	-- color power text by power type
	local _, ptype = UnitPowerType(unit)
        if(colors.power[ptype]) then
		r, g, b = unpack(colors.power[ptype])
	end
	
	Power.value:SetTextColor(r, g, b)
end

local PostUpdatePowerRaid = function(Power, unit)
	local powertype, _ = UnitPowerType(unit)
	if powertype ~= SPELL_POWER_MANA then
		Power:Hide()
	else
		Power:Show()
	end	
end	
	
-- custom castbar text (curCastTime/maxCastTime)
local function CustomTimeText(self, duration)
	if self.casting then
		self.Time:SetFormattedText('%.1f /', (self.max - duration))
		self.Time2:SetFormattedText(' %.1f', self.max)
	elseif self.channeling then
		self.Time:SetFormattedText('%.1f /', duration)
		self.Time2:SetFormattedText(' %.1f', self.max)
	end
end

--------------------
-- aura functions --
--------------------
-- filter some crap
local Whitelist = Whitelist.auras
local CustomFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
	if(Whitelist[name]) then
		return true
	end 
end

-- format time
local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		if s <= minute * 5 then
			return format('%d:%02d', floor(s/60), s % minute), s - floor(s)
		end
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end


-- aura timer 
local CreateAuraTimer = function(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.1 then
		if not self.first then
			self.timeLeft = self.timeLeft - self.elapsed
		else
			self.timeLeft = self.timeLeft - GetTime()
			self.first = false
		end
		if self.timeLeft > 0 then
			local time = FormatTime(self.timeLeft)
			self.time:SetText(time)
			if self.timeLeft < 5 then
				self.time:SetTextColor(1, 0, 0)
			elseif self.timeLeft >= 5 and self.timeLeft < cfg.HideAuraTimer then
				self.time:SetTextColor(unpack(cfg.sndcolor))
			else
				self.time:SetText('')
				self.time:SetTextColor(unpack(cfg.sndcolor))			
			end
			else
				self.time:Hide()
			end
			self.elapsed = 0
		end
end

-- icon style
local PostCreateIcon = function(Auras, button)
	local buttonwidth = button:GetWidth()
	button.cd.noOCC = true		 		-- hide OmniCC CDs
	button.cd.noCooldownCount = true	-- hide CDC CDs
	Auras.disableCooldown = true		-- hide CD spiral
	Auras.showDebuffType = true			-- show debuff border type color 		
	
	button.overlay:SetTexture(cfg.Auratex)
    button.overlay:SetPoint("TOPLEFT", button.icon, "TOPLEFT", 0, 0)
    button.overlay:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 0, 0)		
	button.overlay:SetTexCoord(0, 1, 0, 1)
	button.overlay.Hide = function(self) self:SetVertexColor(unpack(cfg.brdcolor)) end		
	
	button.time = button:CreateFontString(nil, 'OVERLAY')
	button.time:SetFont(cfg.NumbFont, cfg.NumbFS, cfg.fontFNum)	--aura计时字体
	button.time:SetPoint("BOTTOM", button, 1, -3)--计时字体位置
	button.time:SetJustifyH('CENTER')
	button.time:SetVertexColor(unpack(cfg.sndcolor))	

	button:SetSize(cfg.buSize, cfg.buSize*cfg.buHeightMulti)
	
	local count = button.count
	count:ClearAllPoints()
	count:SetPoint("CENTER", button, "TOP", 1, 1)
	count:SetFont(cfg.NumbFont, cfg.NumbFS, cfg.fontFNum)--层数字体
	count:SetVertexColor(unpack(cfg.sndcolor))
	
	button.icon:SetTexCoord(.08, .92, .08, .92)
end

-- weapon enchant icon
local function WeapEnchantIcon(self, icon, icons)
	local iconwidth = icon:GetWidth()
	icon.time = icon:CreateFontString(nil, 'OVERLAY')
	icon.time:SetFont(cfg.NumbFont, iconwidth/2.6, cfg.fontFNum)
	icon.time:SetPoint("BOTTOM", icon, 0, -2)
	icon.time:SetJustifyH('CENTER')
	icon.time:SetVertexColor(unpack(cfg.sndcolor))
	
	icon.overlay:SetTexture(cfg.Auratex)
	icon.overlay:SetTexCoord(0, 1, 0, 1)
	icon.overlay:SetVertexColor(unpack(cfg.brdcolor))	

	icon.icon:SetTexCoord(.08, .92, .08, .92)	
end

local CreateEnchantTimer = function(self, icons)
	for i = 1, 2 do
		local icon = icons[i]
		if icon.expTime then
			icon.timeLeft = icon.expTime - GetTime()
			icon.time:Show()
		else
			icon.time:Hide()
		end
		icon:SetScript("OnUpdate", CreateAuraTimer)
	end
end

-- update icon 图标时间？
local PostUpdateIcon
do
	local playerUnits = {
		player = true,
		pet = true,
		vehicle = true,
	}

	PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
	local name, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
	local texture = icon.icon
	
	if unit == "target" or unit == "focus" then
		if duration and duration > 0 then --and Whitelist[name] or (playerUnits[icon.owner]) then--显示全部buff/debuff的计时
			icon.time:Show()
			icon.timeLeft = expirationTime
			icon:SetScript("OnUpdate", CreateAuraTimer)
		else
			icon.time:Hide()
		end
	else
		if duration and duration > 0 then
			icon.time:Show()
			icon.timeLeft = expirationTime
			icon:SetScript("OnUpdate", CreateAuraTimer)
		else
			icon.time:Hide()
		end
	end

	if unit == "target" or unit == "focus" then
		if (playerUnits[icon.owner]) then
			if dtype == "Magic" or dtype == "Disease" or dtype == "Poison" or dtype == "Curse" then
				local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
				icon.overlay:SetVertexColor(color.r*0.9, color.g*0.9, color.b*0.9)
				texture:SetDesaturated(false)
			end
		else
			icons.showDebuffType = true
			icon.overlay:SetVertexColor(unpack(cfg.brdcolor))	
			texture:SetDesaturated(true)
		end	
	end	
	
	icon.first = true
	end
end

-- right click menu
local dropdown = CreateFrame("Frame", "MyAddOnUnitDropDownMenu", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(dropdown, function(self)
	local unit = self:GetParent().unit
	if not unit then return end

	local menu, name, id
	if UnitIsUnit(unit, "player") then
		menu = "SELF"
	elseif UnitIsUnit(unit, "vehicle") then
		menu = "VEHICLE"
	elseif UnitIsUnit(unit, "pet") then
		menu = "PET"
	elseif UnitIsPlayer(unit) then
		id = UnitInRaid(unit)
		if id then
			menu = "RAID_PLAYER"
			name = GetRaidRosterInfo(id)
		elseif UnitInParty(unit) then
			menu = "PARTY"
		else
			menu = "PLAYER"
		end
	else
		menu = "TARGET"
		name = RAID_TARGET_ICON
	end
	if menu then
		UnitPopup_ShowMenu(self, menu, unit, name, id)
	end
end, "MENU")

local menu = function(self)
	dropdown:SetParent(self)
	ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
end


-- threat highlight
local function updateThreatStatus(self, event, u)
	if (self.unit ~= u) then return end
	local s = UnitThreatSituation(u)
	if s and s > 1 then
		local r, g, b = GetThreatStatusColor(s)
		self.ThreatHlt:Show()
		self.ThreatHlt:SetVertexColor(r, g, b, 1.0)	
	else
		self.ThreatHlt:Hide()
	end
end

-- debuff highlight
local CanDispel = {
	PRIEST = { Magic = true, Disease = true, },
	SHAMAN = { Magic = true, Curse = true},
	PALADIN = { Magic = true, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Magic = true, Curse = true, Poison = true},
}
local dispellist = CanDispel[playerClass] or {}

local function GetDebuffType(unit)
	if not UnitCanAssist("player", unit) then return nil end
	local i = 1
	while true do
		local name, rank, texture, count, debufftype, duration, expirationTime, source = UnitDebuff(unit, i)
		if not texture then break end
		if debufftype and dispellist[debufftype] then
			return debufftype
		end
		i = i + 1
	end
end

local function updateDispel(self, event, u)
	if not u or self.unit ~= u then return end
	local debufftype = GetDebuffType(u)
	if debufftype then
		local color = DebuffTypeColor[debufftype] 
		self.dHlight:Show()
		self.dHlight:SetVertexColor(color.r, color.g, color.b)	
		self.dHlight2:Show()
		self.dHlight2:SetVertexColor(color.r, color.g, color.b)			
	else
		self.dHlight:Hide()	
		self.dHlight2:Hide()			
	end
end

-- mouseover highlight
local UnitFrame_OnEnter = function(self)
	UnitFrame_OnEnter(self)
	self.Mouseover:Show()	
end

local UnitFrame_OnLeave = function(self)
	UnitFrame_OnLeave(self)
	self.Mouseover:Hide()
end

--施法条分段
local channelingTicks = { 
   -- warlock 
   --[GetSpellInfo(1120)] = 5, -- drain soul 
   [GetSpellInfo(689)] = 3, -- drain life 
   [GetSpellInfo(5740)] = 4, -- rain of fire 
   -- druid 
   [GetSpellInfo(740)] = 4, -- Tranquility 
   [GetSpellInfo(16914)] = 10, -- Hurricane 
   -- priest 
   [GetSpellInfo(15407)] = 3, -- mind flay 
   [GetSpellInfo(48045)] = 5, -- mind sear 
   [GetSpellInfo(47540)] = 2, -- penance  
   -- mage 
   [GetSpellInfo(5143)] = 5, -- arcane missiles 
   [GetSpellInfo(10)] = 5, -- blizzard 
   [GetSpellInfo(12051)] = 4, -- evocation 
} 
local ticks = {} 
   setBarTicks = function(castBar, ticknum) 
   if ticknum and ticknum > 0 then 
      local delta = castBar:GetWidth() / ticknum 
      for k = 1, ticknum do 
         if not ticks[k] then 
            ticks[k] = castBar:CreateTexture(nil, 'OVERLAY') 
            ticks[k]:SetTexture(cfg.CBtex) 
            ticks[k]:SetVertexColor(0, 0, 0) 
            ticks[k]:SetWidth(1)--分段施法宽度 
            ticks[k]:SetHeight(castBar:GetHeight()) 
         end 
         ticks[k]:ClearAllPoints() 
         ticks[k]:SetPoint("CENTER", castBar, "LEFT", delta * k, 0 ) 
         ticks[k]:Show() 
      end 
   else 
      for k, v in pairs(ticks) do 
         v:Hide() 
      end 
   end 
end 
-- hide/show unitname/spellname while casting
local PostCastStart = function(Castbar, unit, spell, spellrank)
	Castbar:GetParent().Name:Hide()
	Castbar:GetParent().Status:Hide()
	
	if Castbar.interrupt and UnitCanAttack("player", unit) then
		Castbar:SetStatusBarColor(0.9, 0, 1.0, 0.6)--不可打断的施法条颜色
		if cfg.useSpellIcon then
			Castbar.IconGlow:SetBackdropColor(0.9, 0, 1.0, 0.6)
		end	
	else
		local cbR, cbG, cbB = unpack(cfg.trdcolor)
		Castbar:SetStatusBarColor(cbR, cbG, cbB, 0.6)
		if cfg.useSpellIcon then
			Castbar.IconGlow:SetBackdropColor(unpack(cfg.brdcolor))	
		end			
	end	
--施法条分段第二段
	local parent = Castbar:GetParent() 
    if parent.unit == "player" then 
      if Castbar.casting then 
         setBarTicks(Castbar, 0) 
      else 
         local spell = UnitChannelInfo(unit) 
         Castbar.channelingTicks = channelingTicks[spell] or 0 
         setBarTicks(Castbar, Castbar.channelingTicks) 
      end 
   end
--
end

local PostCastStop = function(Castbar, unit)
	local self = Castbar:GetParent()
	self.Name:Show()
	self.Status:Show()
end

local PostCastStopUpdate = function(self, event, unit)
	if(unit ~= self.unit) then return end
	return PostCastStop(self.Castbar, unit)
end

-- skin mirror bars
function MirrorBars()
	if(MirrorBars) then
		for _, bar in pairs({
			'MirrorTimer1',
			'MirrorTimer2',
			'MirrorTimer3',
	}) do   
		local bg = select(1, _G[bar]:GetRegions())
		bg:Hide()
			
			_G[bar]:SetBackdrop(backdrop3)			
			_G[bar]:SetBackdropColor(unpack(cfg.brdcolor))
							
			_G[bar..'Border']:Hide()
			
			_G[bar]:SetParent(UIParent)
			_G[bar]:SetScale(1)
			_G[bar]:SetHeight(4)
			_G[bar]:SetWidth(160)
			  
			_G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
			_G[bar..'Background']:SetTexture(blankTex)
			_G[bar..'Background']:SetAllPoints(_G[bar])
			_G[bar..'Background']:SetVertexColor(0, 0, 0, 0.5)
				
			_G[bar..'Text']:SetFont(cfg.NameFont, cfg.NameFS, cfg.FontF)
			_G[bar..'Text']:ClearAllPoints()
			_G[bar..'Text']:SetPoint('TOP', MirrorTimer1StatusBar, 'BOTTOM', 0, -2)
			
			_G[bar..'StatusBar']:SetStatusBarTexture(cfg.HPtex)
				
			_G[bar..'StatusBar']:SetAllPoints(_G[bar])
		end
	end
end

--------------------------------
-- shared stuff for all units --
--------------------------------
local Shared = function(self, unit, isSingle)
local _, playerClass = UnitClass('player')

	self.menu = menu
	--self:SetAttribute("*type2", "menu")

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks"AnyUp"
	
	-- set/clear focus with shift + left click
    local ModKey = 'Shift'
    local MouseButton = 1
    local key = ModKey .. '-type' .. (MouseButton or '')
	if(self.unit == 'focus') then
		self:SetAttribute(key, 'macro')
		self:SetAttribute('macrotext', '/clearfocus')
	else
		self:SetAttribute(key, 'focus')
	end
	
	if cfg.HideBlizzardAuras == true then
		-- hide blizzard buff, debuff and weapon enchant frame
		local BlizzFrame = _G['BuffFrame']
		BlizzFrame:UnregisterEvent('UNIT_AURA')
		BlizzFrame:Hide()
		BlizzFrame = _G['TemporaryEnchantFrame']
		BlizzFrame:Hide()
	end
	
	-- hp
	local hp = CreateFrame("StatusBar", nil, self)
	hp:SetHeight(cfg.heightHP)	
	hp:SetStatusBarTexture(cfg.HPtex)
	hp:SetPoint"TOP"
	hp:SetPoint"LEFT"
	hp:SetPoint"RIGHT"
	hp:GetStatusBarTexture():SetHorizTile(true)
	hp:SetFrameLevel(3)
	hp.frequentUpdates = true
	hp.Smooth = true	
	self.Health = hp
	
	if cfg.TransparencyMode then
		local tmR, tmG, tmB = unpack(cfg.hpTransMcolor)
		hp:SetStatusBarColor(tmR, tmG, tmB, cfg.hpTransMalpha)
		
		self.Health.PostUpdate = PostUpdateHealthTM			
	else
		hp.colorTapping = true
		hp.colorClass = true--血条职业颜色
		hp.colorReaction = true	
	
		self.Health.PostUpdate = PostUpdateHealth	
	end
	
	-- hp border
	self.Glow = CreateFrame("Frame", nil, hp)
	self.Glow:SetPoint("TOPLEFT", hp, "TOPLEFT", -1, 1)
	self.Glow:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", 1, -1)
	self.Glow:SetBackdrop(backdrop)
	self.Glow:SetBackdropBorderColor(unpack(cfg.brdcolor))	
	self.Glow:SetFrameLevel(3)
	
	local Framewidth = self:GetWidth()
	
	-- hp bg
	hpbg = hp:CreateTexture(nil, "BACKGROUND")
	hpbg:SetTexture(cfg.Itex)
	hp.bg = hpbg	
	
	if cfg.TransparencyMode then
		hpbg:SetPoint"LEFT"
		hpbg:SetPoint"RIGHT"
		hpbg:SetPoint("LEFT", hp:GetStatusBarTexture(), "RIGHT")	
	else
		hpbg:SetAllPoints(hp)
		hpbg:SetAlpha(0.6)			
		hpbg.multiplier = 0.4	
	end
	
	-- pp
	local pp = CreateFrame("StatusBar", nil, self)
	pp:SetSize(cfg.widthP, cfg.heightPP)			
	pp:SetStatusBarTexture(cfg.PPtex)
	pp:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -cfg.PPyOffset)
	pp:GetStatusBarTexture():SetHorizTile(true)
	pp:SetFrameLevel(1)
	
	pp.frequentUpdates = true
	pp.colorPower = true	
	self.Power = pp	
	self.Power.PostUpdate = PostUpdatePower	

	self.Power.Smooth = true	
	
	-- pp border
	self.Glow.pp = CreateFrame("Frame", nil, pp)
	self.Glow.pp:SetPoint("TOPLEFT", pp, "TOPLEFT", -1, 1)
	self.Glow.pp:SetPoint("BOTTOMRIGHT", pp, "BOTTOMRIGHT", 1, -1)
	self.Glow.pp:SetBackdrop(backdrop)
	self.Glow.pp:SetBackdropBorderColor(unpack(cfg.brdcolor))	
	self.Glow.pp:SetFrameLevel(1)	
	
	-- pp bg
	local ppBG = pp:CreateTexture(nil, 'BORDER')
	ppBG:SetAllPoints()	
	ppBG:SetTexture(cfg.Itex)
	ppBG.multiplier = 0.4
	ppBG:SetAlpha(0.5)		
	pp.bg = ppBG

	if cfg.TransparencyMode then
		pp:SetAlpha(0.8)	
	else
		pp:SetAlpha(1)	
	end
	
	-- enable custom colors
	self.colors = colors

	-- font strings
	self.Health.value = hp:CreateFontString(nil, "OVERLAY")
	self.Health.value:SetFont(cfg.NumbFont, cfg.hpNumbFS, cfg.fontFNum)
	
	self.Health.PERvalue = self.Health:CreateFontString(nil, "OVERLAY")	
	self.Health.PERvalue:SetFont(cfg.NumbFont, cfg.hpNumbFS, cfg.fontFNum)
--？
	
	self.Power.value = hp:CreateFontString(nil, "OVERLAY")
	self.Power.value:SetFont(cfg.NumbFont, cfg.NumbFS, cfg.fontFNum)	
	
	self.Name = hp:CreateFontString(nil, "OVERLAY")
	self.Name:SetFont(cfg.NameFont, cfg.NameFS, cfg.FontF)
	self:Tag(self.Name, '[raidcolor][abbrevname]')

	self.Status = hp:CreateFontString(nil, "OVERLAY")
	self.Status:SetFont(cfg.NameFont, cfg.NameFS, cfg.FontF)
	self:Tag(self.Status, '[afkdnd][difficulty][smartlevel] ')
	
	-- mouseover highlight
	local mov = self.Health:CreateTexture(nil, "OVERLAY")
	mov:SetAllPoints(self.Health)
	mov:SetTexture("Interface\\AddOns\\dMedia\\highlight")
	mov:SetVertexColor(1, 1, 1, 0.3)
	mov:SetTexCoord(0,1,1,0)
	mov:SetBlendMode("ADD")
	mov:Hide()
	self.Mouseover = mov
	
	-- debuff highlight
	local dHlight = self.Health:CreateTexture(nil, "OVERLAY")
	dHlight:SetSize(64,16)
	dHlight:SetPoint("TOPLEFT", self.Health, -4, 4)
	dHlight:SetTexture("Interface\\AddOns\\dMedia\\dHlight")
	dHlight:Hide()
	self.dHlight = dHlight	

	local dHlight2 = self.Health:CreateTexture(nil, "OVERLAY")
	dHlight2:SetSize(64,16)
	dHlight2:SetPoint("TOPRIGHT", self.Health, 4, 4)
	dHlight2:SetTexture("Interface\\AddOns\\dMedia\\dHlight")
	dHlight2:SetTexCoord(1,0,0,1)
	dHlight2:Hide()
	self.dHlight2 = dHlight2	
	
	-- threat highlight
	local Thrt = self.Health:CreateTexture(nil, "OVERLAY")
	Thrt:SetPoint("TOPLEFT", self.Health, 1/5, 3)
	Thrt:SetPoint("TOPRIGHT", self.Health, -1/5, 3)
	Thrt:SetHeight(2)
	Thrt:SetTexture("Interface\\AddOns\\dMedia\\threat")
	Thrt:Hide()
	self.ThreatHlt = Thrt

	-- update threat
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", updateThreatStatus)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", updateThreatStatus)
end

local function CreateSpark(f) --施法条闪光材质
	if f.spark == nil then
		local spark = f:CreateTexture(nil, "OVERLAY")
		spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
		spark:SetBlendMode("ADD")
		spark:SetAlpha(1)
		spark:SetPoint("TOPLEFT", f:GetStatusBarTexture(), "TOPRIGHT", -5, 15)
		spark:SetPoint("BOTTOMRIGHT", f:GetStatusBarTexture(), "BOTTOMRIGHT", 5, -15)
		f.spark = spark
	end
end
----------------------
-- object functions --
----------------------

-- castbar
local createCastbar = function(self, unit)
	local cb = CreateFrame("StatusBar", nil, self)
	cb:SetStatusBarTexture(cfg.CBtex)
	cb:GetStatusBarTexture():SetHorizTile(true)
	cb:SetFrameLevel(4)	
	
	self.Castbar = cb

	cb.Text = cb:CreateFontString(nil, 'ARTWORK')
	cb.Text:SetJustifyH("LEFT")		
	cb.Text:SetFont(cfg.NameFont, cfg.CastFS, cfg.FontF)
	cb.Text:SetTextColor(unpack(cfg.sndcolor)) 

	cb.Time = cb:CreateFontString(nil, 'ARTWORK')
	cb.Time:SetFont(cfg.NumbFont, cfg.NumbFS, cfg.fontFNum)
	cb.Time:SetJustifyH('RIGHT')		
	cb.Time:SetTextColor(unpack(cfg.sndcolor))	

	cb.Time2 = cb:CreateFontString(nil, 'ARTWORK')
	cb.Time2:SetFont(cfg.NumbFont, cfg.NumbFS, cfg.fontFNum)
	cb.Time2:SetJustifyH('RIGHT')		
	cb.Time2:SetTextColor(unpack(cfg.sndcolor))
	
	cb.CustomTimeText = CustomTimeText	
	
	if cfg.useSpellIcon then 	
		cb.Icon = cb:CreateTexture(nil, 'OVERLAY')
		cb.Icon:SetSize(28,28)
		cb.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
		
		cb.IconGlow = CreateFrame("Frame", nil, cb)
		cb.IconGlow:SetPoint("TOPLEFT", cb.Icon, "TOPLEFT", -1, 1)
		cb.IconGlow:SetPoint("BOTTOMRIGHT", cb.Icon, "BOTTOMRIGHT", 1, -1)
		cb.IconGlow:SetBackdrop(backdrop2)
		cb.IconGlow:SetBackdropColor(unpack(cfg.brdcolor))
		cb.IconGlow:SetFrameLevel(0)
	end

	CreateSpark(cb)
	--cb.Spark = cb:CreateTexture(nil, 'OVERLAY')
	--cb.Spark:SetBlendMode('ADD')	
	--cb.Spark:SetSize(6, cfg.heightP*2.5)
	
	self:RegisterEvent('UNIT_NAME_UPDATE', PostCastStopUpdate)
	table.insert(self.__elements, PostCastStopUpdate)

	cb.PostCastStart = PostCastStart	
	cb.PostChannelStart = PostCastStart
	cb.PostCastStop = PostCastStop
	cb.PostChannelStop = PostCastStop	
end

-- buffs
local createBuffs = function(self)
	local Buffs = CreateFrame("Frame", nil, self)
	Buffs.num = 40
	Buffs.spacing = 2
	Buffs.size = cfg.buSize
	
	self.Buffs = Buffs
	
	Buffs.PostCreateIcon = PostCreateIcon
	Buffs.PostUpdateIcon = PostUpdateIcon		
end

-- debuffs
local createDebuffs = function(self)
	local Debuffs = CreateFrame("Frame", nil, self)
	Debuffs.spacing = 2
	Debuffs.size = cfg.buSize
	
	self.Debuffs = Debuffs
	
	Debuffs.PostCreateIcon = PostCreateIcon
	Debuffs.PostUpdateIcon = PostUpdateIcon
end

-- phase icon
local createPhaseIcon = function(self)
	local pIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	pIcon:SetSize(18, 18)
	self.PhaseIcon = pIcon
end

-- quest icon
local createQuestIcon = function(self)
	local qIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	qIcon:SetSize(18, 18)
	self.QuestIcon = qIcon
end

-- raid icons
local createRaidIcon = function(self)
	RI = self.Health:CreateTexture(nil, "OVERLAY")
	RI:SetTexture("Interface\\AddOns\\dMedia\\raidicons.blp")
	RI:SetSize(20, 20)
	self.RaidIcon = RI
end
		
-- class (healer) specific tags
local classTags = function(self)		
		local PriestTags = "[NivPWS] [NivRenew] [NivPoM] [NivGS] [NivFW]"
		local PaladinTags = "[NivBoL]"
		local DruidTags = "[NivRej] [NivReg] [NivLB] [NivWG] [NivInn]"
		local ShamanTags = "[NivES] [NivRipT] [NivErLiv]"	
	
		self.Text = self.Health:CreateFontString(nil, "ARTWORK")
		self.Text:SetFont(cfg.NumbFont, cfg.RaidFS, cfg.fontFNum)
		self.Text:SetTextColor(unpack(cfg.sndcolor))	
		--self.Text:SetPoint("TOPLEFT", self.Health, "TOPLEFT", cfg.widthR*0.3, 2)			
		self.Text:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 1, 2)			
		self.Text:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -1, 0)	
		
		if playerClass == "PRIEST" then			
			self:Tag(self.Text, PriestTags)
		elseif playerClass == "PALADIN" then			
			self:Tag(self.Text, PaladinTags)
		elseif playerClass == "DRUID" then			
			self:Tag(self.Text, DruidTags)
		elseif playerClass == "SHAMAN" then
			self:Tag(self.Text, ShamanTags) 			
		else
			self:Tag(self.Text, " ")
		end
end			
	
-- plugin support
local SpellRange = function(self)
	if IsAddOnLoaded("oUF_SpellRange") then	
		self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = cfg.FadeOutAlpha}	
	end
end

local CombatFeedback = function(self)
	if IsAddOnLoaded("oUF_CombatFeedback") then
		local cbft = self.Health:CreateFontString(nil, "ARTWORK")
		cbft:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
		self.CombatFeedbackText = cbft	
		self.CombatFeedbackText:SetFont(cfg.NumbFont, cfg.NumbFS, cfg.fontFNum)
	end
end
	
local BarFader = function(self)
	if IsAddOnLoaded("oUF_BarFader") then		
		self.BarFade = true
		self.BarFaderMinAlpha = cfg.BarFadeAlpha	
	end
end
	
local HealComm4 = function(self)	
	if IsAddOnLoaded("oUF_HealComm4") then	
		HCB = CreateFrame('StatusBar', nil, self.Health)
		HCB:SetStatusBarTexture(cfg.HPtex)
		HCB:SetStatusBarColor(0, 0.8, 0, 0.5)
		HCB:SetPoint('LEFT', self.Health, 'LEFT')
		self.HealCommBar = HCB
		self.allowHealCommOverflow = false
		self.HealCommOthersOnly = true
	end
end

local WeaponEnchant = function(self)
	if IsAddOnLoaded("oUF_WeaponEnchant") then
		self.Enchant = CreateFrame("Frame", nil, self)
		self.Enchant:SetSize(cfg.WeapEnchantIconSize * 2, cfg.WeapEnchantIconSize)
		self.Enchant:SetPoint("TOPRIGHT", self, 0, 0)
		self.Enchant.size = cfg.WeapEnchantIconSize
		self.Enchant.spacing = 2
		self.Enchant.initialAnchor = "TOPRIGHT"
		self.Enchant["growth-x"] = "LEFT"
		self.Enchant:SetFrameLevel(10)
		self.PostCreateEnchantIcon = WeapEnchantIcon
		self.PostUpdateEnchantIcons = CreateEnchantTimer
	end
end

local TotemBar = function(self)
	self.TotemBar = {}
	self.TotemBar.Destroy = true
	for i = 1, 4 do
		self.TotemBar[i] = CreateFrame("StatusBar", nil, self)
		self.TotemBar[i]:SetHeight(cfg.heightCB)
		self.TotemBar[i]:SetWidth(((cfg.widthP - 9)/4))
	if (i == 1) then
		self.TotemBar[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
	else
		self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 3, 0)
	end
		self.TotemBar[i]:SetStatusBarTexture(cfg.Itex)
		self.TotemBar[i]:SetMinMaxValues(0, 1)		
		
		self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
		self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
		self.TotemBar[i].bg:SetTexture(cfg.Itex)
		self.TotemBar[i].bg.multiplier = 0.3
		self.TotemBar[i].bg:SetAlpha(1.0)

		self.TotemBarBorder = CreateFrame("Frame", nil, self)
		self.TotemBarBorder:SetPoint("TOPLEFT", self.TotemBar[i], "TOPLEFT", -1, 1)
		self.TotemBarBorder:SetPoint("BOTTOMRIGHT", self.TotemBar[i], "BOTTOMRIGHT", 1, -1)					
		self.TotemBarBorder:SetBackdrop(backdrop2)
		self.TotemBarBorder:SetBackdropColor(unpack(cfg.brdcolor))
		self.TotemBarBorder:SetFrameLevel(0)	
	end
end

function UpdateHarmony(self)
    local maxChi = UnitPowerMax("player", SPELL_POWER_CHI)

	for i = 1, 6 do
        if i > maxChi then
            self[i]:Hide()
        else
            self[i]:SetWidth((cfg.widthP - (maxChi - 1)*3)/maxChi)
        end
    end
end

function UpdateShadowOrbs(self)
	local totalOrbs = IsSpellKnown(SHADOW_ORB_MINOR_TALENT_ID) and 5 or 3
	for i = 1,totalOrbs do
		self[i]:SetWidth((cfg.widthP - (totalOrbs - 1)*3)/totalOrbs)
    end
end

function UpdateHolyPower(self)
    local maxHolyPower = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
    if maxHolyPower < self.number then
        for i = 1, 3 do
            self[i]:SetWidth((cfg.widthP - 6)/3)
        end
        self[4]:Hide()
        self[5]:Hide()
        self.number = maxHolyPower
    elseif maxHolyPower > self.number then
        for i = 1, 3 do
            self[i]:SetWidth((cfg.widthP - 12)/5)
        end
        self[4]:Show()
        self[5]:Show()
        self.number = maxHolyPower
    end
end

function UpdateShardBar(self)
    local maxBars = self.number
    local frame = self:GetParent()

    for i = 1, 4 do
        if i > maxBars then
            self[i]:Hide()
        else
            self[i]:SetWidth((cfg.widthP - (maxBars - 1)*3)/maxBars)
        end
    end
end
-------------------------
-- unit specific stuff --
-------------------------
local UnitSpecific = {
	--玩家框体
	player = function(self, ...)
		Shared(self, ...)
		MirrorBars()
		--CreatExpBar(self)--- --经验条
		
		if cfg.useCastbar then	
			createCastbar(self)	

			-- disable blizzards pet castbar
			PetCastingBarFrame:UnregisterAllEvents()
			PetCastingBarFrame.Show = function() end
			PetCastingBarFrame:Hide()
			
			self.Castbar:SetAllPoints(self.Health)
			self.Castbar.Text:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -2)	
			self.Castbar.Time:SetPoint("BOTTOMLEFT", self.Castbar.Text, "BOTTOMRIGHT", 2, 4) --施法条时间位置
			self.Castbar.Time2:SetPoint("BOTTOMLEFT", self.Castbar.Time, "BOTTOMRIGHT", 0, 0)

			--施法条延迟
			if cfg.Castbarsafe then
				self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "ARTWORK")
				self.Castbar.SafeZone:SetTexture(cfg.CBtex)
				if cfg.moveCastbar then
					self.Castbar.SafeZone:SetVertexColor(0.85,0.10,0.10)

				else
					self.Castbar.SafeZone:SetVertexColor(0.85,0.10,0.10,0.80)

				end
				self.Castbar.SafeZone:SetPoint("TOPRIGHT")
				self.Castbar.SafeZone:SetPoint("BOTTOMRIGHT")
			end			
				
			if cfg.useSpellIcon then 
				if not cfg.PlayerRightSideSpellIcon then
					self.Castbar.Icon:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", -4, 0)
				else
					self.Castbar.Icon:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", 4, 0)
				end
			end
		end

		self.Health.value:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -2)			
		self.Power.value:SetPoint("TOPRIGHT", self.Health.value, "BOTTOMRIGHT", 0, -2)			
		self.Health.PERvalue:SetPoint("RIGHT",self.Health.value,"LEFT",-6,0)
		
		if playerClass == "DRUID" then --小D的法力显示，在名字的位置
			self.Name:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -2)
			self:Tag(self.Name, '[druidPower]')
		--else self.Name:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -2)
		end
		
		self.Health:SetHeight(cfg.heightP)
		self.Health:SetWidth(cfg.widthP)	
		self.Power:SetWidth(cfg.widthP)	
		
		--玩家debuff
		if cfg.showDebuff then
		createDebuffs(self)
		self.Debuffs:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 12)
		self.Debuffs.initialAnchor = "BOTTOMRIGHT"
		self.Debuffs["growth-x"] = "LEFT"		
		self.Debuffs["growth-y"] = "UP"	
		self.Debuffs.num = 24
		self.Debuffs:SetSize(self.Debuffs.size*13, self.Debuffs.size*2)		
		end		

		-- Icons
		local Ihld = CreateFrame("Frame", nil, self)
		Ihld:SetAllPoints(self.Health)
		Ihld:SetFrameLevel(6)
		--团队图标		
		createRaidIcon(self)
		self.RaidIcon:SetPoint("RIGHT", self.Health, "RIGHT", 20, 0)
		self.RaidIcon:SetParent(Ihld)
		--休息图标		
		RIc = Ihld:CreateTexture(nil, 'OVERLAY')
		RIc:SetSize(18, 18)	
		RIc:SetPoint("TOPLEFT", self.Health, 4, 8)	
		self.Resting = RIc
		self.Resting:SetTexture("Interface\\AddOns\\dmedia\\resting") --休息图标
		--战斗图标		
		CIc = Ihld:CreateTexture(nil, 'OVERLAY')
		CIc:SetSize(16, 16)			
		CIc:SetPoint("LEFT", RIc, "RIGHT", 4, 0)	
		self.Combat = CIc			
		self.Combat:SetTexture("Interface\\AddOns\\dmedia\\combat") --战斗图标
		--队长图标		
		LIc = Ihld:CreateTexture(nil, "OVERLAY")
		LIc:SetSize(14, 14)			
		LIc:SetPoint("LEFT", CIc, "RIGHT", 4, 0)
		self.Leader = LIc
		--拾取权图标		
		MLIc = Ihld:CreateTexture(nil, 'OVERLAY')
		MLIc:SetSize(14, 14)	
		MLIc:SetPoint("LEFT", LIc, "RIGHT", 4, 0)
		self.MasterLooter = MLIc	
		
		-- plugins
		CombatFeedback(self)
		BarFader(self)
		
		-- TotemBar
		if playerClass == "SHAMAN" then		
			TotemBar(self)
		end
		
		--DK符文
		if playerClass =="DEATHKNIGHT" then	
			self.Runes = CreateFrame("Frame", nil, self)
			for i = 1, 6 do
				self.Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
				self.Runes[i]:SetHeight(cfg.heightCB)
				self.Runes[i]:SetWidth((cfg.widthP - 15) / 6)
				if (i == 1) then
					self.Runes[i]:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
				else
					self.Runes[i]:SetPoint("TOPLEFT", self.Runes[i-1], "TOPRIGHT", 3, 0)
				end
				self.Runes[i]:SetStatusBarTexture(cfg.HPtex)

				self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
				self.Runes[i].bg:SetPoint("TOPLEFT", self.Runes[i], "TOPLEFT", -0, 0)
				self.Runes[i].bg:SetPoint("BOTTOMRIGHT", self.Runes[i], "BOTTOMRIGHT", 0, -0)				
				self.Runes[i].bg:SetTexture(cfg.Itex)
				self.Runes[i].bg.multiplier = 0.34
				
				self.RunesBorder = CreateFrame("Frame", nil, self)
				self.RunesBorder:SetPoint("TOPLEFT", self.Runes[i], "TOPLEFT", -1, 1)
				self.RunesBorder:SetPoint("BOTTOMRIGHT", self.Runes[i], "BOTTOMRIGHT", 1, -1)					
				self.RunesBorder:SetBackdrop(backdrop2)
				self.RunesBorder:SetBackdropColor(unpack(cfg.brdcolor))
				self.RunesBorder:SetFrameLevel(0)	
			end
		end		
		
		--鸟D日月能条
		--[[if playerClass == 'DRUID' then
			local eclipseBar = CreateFrame("Frame","Slim_EclipseBar",self)
			eclipseBar:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
			eclipseBar:SetSize(cfg.widthP, cfg.heightCB)
			CreateBorder_Small(eclipseBar)
			
			local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
			lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
			lunarBar:SetSize(cfg.widthP, cfg.heightCB)
			lunarBar:SetStatusBarTexture(cfg.HPtex)
			lunarBar:SetStatusBarColor(0.34, 0.1, 0.86)
			eclipseBar.LunarBar = lunarBar
			
			local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
			solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
			solarBar:SetSize(cfg.widthP, cfg.heightCB)
			solarBar:SetStatusBarTexture(cfg.HPtex)
			solarBar:SetStatusBarColor(0.95, 0.73, 0.15)
			eclipseBar.SolarBar = solarBar
			
			local eclipseBarText = solarBar:CreateFontString(nil, 'OVERLAY')
			eclipseBarText:SetPoint('CENTER', eclipseBar, 'CENTER', 0, 5)
			eclipseBarText:SetFont(cfg.NumbFont, cfg.NumbFS*1.3, cfg.fontFNum)
			self:Tag(eclipseBarText, '[pereclipse]%')
			
			self.EclipseBar = eclipseBar
		end
	]]
		--PAL 骑士圣能
		if playerClass == 'PALADIN' then
			local holyPower = CreateFrame("Frame","Slim_HolyPowerBar",self)
			holyPower:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
			holyPower:SetSize(cfg.widthP,cfg.heightCB)
			local count = 5
			
			for i = 1,count do
				holyPower[i] =CreateFrame("StatusBar", "Slim_HolyPower"..i, holyPower)
				holyPower[i]:SetHeight(cfg.heightCB)
				holyPower[i]:SetWidth((cfg.widthP - (count - 1)*3)/count)
				holyPower[i]:SetStatusBarTexture(blankTex)
				holyPower[i]:SetStatusBarColor(228/255,225/255,16/255)
				if i == 1 then
					holyPower[i]:SetPoint("TOPLEFT",holyPower)
				else
					holyPower[i]:SetPoint("LEFT",holyPower[i-1],"RIGHT",3,0)
				end
				
				CreateBorder_Small(holyPower[i])
			end

			holyPower.number = 5
			holyPower.PostUpdate = UpdateHolyPower
			self.HolyPower = holyPower
		end
		
		--WL
		if playerClass == "WARLOCK" then
			local wb = CreateFrame("Frame","Slim_WarlockShardBar",self)
			wb:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
			wb:SetSize(cfg.widthP,cfg.heightCB)
			local count = 4

			for i = 1,count do
				wb[i] = CreateFrame("StatusBar","Slim_WarloclSpec"..i,wb)
				wb[i]:SetHeight(cfg.heightCB)
				wb[i]:SetWidth((cfg.widthP - (count - 1)*3)/count)
				wb[i]:SetStatusBarTexture(blankTex)
				local color = oUF.colors.class[playerClass]
				wb[i]:SetStatusBarColor(unpack(color))

				if i == 1 then
					wb[i]:SetPoint("LEFT", wb, "LEFT", 0, 0)
				else
					wb[i]:SetPoint("LEFT", wb[i-1], "RIGHT", 3, 0)
				end
				
				CreateBorder_Small(wb[i])
				wb[i].border:SetBackdropColor(cfg.hpTransMcolor[1],cfg.hpTransMcolor[2],cfg.hpTransMcolor[3],cfg.hpTransMalpha)
			end

			wb.PostUpdate = UpdateShardBar
			self.ShardBar = wb
		end
		



-- combo point 连击点
		if playerClass =="DRUID" or playerClass =="ROGUE" then
			local cps = CreateFrame("Frame","Slim_CPoints",self)
			cps:SetSize(cfg.widthP,cfg.heightCB)
			cps:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
			cps:SetFrameLevel(5)
			
			local cp={}
			cp.unit = "player"
			for i = 1,5 do
				cp[i] = CreateFrame("StatusBar","Slim_CPoint"..i,cps)
				cp[i]:SetSize((cfg.widthP-12)/5 ,cfg.heightCB )
				cp[i]:SetStatusBarTexture(cfg.Itex)
				if i == 1 then
					cp[i]:SetPoint("TOPLEFT",cps)
				else
					cp[i]:SetPoint("LEFT",cp[i-1],"RIGHT",3,0)
				end
				CreateBorder_Small(cp[i])
			end
			cp[1]:SetStatusBarColor(0,1,1)
			cp[2]:SetStatusBarColor(0.5,0.5,1)
			cp[3]:SetStatusBarColor(1,0.5,0.5)
			cp[4]:SetStatusBarColor(1,0.5,0)
			cp[5]:SetStatusBarColor(1,1,0)
			self.CPoints = cp
			
			--self.Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 8+cfg.heightCB)
		end

		--PR
		if playerClass == 'PRIEST' then
			local pb = CreateFrame("Frame","Slim_ShadowOrbsBar",self)
			pb:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
			pb:SetSize(cfg.widthP,cfg.heightCB)
			local count = 5
			
			for i = 1,count do
				pb[i] = CreateFrame("StatusBar","Slim_ShadowOrb"..i,pb)
				pb[i]:SetHeight(cfg.heightCB)
				pb[i]:SetWidth((cfg.widthP  - (count - 1)*3)/count)
				pb[i]:SetStatusBarTexture(blankTex)
				pb[i]:SetStatusBarColor(150/255, 130/255, 188/255)
				
				if i == 1 then
					pb[i]:SetPoint("LEFT", pb, "LEFT", 0, 0)
				else
					pb[i]:SetPoint("LEFT", pb[i-1], "RIGHT", 3, 0)
				end
				
				CreateBorder_Small(pb[i])
			end
			
			pb.PostUpdate = UpdateShadowOrbs
			self.ShadowOrbs = pb
		end
		
		--Monk武僧
		if playerClass == 'MONK' then
			local hb = CreateFrame("Frame","Slim_HarmonyBar",self)
			hb:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
			hb:SetSize(cfg.widthP,cfg.heightCB)
			local count = 6

			for i = 1,count do
				hb[i] =CreateFrame("StatusBar", "Slim_Harmony"..i, hb)
				hb[i]:SetHeight(cfg.heightCB)
				hb[i]:SetWidth((cfg.widthP  - (count - 1)*3)/count)
				hb[i]:SetStatusBarTexture(blankTex)

				local color = oUF.colors.class[playerClass]
				hb[i]:SetStatusBarColor(unpack(color))
				if i == 1 then
					hb[i]:SetPoint("TOPLEFT",hb)
				else
					hb[i]:SetPoint("LEFT",hb[i-1],"RIGHT",3,0)
				end
				
				CreateBorder_Small(hb[i])
			end
			hb.PostUpdate = UpdateHarmony
			self.Harmony = hb
		end			
		
		-- update debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)
		
		--头像横竖装饰线条
		--[[local TFrame = CreateFrame("Frame", nil, self)
		TFrame:SetPoint("TOPLEFT", self, "TOPLEFT", -4, 4)
		TFrame:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT", 4, -4)
		TFrame:SetFrameLevel(0)	
	
		TFrame.bg = TFrame:CreateTexture(nil, "BACKGROUND")
		TFrame.bg:SetPoint("TOPLEFT", TFrame, 0, 0)
		TFrame.bg:SetPoint("TOPRIGHT", TFrame, 0, 0)
		TFrame.bg:SetHeight(1)
		TFrame.bg:SetTexture(blankTex)
		TFrame.bg:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 1, 0, 0, 0, 0.1)	-- HORIZONTAL | VERTICAL
	
		TFrame.bg2 = TFrame:CreateTexture(nil, "BACKGROUND")
		TFrame.bg2:SetPoint("TOPLEFT", TFrame, 0, -1)
		TFrame.bg2:SetPoint("BOTTOMLEFT", TFrame, 0, 0)
		TFrame.bg2:SetWidth(1)
		TFrame.bg2:SetTexture(blankTex)
		TFrame.bg2:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.1, 0, 0, 0, 1.0)	-- HORIZONTAL | VERTICAL
	]]
	
		self.dHlight:SetSize(128,16)
		self.dHlight2:SetSize(128,16)		
		self.dHlight:SetTexture("Interface\\AddOns\\dMedia\\dHlightL")	
		self.dHlight2:SetTexture("Interface\\AddOns\\dMedia\\dHlightL")
		
		-- xp/rep 经验/声望
		if cfg.showXpRep then
			local XpRepHld = CreateFrame("Frame", nil, self)
			XpRepHld:SetAllPoints(self.Health)
			XpRepHld:SetFrameLevel(10)
		
			xprep = XpRepHld:CreateFontString(nil, "OVERLAY")
			xprep:SetFont(cfg.NameFont, cfg.NameFS, cfg.FontF)
			xprep:SetTextColor(unpack(cfg.sndcolor)) 			
			xprep:SetAlpha(0)
			xprep:SetPoint("CENTER", self.Health)
			self:Tag(xprep, '[SlimExp] [SlimRep]')
			self.xprep = xprep

			local xprepDummy = XpRepHld:CreateFontString(nil, "OVERLAY")
			xprepDummy:SetFont(cfg.NameFont, cfg.NameFS, cfg.FontF)
			xprepDummy:SetTextColor(unpack(cfg.sndcolor)) 
			xprepDummy:SetPoint("CENTER", self.Health)
			xprepDummy:SetAlpha(0)
			xprepDummy:Hide()
		
			local animXPFadeIn = xprepDummy:CreateAnimationGroup()
			local delayXP = animXPFadeIn:CreateAnimation("Alpha")
			delayXP:SetChange(0)
			delayXP:SetDuration(cfg.delay)
			delayXP:SetOrder(1)
			local alphaInXP = animXPFadeIn:CreateAnimation("Alpha")
			alphaInXP:SetChange(1)
			alphaInXP:SetSmoothing("OUT")
			alphaInXP:SetDuration(cfg.delay)
			alphaInXP:SetOrder(2)
		
			animXPFadeIn:SetScript("OnFinished", function()
				xprep:SetAlpha(1)
				xprepDummy:Hide()
			end)
			
			self:HookScript("OnEnter", function(_, motion)
			if motion then
				xprepDummy:SetText(self.xprep:GetText())
				xprepDummy:Show()
				animXPFadeIn:Play()
			end
			end)	
		
			self:HookScript("OnLeave", function()
			if animXPFadeIn:IsPlaying() then animXPFadeIn:Stop() end
				xprepDummy:Hide()
				xprep:SetAlpha(0)
			end)
		end		
	
		self:SetSize(cfg.widthP, cfg.heightP + cfg.NumbFS + cfg.PPyOffset)
	end,
	
	WpnEnch = function(self, ...)
		WeaponEnchant(self)
		BarFader(self)
	
		self:SetSize(cfg.WeapEnchantIconSize*2, cfg.WeapEnchantIconSize)
	end,
	
	--目标框体
	target = function(self, ...)
		Shared(self, ...)
		self.Health:SetHeight(cfg.heightT)
		self.Health:SetWidth(cfg.widthT)	
		self.Power:SetWidth(cfg.widthT)	
		
		if cfg.useCastbar then	
			createCastbar(self)			
			self.Castbar:SetAllPoints(self.Health)
			self.Castbar.Text:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -3)--目标施法条法术名称位置	
			self.Castbar.Time2:SetPoint("BOTTOMRIGHT", self.Castbar.Text, "BOTTOMLEFT", -5, 3)
			self.Castbar.Time:SetPoint("BOTTOMRIGHT", self.Castbar.Time2, "BOTTOMLEFT", 0, 0)
			
			if cfg.useSpellIcon then 
				if not cfg.TargetRightSideSpellIcon then
					self.Castbar.Icon:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", -4, 0)
				else
					self.Castbar.Icon:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", 4, 0)
				end
			end
		end

		self.Health.value:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -2)			
		self.Power.value:SetPoint("TOPLEFT", self.Health.value, "BOTTOMLEFT", 0, -2)
		self.Health.PERvalue:SetPoint("LEFT",self.Health.value,"RIGHT",6,0)
		self.Name:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -2)		
		self.Status:SetPoint("TOPRIGHT", self.Name, "TOPLEFT", 0, 0)		

		createBuffs(self)	
		self.Buffs:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
		self.Buffs.initialAnchor = "BOTTOMLEFT"	
		self.Buffs["growth-x"] = "RIGHT"		
		self.Buffs.num = 12--目标头像buff数量
		self.Buffs:SetSize(self.Buffs.size*13, self.Buffs.size)
		
		createDebuffs(self)
		self.Debuffs:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 1, self.Buffs.size*cfg.buHeightMulti+16)
		self.Debuffs.initialAnchor = "BOTTOMLEFT"
		self.Debuffs["growth-x"] = "RIGHT"		
		self.Debuffs["growth-y"] = "UP"	
		self.Debuffs.num = 24--目标头像debuff数量
		self.Debuffs:SetSize(self.Debuffs.size*13, self.Debuffs.size*2)		
		
		if cfg.onlyShowPlayerBuffs then
			self.Buffs.onlyShowPlayer = true
		end	
		
		if cfg.onlyShowPlayerDebuffs then
			self.Debuffs.onlyShowPlayer = true
		end	
		
		
		
		-- plugins
		SpellRange(self)
		CombatFeedback(self)
		
		-- Icons
		local Ihld = CreateFrame("Frame", nil, self)
		Ihld:SetAllPoints(self.Health)
		Ihld:SetFrameLevel(6)

		createRaidIcon(self)
		createQuestIcon(self)
		createPhaseIcon(self)		
		self.RaidIcon:SetPoint("LEFT", self.Health, "LEFT", -20, 0)--团队图标		
		self.QuestIcon:SetPoint("LEFT", self.RaidIcon, "RIGHT", 25, 0)--任务图标	
		self.PhaseIcon:SetPoint("LEFT", self.QuestIcon, "RIGHT", 4, 0)
		self.RaidIcon:SetParent(Ihld)		
		self.QuestIcon:SetParent(Ihld)		
		self.PhaseIcon:SetParent(Ihld)	
		
		-- update debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)
		--目标头像的横竖装饰线条
		--[[local TTFrame = CreateFrame("Frame", nil, self)
		TTFrame:SetPoint("TOPLEFT", self, "TOPLEFT", -4, 4)
		TTFrame:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT", 4, -4)
		TTFrame:SetFrameLevel(0)
		
		TTFrame.bg = TTFrame:CreateTexture(nil, "BACKGROUND")
		TTFrame.bg:SetPoint("TOPLEFT", TTFrame, 0, 0)
		TTFrame.bg:SetPoint("TOPRIGHT", TTFrame, 0, 0)
		TTFrame.bg:SetHeight(1)
		TTFrame.bg:SetTexture(blankTex)
		TTFrame.bg:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.2, 0, 0, 0, 1.0)	-- HORIZONTAL | VERTICAL
	
		TTFrame.bg2 = TTFrame:CreateTexture(nil, "BACKGROUND")
		TTFrame.bg2:SetPoint("TOPRIGHT", TTFrame, 0, -1)
		TTFrame.bg2:SetPoint("BOTTOMRIGHT", TTFrame, 0, 0)
		TTFrame.bg2:SetWidth(1)
		TTFrame.bg2:SetTexture(blankTex)
		TTFrame.bg2:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.1, 0, 0, 0, 1.0)	-- HORIZONTAL | VERTICAL
	]]
		
		self.dHlight:SetSize(128,16)
		self.dHlight2:SetSize(128,16)			
		self.dHlight:SetTexture("Interface\\AddOns\\dMedia\\dHlightL")	
		self.dHlight2:SetTexture("Interface\\AddOns\\dMedia\\dHlightL")
		
		self:SetSize(cfg.widthT, cfg.heightT + cfg.NumbFS + cfg.PPyOffset)
	end,
	
	--焦点框体
	focus = function(self, ...)
		Shared(self, ...)
		self.Health:SetHeight(cfg.heightF)
		self.Health:SetWidth(cfg.widthF)	
		self.Power:SetWidth(cfg.widthF)	
		
		if cfg.useCastbar then	
			createCastbar(self)			
			self.Castbar:SetAllPoints(self.Health)
			self.Castbar.Text:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -2)--焦点施法条法术名称位置	
			self.Castbar.Time2:SetPoint("BOTTOMRIGHT", self.Castbar.Text, "BOTTOMLEFT", -5, 0)
			self.Castbar.Time:SetPoint("BOTTOMRIGHT", self.Castbar.Time2, "BOTTOMLEFT", 0, 0)
			
			if cfg.useSpellIcon then 
				if not cfg.FocusRightSideSpellIcon then
					self.Castbar.Icon:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", -4, 0)
				else
					self.Castbar.Icon:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", 4, 0)
				end
			end
		end
		
		self.Health.value:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -2)			
--?
		self.Power.value:SetPoint("TOPLEFT", self.Health.value, "BOTTOMLEFT", 0, -2)			
		self.Name:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -2)		
		self.Status:SetPoint("TOPRIGHT", self.Name, "TOPLEFT", 0, 0)
		
		createBuffs(self)	
		self.Buffs:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 6)
		self.Buffs.initialAnchor = "BOTTOMLEFT"	
		self.Buffs["growth-x"] = "RIGHT"		
		self.Buffs.num = 12
		self.Buffs:SetSize(self.Buffs.size*13, self.Buffs.size)
		
		createDebuffs(self)
		self.Debuffs:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, self.Debuffs.size*cfg.buHeightMulti+12)
		self.Debuffs.initialAnchor = "BOTTOMLEFT"
		self.Debuffs["growth-x"] = "RIGHT"		
		self.Debuffs["growth-y"] = "UP"	
		self.Debuffs.num = 24
		self.Debuffs:SetSize(self.Debuffs.size*13, self.Debuffs.size*2)					
		
		if cfg.onlyShowPlayerBuffs then
			self.Buffs.onlyShowPlayer = true
		end	
		
		if cfg.onlyShowPlayerDebuffs then
			self.Debuffs.onlyShowPlayer = true
		end	
		
		-- plugins
		SpellRange(self)
		CombatFeedback(self)
		
		-- Icons
		local Ihld = CreateFrame("Frame", nil, self)
		Ihld:SetAllPoints(self.Health)
		Ihld:SetFrameLevel(6)
	
		createRaidIcon(self)
		createQuestIcon(self)
		self.RaidIcon:SetPoint("LEFT", self.Health, "LEFT", -20, 0)--团队图标		
		self.QuestIcon:SetPoint("LEFT", self.RaidIcon, "RIGHT", 25, 0)--任务图标		
		self.RaidIcon:SetParent(Ihld)		
		self.QuestIcon:SetParent(Ihld)	
		
		-- update and debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)
		
		self:SetSize(cfg.widthF, cfg.heightF + cfg.NumbFS + cfg.PPyOffset)
	end,	
	--宠物框体
	pet = function(self, ...)
		Shared(self, ...)
		
		self.Health:SetHeight(cfg.heightS)
		self.Health:SetWidth(cfg.widthS)			
		self.Power:SetWidth(cfg.widthS)
		self.Name:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
		self:Tag(self.Name, '[raidcolor][shortname]')		
		
		self.Power.colorPower = true			
		
		-- plugins
		SpellRange(self)
		BarFader(self)		

		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)	
		
		-- update and debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)
		
		self:SetSize(cfg.widthS, cfg.heightS + cfg.NumbFS + cfg.PPyOffset)
	end,
	
	targettarget = function(self, ...)
		Shared(self, ...)	

		self.Health:SetHeight(cfg.heightS)
		self.Health:SetWidth(cfg.widthS)			
		self.Power:SetWidth(cfg.widthS)	
		self.Name:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
		self:Tag(self.Name, '[raidcolor][shortname]')
		
		-- plugins
		SpellRange(self)
		
		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)		
		
		-- update and debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)		
		
		self:SetSize(cfg.widthS, cfg.heightS + cfg.NumbFS + cfg.PPyOffset)
	end,

	--目标的目标的目标框体
	targettargettarget = function(self, ...)
	if cfg.totot == true then
		Shared(self, ...)	
		
		self.Health:SetHeight(cfg.heightS)
		self.Health:SetWidth(cfg.widthS)			
		self.Power:SetWidth(cfg.widthS)	
		self.Name:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
		self:Tag(self.Name, '[raidcolor][shortname]')
		
		-- plugins
		SpellRange(self)
		
		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)		
		
		-- update and debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)		
		
		self:SetSize(cfg.widthS, cfg.heightS + cfg.NumbFS + cfg.PPyOffset)
	    end
	end,
	--焦点目标框体	
	focustarget = function(self, ...)
		Shared(self, ...)
		
		self.Health:SetHeight(cfg.heightS)
		self.Health:SetWidth(cfg.widthS)			
		self.Power:SetWidth(cfg.widthS)		
		self.Name:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
		self:Tag(self.Name, '[raidcolor][shortname]')
		
		-- plugins
		SpellRange(self)
		
		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)	
		
		-- update and debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)		
		
		self:SetSize(cfg.widthS, cfg.heightS + cfg.NumbFS + cfg.PPyOffset)
	end,
	--BOSS框体
	boss = function(self, ...)
		Shared(self, ...)
		
		self.Health:SetHeight(cfg.heightM)
		self.Health:SetWidth(cfg.widthM)				
		self.Power:SetWidth(cfg.widthM) 
            --self.Power:Hide() BOSS能量显示
		self.Name:SetPoint("TOPLEFT", self.Health, 0, cfg.NameFS/2)
		self:Tag(self.Name, '[afkdnd][raidcolor][abbrevname]')	
		self.Health.value:SetPoint("TOPRIGHT", self.Health, 0, cfg.NameFS/2)		
		self.Health.value:SetFont(cfg.NumbFont, cfg.hpNumbFS, cfg.fontFNum)	
		
		-- plugins
		SpellRange(self)
		
		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", -20, 0)		
		
		self:SetSize(cfg.widthM, cfg.heightM + cfg.NumbFS + cfg.PPyOffset)
		---boss框体 debuff
		createDebuffs(self)
		self.Debuffs:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 10)
		self.Debuffs.initialAnchor = "BOTTOMLEFT"
		self.Debuffs["growth-x"] = "RIGHT"		
		self.Debuffs["growth-y"] = "UP"	
		self.Debuffs.num = 24
		self.Debuffs.onlyShowPlayer = true
		self.Debuffs:SetSize(self.Debuffs.size*13, self.Debuffs.size*2)	
	end,
	--BOSS目标框体
	bosstargets = function(self, ...)
		Shared(self, ...)
		--self.health:clearallpoints()
		self.Health:SetHeight(cfg.heightM)
		self.Health:SetWidth(cfg.widthS)			
		self.Power:SetWidth(cfg.widthS)	
		self.Name:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
		self:Tag(self.Name, '[raidcolor][shortname]')
		
		-- plugins
		SpellRange(self)
		
		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 15, 0)		

		-- update and debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)		

		self:SetSize(cfg.widthS, cfg.heightM + cfg.NumbFS + cfg.PPyOffset)
	end,	
	
	--MT框体
	MainTank = function(self, ...)
		Shared(self, ...)
		
		self.Health:SetHeight(cfg.heightM)
		self.Health:SetWidth(cfg.widthM)				
		self.Power:Hide()
		self.Name:SetPoint("TOPLEFT", self.Health, 0, cfg.NameFS/2)
		self:Tag(self.Name, '[afkdnd][raidcolor][abbrevname]')	
		self.Health.value:SetPoint("TOPRIGHT", self.Health, 0, cfg.NameFS/2)		

		-- plugins
		SpellRange(self)
		
		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)	
	end,
	
	arenaframes = function(self, ...)
		Shared(self, ...)
		self.Health:SetHeight(cfg.heightPA)
		self.Health:SetWidth(cfg.widthPA)	
		self.Power:SetWidth(cfg.widthPA)

		self.Health.value:SetPoint("RIGHT", self.Health, "RIGHT", -4, 0)			
		self.Power.value:SetPoint("RIGHT", self.Health.value, "LEFT", -2, 0)		
		self.Status:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -2)		
		self.Name:SetPoint("TOPLEFT", self.Status, "TOPRIGHT", 0, 0)	
		self.Health.value:SetFont(cfg.NumbFont, cfg.NumbFS, cfg.fontFNum)
		
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetHeight(cfg.heightPA)
		Auras:SetPoint("TOPRIGHT", self, "TOPLEFT", -10, 2)
		Auras.initialAnchor = "TOPRIGHT"
		Auras.size = cfg.buSize		
		Auras:SetWidth(Auras.size * 13)
		Auras.gap = true
		Auras.numBuffs = 8
		Auras.numDebuffs = 4
		Auras.spacing = 2
		Auras["growth-x"] = "LEFT"

		Auras.PostCreateIcon = PostCreateIcon
		--Auras.PostUpdateIcon = PostUpdateIcon
		self.Auras = Auras	

		-- apply aura filter
		if cfg.FilterAuras then
			self.Auras.CustomFilter = CustomFilter
		end
		
		-- plugins
		CombatFeedback(self)
		SpellRange(self)
		
		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("LEFT", self.Health, "LEFT", 4, 0)
		
		self:SetSize(cfg.widthPA, cfg.heightPA + cfg.NumbFS + cfg.PPyOffset)
	end,	
		
	arenatargets = function(self, ...)
		Shared(self, ...)
			
		self.Health.value:ClearAllPoints()	
		self.Power.value:ClearAllPoints()		
		
		self.Health:SetHeight(cfg.heightPA)
		self.Health:SetWidth(cfg.widthS)			
		self.Power:SetWidth(cfg.widthS)		
		self.Name:SetPoint("CENTER", self.Health, 0, 0)	
		self:Tag(self.Name, '[raidcolor][shortname]')
		
		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)	
		
		self:SetSize(cfg.widthS, cfg.heightPA + cfg.NumbFS + cfg.PPyOffset)
	end,			
}

-- raid, party 团队/小队框体
do
	local range = {
		insideAlpha = 1,
		outsideAlpha = cfg.FadeOutAlpha,
	}
	
	UnitSpecific.party = function(self, ...)
		Shared(self, ...)
		self.Health:SetHeight(cfg.heightPA)
		self.Health:SetWidth(cfg.widthPA)	
		self.Power:SetWidth(cfg.widthPA)

		self.Health.value:SetFont(cfg.NumbFont, cfg.NumbFS, cfg.fontFNum)
		self.Health.value:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -2)			
--？
		self.Power.value:SetPoint("RIGHT", self.Health.value, "LEFT", -2, 0)		
		self.Status:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -2)		
		self.Name:SetPoint("TOPLEFT", self.Status, "TOPRIGHT", -5, 0)--小队玩家名字位置		
		
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetHeight(cfg.heightPA)
		Auras:SetPoint("TOPLEFT", self, "TOPRIGHT", 6, 2)
		Auras.initialAnchor = "TOPLEFT"
		Auras.size = cfg.buSize
		Auras:SetWidth(Auras.size * 13)
		Auras.gap = true
		Auras.numBuffs = 8
		Auras.numDebuffs = 4
		Auras.spacing = 2

		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		self.Auras = Auras	

		-- apply aura filter
		if cfg.FilterAuras then
			self.Auras.CustomFilter = CustomFilter
		end
		
		-- plugins
		HealComm4(self)
		CombatFeedback(self)
		self.Range = range
		
		-- Icons
		createRaidIcon(self)
		createPhaseIcon(self)		
		self.RaidIcon:SetPoint("RIGHT", self.Health, "RIGHT", -4, 0)
		self.PhaseIcon:SetPoint("RIGHT", self.RaidIcon, "LEFT", -4, 0)
	
		LfDR = self.Health:CreateTexture(nil, 'OVERLAY')
		LfDR:SetSize(12, 12)
		LfDR:SetPoint("TOPLEFT", self.Health, 4, 6)		
		self.LFDRole = LfDR
		
		LIc = self.Health:CreateTexture(nil, "OVERLAY")
		LIc:SetSize(12, 12)			
		LIc:SetPoint("LEFT", LfDR, "RIGHT", 4, 0)
		self.Leader = LIc
		
		MLIc = self.Health:CreateTexture(nil, 'OVERLAY')
		MLIc:SetSize(12, 12)	
		MLIc:SetPoint("LEFT", LIc, "RIGHT", 4, 0)
		self.MasterLooter = MLIc
		
		rChk = self.Health:CreateTexture(nil, 'OVERLAY')
		rChk:SetSize(18, 18)
		rChk:SetPoint("CENTER", self.Health, 0, 0)		
		rChk.fadeTimer = 6
		rChk.finishedTimer = 6
		self.ReadyCheck = rChk		
		
		-- update and debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)
		
			-- party pets
			if (self:GetAttribute("unitsuffix") == "pet") then
				
				-- clear up the inherited mess ...
				self.Auras:ClearAllPoints()
				self.Name:ClearAllPoints()
				self.Health.value:ClearAllPoints()	
				self.Power.value:ClearAllPoints()		
				self.Status:ClearAllPoints()
				self.PhaseIcon:ClearAllPoints()
				
				self.Health:SetWidth(cfg.widthS)			
				self.Power:SetWidth(cfg.widthS)		
				self.Name:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
				self:Tag(self.Name, '[raidcolor][shortname]')
		
				-- Icons
				self.RaidIcon:ClearAllPoints()
				self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)	
		
				self:SetSize(cfg.widthS, cfg.heightPA + cfg.NumbFS + cfg.PPyOffset)
			end
	
			if cfg.PartyTarget and (self:GetAttribute("unitsuffix") == "target") then
				-- clear up the inherited mess ...
				self.Auras:ClearAllPoints()
				self.Name:ClearAllPoints()
				self.Health.value:ClearAllPoints()	
				self.Power.value:ClearAllPoints()		
				self.Status:ClearAllPoints()
				self.PhaseIcon:ClearAllPoints()
				
				self.Health:SetWidth(cfg.widthS)			
				self.Power:SetWidth(cfg.widthS)		
				self.Name:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
				self:Tag(self.Name, '[raidcolor][shortname]')
		
				-- Icons
				self.RaidIcon:ClearAllPoints()
				self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)	
		
				self:SetSize(cfg.widthS, cfg.heightPA + cfg.NumbFS + cfg.PPyOffset)
			end
	end
	
	UnitSpecific.raid = function(self, ...)
		Shared(self, ...)
		
		self.Name:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 1, -2)
		self:Tag(self.Name, '[afkdnd][raidcolor][raidhpname]')		

		self.Health:SetHeight(cfg.heightR)
		self.Health:SetWidth(cfg.widthR)	
		self.Power:SetWidth(cfg.widthR*0.7)		
		self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, cfg.heightPP)	
		self.Power:SetFrameLevel(4)		
		self.Power.PostUpdate = PostUpdatePowerRaid

		local rDhF = CreateFrame("Frame", nil, self)
		rDhF:SetAllPoints(self.Health)
		rDhF:SetFrameLevel(10)
		
		local Debuffs = CreateFrame("Frame", nil, rDhF)
		Debuffs:SetSize(cfg.buSizeRaid*cfg.RaidDebuffNumb, cfg.buSizeRaid)
		Debuffs:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 4)
		Debuffs.initialAnchor = "TOPRIGHT"
		Debuffs.num = cfg.RaidDebuffNumb
		Debuffs["growth-x"] = "LEFT"
		Debuffs.spacing = 7		
		
		Debuffs.PostCreateIcon = PostCreateIcon
		Debuffs.PostUpdateIcon = PostUpdateIcon		
		self.Debuffs = Debuffs
		
		if cfg.FilterAuras then
			self.Debuffs.CustomFilter = CustomFilter
		end		
		
		-- class specific tags
		classTags(self)		

		-- plugins
		HealComm4(self)
		self.Range = range
		self.Health.Smooth = false	
		self.Power.Smooth = false
		
		-- Icons
		createRaidIcon(self)
		self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)	
		
		rChk = self.Health:CreateTexture(nil, 'OVERLAY')
		rChk:SetSize(18, 18)
		rChk:SetPoint("CENTER", self.Health, 0, 0)		
		rChk.fadeTimer = 6
		rChk.finishedTimer = 6
		self.ReadyCheck = rChk
		
		self.dHlight:SetPoint("TOPLEFT", self.Health, -3, 3)
		self.dHlight2:SetPoint("TOPLEFT", self.Health, -3, 3)
		
		-- update and debuff highlight
		self:RegisterEvent("UNIT_AURA", updateDispel)
	end
	
	UnitSpecific.r40 = UnitSpecific.raid
end	 

 
---------------------------------------
-- register style(s) and spawn units --
---------------------------------------
 oUF:RegisterStyle("Slim", Shared)

for unit,layout in next, UnitSpecific do
	oUF:RegisterStyle('Slim - ' .. unit:gsub("^%l", string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle('Slim - ' .. unit:gsub("^%l", string.upper))
		local object = self:Spawn(unit)
		object:SetPoint(...)
		return object
	else
		self:SetActiveStyle'Slim'
		local object = self:Spawn(unit)
		object:SetPoint(...)
		return object
	end
end

if cfg.ArenaFrames then
oUF:RegisterStyle('oUF_Slim_Arena', UnitSpecific.arenaframes)
oUF:SetActiveStyle('oUF_Slim_Arena')
local arena = {}
local arenatarget = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
		if i == 1 then
			arena[i]:SetPoint('RIGHT', UIParent, 'RIGHT', -100, 0)
		else
			arena[i]:SetPoint("BOTTOMRIGHT", arena[i-1], "TOPRIGHT", 0, 20)
		end
	end
	
oUF:RegisterStyle("oUF_Slim_ArenaTarget", UnitSpecific.arenatargets)
oUF:SetActiveStyle("oUF_Slim_ArenaTarget")
	for i = 1, 5 do
		arenatarget[i] = oUF:Spawn("arena"..i.."target", "oUF_Arena"..i.."target"):SetPoint("TOPLEFT",arena[i], "TOPRIGHT", 8, 0)
	end
end

oUF:Factory(function(self)
	
	local player = spawnHelper(self, 'player', "CENTER", -230, -37)--玩家头像位置
	spawnHelper(self, 'pet', "RIGHT", player, "LEFT", -10, 0)--玩家宠物位置
	local target = spawnHelper(self, 'target', "CENTER", 230, -37) --目标头像位置
	spawnHelper(self, 'targettarget', "LEFT", target, "RIGHT", 10, 0)
	spawnHelper(self, 'targettargettarget', "BOTTOMLEFT", target, "TOPRIGHT", 66, -26) --TOTOT 目标的目标的目标的位置
	local focus = spawnHelper(self, 'focus', "bottom", player, "TOP", 81, 320)	--焦点
	spawnHelper(self, 'focustarget', "LEFT", focus, "RIGHT", 10, 0)
	
if cfg.PartyFrames then
	self:SetActiveStyle'Slim - Party'
	local party = self:SpawnHeader('oUF_Party', nil, 'party',
		'showParty', true, 
		--'showPlayer', true, 
		'yOffset', -30,--间隔  
		'template', 'oUF_SlimRaid',	-- party pets
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
    ]]):format(cfg.widthPA, cfg.heightPA + cfg.NumbFS + cfg.PPyOffset))
	party:SetPoint("TOPRIGHT", player, "BOTTOMRIGHT", 0, -49.2)
end

if cfg.RaidFrames then	
	self:SetActiveStyle"Slim - Raid"
	local raid = self:SpawnHeader('oUF_Raid', nil, 'raid',			
	'showRaid', true, 	
	'showPlayer', true,
	'groupFilter', '1,2,3,4,5',
	'groupingOrder', '1,2,3,4,5',
	'groupBy', 'GROUP',
	'maxColumns', 5,
	'unitsPerColumn', 5,
	'column', 4,
	'columnAnchorPoint', "RIGHT",
	'columnSpacing', 6,
	'yOffset', -6,
	'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
    ]]):format(cfg.widthR, cfg.heightR + cfg.NumbFS))
	--raid:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 150)	
	raid:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 30, -30)	
end

if cfg.RaidFrames2 then	
	self:SetActiveStyle"Slim - R40"
	local r40 = self:SpawnHeader('oUF_R40', nil, 'raid40',			
	'showRaid', true, 	
	'showPlayer', true,
	'groupFilter', '6,7,8',
	'groupingOrder', '6,7,8',
	'groupBy', 'GROUP',
	'maxColumns', 3,
	'unitsPerColumn', 5,
	'column', 4,
	'columnAnchorPoint', "RIGHT",
	'columnSpacing', 6,
	'yOffset', -6,
	'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
    ]]):format(cfg.widthR, cfg.heightR + cfg.NumbFS))
	r40:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 30, -250)	
end

if cfg.BossFrames then		
	self:SetActiveStyle"Slim - Boss"
	local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			local unit = self:Spawn("boss"..i, "oUF_SlimBoss"..i)

			if i==1 then
				unit:SetPoint("TOPLEFT", target, "TOPLEFT", 0, -101)
			else
				unit:SetPoint("TOPLEFT", boss[i-1], "BOTTOMLEFT", 0, -30)
			end
			boss[i] = unit
		end
end
		
if cfg.MTFrames then		
	self:SetActiveStyle"Slim - MainTank"
	local Main_Tank = self:SpawnHeader("oUF_MainTank", nil, 'raid, party, solo', 
		'showRaid', true, 
		"groupFilter", "MAINTANK", 
		'yOffset', -10, 
		"template", "oUF_SlimMTartemplate",		-- MT Target
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(cfg.widthM, cfg.heightM))		
	Main_Tank:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -80, -250)		
end
	
if IsAddOnLoaded("oUF_WeaponEnchant") then	
	oUF:RegisterStyle("oUF_Slim_WpnEnch", UnitSpecific.WpnEnch)
	oUF:SetActiveStyle("oUF_Slim_WpnEnch")
	oUF:Spawn('player', 'WpnEnch'):SetPoint("BOTTOMRIGHT", player, "BOTTOMLEFT", -8, -(cfg.WeapEnchantIconSize+8))	
end

end)

-- disable blizzard raidframe manager
if cfg.disableRaidFrameManager then
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager:Hide()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer:Hide()	
end

-- remove SET_FOCUS & CLEAR_FOCUS from menu, to prevent errors
do 
    for k,v in pairs(UnitPopupMenus) do
        for x,y in pairs(UnitPopupMenus[k]) do
            if y == "SET_FOCUS" then
                table.remove(UnitPopupMenus[k],x)
            elseif y == "CLEAR_FOCUS" then
                table.remove(UnitPopupMenus[k],x)
            end
        end
    end
end

-------------
-- The End --
-------------