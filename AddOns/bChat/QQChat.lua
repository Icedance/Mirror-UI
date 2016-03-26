
  -- // rChat
  -- // zork - 2012

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  -----------------------------
  -- CONFIG
  -----------------------------

-- 隐藏聊天框背景 (true/false) (隐藏/显示)
local hide_chatframe_backgrounds = true
-- 隐藏聊天标签背景 (true/false) (隐藏/显示)
local hide_chattab_backgrounds = true
-- 输入框边框颜色/透明度 (a是透明度,白色请改成 {r=1, g=1, b=1, a=0.8})
local BorderColor = {r=0, g=0, b=0, a=0}


  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = ns.cfg


  --add more chat font sizes
  for i = 1, 23 do
    CHAT_FONT_HEIGHTS[i] = i+7
  end

-- 打开输入框回到上次对话 (1/0 = On/Off)
ChatTypeInfo["SAY"].sticky  = 1; -- 说
ChatTypeInfo["PARTY"].sticky 	= 1; -- 小队
ChatTypeInfo["GUILD"].sticky 	= 1; -- 公会
ChatTypeInfo["WHISPER"].sticky 	= 1; -- 密语
ChatTypeInfo["BN_WHISPER"].sticky   = 1; -- 战网好友密语
ChatTypeInfo["RAID"].sticky 	= 1; -- 团队
ChatTypeInfo["OFFICER"].sticky 	= 1; -- 官员
ChatTypeInfo["CHANNEL"].sticky 	= 1; -- 频道

-- 聊天标签
CHAT_FRAME_FADE_OUT_TIME = 0 -- 聊天窗口褪色时间
CHAT_TAB_HIDE_DELAY = 0      -- 聊天标签弹出延时
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.6   -- 鼠标停留时,标签透明度
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0       -- 鼠标离开时,标签透明度 (修改这里能一直显示)
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1   -- 鼠标停留时,选择标签时透明度
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0     -- 鼠标离开时,选择标签时透明度
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 0.6 -- 鼠标停留时,标签闪动时透明度
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0     -- 鼠标离开时,标签闪动时透明度


  --don't cut the toastframe
  --BNToastFrame:SetClampedToScreen(true)
  --BNToastFrame:SetClampRectInsets(-15,15,15,-15)

  --ChatFontNormal:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
  --ChatFontNormal:SetShadowOffset(1,-1)
  --ChatFontNormal:SetShadowColor(0,0,0,0.6)

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function skinChat(self)
    if not self or (self and self.skinApplied) then return end

    local name = self:GetName()

    --chat frame resizing
    self:SetClampRectInsets(0, 0, 0, 0)
    self:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
    self:SetMinResize(100, 50)

    --fix the buttonframe
    local frame = _G[name.."ButtonFrame"]
    frame:Hide()
    frame:HookScript("OnShow", frame.Hide)

    --editbox skinning
    _G[name.."EditBoxLeft"]:Hide()
    _G[name.."EditBoxMid"]:Hide()
    _G[name.."EditBoxRight"]:Hide()
    local eb = _G[name.."EditBox"]
    eb:SetAltArrowKeyMode(false)
    eb:ClearAllPoints()
    eb:SetPoint("BOTTOM",self,"TOP",0,22)
    eb:SetPoint("LEFT",self,-5,0)
    eb:SetPoint("RIGHT",self,10,0)
    ChatFrame1EditBoxLanguage:SetPoint('LEFT', editbox, 'RIGHT', -5, 0) --输入框语言按钮位置

    self.skinApplied = true
  end

  -----------------------------
  -- CALL
  -----------------------------
local tabs = {"Left", "Middle", "Right", "SelectedLeft", "SelectedRight",
    "SelectedMiddle",}--, "Glow"
    
  --chat skinning
  for i = 1, NUM_CHAT_WINDOWS do
  
-- 聊天标签背景
if hide_chattab_backgrounds then
    for index, value in pairs(tabs) do
        local texture = _G['ChatFrame'..i..'Tab'..value]
        texture:SetTexture(nil)
    end
end
-- 聊天框背景
if hide_chatframe_backgrounds then
    for g = 1, #CHAT_FRAME_TEXTURES do
     _G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:SetTexture(nil)
     end
end
    skinChat(_G["ChatFrame"..i])
  end

  --skin temporary chats
  hooksecurefunc("FCF_OpenTemporaryWindow", function()
    for _, chatFrameName in pairs(CHAT_FRAMES) do
      local frame = _G[chatFrameName]
      if (frame.isTemporary) then
        skinChat(frame)
      end
    end
  end)

  --combat log custom hider
  local function fixStuffOnLogin()
    for i = 1, NUM_CHAT_WINDOWS do
      local name = "ChatFrame"..i
      local tab = _G[name.."Tab"]
      --tab:SetAlpha(cfg.selectedTabAlpha)
    end
    CombatLogQuickButtonFrame_Custom:HookScript("OnShow", CombatLogQuickButtonFrame_Custom.Hide)
    CombatLogQuickButtonFrame_Custom:Hide()
    CombatLogQuickButtonFrame_Custom:SetHeight(0)
  end

  local a = CreateFrame("Frame")
  a:RegisterEvent("PLAYER_LOGIN")
  a:SetScript("OnEvent", fixStuffOnLogin)
  
  
  
  
  
  
  
  
  
  
  FloatingChatFrame_OnMouseScroll = function(self, dir)
  if(dir > 0) then
    if(IsShiftKeyDown()) then
      self:ScrollToTop()
    else
      self:ScrollUp()
    end
  else
    if(IsShiftKeyDown()) then
      self:ScrollToBottom()
    else
      self:ScrollDown()
    end
  end
end













  ------------====================自定义频道可在(95行-183行)修改==================------------

--精简公共频道 (true/false) (精简/不精简)
local ShortChannel = true

----==============================精简聊天频道,可修改汉字自定义==========================----
if (GetLocale() == "zhCN") then

  --公会
  CHAT_GUILD_GET = "|Hchannel:GUILD|h[公会]|h %s: "
  CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[官员]|h %s: "
    
  --团队
  CHAT_RAID_GET = "|Hchannel:RAID|h[团队]|h %s: "
  CHAT_RAID_WARNING_GET = "[通知] %s: "
  CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[团长]|h %s: "
  
  --队伍
  CHAT_PARTY_GET = "|Hchannel:PARTY|h[队伍]|h %s: "
  CHAT_PARTY_LEADER_GET =  "|Hchannel:PARTY|h[队长]|h %s: "
  CHAT_PARTY_GUIDE_GET =  "|Hchannel:PARTY|h[向导]:|h %s: "

  --战场
  CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|h[战场]|h %s: "
  CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|h[领袖]|h %s: "
  
  --密语  
  CHAT_WHISPER_INFORM_GET = "发送给%s: "
  CHAT_WHISPER_GET = "%s悄悄话: "
  CHAT_BN_WHISPER_INFORM_GET = "发送给%s "
  CHAT_BN_WHISPER_GET = "悄悄话%s "
  
  --说 / 喊
  CHAT_SAY_GET = "%s: "
  CHAT_YELL_GET = "%s: "  

  --flags
  CHAT_FLAG_AFK = "[暂离] "
  CHAT_FLAG_DND = "[勿扰] "
  CHAT_FLAG_GM = "[GM] "

elseif GetLocale() == "zhTW" then
  --公会
  CHAT_GUILD_GET = "|Hchannel:GUILD|h[公會]|h %s: "
  CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[官員]|h %s: "
    
  --团队
  CHAT_RAID_GET = "|Hchannel:RAID|h[團隊]|h %s: "
  CHAT_RAID_WARNING_GET = "[通知] %s: "
  CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[團長]|h %s: "
  
  --队伍
  CHAT_PARTY_GET = "|Hchannel:PARTY|h[隊伍]|h %s: "
  CHAT_PARTY_LEADER_GET =  "|Hchannel:PARTY|h[隊長]|h %s: "
  CHAT_PARTY_GUIDE_GET =  "|Hchannel:PARTY|h[向導]:|h %s: "

  --战场
  CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|h[戰場]|h %s: "
  CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|h[領袖]|h %s: "
  
  --密语  
  CHAT_WHISPER_INFORM_GET = "發送給%s: "
  CHAT_WHISPER_GET = "%s悄悄話: "
  CHAT_BN_WHISPER_INFORM_GET = "發送給%s "
  CHAT_BN_WHISPER_GET = "悄悄話%s "
  
  --说 / 喊
  CHAT_SAY_GET = "%s: "
  CHAT_YELL_GET = "%s: "  

  --flags
  CHAT_FLAG_AFK = "[暫離] "
  CHAT_FLAG_DND = "[勿擾] "
  CHAT_FLAG_GM = "[GM] "
  
else
  --guild
  CHAT_GUILD_GET = "|Hchannel:GUILD|hG|h %s "
  CHAT_OFFICER_GET = "|Hchannel:OFFICER|hO|h %s "
    
  --raid
  CHAT_RAID_GET = "|Hchannel:RAID|hR|h %s "
  CHAT_RAID_WARNING_GET = "RW %s "
  CHAT_RAID_LEADER_GET = "|Hchannel:RAID|hRL|h %s "
  
  --party
  CHAT_PARTY_GET = "|Hchannel:PARTY|hP|h %s "
  CHAT_PARTY_LEADER_GET =  "|Hchannel:PARTY|hPL|h %s "
  CHAT_PARTY_GUIDE_GET =  "|Hchannel:PARTY|hPG|h %s "

  --instance
  CHAT_INSTANCE_CHAT_GET = "|Hchannel:Battleground|hI.|h %s: "
  CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
  
  --battle
  CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|hB|h %s "
  CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|hBL|h %s " 
  
  --whisper  
  CHAT_WHISPER_INFORM_GET = "to %s "
  CHAT_WHISPER_GET = "from %s "
  CHAT_BN_WHISPER_INFORM_GET = "to %s "
  CHAT_BN_WHISPER_GET = "from %s "
  
  --say / yell
  CHAT_SAY_GET = "%s "
  CHAT_YELL_GET = "%s "
  
  --flags
  CHAT_FLAG_AFK = "[AFK] "
  CHAT_FLAG_DND = "[DND] "
  CHAT_FLAG_GM = "[GM] "
end

--================================公共频道和自定义频道精简================================--
local gsub = _G.string.gsub
local newAddMsg = {}
local chn, rplc
  if (GetLocale() == "zhCN") then  ---国服
	rplc = {
		"[%1综合]",  
		"[%1交易]",   
		"[%1防务]",   
		"[%1组队]",   
		"[%1世界]",   
		"[%1招募]",
                "[%1世界]",  
                "[%1自定义]",    -- 自定义频道缩写请自行修改
	}
        end

  if (GetLocale() == "zhTW") then  ---台服
	rplc = {
		"[%1綜合]",  
		"[%1交易]",   
		"[%1防務]",   
		"[%1組隊]",   
		"[%1世界]",   
		"[%1招募]",
                "[%1自定义]",    -- 自定义频道缩写请自行修改
	}
        end
        
	chn = {
		"%[%d+%. General.-%]",
		"%[%d+%. Trade.-%]",
		"%[%d+%. LocalDefense.-%]",
		"%[%d+%. LookingForGroup%]",
		"%[%d+%. WorldDefense%]",
		"%[%d+%. GuildRecruitment.-%]",
                "%[%d+%. BigFootChannel.-%]",
                "%[%d+%. CustomChannel.-%]",       -- 自定义频道英文名随便填写
	}

---------------------------------------- 国服 ---------------------------------------------
	local L = GetLocale()
	if L == "zhCN" then
		chn[1] = "%[%d+%. 综合.-%]"
		chn[2] = "%[%d+%. 交易.-%]"
		chn[3] = "%[%d+%. 本地防务.-%]"
		chn[4] = "%[%d+%. 寻求组队%]"
                chn[5] = "%[%d+%. 世界防务%]"	
		chn[6] = "%[%d+%. 公会招募.-%]"
                chn[7] = "%[%d+%. 大脚世界频道.-%]"
                chn[8] = "%[%d+%. 自定义频道.-%]"   -- 请修改频道名对应你游戏里的频道
	end

---------------------------------------- 台服 ---------------------------------------------	
  if L == "zhTW" then
		chn[1] = "%[%d+%. 綜合.-%]"
		chn[2] = "%[%d+%. 交易.-%]"
		chn[3] = "%[%d+%. 本地防務.-%]"
		chn[4] = "%[%d+%. 尋求組隊%]"
                chn[5] = "%[%d+%. 世界防務%]"	
		chn[6] = "%[%d+%. 公會招募.-%]"
                chn[7] = "%[%d+%. 自定义频道.-%]"   -- 请修改频道名对应你游戏里的频道
	end
	
