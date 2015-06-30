-- Config start
local width = 200
local slotSize = 30
local x, y = 300, -300
local anchor = "TOPLEFT"
local font = 'Fonts\\FRIZQT__.TTF'
local font_size = 16
local font_style = "THINOUTLINE"
-- Config end


local lootSlots = {}
local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, 'ARTWORK')
	fstring:SetFont(font, fsize, fstyle)
	return fstring
end

local OnClick = function(self)
	if IsModifiedClick() then
		HandleModifiedItemClick(GetLootSlotLink(self.id))
	else
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		LootFrame.selectedSlot = self.id
		LootFrame.selectedQuality = self.quality
		LootFrame.selectedItemName = self.text:GetText()
		LootSlot(self.id)
	end
end

local OnEnter = function(self)
	if LootSlotHasItem(self.id) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetLootItem(self.id);
		CursorUpdate(self);
	end
end

local OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

local CreateLootSlot = function(self, id)
	local slot = CreateFrame("Button", nil, self)
	slot:SetPoint("TOPLEFT", 3, -21.8 - (id - 1) * (slotSize + 3)) --格子最上方的位置
	slot:SetWidth(slotSize)
	slot:SetHeight(slotSize)
	slot:SetBackdrop(backdrop)
	slot:SetBackdropBorderColor(0, 0, 0)
	slot.texture = slot:CreateTexture(nil, "BORDER")
	slot.texture:SetPoint("TOPLEFT", 1, -1)
	slot.texture:SetPoint("BOTTOMRIGHT", -1, 1)
	slot.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	slot.text = CreateFS(slot, font_size, font_style)
	slot.text:SetPoint("LEFT", slot, "RIGHT", 4, 0)
	slot.text:SetPoint("RIGHT", slot:GetParent(), "RIGHT", -4, 0)
	slot.text:SetJustifyH("LEFT")
	slot.count = CreateFS(slot, font_size, font_style)
	slot.count:SetPoint("BOTTOMRIGHT", 0, 0)
	slot:SetScript("OnClick", OnClick)
	slot:SetScript("OnEnter", OnEnter)
	slot:SetScript("OnLeave", OnLeave)
	slot:Hide()
	return slot
end

local GetLootSlot = function(self, id)
	if not lootSlots[id] then 
		lootSlots[id] = CreateLootSlot(self, id)
	end
	return lootSlots[id]
end

local UpdateLootSlot = function(self, id)
	local lootSlot = GetLootSlot(self, id)
	local texture, item, quantity, quality, locked = GetLootSlotInfo(id)
	local color = ITEM_QUALITY_COLORS[quality]
	lootSlot.quality = quality
	lootSlot.id = id
	lootSlot.texture:SetTexture(texture)
	if color then lootSlot:SetBackdropBorderColor(color.r, color.g, color.b) end
	item = item and item:gsub("\n", " ") --加上这行 所有带换行字符的字符串中的'\n'换行符都被替换成了' '的空格 可以改变暴雪对于掉落的金钱封装的字符串的输出格式 
	lootSlot.text:SetText(item)
	if color then lootSlot.text:SetTextColor(color.r, color.g, color.b) end
	if quantity > 1 then
		lootSlot.count:SetText(quantity)
		lootSlot.count:Show()
	else
		lootSlot.count:Hide()
	end
	lootSlot:Show()
end

local OnEvent = function(self, event, ...)
	if event == "ADDON_LOADED" then
		local name = ...
		if name == "alLootFrames" then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetWidth(width)
			self:SetBackdrop(backdrop)
			self:SetBackdropColor(0, 0, 0, 0.5)
			self:SetBackdropBorderColor(0, 0, 0)
			self:SetPoint(anchor, UIParent, anchor, x, y)
			self:SetFrameStrata("HIGH")
			self:SetToplevel(true)
			self.title = CreateFS(self, font_size, font_style)
			self.title:SetPoint("TOPLEFT", 3, -2) --标题位置1
			self.title:SetPoint("TOPRIGHT", -16, 1) --标题位置2
			self.title:SetJustifyH("LEFT")
			self.button = CreateFrame("Button", nil, self)
			self.button:SetPoint("TOPRIGHT")
			self.button:SetSize(20, 20)
			self.button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
			self.button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
			self.button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
			self.button:SetScript("OnClick", function()
				CloseLoot()
			end)
		end
	elseif event == "LOOT_OPENED" then
		local autoLoot = ...
		self:Show()
		if UnitExists("target") and UnitIsDead("target") then
			self.title:SetText(UnitName("target"))
		else
			self.title:SetText(ITEMS)
		end
		local numLootItems = GetNumLootItems()
		self:SetHeight(numLootItems * (slotSize + 3) + 20)
		if GetCVar("lootUnderMouse") == "1" then
			local x, y = GetCursorPosition()
			x = x / self:GetEffectiveScale()
			y = y / self:GetEffectiveScale()
			local posX = x - 15
			local posY = y + 32
			if posY < 350 then
				posY = 350
			end
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", posX, posY)
			self:GetCenter()
			self:Raise()
		end
		for i = 1, numLootItems do
			UpdateLootSlot(self, i)
		end
		if not self:IsShown() then
			CloseLoot(autoLoot == 0)
		end
	elseif event == "LOOT_SLOT_CLEARED" then
		local slotId = ...
		if not self:IsShown() then return end
		if slotId > 0 then
			if lootSlots[slotId] then
				lootSlots[slotId]:Hide()
			end
		end
	elseif event == "LOOT_SLOT_CHANGED" then
		local slotId = ...
		UpdateLootSlot(self, slotId)
	elseif event == "LOOT_CLOSED" then
		StaticPopup_Hide("LOOT_BIND")
		for i, v in pairs(lootSlots) do
			v:Hide()
		end
		self:Hide()
	elseif event == "OPEN_MASTER_LOOT_LIST" then
		ToggleDropDownMenu(1, nil, GroupLootDropDown, lootSlots[LootFrame.selectedSlot], 0, 0)
	elseif event == "UPDATE_MASTER_LOOT_LIST" then
		UIDropDownMenu_Refresh(GroupLootDropDown)
	end
end


local addon = CreateFrame("frame", nil, UIParent)
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("LOOT_OPENED")
addon:RegisterEvent("LOOT_SLOT_CLEARED")
addon:RegisterEvent("LOOT_SLOT_CHANGED")
addon:RegisterEvent("LOOT_CLOSED")
addon:RegisterEvent("OPEN_MASTER_LOOT_LIST")
addon:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
LootFrame:UnregisterAllEvents()