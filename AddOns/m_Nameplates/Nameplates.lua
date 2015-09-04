local addon, ns = ...
local cfg = ns.cfg

local backdrop = {
	edgeFile = cfg.backdrop_edge, edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3}}

ns.eventFrame = CreateFrame("Frame", nil, UIParent)
ns.eventFrame:SetScript("OnEvent", function(self, event, ...)
	if type(self[event] == "function") then
		return self[event](self, event, ...)
	end
end)

local cacheframe = {}
local modf, len, lower, gsub, select, upper, sub, find = math.modf, string.len, string.lower, string.gsub, select, string.upper, string.sub, string.find
local numKids = -1

-- functions
local function round(num, idp)
	return tonumber(format("%." .. (idp or 0) .. "f", num))
end

local function formatNumber(number)
	if number >= 1e8 then
		return round(number/1e8, 1).."|cffEEEE00Y|r"
	elseif number >= 1e4 then
		return round(number/1e4, 1).."|cffEEEE00w|r"
	else
		return number
	end
end

local function nameColoring(self, checker)
	if checker then
		local r, g, b = self.healthBar:GetStatusBarColor()
		return r * 1.5, g * 1.5, b * 1.5
	else
		return 1, 1, 1
	end
end

local function IsTargetNameplate(self)
	return (self:IsShown() and self:GetAlpha() ==1 and UnitExists("target")) or false
end



--[[-->Needed to fix castbar colors and bloat
local function FixCastbar(self)
	self:ClearAllPoints()
	self:SetParent(self.healthBar)
	self.castbarOverlay:Hide()	
	self:SetSize(cfg.cbWidth, cfg.cbHeight)
	self:SetPoint("TOPRIGHT",self.healthBar,"BOTTOMRIGHT", (cfg.cbWidth/2)-(cfg.hpWidth/2),-5)
	self:SetPoint("BOTTOMLEFT",self.healthBar,"BOTTOMLEFT", (cfg.hpWidth/2)-(cfg.cbWidth/2),-5-cfg.cbHeight)
	
	-- have to define not protected casts colors again due to some weird bug reseting colors when you start channeling a spell 
 	if  not self.shieldedRegion:IsShown() then
		self:SetStatusBarColor(.5,.65,.85)
	else
		self:SetStatusBarColor(1,.4,0)
	end 
end


-->Color castbar depending on interruptability
local function ColorCastbar(self, shielded)
	if shielded then 
		self:SetStatusBarColor(1,.4,0)
	else
		self:SetStatusBarColor(.5,.65,.85)

	end
end
]]

--------------------------
--- SHOW HEALTH UPDATE ---
--------------------------
local function updateHealth(healthBar, maxHp)
	if healthBar then
		local self = healthBar:GetParent():GetParent() 
		local _, maxhealth = self.healthBar:GetMinMaxValues()
		if maxHp == "x" then 
			maxHp = maxhealth
		end
		local currentValue = self.healthBar:GetValue()
		local p = (currentValue/maxhealth)*100
		self.hp:SetTextColor(r, g, b)
	
		if p < 100 and currentValue > 1 then
			self.hp:SetText(formatNumber(currentValue))
			self.pct:SetText(format("%.1f %s",p,"%"))
		else
			self.hp:SetText("")
			self.pct:SetText("")
		end
		
		if(p <= 35 and p >= 25) then
			self.hp:SetTextColor(253/255, 238/255, 80/255)
			self.pct:SetTextColor(253/255, 238/255, 80/255)
		elseif(p < 25 and p >= 20) then
			self.hp:SetTextColor(250/255, 130/255, 0/255)
			self.pct:SetTextColor(250/255, 130/255, 0/255)
		elseif(p < 20) then
			self.hp:SetTextColor(200/255, 20/255, 40/255)
			self.pct:SetTextColor(200/255, 20/255, 40/255)
		else
			self.hp:SetTextColor(1,1,1)
			self.pct:SetTextColor(1,1,1)
		end	
	end
end

