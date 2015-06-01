--[[	$Id: oUF_cTotems.lua 2522 2012-09-13 12:48:34Z sdkyron@gmail.com $	]]

local _, playerClass = UnitClass('player')
if playerClass ~= "SHAMAN" then return end

local _, ns = ...
local oUF = ns.oUF or oUF

oUF.colors.totems = {
	[FIRE_TOTEM_SLOT] = {0.752,0.172,0.02},
	[EARTH_TOTEM_SLOT] = {0.741,0.580,0.04},
	[WATER_TOTEM_SLOT] = {0,0.443,0.631},
	[AIR_TOTEM_SLOT] = {0.6,1,0.945}
}

local total = 0
local delay = 0.01

local function TotemOnClick(self, ...)
	local id = self.ID
	local mouse = ...

	if IsShiftKeyDown() then
		for j = 1, 4 do
			DestroyTotem(j)
		end
	else
		DestroyTotem(id)
	end
end

local function InitDestroy(self)
	local totem = self.TotemBar
	for i = 1, 4 do
		local Destroy = CreateFrame("Button",nil, totem[i])
		Destroy:SetAllPoints(totem[i])
		Destroy:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		Destroy.ID = i
		Destroy:SetScript("OnClick", TotemOnClick)
	end
end

local UpdateTotem = function(self, event, slot)

	local totems = self.TotemBar
	
	local totem = totems[slot]
	
	totem:SetStatusBarColor(unpack(oUF.colors.totems[slot]))

	if totem.bg.multiplier then
		local mu = totem.bg.multiplier
		local r, g, b = totem:GetStatusBarColor()
		r, g, b = r * mu, g * mu, b * mu
		totem.bg:SetVertexColor(r, g, b)
	end

	totem:SetMinMaxValues(0, 1)

	totem.ID = slot
	
	local haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(slot)

	if(haveTotem) then
		if(duration > 0) then
			totem:Show()
			totem:SetValue(1 - ((GetTime() - startTime) / duration))	

			totem:SetScript("OnUpdate",function(self,elapsed)
					total = total + elapsed
					if total >= delay then
						total = 0
						haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(self.ID)
							if ((GetTime() - startTime) == 0) then
								self:SetValue(0)
							else
								self:SetValue(1 - ((GetTime() - startTime) / duration))
							end
					end
				end)					
		else
			totem:SetScript("OnUpdate",nil)
--			totem:Hide()
			totem:SetValue(0)
		end 
	else
		totem:SetValue(0)
--		totem:Hide()
	end

	if(totems.PostUpdate) then
		return totems:PostUpdate(slot, haveTotem, name, start, duration, icon)
	end
end

local Path = function(self, ...)
	return (self.TotemBar.Override or UpdateTotem) (self, ...)
end

local Update = function(self, event)
	for i = 1, MAX_TOTEMS do
		Path(self, event, i)
	end
end

local ForceUpdate = function(element)
	return Update(element.__owner, "ForceUpdate")
end

local Enable = function(self)
	local totems = self.TotemBar
	if(totems) then
		totems.__owner = self
		totems.ForceUpdate = ForceUpdate

		if totems.Destroy then
			InitDestroy(self)
		end
		
		for i = 1, MAX_TOTEMS do
			local totem = totems[i]

			totem:SetID(i)
			
		end

		self:RegisterEvent("PLAYER_TOTEM_UPDATE", Path, true)

		TotemFrame.Show = TotemFrame.Hide
		TotemFrame:Hide()

		TotemFrame:UnregisterEvent"PLAYER_TOTEM_UPDATE"
		TotemFrame:UnregisterEvent"PLAYER_ENTERING_WORLD"
		TotemFrame:UnregisterEvent"UPDATE_SHAPESHIFT_FORM"
		TotemFrame:UnregisterEvent"PLAYER_TALENT_UPDATE"

		return true
	end
end

local Disable = function(self)
	if(self.TotemBar) then
		TotemFrame.Show = nil
		TotemFrame:Show()

		TotemFrame:RegisterEvent"PLAYER_TOTEM_UPDATE"
		TotemFrame:RegisterEvent"PLAYER_ENTERING_WORLD"
		TotemFrame:RegisterEvent"UPDATE_SHAPESHIFT_FORM"
		TotemFrame:RegisterEvent"PLAYER_TALENT_UPDATE"

		self:UnregisterEvent("PLAYER_TOTEM_UPDATE", Path)
	end
end

oUF:AddElement("TotemBar", Update, Enable, Disable)