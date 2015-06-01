----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig

local AuraList, Aura, UnitIDTable, MaxFrame = {}, {}, {}, 12
local MyClass = select(2, UnitClass("player")) 
local BuildICON = cfg.BuildICON
local BuildBAR = cfg.BuildBAR
local BuildBAR2 = cfg.BuildBAR2
if not sRawDB then sRawDB = {} end

-- Init
local function BuildAuraList()
	AuraList = SRAuraList["ALL"] and SRAuraList["ALL"] or {}
	for key, _ in pairs(SRAuraList) do
		if key == MyClass then
			for _, value in pairs(SRAuraList[MyClass]) do
				tinsert(AuraList, value)
			end
		end
	end
	wipe(SRAuraList)
end
local function BuildUnitIDTable()
	for _, VALUE in pairs(AuraList) do
		for _, value in pairs(VALUE.List) do
			local Flag = true
			for _,v in pairs(UnitIDTable) do
				if value.UnitID == v then Flag = false end
			end
			if Flag then tinsert(UnitIDTable, value.UnitID) end
		end
	end
end
local function MakeMoveHandle(Frame, Text, key, Pos)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:SetWidth(Frame:GetWidth())
	MoveHandle:SetHeight(Frame:GetHeight())
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({bgFile = cfg.Solid})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
	MoveHandle.Text = MoveHandle:CreateFontString(nil, "OVERLAY")
	MoveHandle.Text:SetFont(cfg.Font, 10, "THINOUTLINE")
	MoveHandle.Text:SetPoint("CENTER")
	MoveHandle.Text:SetText(Text)
	if not sRawDB[key] then 
		MoveHandle:SetPoint(unpack(Pos))
	else
		MoveHandle:SetPoint(unpack(sRawDB[key]))		
	end
	MoveHandle:EnableMouse(true)
	MoveHandle:SetMovable(true)
	MoveHandle:RegisterForDrag("LeftButton")
	MoveHandle:SetScript("OnDragStart", function(self) MoveHandle:StartMoving() end)
	MoveHandle:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		sRawDB[key] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	MoveHandle:Hide()
	Frame:SetPoint("CENTER", MoveHandle)
	return MoveHandle
end
local function BuildAura()
	for key, value in pairs(AuraList) do
		local FrameTable = {}
		for i = 1, MaxFrame do
			if value.Mode:lower() == "icon" then
				local Frame = BuildICON(value.IconSize)
				if i == 1 then Frame.MoveHandle = MakeMoveHandle(Frame, value.Name, key, value.Pos) end
				tinsert(FrameTable, Frame)
			elseif value.Mode:lower() == "bar" then
				local Frame = BuildBAR(value.BarWidth, value.IconSize)
				if i == 1 then Frame.MoveHandle = MakeMoveHandle(Frame, value.Name, key, value.Pos) end
				tinsert(FrameTable, Frame)
			elseif value.Mode:lower() == "bar2" then
				local Frame = BuildBAR2(value.BarWidth, value.IconSize)
				if i == 1 then Frame.MoveHandle = MakeMoveHandle(Frame, value.Name, key, value.Pos) end
				tinsert(FrameTable, Frame)
			end
		end
		FrameTable.Index = 1
		tinsert(Aura, FrameTable)
	end
end
local function Pos()
	for key, value in pairs(Aura) do
		local Direction, Interval = AuraList[key].Direction, AuraList[key].Interval
		for i = 1, MaxFrame do
			value[i]:ClearAllPoints()
			if i == 1 then
				value[i]:SetPoint("CENTER", value[i].MoveHandle)
			elseif Direction:lower() == "right" then
				value[i]:SetPoint("LEFT", value[i-1], "RIGHT", Interval, 0)
			elseif Direction:lower() == "left" then
				value[i]:SetPoint("RIGHT", value[i-1], "LEFT", -Interval, 0)
			elseif Direction:lower() == "up" then
				value[i]:SetPoint("BOTTOM", value[i-1], "TOP", 0, Interval)
			elseif Direction:lower() == "down" then
				value[i]:SetPoint("TOP", value[i-1], "BOTTOM", 0, -Interval)
			end
		end
	end
