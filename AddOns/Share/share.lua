--缩写重置命令
SlashCmdList['RELOAD'] = function() ReloadUI() end

SLASH_RELOAD1 = '/rl'

--超过一定事件自动回收内存
local eventcount = 0
local a = CreateFrame("Frame")
a:RegisterAllEvents()
a:SetScript("OnEvent", function(self, event)
   eventcount = eventcount + 1
   if InCombatLockdown() then return end
   if eventcount > 6000 or event == "PLAYER_ENTERING_WORLD" then
      collectgarbage("collect")
      eventcount = 0
   end
end)

--成就自动截图
local function TakeScreen(delay, func, ...)
local waitTable = {}
local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
   waitFrame:SetScript("onUpdate", function (self, elapse)
      local count = #waitTable
      local i = 1
      while (i <= count) do
         local waitRecord = tremove(waitTable, i)
         local d = tremove(waitRecord, 1)
         local f = tremove(waitRecord, 1)
         local p = tremove(waitRecord, 1)
         if (d > elapse) then
            tinsert(waitTable, i, {d-elapse, f, p})
            i = i + 1
         else
            count = count - 1
            f(unpack(p))
         end
      end
   end)
   tinsert(waitTable, {delay, func, {...} })
end
local function OnEvent(...)
   TakeScreen(1, Screenshot)
end
local AchScreen = CreateFrame("Frame")
AchScreen:RegisterEvent("ACHIEVEMENT_EARNED")
AchScreen:SetScript("OnEvent", OnEvent)

--修正BLZ点击掉落的一个报错
hooksecurefunc("EncounterJournal_LoadUI", function()
    function EncounterJournal_Loot_OnUpdate(self)
        if GameTooltip:IsOwned(self) then
            if IsModifiedClick("COMPAREITEMS") or
                    (GetCVarBool("alwaysCompareItems") and not GameTooltip:IsEquippedItem()) then
                GameTooltip_ShowCompareItem();
            else
                ShoppingTooltip1:Hide();
                ShoppingTooltip2:Hide();
                ShoppingTooltip3:Hide();
            end

            if IsModifiedClick("DRESSUP") then
                ShowInspectCursor();
            else
                ResetCursor();
            end
        end
    end
end)

--AH搜索上货和直接邮寄物品
local  bag, slot
hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
      bag, slot = self:GetParent():GetID(), self:GetID()
      local tLink = GetContainerItemLink(bag, slot)
      local tName = GetItemInfo(tLink) 
        if (button == 'LeftButton') and (IsAltKeyDown()) and AuctionFrame and AuctionFrame:IsVisible() then
            AuctionFrameTab3:Click()
             PickupContainerItem(bag, slot)
             ClickAuctionSellItemButton()
             ClearCursor()
        elseif (button == 'LeftButton') and (IsShiftKeyDown()) and AuctionFrame and AuctionFrame:IsVisible() then
            if tLink then 
              AuctionFrameTab1:Click()
              BrowseName:SetText(tName)
              AuctionFrameBrowse_Search()   
            end
--        elseif ((button == 'LeftButton') and (IsAltKeyDown()) and SendMailFrame:IsVisible() and not CursorHasItem() ) then
--                 PickupContainerItem(bag, slot);
--                ClickSendMailItemButton();
--                return;
        end   
end)

local f =CreateFrame('Frame')
f:SetScript("OnEvent", function(self, event)
if event == 'AUCTION_HOUSE_SHOW' then
  OpenAllBags()
elseif event == 'AUCTION_HOUSE_CLOSED' then
  CloseAllBags()
end
end)
f:RegisterEvent('AUCTION_HOUSE_SHOW')
f:RegisterEvent('AUCTION_HOUSE_CLOSED')

--[[WorldStateUpFrame Mover by Sniffles 移动战场信息标签(包括返回墓地标签)

Credits: 
blooblahguy (move func) 
tekkub (wow ui source) 
--]] 
-- Config 
local font = [[Fonts\ARIALN.ttf]] -- FONT 
local fsize = 16 -- FONTSIZE 
local _G = _G 
local UIParent = UIParent 
local function dummy() end 