local function AddMessage(frame, text, ...)
	for i = 1, 8 do	 -- 对应上面几个频道(如果有9个频道就for i = 1, 9 do)
		text = gsub(text, chn[i], rplc[i])
	end

	text = gsub(text, "%[(%d0?)%. .-%]", "%1.") 
	return newAddMsg[frame:GetName()](frame, text, ...)
end

if ShortChannel then
	for i = 1, 5 do
		if i ~= 2 then 
			local f = _G[format("%s%d", "ChatFrame", i)]
			newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
			f.AddMessage = AddMessage
		end
	end
end


















local origSetItemRef = SetItemRef
SetItemRef = function(link, text, button)
  local linkType = string.sub(link, 1, 6)
  if IsAltKeyDown() and linkType == "player" then
    local name = string.match(link, "player:([^:]+)")
    InviteUnit(name)
    return nil
  end
  return origSetItemRef(link,text,button)
end













--TabChangeChannel 按TAB切換頻道.==--
function ChatEdit_CustomTabPressed(self)
	if strsub(tostring(self:GetText()), 1, 1) == '/' then return end
	local chatType = self:GetAttribute('chatType')
	local inParty = GetNumSubgroupMembers() > 0
	local inInstance = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()
	local inRaid = GetNumGroupMembers() > 0 and IsInRaid()
	local inGuild = IsInGuild()
	local isOfficer = CanEditOfficerNote()
	local setType
	if chatType == 'SAY' then
		setType = inParty and 'PARTY' or inInstance and 'INSTANCE_CHAT' or inRaid and 'RAID' or inGuild and 'GUILD' or isOfficer and 'OFFICER'
	elseif chatType == 'PARTY' then
		setType = inInstance and 'INSTANCE_CHAT' or inRaid and 'RAID' or inGuild and 'GUILD' or isOfficer and 'OFFICER' or 'SAY'
	elseif chatType == 'INSTANCE_CHAT' then
		setType = inGuild and 'GUILD' or isOfficer and 'OFFICER' or 'SAY'
	elseif chatType == 'RAID' then
		setType = inGuild and 'GUILD' or isOfficer and 'OFFICER' or 'SAY'
	elseif chatType == 'GUILD' then
		setType = isOfficer and 'OFFICER' or 'SAY'
	elseif chatType == 'OFFICER' then
		setType = 'SAY'
	elseif chatType == 'CHANNEL' then
		setType = inParty and 'PARTY' or inInstance and 'INSTANCE_CHAT' or inRaid and 'RAID' or inGuild and 'GUILD' or isOfficer and 'OFFICER' or 'SAY'
	end
	if setType then
		self:SetAttribute('chatType', setType)
		ChatEdit_UpdateHeader(self)	
	else
		return
	end
end


-----------------------------------------------聊天复制------------------------------------
local _AddMessage = ChatFrame1.AddMessage
local _SetItemRef = SetItemRef
local blacklist = {
	[ChatFrame2] = true,
}

local ts = '|cff68ccef|HyCopy|h%s|h|r %s'
local AddMessage = function(self, text, ...)
	if(type(text) == 'string') then
        if showtime then
          text = format(ts, date'%H:%M', text)  --text = format(ts, date'%H:%M:%S', text)
        else
	  text = format(ts, '> ', text)
       end
end

	return _AddMessage(self, text, ...)
end

for i=1, NUM_CHAT_WINDOWS do
	local cf = _G['ChatFrame'..i]
	if(not blacklist[cf]) then
		cf.AddMessage = AddMessage
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

	if(not left) then
		return
	end

	if((x > left and x < right) and (y > bottom and y < top)) then
		return 1
	else
		return
	end
end

local borderManipulation = function(...)
	for l = 1, select('#', ...) do
		local obj = select(l, ...)
		if(obj:GetObjectType() == 'FontString' and MouseIsOver(obj)) then
			return obj:GetText()
		end
	end
end

local eb = ChatFrame1EditBox
SetItemRef = function(link, text, button, ...)
	if(link:sub(1, 5) ~= 'yCopy') then return _SetItemRef(link, text, button, ...) end

	local text = borderManipulation(SELECTED_CHAT_FRAME:GetRegions())
	if(text) then
		text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r', '%1')
		text = text:gsub('|H.-|h(.-)|h', '%1')

		eb:Insert(text)
		eb:Show()
		eb:HighlightText()
		eb:SetFocus()
	end
end

----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
local hooks = {}
local blacklist = {
	SPELL_FAILED_NO_COMBO_POINTS,   -- That ability requires combo points
	SPELL_FAILED_TARGETS_DEAD,      -- Your target is dead
	SPELL_FAILED_SPELL_IN_PROGRESS, -- Another action is in progress
	SPELL_FAILED_TARGET_AURASTATE,  -- You can't do that yet. (TargetAura)
	SPELL_FAILED_CASTER_AURASTATE,  -- You can't do that yet. (CasterAura)
	SPELL_FAILED_NO_ENDURANCE,      -- Not enough endurance
	SPELL_FAILED_BAD_TARGETS,       -- Invalid target
	SPELL_FAILED_NOT_MOUNTED,       -- You are mounted
	SPELL_FAILED_NOT_ON_TAXI,       -- You are in flight
	SPELL_FAILED_NOT_INFRONT,       -- You must be in front of your target
	SPELL_FAILED_NOT_IN_CONTROL,    -- You are not in control of your actions
	SPELL_FAILED_MOVING,            -- Can't do that while moving
	ERR_ATTACK_FLEEING,				-- Can't attack while fleeing.
	ERR_ITEM_COOLDOWN,				-- Item is not ready yet.
	ERR_GENERIC_NO_TARGET,          -- You have no target.
	ERR_ABILITY_COOLDOWN,           -- Ability is not ready yet.
	ERR_OUT_OF_ENERGY,              -- Not enough energy
	ERR_NO_ATTACK_TARGET,           -- There is nothing to attack.
	ERR_SPELL_COOLDOWN,             -- Spell is not ready yet. (Spell)
	ERR_OUT_OF_RAGE,                -- Not enough rage.
	ERR_INVALID_ATTACK_TARGET,      -- You cannot attack that target.
	ERR_OUT_OF_MANA,                -- Not enough mana
	ERR_NOEMOTEWHILERUNNING,        -- You can't do that while moving!
	OUT_OF_ENERGY,                  -- Not enough energy.
}

hooks["UIErrorsFrame_AddMessage"] = UIErrorsFrame.AddMessage
UIErrorsFrame.AddMessage = function(...)
	for k,v in ipairs(blacklist) do
		if v==arg1 then return end
	end
	hooks["UIErrorsFrame_AddMessage"](...)
end

---------------------------------密语语音提示---------------------------

local addon = CreateFrame("Frame")

local soundfile = tostring("Interface\\AddOns\\ShiGuang\\bChat\\Whisper.ogg")

function addon:CHAT_MSG_WHISPER()
		PlaySoundFile(soundfile)
end

addon:SetScript("OnEvent",function(self, event, ...)
	if self[event] then
		self[event](self, ...)
	else
		self:UnregisterEvent(event)
	end
end
)
addon:RegisterEvent("CHAT_MSG_WHISPER")


  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
-- 隐藏聊天菜单按钮(鼠标划过右上角显示)
--ChatFrameMenuButton:Hide()
--ChatFrameMenuButton:SetScript("OnShow", kill)
 ChatFrameMenuButton:SetScale(0.85)  --按钮缩放
 ChatFrameMenuButton:SetAlpha(0.8)  --刚进游戏时按钮透明度(鼠标经过1次后显示鼠标离开时透明度)
 ChatFrameMenuButton:ClearAllPoints()
 ChatFrameMenuButton:SetPoint("BOTTOMLEFT",ChatFrame1,"BOTTOMLEFT",-11138,-33) --位置  X15
 ChatFrameMenuButton:SetScript('OnEnter', function(self) self:SetAlpha(1) end) --鼠标进入时透明度
 ChatFrameMenuButton:SetScript('OnLeave', function(self) self:SetAlpha(0.8) end) --鼠标离开时透明度
 
-- 社交按钮(鼠标划过左上角显示)
--FriendsMicroButton:Hide()
--FriendsMicroButton:SetScript("OnShow", kill)
 FriendsMicroButton:SetScale(0.8) --按钮缩放
 FriendsMicroButton:SetAlpha(0.001) --刚进游戏时按钮透明度(鼠标经过1次后显示鼠标离开时透明度)
 FriendsMicroButton:ClearAllPoints()
 FriendsMicroButton:SetPoint("BOTTOMLEFT",ChatFrame1,"BOTTOMLEFT",-11138,-32) --位置
 FriendsMicroButton:SetScript('OnEnter', function(self) self:SetAlpha(1) end) --鼠标进入时透明度
 FriendsMicroButton:SetScript('OnLeave', function(self) self:SetAlpha(0.001) end) --鼠标离开时透明度

-- 隐藏翻页按钮(不在最后一行右下角显示翻页至底按钮)
local updateBottomButton = function(frame)
	local button = frame.buttonFrame.bottomButton
	if frame:AtBottom() then
		button:Hide()
	else
		button:Show()
	end
end
local bottomButtonClick = function(button)
	local frame = button:GetParent()
	frame:ScrollToBottom()
	updateBottomButton(frame)
end
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame" .. i]
		frame:HookScript("OnShow", updateBottomButton)
		frame.buttonFrame:Hide()
		local up = frame.buttonFrame.upButton
                local down = frame.buttonFrame.downButton
                local minimize = frame.buttonFrame.minimizeButton
		local bottom = frame.buttonFrame.bottomButton
		bottom:SetParent(frame)
		bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, 5)
		bottom:SetScript("OnClick", bottomButtonClick)
		bottom:SetAlpha(0.8)
                bottom:SetScale(0.7)
		updateBottomButton(frame)
                up.Show = up.Hide 
                up:Hide()
                down.Show = down.Hide 
                down:Hide()
                minimize:SetScale(.7)   
                minimize:ClearAllPoints()
                minimize:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', 5, 5)
                minimize:SetScript('OnEnter', function(self) self:SetAlpha(1) end)
                minimize:SetScript('OnLeave', function(self) self:SetAlpha(0) end)             	end
	hooksecurefunc("FloatingChatFrame_OnMouseScroll", updateBottomButton)


-------------------------------------------
-----------     Chatbar     ----------
-------------------------------------------
local addon, ns = ...
local cfg = CreateFrame("Frame")

----------------------------------------------------------
-- 自定义式样 --
----------------------------------------------------------
cfg.config = {
	useText= true,											--使用文字
	usebg = false,											--使用背景
	vertical = false,										--竖向排列（从上往下排列）
	OnMouseOver = true,									--鼠标划过时可见，平时淡出
	AlphaFadeOut = 0.95,										--淡出时的透明度
	size = 16,												--图标及文字的大小
	snap = 6,												--间隔
	postion = {"BOTTOMRIGHT",ChatFrame1,"BOTTOMRIGHT",-21,-16},	--位置
	font = STANDARD_TEXT_FONT,								--字体可改为指定字体，如"Fonts\\ARKai_T.ttf"
	fontstyle = "THINOUTLINE",								--字体样式"OUTLINE", "OUTLINE MONOCHROME", "OUTLINE" ，“GameFontNormal”或者 nil		
}

----------------------------------------------------------
-- 自定义函数 --
----------------------------------------------------------
-- 本地化专精
function Talent()
	local Spec = GetSpecialization()
	local SpecName = Spec and select(2, GetSpecializationInfo(Spec)) or "无"
	return SpecName
end

-- 格式化血量
function HealText()
local HP = UnitHealthMax("player");
	if HP > 1e4 then
		return format('%.2f万',HP/1e4)
	else
		return HP
	end
end

-- 基础属性
function BaseInfo()
	local BaseStat = ""
		BaseStat = BaseStat..("[%s] "):format(UnitClass("player"))
		BaseStat = BaseStat..("[%s] "):format(Talent())
		BaseStat = BaseStat..("最高装等:%.1f 当前:%.1f "):format(GetAverageItemLevel())
		BaseStat = BaseStat..("血量:%s "):format(HealText())
	return BaseStat
end

-- 输出属性(9 = 暴击 12 = 溅射 17 = 吸血 18 = 急速 21 = 闪避 26 = 精通 29 = 装备+自身全能 31 = 装备全能)
-- by图图
function DpsInfo()
    local DpsStat={"", "", ""}
    local specAttr={
        --纯力敏智属性职业
        WARRIOR={1,1,1},
        DEATHKNIGHT={1,1,1},
        ROGUE={2,2,2},
        HUNTER={2,2,2},
        MAGE={3,3,3},
        WARLOCK={3,3,3},
        PRIEST={3,3,3},
        --混合力敏智属性职业
        SHAMAN={3,2,3},
        MONK={2,3,2},
        DRUID={3,2,2,3},
        PALADIN={3,1,1}
    }
	local specId = GetSpecialization()