local function setBarColors(self)
	local r, g, b = self.healthBar:GetStatusBarColor()
	local newr, newg, newb
	if g + b == 0 then
		-- Hostile unit
		newr, newg, newb = 0.69, 0.31, 0.31
	elseif r + b == 0 then
		-- Friendly npc
		newr, newg, newb = 0.33, 0.59, 0.33
	elseif r + g == 0 then
		-- Friendly player
		newr, newg, newb = 0.31, 0.45, 0.63
	elseif (2 - (r + g) < 0.05 and b == 0) then
		-- Neutral unit
		newr, newg, newb = 0.71, 0.71, 0.35
	else
		newr, newg, newb = r, g, b
	end	
	
	self.r, self.g, self.b = newr, newg, newb -->set them unique to each frame
	self.healthBar:SetStatusBarColor(newr, newg, newb) -->set our wanted colors
end

-- OnUpdate
local InCombat = false
local function PlateOnUpdate(frame)
		-- mouseover highlight
		if frame.highlight:IsShown() then
			frame.name:SetTextColor(1, 1, 0)
		else
			frame.name:SetTextColor(nameColoring(frame, cfg.namecolor))
		end

	    if not frame.oldglow:IsShown() then
		    frame.healthBar.hpGlow:SetBackdropBorderColor(0, 0, 0)
	    else
		    frame.healthBar.hpGlow:SetBackdropBorderColor(frame.oldglow:GetVertexColor())
	    end		

end

local function UpdateTarget(frame)
    if IsTargetNameplate(frame) then frame.isTarget = true else frame.isTarget = false end
    if frame.isTarget then 
		frame.healthBar.tarT:SetVertexColor(1, .7, .2, 1)
		frame.healthBar.tarB:SetVertexColor(1, .7, .2, 1)
		frame.healthBar.tarL:SetVertexColor(1, .7, .2, 1)
		frame.healthBar.tarR:SetVertexColor(1, .7, .2, 1)
	else 
		frame.healthBar.tarT:SetVertexColor(0, 0, 0, 0)
		frame.healthBar.tarB:SetVertexColor(0, 0, 0, 0)
	    frame.healthBar.tarL:SetVertexColor(0, 0, 0, 0)
		frame.healthBar.tarR:SetVertexColor(0, 0, 0, 0)
	end
end

-- update plate
local function PlateOnShow(self)
	setBarColors(self)
	
	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self.healthBar:GetParent(), 0, 0)
	self.healthBar:SetSize(cfg.hpWidth, cfg.hpHeight)
	self.healthBar.hpBackground:SetVertexColor(0.15, 0.15, 0.15, 1)
	
	-->initial castbar maintenance
	if self.castBar:IsShown() then self.castBar:Hide() end
	self.castBar.IconOverlay:SetVertexColor(0, 0, 0, 1)
			
	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)
		
	local oldName = self.oldname:GetText()
	local newName = (len(oldName) > 25) and gsub(oldName, "%s?(.[\128-\191]*)%S+%s", "%1. ") or oldName -->fixes really long names
	self.name:SetTextColor(nameColoring(self, cfg.namecolor))
	self.name:SetText(newName) 
	
	local level, elite, mylevel = tonumber(self.level:GetText()), self.elite:IsShown(), UnitLevel("player")
	local lvlr, lvlg, lvlb = self.level:GetTextColor()
	self.level:ClearAllPoints()
	self.level:SetPoint("RIGHT", self.healthBar, "LEFT", -2, 0)
	self.level:Hide()	self.level:SetAlpha(0)
	if self.boss:IsShown() then
		self.level:SetText("|TInterface\\RAIDFRAME\\Raid-Icon-DebuffDisease.blp:16|t")
		self.name:SetText('|cffDC3C2D'..self.level:GetText()..'|r '..self.name:GetText())
self.elite:SetTexture(1,1,1,0)
	elseif self.elite:IsShown() then
		self.level:SetText(level..("+"))
		self.name:SetText(format('|cff%02x%02x%02x', lvlr*255, lvlg*255, lvlb*255)..self.level:GetText()..'|r '..self.name:GetText())
self.elite:SetTexture(1,1,1,0)

else self.level:SetText(level..(""))
self.name:SetText(format('|cff%02x%02x%02x', lvlr*255, lvlg*255, lvlb*255)..self.level:GetText()..'|r '..self.name:GetText())
	end

	self.fade:SetChange(self:GetAlpha())
	self:SetAlpha(0)
	self.ag:Play()
end

-- event handlers
local function OnSizeChanged(self, width, height)
	if self:IsShown() ~= 1 then return end
		
	if height > cfg.cbHeight then
		self.needFix = true
	end
