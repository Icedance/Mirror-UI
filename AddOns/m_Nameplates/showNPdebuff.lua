local addon, ns = ...
local OVERLAY = "Interface\\TargetingFrame\\UI-TargetingFrame-Flash"
local blankTex = "Interface\\Buttons\\WHITE8x8"	
local font = GameFontNormal:GetFont()
local backdrop = {
	edgeFile =  "Interface\\AddOns\\m_Nameplates\\media\\glowTex", edgeSize = 2,
	insets = {left = 1, right = 1, top = 1, bottom = 1}}
local numChildren = -1
local frames = {}
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/0.8
local noscalemult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")
local day, hour, minute, second = 86400, 3600, 60, 1

local function scale(x)
	return (mult*math.floor(x/mult+.5))
end

local DebuffWhiteList = ns.DebuffWhiteList

local function UpdateAuraAnchors(frame)
	for i = 1, 5 do
		if frame.icons and frame.icons[i] and frame.icons[i]:IsShown() then
			if frame.icons.lastShown then 
				frame.icons[i]:SetPoint("RIGHT", frame.icons.lastShown, "LEFT", -2, 0)
			else
				frame.icons[i]:SetPoint("RIGHT",frame.icons,"RIGHT")
			end
			frame.icons.lastShown = frame.icons[i]
		end
	end
	
	frame.icons.lastShown = nil;
end

local function CreateAuraIcon(parent)
	local button = CreateFrame("Frame",nil,parent)
	button:SetScript("OnHide", function(self) UpdateAuraAnchors(self:GetParent()) end)
	button:SetWidth(25)
	button:SetHeight(25)

	button.shadow = CreateFrame("Frame", nil, button)
	button.shadow:SetFrameLevel(0)
	button.shadow:SetPoint("TOPLEFT", -noscalemult, noscalemult)
	button.shadow:SetPoint("BOTTOMRIGHT", noscalemult, -noscalemult)
	button.shadow:SetBackdrop(backdrop)
	button.shadow:SetBackdropColor( 0, 0, 0 )
	button.shadow:SetBackdropBorderColor( 0, 0, 0,.2 )
	
	button.bord = button:CreateTexture(nil, "BORDER")
	button.bord:SetTexture(0, 0, 0, 1)
	button.bord:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult,-noscalemult)
	button.bord:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult,noscalemult)
	
	button.bg2 = button:CreateTexture(nil, "ARTWORK")
	button.bg2:SetTexture(.05,.05,.05,.9)
	button.bg2:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult*2,-noscalemult*2)
	button.bg2:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult*2,noscalemult*2)	
	
	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult*2,-noscalemult*2)
	button.icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult*2,noscalemult*2)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.text = button:CreateFontString(nil, 'OVERLAY')
	button.text:SetPoint("BOTTOMRIGHT", 5, -2)
	button.text:SetJustifyH('CENTER')
	button.text:SetFont(font, 10, "THINOUTLINE")
	button.text:SetShadowColor(0, 0, 0, 0)

	button.count = button:CreateFontString(nil,"OVERLAY")
	button.count:SetFont(font,9,"THINOUTLINE")
	button.count:SetShadowColor(0, 0, 0, 0.4)
	button.count:SetPoint("BOTTOMRIGHT", button, "TOPRIGHT", 5, -5)
	return button
end


local function formatTime(s)
	if s >= day then
		return format("%dd", ceil(s / hour))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	--elseif s >= minute / 12 then
		
	end
	return floor(s)
	--return format("%.1f", s)
end

local function UpdateAuraTimer(self, elapsed)
	if not self.timeLeft then return end
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.1 then
		if not self.firstUpdate then
			self.timeLeft = self.timeLeft - self.elapsed
		else
			self.timeLeft = self.timeLeft - GetTime()
			self.firstUpdate = false
		end
		if self.timeLeft > 0 then
			local time = formatTime(self.timeLeft)
			self.text:SetText(time)
			if self.timeLeft <= 5 then
				self.text:SetTextColor(1, 0, 0)
			elseif self.timeLeft <= minute then
				self.text:SetTextColor(1, 1, 0)
			else
				self.text:SetTextColor(1, 1, 1)
			end
		else
			self.text:SetText('')
			self:SetScript("OnUpdate", nil)
			self:Hide()
		end
		self.elapsed = 0
	end
end