--    print("specId = "..specId)
	local classCN,classEnName = UnitClass("player")
    local classSpecArr = specAttr[classEnName]
    DpsStat[1] = ("力量:%s "):format(UnitStat("player", 1))
    DpsStat[2] = ("敏捷:%s "):format(UnitStat("player", 2))
    DpsStat[3] = ("智力:%s "):format(UnitStat("player", 4))
	return DpsStat[classSpecArr[specId]]
end

-- 坦克属性
function TankInfo()
	local TankStat = ""
		TankStat = TankStat..("耐力:%s "):format(UnitStat("player", 3))
		TankStat = TankStat..("护甲:%s "):format(UnitArmor("player"))
		TankStat = TankStat..("闪避:%.2f%% "):format(GetDodgeChance())
		TankStat = TankStat..("招架:%.2f%% "):format(GetParryChance())
		TankStat = TankStat..("格挡:%.2f%% "):format(GetBlockChance())
	return TankStat
end

-- 治疗属性
function HealInfo()
	local HealStat = ""
		HealStat = HealStat..("精神:%s "):format(UnitStat("player", 5))
		HealStat = HealStat..("法力回复:%d "):format(GetManaRegen()*5)
	return HealStat
end
-- 增强属性
function MoreInfo()
	local MoreStat = ""
		MoreStat = MoreStat..("急速:%.2f%% "):format(GetMeleeHaste())
		MoreStat = MoreStat..("爆击:%.2f%% "):format(GetCritChance())
		MoreStat = MoreStat..("精通:%.2f%% "):format(GetMasteryEffect())
		MoreStat = MoreStat..("溅射:%.2f%% "):format(GetMultistrike())
		--MoreStat = MoreStat..("溅射:%.2f%% "):format(GetCombatRating(12))
		MoreStat = MoreStat..("吸血:%s "):format(GetCombatRating(17))
		--MoreStat = MoreStat..("全能:%.2f%% "):format(GetCombatRating(29))
	return MoreStat
end

-- 属性收集
function StatReport()
	if UnitLevel("player") < 10 then
		return BaseInfo()
	end
	local StatInfo = ""
	local Role = GetSpecializationRole(GetSpecialization())
	if Role == "HEALER" then
		StatInfo = StatInfo..BaseInfo()..DpsInfo()..HealInfo()..MoreInfo()
	elseif Role == "TANK" then
		StatInfo = StatInfo..BaseInfo()..DpsInfo()..TankInfo()..MoreInfo()
	else
		StatInfo = StatInfo..BaseInfo()..DpsInfo()..MoreInfo()
	end
	return StatInfo
end


-- 自定义宏模块
local StatReport = "/run ChatFrame_OpenChat(StatReport())"
local TalentChange = "/run SetActiveSpecGroup(GetActiveSpecGroup() == 1 and 2 or 1)"

----------------------------------------------------------
-- 自定义按钮 --
----------------------------------------------------------
--[[
	channel 频道名， 
	input 切换频道命令[注意需空格结尾]/宏内容，
	macro 是否为宏/可缺省（宏命令必须为true），
	text 聊天条上显示文字/可缺省（M）， 尽量是一个字，好看点咯，可以为中文或繁体
	color 文字或方块颜色/可缺省（白色）
	最后出来的顺序是按照custom里的先后，从左往右排序
	如果宏内容太长，可以先定义个字符串，再在表里添加 如：
	在外面写 local macro_sell = "/s XXX" [注意宏的内容一定要加引号]
	再在表里写 input = macro_sell
]]--

cfg.custom = {
  --属性通报
	{channel = "StatReport", input = StatReport, macro = true , text = "报", color = {0.0,1.0,1.0}},
  --Roll宏
	{channel = "ROLL", input = "/roll", macro = true , text = "掷", color = {1.0,1.0,0.0}},
}


----------------------------------------------------------
-- 自定义按钮 --
--天赋切换
--	{channel = "TalentChange", input = TalentChange, macro = true , text = "切", color = {0.0,1.0,0.0}},
----------------------------------------------------------


ns.cfg = cfg


local addon, ns = ...
local cfg = ns.cfg.config
local custom = ns.cfg.custom

----------------------------------------------------------
-- 自定义背景 --
----------------------------------------------------------
local backdrop = {
	bgFile = "Interface\\Buttons\\WHITE8x8", 
	edgeFile = "Interface\\Buttons\\WHITE8x8", 
	tile = false, tileSize = 0, edgeSize = 1, 
	insets = { left = 1, right = 1, top = 1, bottom = 1 }
}
local editBox = ChatEdit_ChooseBoxForSend()
local chatFrame = editBox.chatFrame

----------------------------------------------------------
-- 自定义频道 --
----------------------------------------------------------
local channels = {
	[3] = {channel = "Yell", input = "/y ", color = {1,64/255,64/255},},
	[4] = {channel = "Say", input = "/s ", color = {1,1,1},},
	[5] = {channel = "Party", input = "/p ", color = {170/255,170/255,1},},
	[6] = {channel = "RaidWarning", input = "/rw ", color = {255/255,64/255,0/255},},
	[7] = {channel = "Raid", input = "/ra ", color = {255/255,127/255,0},},
	[8] = {channel = "Instance", input = "/i ", color = {255/255,127/255,0},},
	[9] = {channel = "Guild", input = "/g ", color = {64/255,255/255,64/255},},
	--[8] = {channel = "Whisper", input = "/w ", color = {255/255,128/255,255/255},},
}

----------------------------------------------------------
-- 各国语言 --
----------------------------------------------------------
local LC= {}
if GetLocale() == "zhCN" then
	LC = {
		["Say"] = "说",
		["Yell"] = "喊",
		["Party"] = "队",
		["Raid"] = "团",
		["RaidWarning"] = "通",
		["Instance"] = "副",
		["Guild"] = "会",
		["Whisper"] = "密",
	}
else
	LC = {
		["Say"] = "說",
		["Yell"] = "喊",
		["Party"] = "隊",
		["Raid"] = "團",
		["RaidWarning"] = "通",
		["Instance"] = "副",
		["Guild"] = "會",
		["Whisper"] = "密",
	}
end

----------------------------------------------------------
-- 未定义按钮 --
----------------------------------------------------------
for i , v in ipairs(custom) do
	local new = {channel=v.channel ,input = v.input,color = v.color or {1,1,1}, macro = v.macro}
	tinsert(channels,new)
	LC[v.channel] = v.text or "X"
end

----------------------------------------------------------
-- MyChatBar框架 --
----------------------------------------------------------
local t = #channels
local chatbar = CreateFrame("Frame","ChatBar",UIParent)
if cfg.vertical then
	chatbar:SetSize(cfg.size/2,cfg.size*t+cfg.snap*(t+1))
else
	chatbar:SetSize(cfg.size*t+cfg.snap*(t+1),cfg.size/2)
end
chatbar:SetPoint(unpack(cfg.postion))
if cfg.usebg then
	chatbar:SetBackdrop(backdrop)
	chatbar:SetBackdropColor(0,0,0,0.4)
	chatbar:SetBackdropBorderColor(0,0,0)
end

----------------------------------------------------------
-- 函数模块 --
----------------------------------------------------------
local CreateElement = function(channel,fun,posX,color)
	local frame
	if type(fun) == "function" then 
		frame = CreateFrame("Button","ChatBar"..channel,chatbar)
		frame:RegisterForClicks("AnyUp")
		frame:SetScript("OnClick", function() fun() end) 
	elseif type(fun) == "string" then
		frame = CreateFrame("Button","ChatBar"..channel,chatbar,"SecureActionButtonTemplate")
		frame:SetAttribute("*type*", "macro")
		frame:SetAttribute("macrotext", fun)
	end
	frame:SetSize(cfg.size,cfg.size)
	if cfg.vertical then
		frame:SetPoint("TOP",0,-posX)
	else
		frame:SetPoint("LEFT",posX,0)
	end
	if cfg.useText then 
		frame.text = frame:CreateFontString("ChatBar"..channel.."TEXT","OVERLAY")
		frame.text:SetFont(cfg.font, cfg.size, cfg.fontstyle)
		frame.text:SetJustifyH("CENTER")
		frame.text:SetText(LC[channel])
		frame.text:SetPoint("CENTER")
		frame.text:SetTextColor(unpack(color))
	else
		frame:SetBackdrop(backdrop)
		frame:SetBackdropColor(unpack(color))
		frame:SetBackdropBorderColor(0,0,0)
	end
end

local offset = cfg.snap
for i,v in ipairs(channels) do
	if v.macro  then	--宏
		CreateElement(v.channel,v.input,offset,v.color)
	else
			local OnClickFunction = function()
				ChatFrame_OpenChat(v.input,chatFrame)
			end
			CreateElement(v.channel,OnClickFunction,offset,v.color)
	end
	offset = offset + cfg.snap + cfg.size
end
----------------------------------------------------------
-- 鼠标指向处 --
----------------------------------------------------------
if cfg.OnMouseOver then
	local _G = _G
	local lighton = function(a)
		for i,v in pairs(channels) do
			local f = _G["ChatBar"..v.channel]
			f:SetAlpha(a)
		end
		_G["ChatBar"]:SetAlpha(a)
	end
	
	_G["ChatBar"]:SetAlpha(cfg.AlphaFadeOut or 0)
	_G["ChatBar"]:SetScript("OnEnter", function(self) lighton(1) end)
	_G["ChatBar"]:SetScript("OnLeave", function(self) lighton(cfg.AlphaFadeOut or 0) end)
	
	for i,v in pairs(channels) do
		local f = _G["ChatBar"..v.channel]
		f:SetAlpha(cfg.AlphaFadeOut or 0)
		f:HookScript("OnEnter", function(self) lighton(1) end)
		f:HookScript("OnLeave", function(self) lighton(cfg.AlphaFadeOut or 0) end)
		--f:HookScript("OnLeave", function(self) UIFrameFadeIn(f, .3, f:GetAlpha(), cfg.AlphaFadeOut) end)
	end
end

-------------------------------------------
-----------     ChatEmote     ----------
-------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
local math,table,string,pairs,type,select,tonumber,floor,unpack=math,table,string,pairs,type,select,tonumber,floor,unpack
local _

local GameTooltip=GameTooltip
local GetCurrentResolution=GetCurrentResolution
local GetScreenResolutions=GetScreenResolutions
local ChatEdit_ChooseBoxForSend=ChatEdit_ChooseBoxForSend