end

local function OnValueChanged(self, curValue)
	if self:IsShown() ~= 1 then return end
	UpdateTime(self, curValue) 
	
	--fix castbar from bloating - as a back up to onshow fixcastbar call
	--if self:GetHeight() > cfg.cbHeight or self.needFix then
		--FixCastbar(self)
		--self.needFix = nil
	--end
	
end

--local function OnShow(self)	
	--FixCastbar(self)
	--self.IconOverlay:Show()
	--ColorCastbar(self, self.shieldedRegion:IsShown() == 1) 
--end

local function OnHide(self)
    self.highlight:Hide()
	--cacheframe[self] = nil
end

local function CastbarEvents(self, event, unit)
	if unit == "target" then
		local chc, cc
		
		self.controller = nil

		self.channeling = select(1, UnitChannelInfo('target'))
		self.casting = select(1, UnitCastingInfo('target'))
		
		chc = select(8, UnitChannelInfo('target'))
		cc = select(9, UnitCastingInfo('target'))

		if self.channeling and not self.casting then self.controller = chc
		else self.controller = cc end
		
		if self:IsShown() == 1 then
			ColorCastbar(self, event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" or self.controller or self.shieldedRegion:IsShown() == 1) 
		end
	end
end

--------------------
--- CREATE PLATE ---
--------------------
local function createPlate(frame)
	frame.nameplate = true
	frame.barFrame, frame.nameFrame = frame:GetChildren() 
	frame.healthBar, frame._, frame.castBar = frame.barFrame:GetChildren()

	local newParent = frame.barFrame 
	local healthBar, castBar = frame.healthBar, frame.castBar
	local nameTextRegion = frame.nameFrame:GetRegions()
	local glowRegion, overlayRegion, highlightRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame.barFrame:GetRegions()
	local _, castbarOverlay, shieldedRegion, spellIconRegion= castBar:GetRegions()	

	frame.oldname = nameTextRegion
	nameTextRegion:Hide()
		
	------------------
	---NAME TEXT------
	------------------
	frame.name = frame:CreateFontString(nil, 'OVERLAY')
	frame.name:SetParent(healthBar)
	
	frame.name:SetPoint('BOTTOMLEFT', healthBar, 'TOPLEFT', -10, 1)
	frame.name:SetPoint('BOTTOMRIGHT', healthBar, 'TOPRIGHT', 10, 1)
	frame.name:SetFont(cfg.font, cfg.fontsize+3, "THINOUTLINE")

	
	-----------------------
	---LEVEL TEXT INFO ----
	-----------------------
	levelTextRegion:SetFont(cfg.font, cfg.fontsize+1, cfg.fontflag)
	levelTextRegion:SetShadowOffset(0,0)

	frame.level = levelTextRegion
	
	---------------------
	---HEALTHBAR stuff---
	---------------------
	healthBar:SetStatusBarTexture(cfg.statusbar)
		

	healthBar.hpBackground = healthBar:CreateTexture(nil, "BORDER")
	healthBar.hpBackground:SetAllPoints()

			
	healthBar.hpGlow = CreateFrame("Frame", nil, healthBar)
	healthBar.hpGlow:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)
	healthBar.hpGlow:SetPoint("TOPLEFT", healthBar, "TOPLEFT", -1, 1)
	healthBar.hpGlow:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 1, -1)
	healthBar.hpGlow:SetBackdrop(backdrop)
	healthBar.hpGlow:SetBackdropColor(0, 0, 0, 0)
	healthBar.hpGlow:SetBackdropBorderColor(0, 0, 0)
	
	------------------
	---HEALTH TEXT----
	------------------
	
	frame.hp = frame:CreateFontString(nil, 'ARTWORK')
	frame.hp:SetPoint("LEFT", healthBar, "LEFT", 2, 0)
	frame.hp:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
	healthBar:SetScript("OnValueChanged", updateHealth)

	frame.pct = healthBar:CreateFontString(nil, "OVERLAY")	
	frame.pct:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
	frame.pct:SetPoint("RIGHT", healthBar, "RIGHT", 0, 0)


	-------------------------
	---CASTBAR ATTRIBUTES----
	-------------------------
	castBar.castbarOverlay = castbarOverlay
	castBar.shieldedRegion = shieldedRegion
	castBar.healthBar = healthBar
	castBar:SetStatusBarTexture(cfg.statusbar)
	castBar:SetParent(healthBar)
	castBar:ClearAllPoints()

	castBar:SetPoint("TOPRIGHT",healthBar,"BOTTOMRIGHT", (cfg.cbWidth/2)-(cfg.hpWidth/2),-5)
	castBar:SetPoint("BOTTOMLEFT",healthBar,"BOTTOMLEFT", (cfg.hpWidth/2)-(cfg.cbWidth/2),-5-cfg.cbHeight)
	castBar:SetSize(cfg.cbWidth, cfg.cbHeight)	
	--castBar:HookScript("OnShow", OnShow)
	castBar:SetScript("OnValueChanged", OnValueChanged)
	castBar:SetScript("OnSizeChanged", OnSizeChanged)
	castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	castBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
	castBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	castBar:RegisterEvent("UNIT_SPELLCAST_START")
			
	
	castBar.cname = castBar:CreateFontString(nil, "ARTWORK")
	castBar.cname:SetPoint("TOPLEFT", castBar, "BOTTOMLEFT", 2, -2)
	castBar.cname:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
	castBar.cname:SetTextColor(1, 1, 1)

	
	castBar.cbBackground = castBar:CreateTexture(nil, "BACKGROUND")
	castBar.cbBackground:SetAllPoints()
	castBar.cbBackground:SetTexture(0.15, 0.15, 0.15, 0.8)


	castBar.cbGlow = CreateFrame("Frame", nil, castBar)
	castBar.cbGlow:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)
	castBar.cbGlow:SetPoint("TOPLEFT", castBar, -1, 1)
	castBar.cbGlow:SetPoint("BOTTOMRIGHT", castBar, 1, -1)
	castBar.cbGlow:SetBackdrop(backdrop)
	castBar.cbGlow:SetBackdropColor(0, 0, 0, 1)
	castBar.cbGlow:SetBackdropBorderColor(0, 0, 0, .7)

	castBar.HolderA = CreateFrame("Frame", nil, castBar)
	castBar.HolderA:SetFrameLevel(castBar.HolderA:GetFrameLevel() + 1)
	castBar.HolderA:SetAllPoints()

	castBar.spellicon = spellIconRegion
	castBar.spellicon:SetSize(cfg.cbIconSize, cfg.cbIconSize)
	castBar.spellicon:ClearAllPoints()
	castBar.spellicon:SetPoint("TOPRIGHT", healthBar, "TOPLEFT", -4, 1)
	castBar.spellicon:SetTexCoord(.07, .93, .07, .93)
		
	castBar.HolderB = CreateFrame("Frame", nil, castBar)
	castBar.HolderB:SetFrameLevel(castBar.HolderA:GetFrameLevel() + 2)
	castBar.HolderB:SetAllPoints()

	castBar.IconOverlay = castBar.HolderB:CreateTexture(nil, "OVERLAY")
	castBar.IconOverlay:SetPoint("TOPLEFT", spellIconRegion, -1, 1)
	castBar.IconOverlay:SetPoint("BOTTOMRIGHT", spellIconRegion, 1, -1)
	castBar.IconOverlay:SetTexture(cfg.icontex)
	
	-----------------------
	---HIGHTLIGHT REGION---
	-----------------------
	highlightRegion:SetTexture(cfg.statusbar)
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25, 1)
	frame.highlight = highlightRegion

	---------------------
	---RAID ICON-----
	---------------------
	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("LEFT", healthBar, "RIGHT", 3, 0)
	raidIconRegion:SetSize(cfg.raidIconSize, cfg.raidIconSize)

	---------------------
	---ELITE/BOSS ICON-----
	---------------------	
	
	-- pixel art starts here... making targeting border as the commented method above deforms after reloading UI
 	healthBar.tar = CreateFrame("Frame", nil, healthBar)
	healthBar.tar:SetFrameLevel(healthBar.hpGlow:GetFrameLevel()+1)
	
	healthBar.tarT = healthBar.tar:CreateTexture(nil, "PARENT")
	healthBar.tarT:SetTexture(1,1,1,1)
	healthBar.tarT:SetPoint("TOPLEFT", healthBar, "TOPLEFT",0,1)
	healthBar.tarT:SetPoint("TOPRIGHT", healthBar, "TOPRIGHT",0,1)
	healthBar.tarT:SetHeight(1)
	healthBar.tarT:SetVertexColor(1,1,1,1)
	
	healthBar.tarB = healthBar.tar:CreateTexture(nil, "PARENT")
	healthBar.tarB:SetTexture(1,1,1,1)
	healthBar.tarB:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMLEFT",0,-1)
	healthBar.tarB:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT",0,-1)
	healthBar.tarB:SetHeight(1)
	healthBar.tarB:SetVertexColor(1,1,1,1)
	
	healthBar.tarL = healthBar.tar:CreateTexture(nil, "PARENT")
	healthBar.tarL:SetTexture(1,1,1,1)
	healthBar.tarL:SetPoint("TOPLEFT", healthBar, "TOPLEFT",-1,1)
	healthBar.tarL:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMLEFT",-1,-1)
	healthBar.tarL:SetWidth(1)
	healthBar.tarL:SetVertexColor(1,1,1,1)
	
	healthBar.tarR = healthBar.tar:CreateTexture(nil, "PARENT")
	healthBar.tarR:SetTexture(1,1,1,1)
	healthBar.tarR:SetPoint("TOPRIGHT", healthBar, "TOPRIGHT",1,1)
	healthBar.tarR:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT",1,-1)
	healthBar.tarR:SetWidth(1)
	healthBar.tarR:SetVertexColor(1,1,1,1)
	
	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion	

	-->hide uglies
	glowRegion:SetTexture("")	
    overlayRegion:SetTexture("")	
    shieldedRegion:SetTexture("")	
	castbarOverlay:SetTexture("")	
    stateIconRegion:SetTexture("")	
    bossIconRegion:SetTexture("")
	
	--animations for initial fade in
	frame.ag = frame:CreateAnimationGroup()
	frame.fade = frame.ag:CreateAnimation('Alpha')
	frame.fade:SetSmoothing("OUT")
	frame.fade:SetDuration(0.5)
	frame.fade:SetChange(1)
	frame.ag:SetScript('OnFinished', function()
		frame:SetAlpha(frame.fade:GetChange())
	end)
	
	---------------------
	---EVENT SCRIPTS-----
	---------------------
	frame:SetScript("OnShow", PlateOnShow)
	frame:SetScript("OnHide", OnHide)
	frame:RegisterEvent("UNIT_POWER")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")

	
	frame.isTarget = false
	frame.skinned = true
	frame.elapsed = 1	
	PlateOnShow(frame)	