local function WorldStateAlwaysUpFrame_Update()  
_G["WorldStateAlwaysUpFrame"]:ClearAllPoints() 
_G["WorldStateAlwaysUpFrame"].ClearAllPoints = dummy 
_G["WorldStateAlwaysUpFrame"]:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT", -180, -30) --這裡修改位置，經測試.. 回到墓地那個玩意兒也受這個影響 
_G["WorldStateAlwaysUpFrame"].SetPoint = dummy 
local alwaysUpShown = 1  
for i = alwaysUpShown, NUM_ALWAYS_UP_UI_FRAMES do  
_G["AlwaysUpFrame"..i.."Text"]:SetFont(font, fsize) 
end 
end 
hooksecurefunc("WorldStateAlwaysUpFrame_Update", WorldStateAlwaysUpFrame_Update) 

  --[[ 任务追踪移动
  -- // rObjectiveTrackerMover
  -- // zork - 2014

  -----------------------------
  -- VARIABLES
  -----------------------------
  
  local an, at = ...
  local unpack = unpack  
  local ObjectiveTrackerFrame = ObjectiveTrackerFrame

  local frame = CreateFrame("Frame")
  
  local cfg = {}
  cfg.y = -75
 
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function AdjustSetPoint(self,...)
    local a1,af,a2,x,y = ...
    if a1 and af == "MinimapCluster" and y ~= cfg.y then    
      if not InCombatLockdown() then
        self:SetPoint(a1,af,a2,x,cfg.y)
      else
        frame.point = {a1,af,a2,x,cfg.y}
        frame:RegisterEvent("PLAYER_REGEN_ENABLED")
      end      
    end
  end 

  frame:SetScript("OnEvent", function(self,event)
    self:UnregisterEvent(event)
    if event == "PLAYER_LOGIN" then
      self.point = {ObjectiveTrackerFrame:GetPoint()}      
      hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", AdjustSetPoint)    
    end
    if not InCombatLockdown() then
      ObjectiveTrackerFrame:SetPoint(unpack(self.point))
    end
  end)
  
  frame:RegisterEvent("PLAYER_LOGIN")]]

--[[ 副本内自动收起任务追踪  
local autocollapse = CreateFrame("Frame") 
autocollapse:RegisterEvent("ZONE_CHANGED_NEW_AREA") 
autocollapse:RegisterEvent("PLAYER_ENTERING_WORLD") 
autocollapse:SetScript("OnEvent", function(self) 
if IsInInstance() then 
ObjectiveTrackerFrame.userCollapsed = true 
ObjectiveTracker_Collapse() 
else 
ObjectiveTrackerFrame.userCollapsed = nil 
ObjectiveTracker_Expand() 
end 
end)]]

-- Remove standard Boss frames 移除系统自带BOSS框架
for i = 1,MAX_BOSS_FRAMES do
   local t_boss = _G["Boss"..i.."TargetFrame"]
   t_boss:UnregisterAllEvents()
   t_boss.Show = dummy
   t_boss:Hide()
   _G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
   _G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
end
--Mapcoordtext(大地图显示坐标(自己&目标))
WorldMapButton:HookScript("OnUpdate", function(self) 
   if not self.coordText then 
      self.coordText = WorldMapFrameCloseButton:CreateFontString(nil, "OVERLAY", "GameFontGreen") 
      self.coordText:SetPoint("BOTTOM", self, "BOTTOM", 0, 6) 
   end 
   local px, py = GetPlayerMapPosition("player") 
   local x, y = GetCursorPosition() 
   local width, height, scale = self:GetWidth(), self:GetHeight(), self:GetEffectiveScale() 
   local centerX, centerY = self:GetCenter() 
   x, y = (x/scale - (centerX - (width/2))) / width, (centerY + (height/2) - y/scale) / height 
   if px == 0 and py == 0 and (x > 1 or y > 1 or x < 0 or y < 0) then 
      self.coordText:SetText("") 
   elseif px == 0 and py == 0 then 
      self.coordText:SetText(format("当前: %d, %d", x*100, y*100)) 
   elseif x > 1 or y > 1 or x < 0 or y < 0 then 
      self.coordText:SetText(format("玩家: %d, %d", px*100, py*100)) 
   else 
      self.coordText:SetText(format("玩家: %d, %d 当前: %d, %d", px*100, py*100, x*100, y*100)) 
   end 
end)
 --自动卖灰
