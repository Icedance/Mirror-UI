--A酱给的人物边框1像素美化
--[[local function UpdateGlow(button, id)
	local quality, texture, _
	local quest = _G[button:GetName().."IconQuestTexture"]
	if(id) then
		quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(id))
	end

	local glow = button.glow
	if(not glow) then
		button.glow = glow
		glow = button:CreateTexture(nil, "BACKGROUND")
		glow:SetPoint("TOPLEFT", -1.2, 1.2)
		glow:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
		glow:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		button.glow = glow
	end

	if(texture) then
		local r, g, b
		if quest and quest:IsShown() then
			r, g, b = 1, 0, 0
		else
			r, g, b = GetItemQualityColor(quality)
			if(r==1) then r, g, b = 0, 0, 0 end
		end
		glow:SetVertexColor(r, g, b)
		glow:Show()
	else
		glow:Hide()
	end
end

hooksecurefunc("BankFrameItemButton_Update", function(self)
	UpdateGlow(self, GetInventoryItemID("player", self:GetInventorySlot()))
end)

hooksecurefunc("ContainerFrame_Update", function(self)
	local name = self:GetName()
	local id = self:GetID()

	for i=1, self.size do
		local button = _G[name.."Item"..i]
		local itemID = GetContainerItemID(id, button:GetID())
		UpdateGlow(button, itemID)
	end
end)

local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", "Ranged", "Tabard",
}

local updatechar = function(self)
	if CharacterFrame:IsShown() then
		for key, slotName in ipairs(slots) do
			-- Ammo is located at 0.
			local slotID = key % 20
			local slotFrame = _G['Character' .. slotName .. 'Slot']
			local slotLink = GetInventoryItemLink('player', slotID)

			UpdateGlow(slotFrame, slotLink)
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:SetScript("OnEvent", updatechar)
CharacterFrame:HookScript('OnShow', updatechar)

local updateinspect = function(self)
	local unit = InspectFrame.unit
	if InspectFrame:IsShown() and unit then
		for key, slotName in ipairs(slots) do
			local slotID = key % 20
			local slotFrame = _G["Inspect"..slotName.."Slot"]
			local slotLink = GetInventoryItemLink(unit, slotID)
			UpdateGlow(slotFrame, slotLink)
		end
	end	
end

local g = CreateFrame("Frame")
g:RegisterEvent("ADDON_LOADED")
g:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_InspectUI" then
		InspectFrame:HookScript("OnShow", function()
			g:RegisterEvent("PLAYER_TARGET_CHANGED")
			g:RegisterEvent("INSPECT_READY")
			g:SetScript("OnEvent", updateinspect)
			updateinspect()
		end)
		InspectFrame:HookScript("OnHide", function()
			g:UnregisterEvent("PLAYER_TARGET_CHANGED")
			g:UnregisterEvent("INSPECT_READY")
			g:SetScript("OnEvent", nil)
		end)
		g:UnregisterEvent("ADDON_LOADED")
	end
end)
]]
--小呆给的染色代码


local function UpdateGlow(button, id)
	local quality, texture
	local quest = _G[button:GetName().."IconQuestTexture"]
	if id then
		quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(id))
	end

	if not button.Border then
		button.Border = CreateFrame("Frame", nil, button)
		button.Border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
		button.Border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
		button.Border:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1.2,
		})
	end

	if texture then
		local r, g, b
		if quest and quest:IsShown() then
			r, g, b = 1, 0, 0
		else
			r, g, b = GetItemQualityColor(quality)
			if r==1 then
				r, g, b = 0, 0, 0
			end
		end
		button.Border:SetBackdropBorderColor(r, g, b)
		button.Border:Show()
	else
		button.Border:Hide()
	end
end


local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", "Ranged", "Tabard",
}

local updatechar = function(self)
	if CharacterFrame:IsShown() then
		for key, slotName in ipairs(slots) do
			local slotID = key % 20
			local slotFrame = _G["Character"..slotName.."Slot"]
			local slotLink = GetInventoryItemLink("player", slotID)

			UpdateGlow(slotFrame, slotLink)
		end
	end
end

local updateinspect = function(self)
	local unit = InspectFrame.unit
	if InspectFrame:IsShown() and unit then
		for key, slotName in ipairs(slots) do
			local slotID = key % 20
			local slotFrame = _G["Inspect"..slotName.."Slot"]
			local slotLink = GetInventoryItemLink(unit, slotID)
			UpdateGlow(slotFrame, slotLink)
		end
	end	
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:RegisterEvent("UNIT_INVENTORY_CHANGED")
Event:SetScript("OnEvent", function(self, event, addon)
	if event == "UNIT_INVENTORY_CHANGED" then
		updatechar()
	elseif event == "ADDON_LOADED" then
		if addon == "Blizzard_InspectUI" then
			InspectFrame:HookScript("OnShow", function()
				Event:RegisterEvent("PLAYER_TARGET_CHANGED")
				Event:RegisterEvent("INSPECT_READY")
				Event:SetScript("OnEvent", updateinspect)
				updateinspect()
			end)
			InspectFrame:HookScript("OnHide", function()
				Event:UnregisterEvent("PLAYER_TARGET_CHANGED")
				Event:UnregisterEvent("INSPECT_READY")
				Event:SetScript("OnEvent", nil)
			end)
			Event:UnregisterEvent("ADDON_LOADED")
		end
	end
end)
CharacterFrame:HookScript("OnShow", updatechar)