local Emote_Panel_STRING_1="表情面板"
local Emote_Panel_STRING_2="<按住Ctrl拖动>"
local Locale={
    ["Angel"]="天使",
    ["Angry"]="生气",
    ["Biglaugh"]="大笑",
    ["Clap"]="鼓掌",
    ["Cool"]="酷",
    ["Cry"]="哭",
    ["Cute"]="可爱",
    ["Despise"]="鄙视",
    ["Dreamsmile"]="美梦",
    ["Embarras"]="尴尬",
    ["Evil"]="邪恶",
    ["Excited"]="兴奋",
    ["Faint"]="晕",
    ["Fight"]="打架",
    ["Flu"]="流感",
    ["Freeze"]="呆",
    ["Frown"]="皱眉",
    ["Greet"]="致敬",
    ["Grimace"]="鬼脸",
    ["Growl"]="龇牙",
    ["Happy"]="开心",
    ["Heart"]="心",
    ["Horror"]="恐惧",
    ["Ill"]="生病",
    ["Innocent"]="无辜",
    ["Kongfu"]="功夫",
    ["Love"]="花痴",
    ["Mail"]="邮件",
    ["Makeup"]="化妆",
    ["Mario"]="马里奥",
    ["Meditate"]="沉思",
    ["Miserable"]="可怜",
    ["Okay"]="好",
    ["Pretty"]="漂亮",
    ["Puke"]="吐",
    ["Shake"]="握手",
    ["Shout"]="喊",
    ["Silent"]="闭嘴",
    ["Shy"]="害羞",
    ["Sleep"]="睡觉",
    ["Smile"]="微笑",
    ["Suprise"]="吃惊",
    ["Surrender"]="失败",
    ["Sweat"]="流汗",
    ["Tear"]="流泪",
    ["Tears"]="悲剧",
    ["Think"]="想",
    ["Titter"]="偷笑",
    ["Ugly"]="猥琐",
    ["Victory"]="胜利",
    ["Volunteer"]="雷锋",
    ["Wronged"]="委屈",
	 ["rt1"]="星星", 
	 ["rt2"]="大饼", 
	 ["rt3"]="菱形", 
	 ["rt4"]="三角", 
	 ["rt5"]="月亮", 
	 ["rt6"]="方块", 
	 ["rt7"]="叉叉", 
	 ["rt8"]="骷髅", 
}
------------------------------------------------------------------------------------------------
local Emote_CallButton
local Emote_Index2Path={}
local Emote_IconTable={}
Emote_IconSize=0.9
local Emote_IconTable={
		{Locale["rt1"],"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"},
        {Locale["rt2"],"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"},
        {Locale["rt3"],"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"},
        {Locale["rt4"],"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"},
        {Locale["rt5"],"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"},
        {Locale["rt6"],"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"},
        {Locale["rt7"],"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"},
        {Locale["rt8"],"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"},
        {Locale["Angel"],"Interface\\AddOns\\bChat\\icon\\angel.tga"},
        {Locale["Angry"],"Interface\\AddOns\\bChat\\icon\\angry.tga"},
        {Locale["Biglaugh"],"Interface\\AddOns\\bChat\\icon\\biglaugh.tga"},
        {Locale["Clap"],"Interface\\AddOns\\bChat\\icon\\clap.tga"},
        {Locale["Cool"],"Interface\\AddOns\\bChat\\icon\\cool.tga"},
        {Locale["Cry"],"Interface\\AddOns\\bChat\\icon\\cry.tga"},
        {Locale["Cute"],"Interface\\AddOns\\bChat\\icon\\cutie.tga"},
        {Locale["Despise"],"Interface\\AddOns\\bChat\\icon\\despise.tga"},
        {Locale["Dreamsmile"],"Interface\\AddOns\\bChat\\icon\\dreamsmile.tga"},
        {Locale["Embarras"],"Interface\\AddOns\\bChat\\icon\\embarrass.tga"},
        {Locale["Evil"],"Interface\\AddOns\\bChat\\icon\\evil.tga"},
        {Locale["Excited"],"Interface\\AddOns\\bChat\\icon\\excited.tga"},
        {Locale["Faint"],"Interface\\AddOns\\bChat\\icon\\faint.tga"},
        {Locale["Fight"],"Interface\\AddOns\\bChat\\icon\\fight.tga"},
        {Locale["Flu"],"Interface\\AddOns\\bChat\\icon\\flu.tga"},
        {Locale["Freeze"],"Interface\\AddOns\\bChat\\icon\\freeze.tga"},
        {Locale["Frown"],"Interface\\AddOns\\bChat\\icon\\frown.tga"},
        {Locale["Greet"],"Interface\\AddOns\\bChat\\icon\\greet.tga"},
        {Locale["Grimace"],"Interface\\AddOns\\bChat\\icon\\grimace.tga"},
        {Locale["Growl"],"Interface\\AddOns\\bChat\\icon\\growl.tga"},
        {Locale["Happy"],"Interface\\AddOns\\bChat\\icon\\happy.tga"},
        {Locale["Heart"],"Interface\\AddOns\\bChat\\icon\\heart.tga"},
        {Locale["Horror"],"Interface\\AddOns\\bChat\\icon\\horror.tga"},
        {Locale["Ill"],"Interface\\AddOns\\bChat\\icon\\ill.tga"},
        {Locale["Innocent"],"Interface\\AddOns\\bChat\\icon\\innocent.tga"},
        {Locale["Kongfu"],"Interface\\AddOns\\bChat\\icon\\kongfu.tga"},
        {Locale["Love"],"Interface\\AddOns\\bChat\\icon\\love.tga"},
        {Locale["Mail"],"Interface\\AddOns\\bChat\\icon\\mail.tga"},
        {Locale["Makeup"],"Interface\\AddOns\\bChat\\icon\\makeup.tga"},
        {Locale["Mario"],"Interface\\AddOns\\bChat\\icon\\mario.tga"},
        {Locale["Meditate"],"Interface\\AddOns\\bChat\\icon\\meditate.tga"},
        {Locale["Miserable"],"Interface\\AddOns\\bChat\\icon\\miserable.tga"},
        {Locale["Okay"],"Interface\\AddOns\\bChat\\icon\\okay.tga"},
        {Locale["Pretty"],"Interface\\AddOns\\bChat\\icon\\pretty.tga"},
        {Locale["Puke"],"Interface\\AddOns\\bChat\\icon\\puke.tga"},
        {Locale["Shake"],"Interface\\AddOns\\bChat\\icon\\shake.tga"},
        {Locale["Shout"],"Interface\\AddOns\\bChat\\icon\\shout.tga"},
        {Locale["Silent"],"Interface\\AddOns\\bChat\\icon\\shuuuu.tga"},
        {Locale["Shy"],"Interface\\AddOns\\bChat\\icon\\shy.tga"},
        {Locale["Sleep"],"Interface\\AddOns\\bChat\\icon\\sleep.tga"},
        {Locale["Smile"],"Interface\\AddOns\\bChat\\icon\\smile.tga"},
        {Locale["Suprise"],"Interface\\AddOns\\bChat\\icon\\suprise.tga"},
        {Locale["Surrender"],"Interface\\AddOns\\bChat\\icon\\surrender.tga"},
        {Locale["Sweat"],"Interface\\AddOns\\bChat\\icon\\sweat.tga"},
        {Locale["Tear"],"Interface\\AddOns\\bChat\\icon\\tear.tga"},
        {Locale["Tears"],"Interface\\AddOns\\bChat\\icon\\tears.tga"},
        {Locale["Think"],"Interface\\AddOns\\bChat\\icon\\think.tga"},
        {Locale["Titter"],"Interface\\AddOns\\bChat\\icon\\titter.tga"},
        {Locale["Ugly"],"Interface\\AddOns\\bChat\\icon\\ugly.tga"},
        {Locale["Victory"],"Interface\\AddOns\\bChat\\icon\\victory.tga"},
        {Locale["Volunteer"],"Interface\\AddOns\\bChat\\icon\\volunteer.tga"},
        {Locale["Wronged"],"Interface\\AddOns\\bChat\\icon\\wronged.tga"},
    }