local frame = CreateFrame('Frame') 
frame:RegisterEvent('MERCHANT_SHOW') 
frame:SetScript('OnEvent', function (frame, event, ...) 
  if event == 'MERCHANT_SHOW' then 
    local link 
    for bag = 0, 4 do 
      for slot = 0, GetContainerNumSlots(bag) do 
        link = GetContainerItemLink(bag, slot) 
        if link and select(3, GetItemInfo(link)) == 0 then 
          ShowMerchantSellCursor(1) 
          UseContainerItem(bag, slot) 
        end 
      end 
    end 
  end 
end)



--隐藏系统自带团队框体
--local frame = CompactRaidFrameManager
   --frame:UnregisterAllEvents()
   --frame.Show = function() end
   --frame:Hide()
   
   --local frame = CompactRaidFrameContainer
   --frame:UnregisterAllEvents()
   --frame.Show = function() end
   --frame:Hide() 

-- make alt power moveable and scale it down 移动BOSS特殊能量条(音波值/腐化值等)
_G["PlayerPowerBarAlt"]:HookScript("OnShow", function(self) self:ClearAllPoints() self:SetPoint("BOTTOM", 60, 120) self.SetPoint = function() end end)

--[[PlayerPowerBarAlt:SetScale(0.7)
PlayerPowerBarAlt:SetMovable(true)
PlayerPowerBarAlt:SetUserPlaced(true)
PlayerPowerBarAlt:SetFrameStrata("HIGH")
PlayerPowerBarAlt:SetScript("OnMouseDown", function()
	if (IsAltKeyDown()) then
			PlayerPowerBarAlt:ClearAllPoints()
			PlayerPowerBarAlt:StartMoving()
	end
end)

local p = PlayerPowerBarAlt
local a = CreateFrame("Frame", nil, UIParent)
a:SetSize(50,50)
a:SetPoint("BOTTOM", p, "BOTTOM", 400, 110)
a:EnableMouse(true)
p:SetMovable(true)
p:SetUserPlaced(true)
p:SetSize(30,30)
a:SetScript("OnMouseDown", function() p:StartMoving() end)
a:SetScript("OnMouseUp", function() p:StopMovingOrSizing() end)
a.t = a:CreateTexture()
a.t:SetAllPoints()
a.t:SetTexture(0, 0.5, 1)   -- the finest light blue you've ever seen
a.t:SetAlpha(0.8)
a:Hide()

SlashCmdList["MOVEPOWERBARALT"]=function() a[a:IsShown() and "Hide" or "Show"](a) end
SLASH_MOVEPOWERBARALT1 = "/mpba"
]]
--alt批量购买
PlayerPowerBarAlt:SetScript('OnMouseUp', function(self, button)
PlayerPowerBarAlt:StopMovingOrSizing()
end)

local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
   if ( IsAltKeyDown() ) then
      local itemLink = GetMerchantItemLink(self:GetID())
      if not itemLink then return end
      local maxStack = select(8, GetItemInfo(itemLink))
      if ( maxStack and maxStack > 1 ) then
         BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
      end
   end
   savedMerchantItemButton_OnModifiedClick(self, ...)
end

--始终显示战斗信息
SetCVar("CombatLogPeriodicSpells",1)
	SetCVar("PetMeleeDamage",1)
	SetCVar("CombatDamage",1)
	--SetCVar("CombatHealing",0)


