------------------------------------------------------------------------------
-- Credit Tekkub, Ray
------------------------------------------------------------------------------
-- CONFIG --------------------------------------------------------------------
------------------------------------------------------------------------------
local M = icrowMedia
local mode = 0						--0为阴影模式 1为1像素模式
local testmode = false
local font = STANDARD_TEXT_FONT			--字体
local fontsize = 14					--字号
local fontflag = "THINOUTLINE"		--描边
local buttonsize = 20				--图标大小
local barw, barh = 326, 5			--条大小
local barspacing = 4				--间距
local fscale = 1					--缩放

local myname, ns = ...

local blank = M.media.solid
local normal = M.media.statusbar
local glow = M.media.shadow

local aotuClick = CreateFrame("Frame")
aotuClick:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
aotuClick:RegisterEvent("CONFIRM_LOOT_ROLL")
aotuClick:RegisterEvent("LOOT_BIND_CONFIRM")      
aotuClick:SetScript("OnEvent", function(self, event, ...)
	for i = 1, STATICPOPUP_NUMDIALOGS do
		local frame = _G["StaticPopup"..i]
		if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND" or frame.which == "LOOT_BIND_CONFIRM") and frame:IsVisible() then 
			StaticPopup_OnClick(frame, 1) 
		end
	end
end)

local function ClickRoll(frame)
	if testmode then return end
	RollOnLoot(frame.parent.rollid, frame.rolltype)
end

local function HideTip() GameTooltip:Hide() end
local function HideTip2() GameTooltip:Hide(); ResetCursor() end

local rolltypes = {"need", "greed", "disenchant", [0] = "pass"}
local function SetTip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	GameTooltip:SetText(frame.tiptext)
	if frame:IsEnabled() == 0 then 
		GameTooltip:AddLine("|cffff3333不可用") 
	end
	for name,roll in pairs(frame.parent.rolls) do if roll == rolltypes[frame.rolltype] then GameTooltip:AddLine(name, 1, 1, 1) end end
	GameTooltip:Show()
end

local function SetItemTip(frame)
	if not frame.link then return end
	GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
	GameTooltip:SetHyperlink(frame.link)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	if IsModifiedClick("DRESSUP") then ShowInspectCursor() else ResetCursor() end
end

local function ItemOnUpdate(self)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	CursorOnUpdate(self)
end

local function LootClick(frame)
	if IsControlKeyDown() then DressUpItemLink(frame.link)
	elseif IsShiftKeyDown() then ChatEdit_InsertLink(frame.link) end
end

local cancelled_rolls = {}
local function OnEvent(frame, event, rollid)
	cancelled_rolls[rollid] = true
	if frame.rollid ~= rollid then return end

	frame.rollid = nil
	frame.time = nil
	frame:Hide()
end

local function StatusUpdate(frame)
	local t = testmode and 70 or GetLootRollTimeLeft(frame.parent.rollid)
	local perc = testmode and .7 or t / frame.parent.time
	frame.spark:SetPoint("CENTER", frame, "LEFT", perc * frame:GetWidth(), 0)
	frame:SetValue(t)
end

local function CreateRollButton(parent, ntex, ptex, htex, rolltype, tiptext, ...)
	local f = CreateFrame("Button", nil, parent)
	f:SetPoint(...)
	f:SetSize(28,28)
	f:SetNormalTexture(ntex)
	if ptex then f:SetPushedTexture(ptex) end
	f:SetHighlightTexture(htex)
	f.rolltype = rolltype
	f.parent = parent
	f.tiptext = tiptext
	f:SetScript("OnEnter", SetTip)
	f:SetScript("OnLeave", HideTip)
	f:SetScript("OnClick", ClickRoll)
	f:SetScript("OnUpdate", SetButtonAlpha)
	f:SetMotionScriptsWhileDisabled(true)
	local txt = f:CreateFontString(nil, nil)
	txt:SetFont(font, fontsize, fontflag)
	txt:SetPoint("CENTER", 0, rolltype == 2 and 1 or rolltype == 0 and -1.2 or 0)
	return f, txt
end