local Emote_ICON_TAG_LIST={
        {strlower(ICON_TAG_RAID_TARGET_STAR1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"},
        {strlower(ICON_TAG_RAID_TARGET_STAR2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"},
        {strlower(ICON_TAG_RAID_TARGET_CIRCLE1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"},
        {strlower(ICON_TAG_RAID_TARGET_CIRCLE2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"},
        {strlower(ICON_TAG_RAID_TARGET_DIAMOND1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"},
        {strlower(ICON_TAG_RAID_TARGET_DIAMOND2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"},
        {strlower(ICON_TAG_RAID_TARGET_TRIANGLE1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"},
        {strlower(ICON_TAG_RAID_TARGET_TRIANGLE2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"},
        {strlower(ICON_TAG_RAID_TARGET_MOON1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"},
        {strlower(ICON_TAG_RAID_TARGET_MOON2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"},
        {strlower(ICON_TAG_RAID_TARGET_SQUARE1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"},
        {strlower(ICON_TAG_RAID_TARGET_SQUARE2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"},
        {strlower(ICON_TAG_RAID_TARGET_CROSS1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"},
        {strlower(ICON_TAG_RAID_TARGET_CROSS2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"},
        {strlower(ICON_TAG_RAID_TARGET_SKULL1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"},
        {strlower(ICON_TAG_RAID_TARGET_SKULL2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"},
        {strlower(RAID_TARGET_1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"},
        {strlower(RAID_TARGET_2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"},
        {strlower(RAID_TARGET_3),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"},
        {strlower(RAID_TARGET_4),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"},
        {strlower(RAID_TARGET_5),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"},
        {strlower(RAID_TARGET_6),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"},
        {strlower(RAID_TARGET_7),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"},
        {strlower(RAID_TARGET_8),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"},
    }
	for k,v in pairs(Emote_ICON_TAG_LIST) do
		Emote_Index2Path["{"..v[1].."}"]=v[2]
 	end

	for k,v in pairs(Emote_IconTable) do
  	    Emote_Index2Path["{"..v[1].."}"]=v[2]
 	end
------------------------------------------------------------------------------------------------
local function IconSize(f)
 	local _,font=f:GetFont()
 	local res=select(GetCurrentResolution(),GetScreenResolutions())
 	local _,h=string.match(res,"(%d+)x(%d+)")
 	font=Emote_IconSize*font*h/500
 	font=floor(font)
 	return font
end
------------------------------------------------------------------------------------------------
local function Emote_SendChatMessage_Filter(text)
	for s in string.gmatch(text,"\124T([^:]+):%d+\124t") do
  		local index
		for k,v in pairs(Emote_Index2Path) do
		    if v==s then
			    index=k
			end
		end
		if index then
   			text=string.gsub(text,"(\124T[^:]+:%d+\124t)",index,1)
  		end
 	end
 	return text
end

local function Emote_AddMessage_Filter(self,text)
	for s in string.gmatch(text,"({[^}]+})") do
  		if (Emote_Index2Path[s]) then
   			text=string.gsub(text,s,"\124T"..Emote_Index2Path[s] ..":"..IconSize(self).."\124t",1)
  		end
 	end
 	return text
end

local _xSendChatMessage=SendChatMessage
local _xBNSendWhisper=BNSendWhisper
local _xBNSendConversationMessage=BNSendConversationMessage
	for i=1,NUM_CHAT_WINDOWS do
		if i~=2 then
			local f=getglobal("ChatFrame"..i)
			f._xAddMessage=f.AddMessage
			f.AddMessage=function(self,text,...)
			        text=Emote_AddMessage_Filter(self,text) self:_xAddMessage(text,...)
			    end
		end
	end
	_xSendChatMessage=SendChatMessage
	_G["SendChatMessage"]=function(text,...) text=Emote_SendChatMessage_Filter(text) _xSendChatMessage(text,...) end
	_xBNSendWhisper=BNSendWhisper
	_G["BNSendWhisper"]=function(presenceID,text) text=Emote_SendChatMessage_Filter(text) _xBNSendWhisper(presenceID,text) end
	_xBNSendConversationMessage=BNSendConversationMessage
	_G["BNSendConversationMessage"]=function(target,text) text=Emote_SendChatMessage_Filter(text) _xBNSendConversationMessage(target,text) end

 	Emote_CallButton=CreateFrame("Button","Emote_CallButton",UIParent)
 	Emote_CallButton:SetWidth(21)
 	Emote_CallButton:SetHeight(21)
 	--Emote_CallButton:SetNormalTexture("Interface\\AddOns\\ShiGuang\\media\\icon\\text_nor_icon")
 	--Emote_CallButton:SetPushedTexture("Interface\\AddOns\\ShiGuang\\media\\icon\\text_push_icon")
 	--Emote_CallButton:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight")
 	--Emote_CallButton:GetHighlightTexture():SetBlendMode("ADD")
 	Emote_CallButton.text = Emote_CallButton:CreateFontString(nil, 'OVERLAY')
	Emote_CallButton.text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
	Emote_CallButton.text:SetPoint("CENTER", 0, 0)
	Emote_CallButton.text:SetText("表情")
	Emote_CallButton.text:SetTextColor(23/255, 132/255, 209/255)	
	Emote_CallButton:SetAlpha(0.8)
	Emote_CallButton:SetFrameLevel(32)
	Emote_CallButton:SetMovable(true)
	Emote_CallButton:EnableMouse(true)
	Emote_CallButton:RegisterForClicks("LeftButtonUp","RightButtonUp")
 	Emote_CallButton:RegisterForDrag("LeftButton","RightButton")
	Emote_CallButton:ClearAllPoints()
 	Emote_CallButton:SetPoint("RIGHT",ChatBar,"LEFT",-8,0)
 	Emote_CallButton:SetScript("OnClick",function(self) if Emote_IconPanel:IsShown() then Emote_IconPanel:Hide() else Emote_IconPanel:Show() end if GameTooltip:GetOwner()==self then GameTooltip:Hide() end end)
 	Emote_CallButton:SetScript("OnDragStart",function(self) if self:IsMovable() and IsControlKeyDown() then self:StartMoving() end end)
 	Emote_CallButton:SetScript("OnDragStop",function(self) if self:IsMovable() then self:StopMovingOrSizing()  end  end)
 	Emote_CallButton:SetScript("OnEnter",function(self) GameTooltip:SetOwner(self,"ANCHOR_TOPRIGHT")  GameTooltip:AddLine(Emote_Panel_STRING_1)  GameTooltip:AddLine(Emote_Panel_STRING_2) GameTooltip:AddLine(Emote_Panel_STRING_3) GameTooltip:Show() Emote_IconPanel.isCounting=nil end)
 	Emote_CallButton:SetScript("OnLeave",function(self) if GameTooltip:GetOwner()==self then GameTooltip:Hide() end Emote_IconPanel.showTimer=1.0 Emote_IconPanel.isCounting=1 end)
	Emote_CallButton:Show()

	Emote_IconPanel=CreateFrame("Frame","Emote_IconPanel",UIParent)
  	Emote_IconPanel:SetWidth(260)
 	Emote_IconPanel:SetHeight(160)
 	Emote_IconPanel:SetFrameLevel(32)
 	Emote_IconPanel:SetMovable(true)
 	Emote_IconPanel:EnableMouse(true)
 	Emote_IconPanel:Hide()
 	Emote_IconPanel:ClearAllPoints()
 	Emote_IconPanel:SetPoint("BOTTOMLEFT",Emote_CallButton,"TOPRIGHT",0,0)
 	Emote_IconPanel:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=12,edgeSize=7,insets={left=4,right=4,top=4,bottom=4}})
 	Emote_IconPanel:SetBackdropColor(0,0,0)
 	Emote_IconPanel.showTimer=0
 	Emote_IconPanel:SetScript("OnUpdate",function(self,elapsed)
									if (not self.isCounting) then
                                     return
                                    elseif (self.showTimer<=0) then
                                     self:Hide()
                                     self.showTimer=nil
                                     self.isCounting=nil
                                    else
                                     self.showTimer=self.showTimer-elapsed
                                    end
								   end)
 	Emote_IconPanel:SetScript("OnEnter",function(self)
                                    self.isCounting=nil
                                  end)
 	Emote_IconPanel:SetScript("OnLeave",function(self)
                                    self.showTimer=1.0
                                    self.isCounting=1
                                  end)
	Emote_IconPanel.IconList={}
	Emote_IconPanel:SetScript("OnShow",function(self) for k,v in pairs(self.IconList) do v:Show() end end)
	Emote_IconPanel:SetScript("OnHide",function(self) for k,v in pairs(self.IconList) do v:Hide() end end)

 	local px=1
 	local py=1
 	for k,v in pairs(Emote_IconTable) do
		local b=CreateFrame("Button","Emote_Icon"..k,Emote_IconPanel)
    	b:Hide()
     	b:Show()
 	    b:EnableMouse(true)
 	    b:SetWidth(23)
 	    b:SetHeight(23)
 	    b.text=v[1]
 	    b.texture=v[2]
 	    b:SetNormalTexture(v[2])
 	    b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
 	    b:GetHighlightTexture():SetBlendMode("ADD")
 	    b:SetFrameLevel(35)
 	    b:ClearAllPoints()
		b.parent=Emote_IconPanel
 	    b:SetPoint("TOPLEFT",Emote_IconPanel,"TOPLEFT",(px-1)*25+5,(1-py)*25-5)
 	    b:SetScript("OnClick",function(self)
                                    local editBox=ChatEdit_ChooseBoxForSend()
                                    editBox:Show()
                                    editBox:SetFocus()
                                    editBox:Insert("\124T"..self.texture..":"..IconSize(SELECTED_CHAT_FRAME).."\124t")
                                    self.parent:Hide()
                                  end)
 	    b:SetScript("OnEnter",function(self)
                                    GameTooltip:SetOwner(self.parent,"ANCHOR_TOPLEFT")
                                    GameTooltip:SetText(self.text)
                                    GameTooltip:Show()
									self.parent.isCounting=nil
                                 end)
 	    b:SetScript("OnLeave",function(self)
                                    if GameTooltip:GetOwner()==self.parent then
                                        GameTooltip:Hide()
                                    end
                                    self.parent.showTimer=1.0
                                    self.parent.isCounting=1
								end)

  	    Emote_IconPanel.IconList[k]=b
  	    px=px+1
  	    if px>=11 then
   	    	px=1
   		    py=py+1
  	    end
 	end

	Locale=nil
	Emote_IconTable=nil
	Emote_ICON_TAG_LIST=nil

-------------------------------------------
-----------     Chatmore     ----------
-------------------------------------------
--[[--------------------------------------------------------------------
	ChatLinkTooltips
	Chat Item Hyperlink with Mouseover and Compare
	Written by Junxx EU-Khaz'goroth <addons@colordesigns.de>
	http://wow.curseforge.com/addons/chattooltips/
----------------------------------------------------------------------]]
local WoD = select(4, GetBuildInfo()) >= 6e4

local supportedType = {
	item = true,
	achievement = true,
	spell = true,
	quest = true,
	enchant = true,
	glyph = true,
	unit = true,
	talent = true,

}

if ( not self ) then
	self = GameTooltip;
end

local CompareShowing

local f = CreateFrame("Frame")
f:RegisterEvent("MODIFIER_STATE_CHANGED")
f:SetScript("OnEvent", function(self, event, key, state)
	if CompareShowing and (key == "LSHIFT" or key == "RSHIFT") and not GameTooltip:IsEquippedItem() then
		if state == 1 then
			GameTooltip_ShowCompareItem(GameTooltip)
		else
			ShoppingTooltip1:Hide()
			ShoppingTooltip2:Hide()
			if(not WoD) then
				ShoppingTooltip3:Hide()
			end
		end
	end
end)

local function OnHyperlinkEnter(self, linkData, link)
	local linkType = strmatch(linkData, "^([^:]+)")
	if linkType and supportedType[linkType] then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:SetHyperlink(linkData)
		CompareShowing = true
	end
end

local function OnHyperlinkLeave(self, linkData, link)
	GameTooltip:Hide()
	CompareShowing = nil
end

for i = 1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
	frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
end



--[[--------------------------------------------------------------------
align
----------------------------------------------------------------------]]
SLASH_EA1 = "/align"

local f

SlashCmdList["EA"] = function()
	if f then
		f:Hide()
		f = nil		
	else
		f = CreateFrame('Frame', nil, UIParent) 
		f:SetAllPoints(UIParent)
		local w = GetScreenWidth() / 64
		local h = GetScreenHeight() / 36
		for i = 0, 64 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == 32 then
				t:SetTexture(1, 0, 0, 0.5)
			else
				t:SetTexture(0, 0, 0, 0.5)
			end
			t:SetPoint('TOPLEFT', f, 'TOPLEFT', i * w - 1, 0)
			t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', i * w + 1, 0)
		end
		for i = 0, 36 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == 18 then
				t:SetTexture(1, 0, 0, 0.5)
			else
				t:SetTexture(0, 0, 0, 0.5)
			end
			t:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -i * h + 1)
			t:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -i * h - 1)
		end	
	end
end

--[[--------------------------------------------------------------------
SlashIn
----------------------------------------------------------------------]]
local addonName, SlashIn = ...
LibStub("AceTimer-3.0"):Embed(SlashIn)

local print = print
local tonumber = tonumber
local MacroEditBox = MacroEditBox
local MacroEditBox_OnEvent = MacroEditBox:GetScript("OnEvent")

local function OnCallback(command)
	MacroEditBox_OnEvent(MacroEditBox, "EXECUTE_CHAT_LINE", command)
end

SLASH_SLASHIN_IN1 = "/in"
SLASH_SLASHIN_IN2 = "/slashin"

function SlashCmdList.SLASHIN_IN(msg)
	local secs, command = msg:match("^([^%s]+)%s+(.*)$")
	secs = tonumber(secs)
	if (not secs) or (#command == 0) then
		local prefix = "|cff33ff99"..addonName.."|r:"
		print(prefix, "usage:\n /in <seconds> <command>")
		print(prefix, "example:\n /in 1.5 /say hi")
	else
		SlashIn:ScheduleTimer(OnCallback, secs, command)
	end
end

-------------------------------------------
-----------     ChatFilter     ----------
-------------------------------------------
-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------
local _, cf = ...

cf.L = {
	["You"] = "You",
	["Space"] = ", ",
	["Channel"] = "大脚世界频道",
	["RaidAlert"] = "%*%*(.+)%*%*",
	["QuestReport"] = "Quest progress%s?:",
	["Achievement"] = "[%s] have earned the achievement %s!",
	["LearnSpell"] = "You have learned: %s",
	["UnlearnSpell"] = "You have unlearned: %s",
	["FriendlistFull"] = "Your friend list is full, remove 2 for this addon to function properly!",
}
if (GetLocale() == "zhCN") then
	cf.L = {
		["You"] = "你",
		["Space"] = "、",
		["Channel"] = "大脚世界频道",
		["RaidAlert"] = "%*%*(.+)%*%*",
		["QuestReport"] = "任务进度%s?[:：]",
		["Achievement"] = "[%s]获得了成就%s!",
		["LearnSpell"] = "你学会了技能: %s",
		["UnlearnSpell"] = "你遗忘了技能: %s",
		["FriendlistFull"] = "你的好友列表已满，现已关闭过滤小号功能，如需再次打开，请在腾出空位后输入/cf level开启。",
	}
elseif (GetLocale() == "zhTW") then
	cf.L = {
		["You"] = "你",
		["Space"] = "、",
		["RaidAlert"] = "%*%*(.+)%*%*",
		["QuestReport"] = "任務進度%s?[:：]",
		["Achievement"] = "[%s]獲得了成就%s!",
		["LearnSpell"] = "你學會了技能: %s",
		["UnlearnSpell"] = "你遺忘了技能: %s",
		["FriendlistFull"] = "你的好友列表已滿，現已關閉過濾小號功能，如需再次打開，請在騰出空位後輸入/cf level開啓。",
	}
end

-----------------------------------------------------------------------
-- Config
-----------------------------------------------------------------------
local _, cf = ...

cf.Config = {
	["Enabled"] = true, --Enable the ChatFilter. // 是否开启本插件

	["noprofanityFilter"] = true, --Disable the profanityFilter. // 关闭语言过滤器
	["nowhisperSticky"] = false, --Disable the sticky of Whisper. // 取消持续密语
	["noaltArrowkey"] = false, --Disable the AltArrowKeyMode. // 取消按住ALT才能移动光标
	["nojoinleaveChannel"] = true, --Disable the alert joinleaveChannel. // 关闭进出频道提示

	["MergeTalentSpec"] = false, --Merge the messages:"You have learned/unlearned..." // 当切换天赋后合并显示“你学会了/忘却了法术…”
	["FilterPetTalentSpec"] = false, --Filter the messages:"Your pet has learned/unlearned..." // 不显示“你的宠物学会了/忘却了…”

	["MergeAchievement"] = true, --Merge the messages:"...has earned the achievement..." // 合并显示获得成就
	["MergeManufacturing"] = false, --Merge the messages:"You has created..." // 合并显示“你制造了…”

	["FilterRaidAlert"] = true, --Filter the bullshit messages from RaidAlert. // 过滤煞笔RaidAlert的脑残信息
	["FilterQuestReport"] = true, --Filter the bullshit messages from QuestReport. // 过滤掉烦人的任务通报信息

	["FilterDuelMSG"] = true, --Filter the messages:"... has defeated/fled from ... in a duel." // 过滤“...在决斗中战胜了...”
	["FilterDrunkMSG"] = false, --Filter the drunk messages:"... has drunked ..."// 过滤“...喝醉了.”
	["FilterAuctionMSG"] = false, --Filter the messages:"Auction created/cancelled."// 过滤“已开始拍卖/拍卖取消.”

	["FilterAdvertising"] = true, --Filter the advertising messages. // 过滤广告信息
	["AllowMatchs"] = 2, --How many words can be allowd to use. // 允许的关键字配对个数
	["IgnoreAdTimes"] = 30, --How many times shall we shield the advertising. // 屏蔽发广告的玩家多长时间(分钟)
	["IgnoreMore"] = false, --When the ignorelist is full, you can still ignore players. // 当屏蔽列表满了后仍然可以屏蔽玩家

	["FilterMultiLine"] = false, --Filter the multiple messages. // 过滤多行信息
	["AllowLines"] = 6, --How many lines can be allowd. // 允许的最大行数

	["FilterRepeat"] = true, --Filter the repeat messages. // 过滤重复聊天信息
	["RepeatAlike"] = 100, --Set the similarity between the messages. // 设定重复信息相似度
	["RepeatInterval"] = 30, --Set the interval between the messages. // 设定重复信息间隔时间(秒)

	["FilterByLevel"] = false, --Filter the messages by level. // 屏蔽小号发言
	["OnlyOnWhisper"] = nil, --Only filter the whisper messages. // 只过滤密语
	["AllowLevel"] = 10, --Filter the messages by level. // 屏蔽多少级以下的发言

	["Debug"] = nil,

	["SafeWords"] = {
		"recruit",
		"dkp",
		"looking",
		"lf[gm]",
		"|cff",
		"raid",
		"recount",
		"skada",
		"boss",
		"dps",
	},
	["DangerWords"] = {"大尾巴","平台交易","担保","承接","工作室","纯手工","游戏币","代打","代练","战点","手工金","手工G","托管","带级","皇冠店","一赔","套装消费","點心","冲钻","店铺","皇冠","小卡","大卡","大饼","小饼","特惠","加盟","七煌","套餐","手工带","塞纳","尘埃","Style","落叶","代刷","代抓","带刷","牛肉","专业","毕业","大桥","QQ","企鹅","联系","点心","-60","-100","-90","2200","2400","3200","0元","消保","好评","优惠","付款","默默","续费","充值","大桥","美味","梦想","黄金","战场","征服","打扰","小花","大花","出货","丫丫","声旺","一波流","小號","渃葉","熵会","落夜","天意","佰圆","二佰","二二","金币","收金","万G","點訫","军装","浅唱","吖妹","续费","大时间","小时间","660","保驾护航","贰百","0万","W金","PJ40","肖废","万金","0块","3015","點芯","-100","90-","美味","W=","可散卖","一百","⒈","⒐","⒉","⒎","萬G","畅游","￥","代刷","陶宝","點訫","宝儿","宝搜","點.卡","饼干","老牌经营","G出售","买G","重.拳.戈.隆","全.网.最.低","全网","荣.誉_征.服","RMB=","包团包毕业","风神无敌","无敌0灯","小可爱","刷红玉","荣.誉","征.服","荣.征","誉.服","波塞冬斯","的Q","小-可","可-爱","H副本","抱团","最后一波","站神","小.甜.心","大/小","小.可","可.爱","十万G","带红玉","接招募","二.佰","42.W","千与千寻","夕瑶歌尽","大{rt2}","小{rt2}","刷屏[勿见]","扰屏[勿见]","月下G","包团","包毕业","挑Z","雪亽","陶{rt2}","{rt2}shop","冰{rt2}","点{rt2}","冰{@}点","挑{@}战","上.陶","锈水财阀","水财阀","{*}冰","{*}点","{*}竞{*}技","月下G团","月下G","牛牛","冰封H黑","封H黑石","大尾巴","内销G团","价格公道","强力老板","躺尸老板","价格便宜啦","黑石G团","皇朝","老板无竞争","强力消费","来老板","跨服H黑石","G团包过","消费老板","消费的老板","支F宝","纵横魔兽","支持躺尸","⑥","⑤","黑石铸造厂","$带走","比例1W","马云消费","散卖","正负","消废","黑石G团","职业老板","清倉","H畢業","黑手门票","内销","赈灾团","畢業","可散"},
	["WhiteList"] = {
	},
	["BlackList"] = {
	},
	["ShieldPlayers"] = {
	},
}


-----------------------------------------------------------------------
-- ChatFilter
-----------------------------------------------------------------------
local _, cf = ...
local Config = cf.Config
local L = cf.L
local _G = _G
local AddFriend = AddFriend
local RemoveFriend = RemoveFriend

local ChatFilter, ChatFilterLv, FriendsFrame, ChatFrames = CreateFrame("Frame"), CreateFrame("Frame"), FriendsFrame
local AddonLoading, prevLineId, orgmsg, adding, addedtime, addedplayer, Latency, craftQuantity, craftItemID, prevCraft
local CacheTable, ShieldTable, _ShieldTable, LevelTable, _LevelTable, ServerTable, AddedTable = {}, {}, {}, {}, {}, {}, {}
local achievements, alreadySent, spellList, totalCreated, resetTimer, craftList = {}, {}, {}, {}, {}, {}
local spamCategories, specialFilters = {[95] = true, [155] = true, [168] = true, [14807] = true, [15165] = true}, {[456] = true, [1400] = true, [1402] = true, [2186] = true, [2187] = true, [2903] = true, [2904] = true, [3004] = true, [3005] = true, [3117] = true, [3259] = true, [3316] = true, [3808] = true, [3809] = true, [3810] = true, [3817] = true, [3818] = true, [3819] = true, [4078] = true, [4079] = true, [4080] = true, [4156] = true, [4576] = true, [4626] = true, [5313] = true, [6954] = true, [7485] = true, [7486] = true, [7487] = true, [8089] = true, [8238] = true, [8246] = true, [8248] = true, [8249] = true, [8260] = true, [8306] = true, [8307] = true, [8398] = true, [8399] = true, [8400] = true, [8401] = true, [8430] = true, [8431] = true, [8432] = true, [8433] = true, [8434] = true, [8435] = true, [8436] = true, [8437] = true, [8438] = true, [8439] = true}

local function deformat(text)
	text = gsub(text, "%.", "%%.")
	text = gsub(text, "%%%d$s", "(.+)")
	text = gsub(text, "%%s", "(.+)")
	text = gsub(text, "%%d", "(%%d+)")
	text = "^"..text.."$"
	return text
end

local createmsg = deformat(LOOT_ITEM_CREATED_SELF)
local createmultimsg = deformat(LOOT_ITEM_CREATED_SELF_MULTIPLE)
local learnpassivemsg = deformat(ERR_LEARN_PASSIVE_S)
local learnspellmsg = deformat(ERR_LEARN_SPELL_S)
local learnabilitymsg = deformat(ERR_LEARN_ABILITY_S)
local unlearnspellmsg = deformat(ERR_SPELL_UNLEARNED_S)
local petlearnspellmsg = deformat(ERR_PET_LEARN_SPELL_S)
local petlearnabilitymsg = deformat(ERR_PET_LEARN_ABILITY_S)
local petunlearnspellmsg = deformat(ERR_PET_SPELL_UNLEARNED_S)
local auctionstartedmsg = deformat(ERR_AUCTION_STARTED)
local auctionremovedmsg = deformat(ERR_AUCTION_REMOVED)
local duelwinmsg = deformat(DUEL_WINNER_KNOCKOUT)
local duellosemsg = deformat(DUEL_WINNER_RETREAT)
local friendaddedmsg = deformat(ERR_FRIEND_ADDED_S)
local friendalreadymsg = deformat(ERR_FRIEND_ALREADY_S)
local friendnotfoundmsg = deformat(ERR_FRIEND_NOT_FOUND)
local friendlistfullmsg = deformat(ERR_FRIEND_LIST_FULL)
local ignorelistfullmsg = deformat(ERR_IGNORE_FULL)
local drunkmsg = {
	deformat(DRUNK_MESSAGE_ITEM_OTHER1),
	deformat(DRUNK_MESSAGE_ITEM_OTHER2),
	deformat(DRUNK_MESSAGE_ITEM_OTHER3),
	deformat(DRUNK_MESSAGE_ITEM_OTHER4),
	deformat(DRUNK_MESSAGE_OTHER1),
	deformat(DRUNK_MESSAGE_OTHER2),
	deformat(DRUNK_MESSAGE_OTHER3),
	deformat(DRUNK_MESSAGE_OTHER4),}

local function SendMessage(event, msg, r, g, b)
	local info = ChatTypeInfo[strsub(event, 10)]
	for i = 1, NUM_CHAT_WINDOWS do
		ChatFrames = _G["ChatFrame"..i]
		if (ChatFrames and ChatFrames:IsEventRegistered(event)) then
			ChatFrames:AddMessage(msg, info.r, info.g, info.b)
		end
	end
end

local function SendAchievement(event, achievementID, players)
	if (not players) then return end
	for k in pairs(alreadySent) do alreadySent[k] = nil end
	for i = getn(players), 1, -1 do
		if (alreadySent[players[i].name]) then
			tremove(players, i)
		else
			alreadySent[players[i].name] = true
		end
	end
	if (getn(players) > 1) then
		sort(players, function(a, b) return a.name < b.name end)
	end
	for i = 1, getn(players) do
		local class, color, r, g, b
		if (players[i].guid and tonumber(players[i].guid)) then
			class = select(2, GetPlayerInfoByGUID(players[i].guid))
			color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		end
		if (not color) then
			local info = ChatTypeInfo[strsub(event, 10)]
			r, g, b = info.r, info.g, info.b
		else
			r, g, b = color.r, color.g, color.b
		end
		players[i] = format("|cff%02x%02x%02x|Hplayer:%s|h%s|h|r", r*255, g*255, b*255, players[i].name, players[i].name)
	end
	SendMessage(event, format(L["Achievement"], table.concat(players, L["Space"]), GetAchievementLink(achievementID)))
end

local function achievementReady(id, achievement)
	if (achievement.area and achievement.guild) then
		local playerGuild = GetGuildInfo("player")
		for i = getn(achievement.area), 1, -1 do
			local player = achievement.area[i].name
			if (UnitExists(player) and playerGuild and playerGuild == GetGuildInfo(player)) then
				tinsert(achievement.guild, tremove(achievement.area, i))
			end
		end
	end
	if (achievement.area and getn(achievement.area) > 0) then
		SendAchievement("CHAT_MSG_ACHIEVEMENT", id, achievement.area)
	end
	if (achievement.guild and getn(achievement.guild) > 0) then
		SendAchievement("CHAT_MSG_GUILD_ACHIEVEMENT", id, achievement.guild)
	end
end

local function talentspecReady(attribute, spells)
	if (not spells) then return end
	for k in pairs(alreadySent) do alreadySent[k] = nil end
	for i = getn(spells), 1, -1 do
		if (alreadySent[spells[i]]) then
			tremove(spells, i)
		else
			alreadySent[spells[i]] = true
		end
	end
	if (getn(spells) > 1) then
		sort(spells, function(a, b) return a < b end)
	end
	for i = 1, getn(spells) do
		spells[i] = GetSpellLink(spells[i])
	end
	if (attribute == "Learn") then
		SendMessage("CHAT_MSG_SYSTEM", format(L["LearnSpell"], table.concat(spells, "")))
	end
	if (attribute == "Unlearn") then
		SendMessage("CHAT_MSG_SYSTEM", format(L["UnlearnSpell"], table.concat(spells, "")))
	end
end

local function ChatFrames_OnUpdate(self, elapsed)
	local found
	for id, resetAt in pairs(resetTimer) do
		if (resetAt <= GetTime()) then
			SendMessage("CHAT_MSG_LOOT", format(LOOT_ITEM_CREATED_SELF_MULTIPLE, (select(2, GetItemInfo(id))), totalCreated[id]))
			totalCreated[id] = nil
			resetTimer[id] = nil
		end
		found = true
	end
	for id, spell in pairs(spellList) do
		if (spell.timeout <= GetTime()) then
			talentspecReady(id, spell)
			spellList[id] = nil
		end
		found = true
	end
	for id, achievement in pairs(achievements) do
		if (achievement.timeout <= GetTime()) then
			achievementReady(id, achievement)
			achievements[id] = nil
		end
		found = true
	end
	if (not found) then
		self:SetScript("OnUpdate", nil)
	end
end

local function queueCraftMessage(craft, itemID, itemQuantity)
	if (prevCraft and prevCraft ~= craft) then return end
	prevCraft = craft
	local Delay
	if (select(3, GetNetStats()) > select(4, GetNetStats())) then
		Delay = select(3, GetNetStats()) / 250 + 0.5
	else
		Delay = select(4, GetNetStats()) / 250 + 0.5
	end
	if (Delay > 3) then Delay = 3 end
	totalCreated[itemID] = (totalCreated[itemID] or 0) + (itemQuantity or 1)
	resetTimer[itemID] = GetTime() + craftList[itemID] + Delay
	ChatFilter:SetScript("OnUpdate", ChatFrames_OnUpdate)
end

local function queueTalentSpecSpam(attribute, spellID)
	spellList[attribute] = spellList[attribute] or {timeout = GetTime() + 0.5}
	tinsert(spellList[attribute], spellID)
	ChatFilter:SetScript("OnUpdate", ChatFrames_OnUpdate)
end

local function queueAchievementSpam(event, achievementID, playerdata)
	achievements[achievementID] = achievements[achievementID] or {timeout = GetTime() + 0.5}
	achievements[achievementID][event] = achievements[achievementID][event] or {}
	tinsert(achievements[achievementID][event], playerdata)
	ChatFilter:SetScript("OnUpdate", ChatFrames_OnUpdate)
end

local function ignoreMore(player)
	if (not player) then return end
	local ignore = nil
	if GetNumIgnores() >= 50 then
		for i = 1, GetNumIgnores() do
			local name = GetIgnoreName(i)
			if (player == name) then
				ignore = true
				break
			end
		end
		if (not ignore) then
			_ShieldTable[player] = true
			SendMessage("CHAT_MSG_SYSTEM", format(ERR_IGNORE_ADDED_S, player))
		end
	end
end

if (Config.IgnoreMore) then
	hooksecurefunc("AddIgnore", ignoreMore)
	hooksecurefunc("AddOrDelIgnore", ignoreMore)
end
if (Config.MergeManufacturing) then
	hooksecurefunc("DoTradeSkill", function(index, quantity)
			local itemID = strmatch(GetTradeSkillItemLink(index), "item:(%d+)")
			if (itemID) then
				craftQuantity = quantity
				craftItemID = tonumber(itemID)
				prevCraft = nil
			end
	end)
	ChatFilter:RegisterEvent("TRADE_SKILL_UPDATE")
end

ChatFilter:RegisterEvent("ADDON_LOADED")
ChatFilter:RegisterEvent("PLAYER_ENTERING_WORLD")

ChatFilter:SetScript("OnEvent", function(self, event)
	if (not Config.Enabled) then return end
	if (event == "ADDON_LOADED") then
		if (Config.noprofanityFilter) then
			SetCVar("profanityFilter", 0)
		end
		if (Config.nowhisperSticky) then
			ChatTypeInfo.WHISPER.sticky = 0
			ChatTypeInfo.BN_WHISPER.sticky = 0
		end
		if (Config.nojoinleaveChannel) then
			for i = 1, NUM_CHAT_WINDOWS do
				ChatFrames = _G["ChatFrame"..i]
				ChatFrame_RemoveMessageGroup(ChatFrames, "CHANNEL")
			end
		end
		if (Config.noaltArrowkey) then
			for i = 1, NUM_CHAT_WINDOWS do
				ChatFrames = _G["ChatFrame"..i.."EditBox"]
				ChatFrames:SetAltArrowKeyMode(false)
			end
		end
		if (Config.noprofanityFilter) then
			SetCVar("profanityFilter", 0)
		end
		AddonLoading = true
	elseif (event == "PLAYER_ENTERING_WORLD") then
		if (Config.FilterByLevel) then
			for k, v in pairs(Config.ShieldPlayers) do
				_ShieldTable[v] = true
			end
			local AddonLoadedTime = GetTime()
			ChatFilterLv:SetScript("OnUpdate", function(self, elapsed)
				if (GetTime() - AddonLoadedTime > 3) then
					AddonLoading = nil
					if (not (AddonLoading or adding)) then
						self:SetScript("OnUpdate", nil)
					end
				end
			end)
		end
	elseif (event == "TRADE_SKILL_UPDATE") then
		if (GetTradeSkillLine() and not IsTradeSkillLinked()) then
			for i = 1, GetNumTradeSkills() do
				if (GetTradeSkillItemLink(i) and GetTradeSkillRecipeLink(i)) then
					local itemID = strmatch(GetTradeSkillItemLink(i), "item:(%d+)")
					local enchantID = strmatch(GetTradeSkillRecipeLink(i), "enchant:(%d+)")
					if (itemID and enchantID) then
						craftList[tonumber(itemID)] = select(7, GetSpellInfo(enchantID)) / 1000
					end
				end
			end
		end
	end
end)

local function ChatFilter_Rubbish(self, event, msg, player, _, _, _, flag, _, _, channel, _, lineId, guid)
	if (not Config.Enabled) then return end
	if (not (guid or player)) then return end
	if (not Config.ScanOurself and UnitIsUnit(player,"player")) then return end
	if (lineId ~= prevLineId) then
		if (flag == "GM" or flag == "DEV") then return end
		if (event == "CHAT_MSG_WHISPER") then
			if (IsAddOnLoaded("WIM") or IsAddOnLoaded("Cellular")) then
				local f = self:GetName() or "?"
				if (f == "WIM_workerFrame" or f == "WIM3_HistoryChatFrame" or f == "Cellular") then
					return
				end
			end
			if (Config.FilterRaidAlert and msg:find(L["RaidAlert"])) then return true end
			if (GetFriendInfo(player)) then return end
			for i = 1, select(2, BNGetNumFriends()) do
				local toon = BNGetNumFriendToons(i)
				for j = 1, toon do
					local _, rName, rGame = BNGetFriendToonInfo(i, j)
					if (rName == player and rGame == "WoW") then return end
				end
			end
		end
		local Time, Name, Server = GetTime()
		if (guid and guid:find("Player")) then
			Name = select(6, GetPlayerInfoByGUID(guid))
			Server = select(7, GetPlayerInfoByGUID(guid))
			player = Name
			if (Server and strlen(Server) > 0 and Server ~= GetRealmName()) then
				player = Name.."-"..Server
			end
		end
		if (ShieldTable[1] and Time - ShieldTable[1].Time  > Config.IgnoreAdTimes * 60) then
			_ShieldTable[ShieldTable[1].Name] = nil
			tremove(ShieldTable, 1)
		end
		if (LevelTable[1] and Time - LevelTable[1].Time > 30 * 60) then
			_LevelTable[LevelTable[1].Name] = nil
			tremove(LevelTable, 1)
		end
		if (_ShieldTable[player]) then
			if (Config.Debug) then
				if (_ShieldTable[player] > 0) then
					print("|cFF33FF99ChatFilter:|r [[''"..player.."'']]的发言被过滤，过滤原因：屏蔽小号，玩家等级：".._ShieldTable[player])
				else
					print("|cFF33FF99ChatFilter:|r [[''"..player.."'']]的发言被过滤，过滤原因：发广告被屏蔽。")
				end
			end
			return true
		end
		if (Config.FilterRepeat or Config.FilterAdvertising) then
			orgmsg = msg
			msg = msg:lower()
			local Symbols = {"%s","%p","，","。","、","？","！","：","；","’","‘","“","”","《","》","（","）","—","…"}
			for i = 1, getn(Symbols) do
				msg = gsub(msg, Symbols[i], "")
			end
		end
		for i = 1, getn(Config.WhiteList) do
			if (msg:find(Config.WhiteList[i]) or orgmsg:find(Config.WhiteList[i])) then
				return
			end
		end
		for i = 1, getn(Config.BlackList) do
			if (msg:find(Config.BlackList[i]) or orgmsg:find(Config.BlackList[i])) then
				if (Config.Debug) then
					print("|cFF33FF99ChatFilter:|r [[''"..player.."'']]的发言被过滤，过滤原因：消息中有黑名单词汇。")
				end
				return true
			end
		end
		local Msg_Data = {Name = player, Msg = msg, Time = Time}
		local Player_Data = {Name = player, Time = Time}
		local matchs = 0
		if (Config.FilterRepeat or Config.FilterMultiLine) then
			local lines, AllowLines, RepeatInterval, RepeatAlike = 1, 10, 10, 95
			if (event == "CHAT_MSG_CHANNEL") then
				RepeatInterval, RepeatAlike, AllowLines = Config.RepeatInterval, Config.RepeatAlike, Config.AllowLines
			end
			for i = getn(CacheTable), 1, -1 do
				local cache = CacheTable[i]
				local interval = Time - cache.Time
				if (interval > Config.RepeatInterval) then
					tremove(CacheTable, i)
				else
					if (Config.FilterMultiLine and cache.Name == player) then
						if (interval < 0.400) then
							lines = lines + 1
						end
						if (lines >= AllowLines) then
							if (Config.Debug) then
								print("|cFF33FF99ChatFilter:|r [[''"..player.."'']]的发言被过滤，过滤原因：多行刷屏，数量："..lines.."行，本次消息为："..msg)
							end
							return true
						end
					end
					if (Config.FilterRepeat and interval < RepeatInterval and (cache.Name == player or (event == "CHAT_MSG_CHANNEL" and strlen(msg) > 20))) then
						if (cache.Msg == msg) then
							if (Config.Debug) then
								print("|cFF33FF99ChatFilter:|r [[''"..player.."'']]的发言被过滤，过滤原因：重复消息刷屏，两次信息间隔："..interval.."秒，本次消息为："..msg.."，上次消息为："..cache.Msg)
							end
							return true
						end
						if (Config.RepeatAlike and Config.RepeatAlike < 100) then
							local count, bigs, smalls = 0
							if (strlen(msg) > strlen(cache.Msg)) then
								bigs = msg
								smalls = cache.Msg
							else
								bigs = cache.Msg
								smalls = msg
							end
							for i = 1, strlen(smalls) do
								if (strfind(bigs, strsub(smalls, i, i + 1), 1, true)) then
									count = count + 1
								end
							end
							if (count / strlen(bigs) * 100 > RepeatAlike) then
								if (Config.Debug) then
									print("|cFF33FF99ChatFilter:|r [[''"..player.."'']]的发言被过滤，过滤原因：重复消息刷屏，两次信息间隔："..interval.."秒，本次消息为："..msg.."，上次消息为："..cache.Msg)
								end
								return true
							end
						end
					end
				end
			end
		end
		if (Config.FilterAdvertising) then
			for i = 1, getn(Config.SafeWords) do
				if (msg:find(Config.SafeWords[i])) then
					matchs = matchs - 1
				end
			end
			for i = 1, getn(Config.DangerWords) do
				local _, Pos = _, 0
				if (strfind(msg, Config.DangerWords[i], Pos + 1)) then
					matchs = matchs + 1
					_, Pos = strfind(msg, Config.DangerWords[i], Pos +1)
					if (strfind(msg, Config.DangerWords[i], Pos + 1)) then
						matchs = matchs + 1
						_, Pos = strfind(msg, Config.DangerWords[i], Pos +1)
						if (strfind(msg, Config.DangerWords[i], Pos + 1)) then
							matchs = matchs + 1
						end
					end
				end
			end
			if (Config.AllowMatchs < 3 and (not CanComplainChat(lineId) or UnitIsInMyGuild(player))) then
				matchs = matchs - 1
			end
			if (matchs > Config.AllowMatchs) then
				if (Config.Debug) then
					print("|cFF33FF99ChatFilter:|r [[''"..player.."'']]的发言被过滤，过滤原因：消息中含有广告，广告数量："..matchs.."个，本次消息为："..msg)
				end
				tinsert(ShieldTable, Player_Data)
				_ShieldTable[player] = 0
				return true
			end
		end
		if (Config.FilterByLevel and (event == "CHAT_MSG_WHISPER" or (not Config.OnlyOnWhisper and event ~= "CHAT_MSG_WHISPER"))) then
			local AllowLevel, added = Config.AllowLevel, nil
			if (Server and strlen(Server) > 0 and Server ~= GetRealmName()) then
				if (event == "CHAT_MSG_GUILD" or channel == L["Channel"]) then
					ServerTable[Server] = true
				else
					if (not ServerTable[Server]) then
						added = true
					end
				end
			end
			if (guid and select(2, GetPlayerInfoByGUID(guid)) == DEATHKNIGHT) then
				if (Config.AllowLevel <= 10) then
					AllowLevel = 55 + Config.AllowLevel / 2
				elseif (Config.AllowLevel <= 60) then
					AllowLevel = 60
				end
			end
			if (_LevelTable[player]) then
				added = true
				if (_LevelTable[player] <= 80) then
					matchs = matchs + 1
				end
			end
			if (matchs > Config.AllowMatchs) then
				if (Config.Debug) then
					print("|cFF33FF99ChatFilter:|r [[''"..player.."'']]的发言被过滤，过滤原因：消息中含有广告且不是满级，广告数量："..(matchs - 1).."个，玩家等级：".._LevelTable[player].."级，本次消息为："..msg)
				end
				tinsert(ShieldTable, Player_Data)
				_ShieldTable[player] = 0
				return true
			end
			if (CanComplainChat(lineId) and not (added or adding or UnitIsInMyGuild(player))) then
				if (not addedtime or Time - addedtime > Latency) then
					adding = true
					addedplayer = player
					AddFriend(addedplayer)
					AddedTable[addedplayer] = true
					ChatFilterLv:RegisterEvent("FRIENDLIST_UPDATE")
					FriendsFrame:UnregisterEvent("FRIENDLIST_UPDATE")
					if (IsAddOnLoaded("Tukui")) then
						TukuiStatFriends:UnregisterEvent("FRIENDLIST_UPDATE")
					end
				end
				ChatFilterLv:SetScript("OnEvent", function(self, event)
					if (event == "FRIENDLIST_UPDATE") then
						if (not GetFriendInfo(addedplayer)) then
							ShowFriends()
						else
							addedtime = GetTime()
							Latency = addedtime - Time
							local _, playerlevel = GetFriendInfo(addedplayer)
							if (playerlevel >= AllowLevel) then
								tinsert(LevelTable, {Name = addedplayer, Time = addedtime})
								_LevelTable[addedplayer] = playerlevel
							elseif (playerlevel > 0) then
								tinsert(ShieldTable, {Name = addedplayer, Time = addedtime})
								_ShieldTable[addedplayer] = playerlevel
							end
							for k in pairs(AddedTable) do
								RemoveFriend(k)
								AddedTable[k] = nil
							end
							adding = nil
						end
						if (not adding) then
							if (IsAddOnLoaded("Tukui")) then
								TukuiStatFriends:RegisterEvent("FRIENDLIST_UPDATE")
							end
							FriendsFrame:RegisterEvent("FRIENDLIST_UPDATE")
							ChatFilterLv:UnregisterEvent("FRIENDLIST_UPDATE")
						end
					end
				end)
			end
		end
		tinsert(CacheTable, Msg_Data)
		prevLineId = lineId
	end
end

local function ChatFilter_Achievement(self, event, msg, player, _, _, _, _, _, _, _, _, _, guid)
	if (not Config.Enabled) then return end
	if (Config.MergeAchievement) then
		local achievementID = strmatch(msg, "achievement:(%d+)")
		if (not achievementID) then return end
		achievementID = tonumber(achievementID)
		local playerdata = {name = player, guid = guid}
		local categoryID = GetAchievementCategory(achievementID)
		if (spamCategories[categoryID] or spamCategories[select(2, GetCategoryInfo(categoryID))] or specialFilters[achievementID]) then
			queueAchievementSpam((event == "CHAT_MSG_GUILD_ACHIEVEMENT" and "guild" or "area"), achievementID, playerdata)
			return true
		end
	end
end

local function ChatFilter_SystemMSG(self, event, msg)
	if (not Config.Enabled) then return end
	if (Config.MergeTalentSpec) then
		local learnID = strmatch(msg, learnspellmsg) or strmatch(msg, learnabilitymsg) or strmatch(msg, learnpassivemsg)
		local unlearnID = strmatch(msg, unlearnspellmsg)
		if (learnID) then
			learnID = tonumber(strmatch(learnID, "spell:(%d+)"))
			queueTalentSpecSpam("Learn", learnID)
			return true
		elseif (unlearnID) then
			unlearnID = tonumber(strmatch(unlearnID, "spell:(%d+)"))
			queueTalentSpecSpam("Unlearn", unlearnID)
			return true
		end
		if (Config.FilterPetTalentSpec and (msg:find(petlearnspellmsg) or msg:find(petlearnabilitymsg) or msg:find(petunlearnspellmsg))) then
			return true
		end
	end
	if (Config.FilterDrunkMSG and not msg:find(L["You"])) then
		for i = 1, getn(drunkmsg) do
			if (msg:find(drunkmsg[i])) then return true end
		end
	end
	if (Config.FilterDuelMSG and (not msg:find(GetUnitName("player"))) and (msg:find(duelwinmsg) or msg:find(duellosemsg))) then return true end
	if (Config.FilterAuctionMSG and (msg:find(auctionstartedmsg) or msg:find(auctionremovedmsg))) then return true end
	if (Config.IgnoreMore and msg:find(ignorelistfullmsg)) then return true end
	if (Config.FilterByLevel) then
		if (AddonLoading) then
			if (msg:find(friendaddedmsg)) then
				local name = gsub(msg, gsub(friendaddedmsg, "%p", ""), "")
				AddedTable[name] = true
				return true
			end
			if (msg:find(friendnotfoundmsg)) then return true end
		end
		if (adding and msg:find(friendnotfoundmsg)) then
			ChatFilterLv:SetScript("OnUpdate", function(self, elapsed)
				adding = nil
				if (not (AddonLoading or adding)) then
					self:SetScript("OnUpdate", nil)
				end
			end)
			return true
		end
		if (msg:find(friendlistfullmsg)) then
			Config.FilterByLevel = nil
			print("|cFF33FF99ChatFilter:|r", L["FriendlistFull"])
		end
		if (not addedplayer) then return end
		msg = gsub(msg, "%-", "")
		addedplayer = gsub(addedplayer, "%-", "")
		if (msg:find(addedplayer) and (msg:find(friendaddedmsg) or msg:find(friendalreadymsg))) then return true end
	end
end

local function ChatFilter_CreateMSG(self, event, msg)
	if (not Config.Enabled) then return end
	if (Config.MergeManufacturing) then
		local craft = self
		local itemID, itemQuantity = strmatch(msg, createmultimsg)
		if (not itemID and not itemQuantity) then
			itemID = strmatch(msg, createmsg)
		end
		if (not itemID) then return end
		itemID = tonumber(strmatch(itemID, "item:(%d+)"))
		itemQuantity = tonumber(itemQuantity)
		if (itemID and craftList[itemID] and craftItemID == itemID and craftQuantity > 1) then
			queueCraftMessage(craft, itemID, itemQuantity)
			return true
		end
	end
end

local function ChatFilter_ReportMSG(self, event, msg)
	if (not Config.Enabled) then return end
	if (Config.FilterRaidAlert and msg:find(L["RaidAlert"])) then return true end
	if (Config.FilterQuestReport and msg:find(L["QuestReport"])) then return true end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", ChatFilter_CreateMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", ChatFilter_SystemMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", ChatFilter_Achievement)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", ChatFilter_Achievement)
-----------------------------------------------------------------------
-- SlashCommand
-----------------------------------------------------------------------
SLASH_CHATFILTER1 = "/chatfilter"
SLASH_CHATFILTER2 = "/cf"

SlashCmdList["CHATFILTER"] = function(msg)
	local cmd = msg:lower()
	if (cmd == "on") then
		Config.Enabled = true
		print("ChatFilter has been enabled.")
	elseif (cmd == "off") then
		Config.Enabled = nil
		print("ChatFilter has been disabled.")
	elseif (cmd == "me") then
		if (Config.ScanOurself) then
			Config.ScanOurself = nil
			print("ScanOurself has been disabled.")
		else
			Config.ScanOurself = true
			print("ScanOurself has been enabled.")
		end
	elseif (cmd == "ad") then
		if (Config.FilterAdvertising) then
			Config.FilterAdvertising = nil
			print("FilterAdvertising has been disabled.")
		else
			Config.FilterAdvertising = true
			print("FilterAdvertising has been enabled.")
		end
	elseif (cmd == "mult") then
		if (Config.FilterMultiLine) then
			Config.FilterMultiLine = nil
			print("FilterMultiLine has been disabled.")
		else
			Config.FilterMultiLine = true
			print("FilterMultiLine has been enabled.")
		end
	elseif (cmd == "repeat") then
		if (Config.FilterRepeat) then
			Config.FilterRepeat = nil
			print("FilterRepeat has been disabled.")
		else
			Config.FilterRepeat = true
			print("FilterRepeat has been enabled.")
		end
	elseif (cmd == "level") then
		if (Config.FilterByLevel) then
			Config.FilterByLevel = nil
			print("FilterByLevel has been disabled.")
		else
			Config.FilterByLevel = true
			print("FilterByLevel has been enabled.")
		end
	elseif (cmd == "achieve") then
		if (Config.MergeAchievement) then
			Config.MergeAchievement = nil
			print("MergeAchievement has been disabled.")
		else
			Config.MergeAchievement = true
			print("MergeAchievement has been enabled.")
		end
	elseif (cmd == "talent") then
		if (Config.MergeTalentSpec) then
			Config.MergeTalentSpec = nil
			print("MergeTalentSpec has been disabled.")
		else
			Config.MergeTalentSpec = true
			print("MergeTalentSpec has been enabled.")
		end
	elseif (cmd == "creat") then
		if (Config.MergeManufacturing) then
			Config.MergeManufacturing = nil
			print("MergeManufacturing has been disabled.")
		else
			Config.MergeManufacturing = true
			print("MergeManufacturing has been enabled.")
		end
	elseif (cmd == "auction") then
		if (Config.FilterAuctionMSG) then
			Config.FilterAuctionMSG = nil
			print("FilterAuctionMSG has been disabled.")
		else
			Config.FilterAuctionMSG = true
			print("FilterAuctionMSG has been enabled.")
		end
	elseif (cmd == "duel") then
		if (Config.FilterDuelMSG) then
			Config.FilterDuelMSG = nil
			print("FilterDuelMSG has been disabled.")
		else
			Config.FilterDuelMSG = true
			print("FilterDuelMSG has been enabled.")
		end
	elseif (cmd == "drunk") then
		if (Config.FilterDrunkMSG) then
			Config.FilterDrunkMSG = nil
			print("FilterDrunkMSG has been disabled.")
		else
			Config.FilterDrunkMSG = true
			print("FilterDrunkMSG has been enabled.")
		end
	elseif cmd == "raidalert" then
		if (Config.FilterRaidAlert) then
			Config.FilterRaidAlert = nil
			print("FilterRaidAlert has been disabled.")
		else
			Config.FilterRaidAlert = true
			print("FilterRaidAlert has been enabled.")
		end
	elseif cmd == "questreport" then
		if (Config.FilterQuestReport) then
			Config.FilterQuestReport = nil
			print("FilterRaidAlert has been disabled.")
		else
			Config.FilterQuestReport = true
			print("FilterQuestReport has been enabled.")
		end
	elseif cmd == "debug" then
		if (Config.Debug) then
			Config.Debug = nil
			print("Debug has been disabled.")
		else
			Config.Debug = true
			print("Debug has been enabled.")
		end
	elseif (cmd == "cache") then
		print("缓存信息："..getn(CacheTable).."条 -- 缓存等级："..getn(LevelTable).."个 -- 屏蔽人物："..getn(Config.ShieldPlayers) + getn(ShieldTable).."个")
	elseif (strfind(cmd, "unignore") == 1) then
		local player = gsub(cmd, "unignore", "")
		player = gsub(player, "%s", "")
		if (_ShieldTable[player]) then
			_ShieldTable[player] = nil
			SendMessage("CHAT_MSG_SYSTEM", format(ERR_IGNORE_REMOVED_S, player))
		else
			SendMessage("CHAT_MSG_SYSTEM", ERR_IGNORE_NOT_FOUND)
		end
	else
		print("/cf [ on/off | ad | mult | repeat | level | achieve | talent | creat ]")
		print("/cf [ raidalert | questreport | duel | drunk | auction | unignore ]")
	end
end

-- 加入/离开大脚世界频道
local bf = CreateFrame("Frame", "bf", ChatFrame1)
local msg
bf:SetSize(18,18) -- 大小
--bf.t = bf:CreateTexture()
--bf.t:SetAllPoints()
--bf.t:SetTexture("Interface\\AddOns\\vChat\\icon.tga")
  bf.t = bf:CreateFontString(nil, 'OVERLAY')
	bf.t:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
	bf.t:SetPoint("CENTER", 0, 0)
	bf.t:SetText("世")
	bf.t:SetTextColor(255/255, 200/255, 150/255)
bf:SetAlpha(0.8)
bf:SetParent(ChatBar)
bf:ClearAllPoints()
--bf:SetPoint('TOPRIGHT', ChatFrame1, 'TOPRIGHT', 0, 25) --位置
bf:SetPoint("LEFT",ChatBar,"RIGHT",0,0)
--bf:SetScript('OnEnter', function(self) self:SetAlpha(1) end) 
--bf:SetScript('OnLeave', function(self) self:SetAlpha(0.2) end) 
bf:SetScript("OnMouseUp", function(self, button) 
     local channels = {GetChannelList()} 
      local isInCustomChannel = false 
      local customChannelName = "大脚世界频道" 
      for i =1, #channels do 
         if channels[i] == customChannelName then 
            isInCustomChannel = true 
         end 
      end 
      if button == "LeftButton" then
            local _, channelName, _  =  GetChannelName("大脚世界频道")
           	if channelName == nil then
		           JoinPermanentChannel("大脚世界频道", nil, 1, 1)
		           ChatFrame_RemoveMessageGroup(ChatFrame1, "CHANNEL")
		           ChatFrame_AddChannel(ChatFrame1,"大脚世界频道")
	          else
		           local channel, _, _  = GetChannelName("大脚世界频道")
		           ChatFrame_OpenChat("/"..channel.." ", chatFrame)
	          end
      elseif button == "RightButton" then
            if isInCustomChannel then 
		           msg = ">>>退出世界频道<<<" 
               LeaveChannelByName(customChannelName) 
            else 
               JoinPermanentChannel(customChannelName,nil,1) 
               msg = ">>>加入世界频道<<<" 
               ChatFrame_AddChannel(ChatFrame1,customChannelName) 
               ChatFrame_RemoveMessageGroup(ChatFrame1,"CHANNEL") 
            end print(msg)
      end
   end) 