end
local function Init()
	BuildAuraList()
	BuildUnitIDTable()
	BuildAura()
	Pos()
end

-- SetTime
local function SetTime(self)
	if self.Timer < 0 then
		if self.Time then self.Time:SetText("|cff00ff00N/A|r") end
		self.Statusbar:SetValue(self.Timer)
	elseif self.Timer < 60 then
		if self.Time then self.Time:SetFormattedText("%.1f", self.Timer) end
		self.Statusbar:SetValue(self.Timer)
	else
		if self.Time then self.Time:SetFormattedText("%d:%.2d", self.Timer/60, self.Timer%60) end
		self.Statusbar:SetValue(self.Timer)
	end
end

-- UpdateCD
local function UpdateCDFrame(index, name, icon, start, duration, bool)
	local Frame = Aura[index][Aura[index].Index]
	if Frame then Frame:Show() end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		Frame.Cooldown:SetCooldown(start, duration)
	end
	if Frame.Count then Frame.Count:SetText(nil) end
	if Frame.Value then Frame.Value:SetText(nil) end 
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Timer = 0
		Frame.Statusbar:SetMinMaxValues(0, duration)
		Frame:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = start+duration-GetTime()
			SetTime(self)
		end)
	end
	
	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function UpdateCD()
	for KEY, VALUE in pairs(AuraList) do
		for _, value in pairs(VALUE.List) do
			if value.SpellID then
				if GetSpellCooldown(value.SpellID) and select(2, GetSpellCooldown(value.SpellID)) > 1.5 then
					local name, _, icon = GetSpellInfo(value.SpellID)
					local start, duration = GetSpellCooldown(value.SpellID)
					UpdateCDFrame(KEY, name, icon, start, duration, true)
				end
			end
			if value.ItemID then
				if select(2, GetItemCooldown(value.ItemID)) > 1.5 then
					local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(value.ItemID)
					local start, duration = GetItemCooldown(value.ItemID)
					UpdateCDFrame(KEY, name, icon, start, duration, false)
				end
			end
		end
	end
end

local function FormatHealth(hp)
	local out = ""	
	if (hp >= 10000) then
		hp = floor(hp / 1000) / 10 .. "万"
	else
		hp = floor(hp)
	end
	return (hp.."")
end

---------------------------------Thanks for tangji---------------------
function Resolve(value1,value2)
return FormatHealth(value2).."("..value1.."%)"
--return FormatHealth(value2)
end

function Stagger(value1,duration)
local hp = floor(value1 * math.floor(duration)/UnitHealthMax("player") * 100)
return FormatHealth(value1).." ("..hp.."%)"
--return hp.."%"
end

-- UpdateAura
local function UpdateAuraFrame(index, UnitID, name, icon, count, duration, expires,value1,value2,spellID)
	local Frame = Aura[index][Aura[index].Index]
	if Frame then Frame:Show() end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Count then Frame.Count:SetText(count > 1 and count or nil) end
	
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(true)
		Frame.Cooldown:SetCooldown(expires-duration, duration)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Timer = 0
		Frame.Statusbar:SetMinMaxValues(0, duration)
		Frame:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = expires-GetTime()
			SetTime(self)
		end)
	end
	
	if Frame.Value and name and value1 and duration > 0 then
	   if spellID == 124275  then 
	      Frame.Value:SetText(Stagger(value1,duration))
	      Frame.Value:SetTextColor(0,1,0)
	   elseif spellID==124274 then
	      Frame.Value:SetText(Stagger(value1,duration))
	      Frame.Value:SetTextColor(1,1,0)
	   elseif spellID==124273 then
	      Frame.Value:SetText(Stagger(value1,duration))
	      Frame.Value:SetTextColor(1,0,0)
	   end
	end
	
	if Frame.Value and name and value1 and spellID == 115295 then
	Frame.Value:SetText(FormatHealth(value1))
	Frame.Value:SetTextColor(0,1,0)
	end
	
	if Frame.Value and name and spellID == 158300 then
	if value1>200 then
	Frame.Value:SetTextColor(1,0,0)
	elseif value1>100 then
	Frame.Value:SetTextColor(1,1,0)
	else
	Frame.Value:SetTextColor(0,1,0)
	end
	
	if value2>0 or UnitAffectingCombat("player")== true then
	Frame.Value:SetText(Resolve(value1,value2))
	else
	Frame.Value:SetText()
	end
	end
	
	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function AuraFilter(spellID, UnitID, index, bool)
	for KEY, VALUE in pairs(AuraList) do
		for key, value in pairs(VALUE.List) do
			if value.AuraID == spellID and value.UnitID == UnitID then
				if bool then
					local name, _, icon, count, _, duration, expires, caster, _, _, _, _, _, _, value1, value2 = UnitBuff(value.UnitID, index)
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					return KEY, value.UnitID, name, icon, count, duration, expires, value1,value2,spellID
				else
					local name, _, icon, count, _, duration, expires, caster, _, _, _, _, _, _, value1, value2= UnitDebuff(value.UnitID, index)
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					return KEY, value.UnitID, name, icon, count, duration, expires, value1,value2,spellID
				end
			end
		end
	end
	return false