local function CreateRollFrame()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetSize(barw+2+buttonsize,buttonsize)
	frame:SetScale(fscale)
	frame:SetBackdropColor(0, 0, 0, .9)
	frame:SetScript("OnEvent", OnEvent)
	frame:RegisterEvent("CANCEL_LOOT_ROLL")
	frame:Hide()

	local button = CreateFrame("Button", nil, frame)
	button:SetPoint("LEFT", -buttonsize-5, 0)
	button:SetSize(buttonsize,buttonsize)
	button:SetScript("OnEnter", SetItemTip)
	button:SetScript("OnLeave", HideTip2)
	button:SetScript("OnUpdate", ItemOnUpdate)
	button:SetScript("OnClick", LootClick)
	M.CreateBG(button)
	if mode == 0 then M.CreateSD(button) end
	frame.button = button

	local tfade = frame:CreateTexture(nil, "BORDER")
	tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
	tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
	tfade:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	tfade:SetBlendMode("ADD")
	tfade:SetGradientAlpha("VERTICAL", .1, .1, .1, 0, .25, .25, .25, 0)

	local status = CreateFrame("StatusBar", nil, frame)
	status:SetSize(barw,barh)
	status:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 0)
	status:SetScript("OnUpdate", StatusUpdate)
	status:SetFrameLevel(status:GetFrameLevel()-1)
	status:SetStatusBarTexture(normal)
	status:SetStatusBarColor(.8, .8, .8, .9)
	M.CreateBG(status)
	if mode == 0 then M.CreateSD(status) end
	status.parent = frame
	frame.status = status

	local spark = frame:CreateTexture(nil, "OVERLAY")
	spark:SetWidth(14)
	spark:SetHeight(25)
	spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	spark:SetBlendMode("ADD")
	status.spark = spark

	local need, needtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Dice-Up", "Interface\\Buttons\\UI-GroupLoot-Dice-Highlight", "Interface\\Buttons\\UI-GroupLoot-Dice-Down", 1, NEED, "BOTTOMLEFT", frame.status, "BOTTOMLEFT", 5, -3)
	local greed, greedtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Coin-Up", "Interface\\Buttons\\UI-GroupLoot-Coin-Highlight", "Interface\\Buttons\\UI-GroupLoot-Coin-Down", 2, GREED, "LEFT", need, "RIGHT", 0, -1)
	local de, detext
	de, detext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-DE-Up", "Interface\\Buttons\\UI-GroupLoot-DE-Highlight", "Interface\\Buttons\\UI-GroupLoot-DE-Down", 3, ROLL_DISENCHANT, "LEFT", greed, "RIGHT", 0, 1)
	local pass, passtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", nil, "Interface\\Buttons\\UI-GroupLoot-Pass-Down", 0, PASS, "LEFT", de or greed, "RIGHT", 0, 1.4)
	frame.needbutt, frame.greedbutt, frame.disenchantbutt = need, greed, de
	frame.need, frame.greed, frame.pass, frame.disenchant = needtext, greedtext, passtext, detext

	local bind = frame:CreateFontString()
	bind:SetPoint("LEFT", pass, "RIGHT", 3, -1)
	bind:SetFont(font, fontsize, fontflag)
	frame.fsbind = bind

	local loot = frame:CreateFontString(nil, "ARTWORK")
	loot:SetFont(font, fontsize, fontflag)
	loot:SetPoint("LEFT", bind, "RIGHT", 0, 1)
	loot:SetPoint("RIGHT", frame, "RIGHT", -5, 1)
	loot:SetSize(200,10)
	loot:SetJustifyH("LEFT")
	frame.fsloot = loot

	frame.rolls = {}

	return frame
end

local anchor = CreateFrame("Button", nil, UIParent)
anchor:SetSize(350,buttonsize)
M.CreateBG(anchor)
local label = anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
label:SetAllPoints(anchor)
label:SetText("SYRoll")

anchor:SetScript("OnClick", anchor.Hide)
anchor:SetScript("OnDragStart", anchor.StartMoving)
anchor:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	self.db.x, self.db.y = self:GetCenter()
end)
anchor:SetMovable(true)
anchor:EnableMouse(true)
anchor:RegisterForDrag("LeftButton")
anchor:RegisterForClicks("RightButtonUp")
anchor:Hide()

local frames = {}