end

----------------------------------
-----CREATE/FIND ALL PLATES-------
----------------------------------

local function searchForNameplates(self)
	self:SetScript("OnUpdate", function(self, elapsed)
		local curKids = WorldFrame:GetNumChildren()
		local i
		if curKids ~= numKids then
			numKids = curKids		
			for i = 1, curKids do
				local frame = select(i, WorldFrame:GetChildren())
				if (frame:GetName() and frame:GetName():find("NamePlate%d") and not frame.skinned) then
					createPlate(frame)
					if not cacheframe[frame] then
					cacheframe[frame] = true
					end
					frame.skinned = true
				end
			end				
		end
		for frame in pairs(cacheframe) do
		   PlateOnUpdate(frame)
		   UpdateTarget(frame)
		end
	end)
end

-->Register initial login event 
local updateFrame = CreateFrame("Frame")
updateFrame:RegisterEvent("PLAYER_LOGIN")
updateFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
updateFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
updateFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

updateFrame:SetScript("OnEvent", function(self, event, ...)
	if (event=="PLAYER_LOGIN") then 
		SetCVar("bloattest",0)
		SetCVar("bloatnameplates",0)
		SetCVar("bloatthreat",0)
		SetCVar("ShowClassColorInNameplate", 1)
		searchForNameplates(self)

	elseif (event == "PLAYER_REGEN_DISABLED") then 
		InCombat = true
		if cfg.combat_toggle then 
			SetCVar("nameplateShowEnemies", 1)
		end
	elseif (event == "PLAYER_REGEN_ENABLED") then
		InCombat = false
		if cfg.combat_toggle then 
			SetCVar("nameplateShowEnemies", 0) 
		end
	end
end)