end
local function UpdateAura(UnitID)
	local index = 1
    while true do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(UnitID, index)
		if not name then break end
		if AuraFilter(spellID, UnitID, index, true) then UpdateAuraFrame(AuraFilter(spellID, UnitID, index, true)) end
		index = index + 1
	end
	local index = 1
    while true do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitDebuff(UnitID, index)
		if not name then break end
		if AuraFilter(spellID, UnitID, index, false) then UpdateAuraFrame(AuraFilter(spellID, UnitID, index, false)) end
		index = index + 1
	end
end

-- CleanUp
local function CleanUp()
	for _, value in pairs(Aura) do
		for i = 1, MaxFrame do
			if value[i] then
				value[i]:Hide()
				value[i]:SetScript("OnUpdate", nil)
			end
			if value[i].Icon then value[i].Icon:SetTexture(nil) end
			if value[i].Count then value[i].Count:SetText(nil) end
			if value[i].Spellname then value[i].Spellname:SetText(nil) end
			if value[i].Statusbar then
				value[i].Statusbar:SetMinMaxValues(0, 1) 
				value[i].Statusbar:SetValue(0)
			end
		end
		value.Index = 1
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("onEvent", function(self, event, unitID, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		Init()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)
Event.Timer = 0
Event:SetScript("OnUpdate", function(self, elapsed)
	self.Timer = self.Timer + elapsed
	if self.Timer > 0.2 then
		self.Timer = 0
		CleanUp()
		UpdateCD()
		for _, value in pairs(UnitIDTable) do
			UpdateAura(value)
		end
	end	
end)

-- Test
local TestFlag = true
SlashCmdList.SRAuraWatch = function(msg)
	if msg:lower() == "test" then
		if TestFlag then
			TestFlag = false
			Event:SetScript("OnUpdate", nil)
			for _, value in pairs(Aura) do
				for i = 1, MaxFrame do
					if value[i] then
						value[i]:SetScript("OnUpdate", nil)
						value[i]:Show()	
					end		
					if value[i].Icon then value[i].Icon:SetTexture(select(3, GetSpellInfo(118))) end
					if value[i].Count then value[i].Count:SetText("9") end
					if value[i].Time then value[i].Time:SetText("59.59") end
					if value[i].Statusbar then value[i].Statusbar:SetValue(1) end
					if value[i].Spellname then value[i].Spellname:SetText("变形术") end				
				end
				value[1].MoveHandle:Show()
			end
		else
			TestFlag = true
			CleanUp()
			for _, value in pairs(Aura) do
				value[1].MoveHandle:Hide()
			end
			Event:SetScript("OnUpdate", function(self, elapsed)
				self.Timer = self.Timer + elapsed
				if self.Timer > 0.5 then
					self.Timer = 0
					CleanUp()
					UpdateCD()
					for _, value in pairs(UnitIDTable) do
						UpdateAura(value)
					end
				end	
			end)
		end
	elseif msg:lower() == "reset" then
		wipe(sRawDB)
		ReloadUI()
	else
		print("/sRaw Test -- 测试模式")
		print("/sRaw Reset -- 恢复默认设置")
	end
end
SLASH_SRAuraWatch1 = "/sRaw"