local f = CreateRollFrame() -- Create one for good measure
f:SetPoint("TOPLEFT", next(frames) and frames[#frames] or anchor, "BOTTOMLEFT", 0, -barspacing)
table.insert(frames, f)

local function GetFrame()
	for i,f in ipairs(frames) do
		if not f.rollid then return f end
	end

	local f = CreateRollFrame()
	f:SetPoint("TOPLEFT", next(frames) and frames[#frames] or anchor, "BOTTOMLEFT", 0, -barspacing)
	table.insert(frames, f)
	return f
end

local function FindFrame(rollid)
	for _,f in ipairs(frames) do
		if f.rollid == rollid then return f end
	end
end

local typemap = {[0] = 'pass', 'need', 'greed', 'disenchant'}
local function UpdateRoll(i, rolltype)
	local num = 0
	local rollid, itemLink, numPlayers, isDone = C_LootHistory.GetItem(i)

	if isDone or not numPlayers then return end

	local f = FindFrame(rollid)
	if not f then return end

	for j=1,numPlayers do
		local name, class, thisrolltype = C_LootHistory.GetPlayerInfo(i, j)
		f.rolls[name] = typemap[thisrolltype]
		if rolltype == thisrolltype then num = num + 1 end
	end

	f[typemap[rolltype]]:SetText(num)
end

local function START_LOOT_ROLL(rollid, time)
	if cancelled_rolls[rollid] then return end

	local f = GetFrame()
	f.rollid = rollid
	f.time = time
	for i in pairs(f.rolls) do f.rolls[i] = nil end
	f.need:SetText(0)
	f.greed:SetText(0)
	f.pass:SetText(0)
	f.disenchant:SetText(0)

	local texture, name, count, quality, bop, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(rollid)
	f.button:SetNormalTexture(texture)
	f.button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	f.button.link = GetLootRollItemLink(rollid)

	if canNeed then GroupLootFrame_EnableLootButton(f.needbutt) else GroupLootFrame_DisableLootButton(f.needbutt) end
	if canGreed then GroupLootFrame_EnableLootButton(f.greedbutt) else GroupLootFrame_DisableLootButton(f.greedbutt) end
	if canDisenchant then GroupLootFrame_EnableLootButton(f.disenchantbutt) else GroupLootFrame_DisableLootButton(f.disenchantbutt) end

	SetDesaturation(f.needbutt:GetNormalTexture(), not canNeed)
	SetDesaturation(f.greedbutt:GetNormalTexture(), not canGreed)
	SetDesaturation(f.disenchantbutt:GetNormalTexture(), not canDisenchant)

	f.fsbind:SetText(bop and "BoP" or "BoE")
	f.fsbind:SetVertexColor(bop and 1 or .3, bop and .3 or 1, bop and .1 or .3)

	local color = ITEM_QUALITY_COLORS[quality]
	f.fsloot:SetVertexColor(color.r, color.g, color.b)
	f.fsloot:SetText(name)

	f.status:SetStatusBarColor(color.r, color.g, color.b, .7)

	f.status:SetMinMaxValues(0, time)
	f.status:SetValue(time)

	f:SetPoint("CENTER", WorldFrame, "CENTER")
	f:Show()
end

local function LOOT_HISTORY_ROLL_CHANGED(rollindex, playerindex)
	local _, _, rolltype = C_LootHistory.GetPlayerInfo(rollindex, playerindex)
	UpdateRoll(rollindex, rolltype)
end

anchor:RegisterEvent("ADDON_LOADED")
anchor:SetScript("OnEvent", function(frame, event, addon)
	if addon ~= "SYRoll" then return end

	anchor:UnregisterEvent("ADDON_LOADED")
	anchor:RegisterEvent("START_LOOT_ROLL")
	anchor:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED")
	UIParent:UnregisterEvent("START_LOOT_ROLL")
	UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")

	anchor:SetScript("OnEvent", function(frame, event, ...)
		if event == "LOOT_HISTORY_ROLL_CHANGED" then return LOOT_HISTORY_ROLL_CHANGED(...)
		else return START_LOOT_ROLL(...) end
	end)

	if not SYRollDB then SYRollDB = {} end
	anchor.db = SYRollDB
	anchor:SetPoint("CENTER", UIParent, anchor.db.x and "BOTTOMLEFT" or "CENTER", anchor.db.x or 0, anchor.db.y or 300)
end)

SlashCmdList["SYROLL"] = function() if anchor:IsVisible() then anchor:Hide() else anchor:Show() end end
SLASH_SYROLL1 = "/syroll"

SlashCmdList["LFrames"] = function(msg)
	if not testmode then
		testmode = true
		local f = GetFrame()
		local texture = select(10, GetItemInfo(32837))
		f.button:SetNormalTexture(texture)
		local nt = f.button:GetNormalTexture()
		if nt then nt:SetTexCoord(.08, .92, .08, .92) end
		f.fsloot:SetVertexColor(ITEM_QUALITY_COLORS[5].r, ITEM_QUALITY_COLORS[5].g, ITEM_QUALITY_COLORS[5].b)
		f.fsloot:SetText(GetItemInfo(32837))
		f.status:SetMinMaxValues(0, 100)
		f.status:SetValue(70)
		f.status:SetStatusBarColor(ITEM_QUALITY_COLORS[5].r, ITEM_QUALITY_COLORS[5].g, ITEM_QUALITY_COLORS[5].b)
		f:Show()
	else
		f:Hide()
		testmode = false
	end
end
SLASH_LFrames1 = "/lframes"