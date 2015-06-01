----------------
--  Sora's Bag
----------------
local _, ns = ...
local cargBags = ns.cargBags

local _, SR = ...
local cfg = SR.BagConfig


----------------
--  主程序  --
----------------

-- locale mod
if GetLocale()=="zhCN" then
	BAGS = "背包"
	SORT = "整理"
	SEARCH = "搜索"
	DEPOSIT = "存放材料"
elseif GetLocale()=="zhTW" then
	BAGS = "背包"
	SORT = "整理"
	SEARCH = "搜索"
	DEPOSIT = "存放材料"
elseif GetLocale()=="enUS" then
	BAGS = "Bags"
	SORT = "Sort"
	SEARCH = "Search"
	DEPOSIT = "Deposit"
end

local Bags = cargBags:NewImplementation("Bags")
Bags:RegisterBlizzard() 

local function highlightFunction(button, match)
	button:SetAlpha(match and 1 or 0.3)
end

local f = {}
function Bags:OnInit()

	local onlyBags = function(item) return item.bagID >= 0 and item.bagID <= 4 end
	local onlyBank = function(item) return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11 end
	local onlyReagentBank = function(item) return item.bagID == -3 end
	local MyContainer = Bags:GetContainerClass()
	
	-- 玩家背包
	f.main = MyContainer:New("Main", {
			Columns = 10,
			Scale = cfg.Scale,
			Bags = "bags",
			Movable = true,
	})
	f.main:SetFilter(onlyBags, true)
	f.main:SetPoint("RIGHT", -80, 0)

	-- 银行
	f.bank = MyContainer:New("Bank", {
			Columns = 13,
			Scale = cfg.Scale,
			Bags = "bank",
			Movable = true,
	})
	f.bank:SetFilter(onlyBank, true)
	f.bank:SetPoint("CENTER", -200, 0)
	f.bank:Hide()

	-- 材料银行
	f.ReagentBank = MyContainer:New("ReagentBank", {
			Columns = 10,
			Scale = cfg.Scale,
			Bags = "ReagentBank",
			Movable = true,
	})
	f.ReagentBank:SetFilter(onlyReagentBank, true)
	f.ReagentBank:SetPoint("TOPRIGHT", f.bank, "TOPLEFT", -10, 0)
	f.ReagentBank:Hide()
	
end

function Bags:OnBankOpened()
	BankFrame:Show()
	ReagentBankFrame:Show()
	self:GetContainer("Bank"):Show()
	self:GetContainer("ReagentBank"):Show()
	DepositReagentBank()
end

function Bags:OnBankClosed()
	BankFrame:Hide()
	ReagentBankFrame:Hide()
	self:GetContainer("Bank"):Hide()
	self:GetContainer("ReagentBank"):Hide()
end


local MyButton = Bags:GetItemButtonClass()
MyButton:Scaffold("Default")

function MyButton:OnCreate()
	self:SetNormalTexture(nil)
	self:SetSize(30, 30)
	
	self.Icon:SetPoint("TOPLEFT", self, 0, 0)
	self.Icon:SetPoint("BOTTOMRIGHT", self, 0, 0)
	self.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	self.Count:SetPoint("BOTTOMRIGHT", -1, 3)
	self.Count:SetFont("Fonts\\Hooge.ttf", 9, "OUTLINE MONOCHROME") --(cfg.Font, 12, "THINOUTLINE")
	self.BottomString:SetPoint("BOTTOMRIGHT", -1, 3)
	self.BottomString:SetFont("Fonts\\Hooge.ttf", 9, "OUTLINE MONOCHROME")
	self.Border = CreateFrame("Frame", nil, self)
	self.Border:SetPoint("TOPLEFT", self.Icon, 0, 0)
	self.Border:SetPoint("BOTTOMRIGHT", self.Icon, 0, 0)
	self.Border:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1.2,
	})
	self.Border:SetBackdropBorderColor(0, 0, 0, 0)	
	
	self.BG = CreateFrame("Frame", nil, self)
	self.BG:SetPoint("TOPLEFT", self.Icon, 0, 0)
	self.BG:SetPoint("BOTTOMRIGHT", self.Icon, 0, 0)
	self.BG:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	})
	self.BG:SetBackdropColor(0.2, 0.2, 0.2, 0.5)
	self.BG:SetFrameLevel(0)

	--_G[self:GetName().."IconQuestTexture"]:SetSize(0.01, 0.01)
end

function MyButton:OnUpdate(item)
	if item.questID or item.isQuestItem then
		self.Border:SetBackdropBorderColor(1, 1, 0, 1)
	elseif item.rarity and item.rarity > 1 then
		local r, g, b = GetItemQualityColor(item.rarity)
		self.Border:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Border:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

--	背包图标模板
local BagButton = Bags:GetClass("BagButton", true, "BagButton")
function BagButton:OnCreate()
	self:GetCheckedTexture():SetVertexColor(0.3, 0.9, 0.9, 0.5)
end

-- 更新背包栏
local UpdateDimensions = function(self)
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, 6, 10, -10)
	local margin = 40
	if self.BagBar and self.BagBar:IsShown() then
		margin = margin + 45
	end
	self:SetHeight(height + margin)
end

local MyContainer = Bags:GetContainerClass()
function MyContainer:OnContentsChanged()
	self:SortButtons("bagSlot")
	-- ("grid", columns, spacing, xOffset, yOffset) or ("circle", radius (optional), xOffset, yOffset)
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, 6, 10, -10)
	self:SetSize(width + 20, height + 10)
	if self.UpdateDimensions then
		self:UpdateDimensions()
	end