--聊天框字体描边
for i = 1, 7 do
   local chat = _G["ChatFrame"..i]
   local font, size = chat:GetFont()
   chat:SetFont(font, size, "THINOUTLINE")
   chat:SetShadowOffset(0, 0)
   chat:SetShadowColor(0, 0, 0, 0)
end

--伤害数字字体大小
--CombatTextFont:SetFont(font,100)

--显示谁在点小地图
--[[Minimap:SetScript("OnMouseUp", function(self, btn)
   if btn == "RightButton" then
      ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "MiniMapTracking", 0, -5)
      PlaySound("igMainMenuOptionCheckBoxOn")
   else
      Minimap_OnClick(self)
   end
end)
]]
--[[
--聊天内容缩写
--拾取 你拾取了：霜紋布。→+霜紋布 拾取金錢 你拾取了2銅幣。→+2O
LOOT_ITEM = "%s + %s"
LOOT_ITEM_MULTIPLE = "%s + % sx%d"
LOOT_ITEM_SELF = "你 + %s"
LOOT_ITEM_SELF_MULTIPLE = "你 + %s x%d"
LOOT_ITEM_PUSHED_SELF = "你 + %s"
LOOT_ITEM_PUSHED_SELF_MULTIPLE = "你 + %s x%d"
--LOOT_MONEY = "|cff00a956+|r |cffffffff%s"
--YOU_LOOT_MONEY = "|cff00a956+|r |cffffffff%s"
--LOOT_MONEY_SPLIT = "|cff00a956+|r |cffffffff%s"

LOOT_ROLL_ALL_PASSED = "全体放弃 %s"
LOOT_ROLL_PASSED_AUTO = "%s 放弃 %s (auto)"
LOOT_ROLL_PASSED_SELF_AUTO = "放弃 %s (auto)"
LOOT_ROLL_WON = "%s 赢得 %s"
LOOT_ROLL_YOU_WON = "你赢得 %s"
LOOT_ROLL_WON_NO_SPAM_DE = "%1$s 赢得 %3$s |cff818181(de %2$d)|r"
LOOT_ROLL_WON_NO_SPAM_NEED = "%1$s 赢得 %3$s |cff818181(need %2$d)|r"
LOOT_ROLL_WON_NO_SPAM_GREED = "%1$s 赢得 %3$s |cff818181(greed %2$d)|r"
LOOT_ROLL_YOU_WON_NO_SPAM_DE = "你赢得 %2$s |cff818181(de %1$d)|r"
LOOT_ROLL_YOU_WON_NO_SPAM_NEED = "你赢得 %2$s |cff818181(need %1$d)|r"
LOOT_ROLL_YOU_WON_NO_SPAM_GREED = "你赢得 %2$s |cff818181(greed %1$d)|r"

COPPER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t"
SILVER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t"
GOLD_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t"

--- 提示AH賣出
ERR_AUCTION_SOLD_S = "|cff1eff00%s|r |cffffffff已卖出.|r"

--- 專業技能提升 [你的附魔技能提升到102→附魔 102]
ERR_SKILL_UP_SI = "%s→ |cff1eff00%d|r"

--- 改變頻道提示 [加入頻道→+][離開頻道→-][改變頻道→=]
CHAT_YOU_CHANGED_NOTICE = "=|Hchannel:%d|h[%s]|h";
CHAT_YOU_CHANGED_NOTICE_BN = "=|Hchannel:CHANNEL:%d|h[%s]|h";
CHAT_YOU_JOINED_NOTICE = "+|Hchannel:%d|h[%s]|h";
CHAT_YOU_JOINED_NOTICE_BN = "+|Hchannel:CHANNEL:%d|h[%s]|h";
CHAT_YOU_LEFT_NOTICE = "-|Hchannel:%d|h[%s]|h";
CHAT_YOU_LEFT_NOTICE_BN = "-|Hchannel:CHANNEL:%d|h[%s]|h";

--- 上下線提示，下線紅色上線綠色
BN_INLINE_TOAST_FRIEND_OFFLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s|cffFF7F50离线|r."
BN_INLINE_TOAST_FRIEND_ONLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s|cff00C957上线|r."

ERR_FRIEND_OFFLINE_S = "%s|cffFF7F50离线|r."
ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h|cff00C957上线|r."

--- 獲得成就
ACHIEVEMENT_BROADCAST = "%s获得%s!"

--聊天复制

local _AddMessage = ChatFrame1.AddMessage
local _SetItemRef = SetItemRef
local blacklist = {
	[ChatFrame2] = true,
}

local ts = "|cff68ccef|HyCopy|h%s|h|r %s"
local AddMessage = function(self, text, ...)
	if type(text) == "string"then
		text = format(ts, ">", text)
	end
	return _AddMessage(self, text, ...)
end

for i=1, NUM_CHAT_WINDOWS do
	local chatframe = _G["ChatFrame"..i]
	if not blacklist[chatframe] then
		chatframe.AddMessage = AddMessage
	end
end

local MouseIsOver = function(frame)
	local s = frame:GetParent():GetEffectiveScale()
	local x, y = GetCursorPosition()
	x = x / s
	y = y / s

	local left = frame:GetLeft()
	local right = frame:GetRight()
	local top = frame:GetTop()
	local bottom = frame:GetBottom()

	if not left then
		return
	end

	if ((x > left and x < right) and (y > bottom and y < top)) then
		return 1
	else
		return
	end
end

local borderManipulation = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)
		if (obj:GetObjectType() == "FontString" and MouseIsOver(obj)) then
			return obj:GetText()
		end
	end
end

local eb = ChatFrame1EditBox
SetItemRef = function(link, text, button, ...)

	if link:sub(1, 5) ~= "yCopy" then
	return _SetItemRef(link, text, button, ...) end

	local text = borderManipulation(SELECTED_CHAT_FRAME:GetRegions())
	if text then
		text = text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
		text = text:gsub("|H.-|h(.-)|h", "%1")

		eb:Insert(text)
		eb:Show()
		eb:HighlightText()
		eb:SetFocus()
	end
end
]]
--CancelAuc一键取消拍卖
--[[local g = getfenv(0)

local function Print(aucid)
    DEFAULT_CHAT_FRAME:AddMessage("已取消拍卖物品 "..GetAuctionItemLink("owner", aucid))
end

for i = 1, 9 do
    local aucbutton = g["AuctionsButton"..i]
    local Button_OnClick = aucbutton:GetScript("OnClick")
    aucbutton:SetScript("OnClick", function (self, ...) 
        if IsAltKeyDown() then
            local aucid = self:GetID() + FauxScrollFrame_GetOffset(AuctionsScrollFrame)
            CancelAuction(aucid)
            Print(aucid)
        else return Button_OnClick(self, ...)
        end
    end)
    local aucitem = g["AuctionsButton"..i.."Item"]
    local Item_OnClick = aucitem:GetScript("OnClick")
    aucitem:SetScript("OnClick", function(self, ...) 
        if IsAltKeyDown() then
            local aucid = self:GetParent():GetID() + FauxScrollFrame_GetOffset(AuctionsScrollFrame) 
            CancelAuction(aucid)
            Print(aucid)
        else return Item_OnClick(self, ...)
        end
    end)
end--]]


--全屏幕渐隐

--水月的代码，仅限于alt+Z后的出现
--[[lpanels:ApplyLayout(nil, "View")

UIParent:SetScript("OnShow", function() 
	UIFrameFadeIn(UIParent, 1, 0, 1) 
end)--]]
--Nea的代码
--[[local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function(self, elasped)
	local Timer = 0
	UIParent:SetAlpha(0)
	self:SetScript("OnUpdate", function(self, elasped)
		Timer = Timer + elasped
		if Timer > 2 then
			UIFrameFadeIn(UIParent, 2, 0, 1)
			self:SetScript("OnUpdate", nil)
		end
	end)
end)
UIParent:HookScript("OnShow", function(self, elasped)
	UIFrameFadeIn(UIParent, 2, 0, 1)
end)
]]