local function UpdateAuraIcon(button, unit, index, filter)
	local name,_,icon,count,debuffType,duration,expirationTime,_,_,_,spellID = UnitAura(unit,index,filter)
	
	if debuffType then
		button.bord:SetTexture(DebuffTypeColor[debuffType].r, DebuffTypeColor[debuffType].g, DebuffTypeColor[debuffType].b)
	else
		button.bord:SetTexture(1, 0, 0, 1)
	end

	button.icon:SetTexture(icon)
	button.firstUpdate = true
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID	
	button.timeLeft = expirationTime
	if count > 1 then 
		button.count:SetText(count)
	else
		button.count:SetText("")
	end
	if not button:GetScript("OnUpdate") then
		button:SetScript("OnUpdate", UpdateAuraTimer)
	end
	button:Show()
end

local function OnAura(frame, unit)
	if not frame.icons or not frame.unit then return end
	if frame.unit ~= unit then return end
	local i = 1
	for index = 1,5 do
		--if i > 5 then return end
		local match
		local name,_,_,_,_,duration,_,caster,_,_,spellid = UnitAura(frame.unit,index,"HARMFUL")
		if DebuffWhiteList[name] and caster == "player" and duration>0 then match = true end
		if match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:SetPoint("RIGHT",frame.icons,"RIGHT") end
			if i ~= 1 and i <= 5 then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

local function OnHide(frame)
	
	frame.unit = nil
	frame.guid = nil
	if frame.icons then
		for _,icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end	
	
	frame:SetScript("OnUpdate",nil)
end

local function CheckUnit_Guid(frames)
  for frame in pairs(frames) do
	if frame:IsShown() and frame:GetAlpha() ==1 and UnitExists("target") then  
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target") 
		break
	elseif  UnitExists("mouseover") and frame:IsShown() and frame.highlight:IsShown() then     
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
		break
	else
	    --frame.guid = nil
		frame.unit = nil
	end	
  end
end

-- local function UpdateUnit(frames,unit)
    -- for frame in pairs(frames) do
	    -- if  then
        -- end
    -- end
-- end
-- local function MatchGUID(frame, destGUID, spellID)
	-- if not frame.guid then return end		
	-- if frame.guid == destGUID then
		-- for _,icon in ipairs(frame.icons) do 
			-- if icon.spellID == spellID then 
				-- icon:Hide() 
			-- end 
		-- end
	-- end
-- end


local function CreatIcons(frame)
	if frame.icons then return end
	frame.icons = CreateFrame("Frame",nil,frame)
	frame.icons:SetPoint("BOTTOMRIGHT",frame,"TOPRIGHT", 0, 3)
	frame.icons:SetWidth(130)
	frame.icons:SetHeight(25)
	frame.icons:SetFrameLevel(frame:GetFrameLevel()+2)
	--frame:RegisterEvent("UNIT_AURA")
	--frame:HookScript("OnEvent", OnAura)	
    frame:HookScript('OnHide', OnHide)
end

local function Initial(frame)  
      -- local _, overlay = frame:GetRegions()
	  -- frame.overlay = overlay
	  CreatIcons(frame)
	  frames[frame] = true
end

-- local function ForEachPlate(functionToRun, ...)
	-- for frame in pairs(frames) do
		-- if frame:IsShown() then
			-- functionToRun(frame, ...)
		-- end
	-- end
-- end
 
local select = select
local function FindNP(...)
   for index = 1, select('#', ...) do
		local frame = select(index, ...)
		--local region = frame:GetRegions()

		if(not frames[frame] and (frame:GetName() and frame:GetName():find("NamePlate%d"))) then
		    Initial(frame)
			--frame.region = region 
		end
	end
end

CreateFrame('Frame'):SetScript('OnUpdate', function()
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		FindNP(WorldFrame:GetChildren())
	end
	CheckUnit_Guid(frames)
end)
    
-- local f = CreateFrame"Frame"
-- function f:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, ...)
	-- if event == "SPELL_AURA_REMOVED" then
		-- local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...
		
		-- if sourceGUID == UnitGUID("player") then
			-- ForEachPlate(MatchGUID, destGUID, spellID)
		-- end
	-- end
-- end   
-- f:SetScript("OnEvent", function(self, event, ...)
	-- if type(self[event] == "function") then
		-- return self[event](self, event, ...)
	-- end
-- end)
-- f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
--f:RegisterEvent("PLAYER_ENTERING_WORLD")