end

-- 创建框体
function MyContainer:OnCreate(name, settings)
    self.Settings = settings
	self.UpdateDimensions = UpdateDimensions

	self:SetBackdrop({ 
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = cfg.edgeFile, edgeSize = 2, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	})
	self:SetBackdropColor(0,0,0,0.8)
	self:SetBackdropBorderColor(0,0,0,1)

	self:SetParent(settings.Parent or Bags)
	self:SetFrameStrata("HIGH")

	if settings.Movable then
		self:SetMovable(true)
		self:RegisterForClicks("LeftButton")
	    self:SetScript("OnMouseDown", function()
			self:ClearAllPoints() 
			self:StartMoving()
	    end)
		self:SetScript("OnMouseUp", self.StopMovingOrSizing)
	end

	settings.Columns = settings.Columns
	self:SetScale(settings.Scale)
	
	-- 信息条
	local infoFrame = CreateFrame("Button", nil, self)
	infoFrame:SetPoint("BOTTOM", -20, 0)
	infoFrame:SetWidth(200)
	infoFrame:SetHeight(32)
	
	-- 信息条插件:金币
	local tagDisplay = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
	tagDisplay:SetFontObject("NumberFontNormal")
	tagDisplay:SetFont("Fonts\\Hooge.ttf", 9, "OUTLINE MONOCHROME") --(cfg.Font, 12)
	tagDisplay:SetPoint("RIGHT", infoFrame,"RIGHT",-9,0)
	
	-- 信息条插件:搜索栏
	local searchText = infoFrame:CreateFontString(nil, "OVERLAY")
	searchText:SetPoint("LEFT", infoFrame, "LEFT", 0, 1)
	searchText:SetFont(cfg.Font, 13, "THINOUTLINE")
	searchText:SetText(SEARCH)	
	local search = self:SpawnPlugin("SearchBar", infoFrame)
	search.highlightFunction = highlightFunction
	search.isGlobal = true
	search:SetPoint("LEFT", infoFrame,"LEFT", 0, 5)
		
	if name == "Main" or name == "Bank" then
		-- 信息条插件:背包栏
		local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
		bagBar:SetSize(bagBar:LayoutButtons("grid", 7))
		bagBar:SetScale(0.8)
		bagBar.highlightFunction = highlightFunction
		bagBar.isGlobal = true
		bagBar:Hide()
		self.BagBar = bagBar
		bagBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 10, 46)
		
		-- 背包栏开关按钮
		self:UpdateDimensions()
		local bagToggle = CreateFrame("CheckButton", nil, self)
		bagToggle:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		bagToggle:SetWidth(40)
		bagToggle:SetHeight(20)
		bagToggle:SetPoint("BOTTOMLEFT",9,7)
		bagToggle:SetScript("OnClick", function()
			if(self.BagBar:IsShown()) then
				self.BagBar:Hide()
			else
				self.BagBar:Show()
			end
			self:UpdateDimensions()
		end)
		bagToggle.Text = bagToggle:CreateFontString(nil, "OVERLAY")
		bagToggle.Text:SetPoint("CENTER", bagToggle)
		bagToggle.Text:SetFont(cfg.Font, 13, "THINOUTLINE")
		bagToggle.Text:SetText(BAGS)
	
	elseif name == "ReagentBank" then
		local deposit = CreateFrame("Button", nil, self)
		deposit:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		deposit:SetWidth(55)
		deposit:SetHeight(20)
		deposit:SetPoint("BOTTOMLEFT",9,7)
		deposit:SetScript("OnClick", function()
			DepositReagentBank()
		end)
		deposit.Text = deposit:CreateFontString(nil, "OVERLAY")
		deposit.Text:SetPoint("CENTER", deposit)
		deposit.Text:SetFont(cfg.Font, 13, "THINOUTLINE")
		deposit.Text:SetText(DEPOSIT)
	end
	
	-- 背包整理按钮
	local SortButton = CreateFrame("Button", nil, self)
	SortButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	SortButton:SetWidth(40)
	SortButton:SetHeight(20)
	SortButton:SetPoint("BOTTOMRIGHT", -30, 7)
	SortButton:SetScript("OnClick", function()
		if name == "Bank" then
			SortBankBags()
		elseif name == "ReagentBank" then
			SortReagentBankBags()
		else
			SortBags()
		end
	end)
	SortButton.Text = SortButton:CreateFontString(nil, "OVERLAY")
	SortButton.Text:SetPoint("CENTER", SortButton)
	SortButton.Text:SetFont(cfg.Font, 13, "THINOUTLINE")
	SortButton.Text:SetText(SORT)

	-- 关闭按钮
	local closebutton = CreateFrame("Button", nil, self)
	closebutton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	closebutton:SetFrameLevel(30)
	closebutton:SetPoint("BOTTOMRIGHT", -7, 7)
	closebutton:SetSize(20,14)
	closebutton.Texture = closebutton:CreateFontString(nil, "OVERLAY")
	closebutton.Texture:SetPoint("CENTER", closebutton, "CENTER",1,0)
	closebutton.Texture:SetFont(cfg.Font, 14, "THINOUTLINE")
	closebutton.Texture:SetText("X")
	closebutton:SetScript("OnClick", function(self) 
		CloseAllBags() 
	end)
end