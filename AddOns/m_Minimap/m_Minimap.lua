-- Config
local Scale = 1.06			-- Minimap scale
local ClassColorBorder = true	-- Should border around minimap be classcolored? Enabling it disables color settings below
local r, g, b, a = 1, 1, 1, .8	-- Border colors and alhpa. More info: http://www.wowwiki.com/API_Frame_SetBackdropColor
local BGThickness = 1           -- Border thickness in pixels
local MapPosition = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -15, 16}
local zoneTextYOffset = 10		-- Zone text position

-- Shape, location and scale
function GetMinimapShape() return "SQUARE" end
Minimap:ClearAllPoints()
Minimap:SetPoint(MapPosition[1], MapPosition[2], MapPosition[3], MapPosition[4] / Scale, MapPosition[5] / Scale)
MinimapCluster:SetScale(Scale)
--Minimap:SetFrameStrata("BACKGROUND")
Minimap:SetFrameLevel(10)

-- Mask texture hint => addon will work with Carbonite
local hint = CreateFrame("Frame")
local total = 0
local SetTextureTrick = function(self, elapsed)
    total = total + elapsed
    if(total > 2) then
        Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
        hint:SetScript("OnUpdate", nil)
    end
end

hint:RegisterEvent("PLAYER_LOGIN")
hint:SetScript("OnEvent", function()
    hint:SetScript("OnUpdate", SetTextureTrick)
end)

-- Background
Minimap:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", insets = {
    top = -BGThickness,
    left = -BGThickness,
    bottom = -BGThickness,
    right = -BGThickness
}})
if(ClassColorBorder==true) then
    local _, class = UnitClass("player")
    local t = RAID_CLASS_COLORS[class]
    Minimap:SetBackdropColor(t.r, t.g, t.b, a)
else
    Minimap:SetBackdropColor(r, g, b, a)
end

-- Mousewheel zoom
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)

-- Hiding ugly things
local dummy = function() end
local _G = getfenv(0)

local frames = {
    "GameTimeFrame",
    "MinimapBorderTop",
    "MinimapNorthTag",
    "MinimapBorder",
    "MinimapZoneTextButton",
    "MinimapZoomOut",
    "MinimapZoomIn",
    "MiniMapVoiceChatFrame",
    "MiniMapWorldMapButton",
    "MiniMapMailBorder",
--  "MiniMapBattlefieldBorder",
--    "FeedbackUIButton",
}

for i in pairs(frames) do
    _G[frames[i]]:Hide()
    _G[frames[i]].Show = dummy
end
MinimapCluster:EnableMouse(false)

-- Tracking
MiniMapTrackingBackground:SetAlpha(0)
MiniMapTrackingButton:SetAlpha(0)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap, -5, -5)

-- BG icon
--MiniMapBattlefieldFrame:ClearAllPoints()
--MiniMapBattlefieldFrame:SetPoint("TOP", Minimap, "TOP", 2, 8)

-- LFG icon
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("TOP", Minimap, "TOP", 0, 4)
QueueStatusMinimapButtonBorder:Hide()
--QueueStatusMinimapButton:SetFrameStrata("MEDIUM")

-- Instance Difficulty flag
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 1, 1)
MiniMapInstanceDifficulty:SetScale(0.75)
MiniMapInstanceDifficulty:SetFrameStrata("LOW")

-- Guild Instance Difficulty flag
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -3, 1)
GuildInstanceDifficulty:SetScale(0.75)
GuildInstanceDifficulty:SetFrameStrata("LOW")

-- Mail icon
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -6)
MiniMapMailIcon:SetTexture("Interface\\AddOns\\m_Minimap\\mail")

-- Invites Icon
GameTimeCalendarInvitesTexture:ClearAllPoints()
GameTimeCalendarInvitesTexture:SetParent("Minimap")
GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")

if FeedbackUIButton then
FeedbackUIButton:ClearAllPoints()
FeedbackUIButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6, -6)
FeedbackUIButton:SetScale(0.8)
end

if StreamingIcon then
StreamingIcon:ClearAllPoints()
StreamingIcon:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 8, 8)
StreamingIcon:SetScale(0.8)
end

-- Creating right click menu
local menuFrame = CreateFrame("Frame", "m_MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = "角色信息",
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = "法术书",
    func = function() ToggleSpellBook("spell") end},
    {text = "天赋",
    func = function() ToggleTalentFrame() end},
    {text = "成就",
    func = function() ToggleAchievementFrame() end},
    {text = "任务日志",
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = "好友",
    func = function() ToggleFriendsFrame(1) end},
    {text = "公会",
    func = function() ToggleGuildFrame(1) end},
    {text = "PvP",
    func = function() ToggleFrame(PVPFrame) end},
    {text = "地下城查找器",
    func = function() ToggleFrame(PVEFrame) end},
	{text = "藏品",
    func = function() ToggleCollectionsJournal(1) end},
    {text = "帮助请求",
    func = function() ToggleHelpFrame() end},
    {text = "日历",
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
    {text = "地下城手册",
	func = function() ToggleEncounterJournal() end},
    {text = "商城",
	func = function() ToggleStoreUI() end},
}


--要塞按钮 
   GarrisonLandingPageMinimapButton:ClearAllPoints()
   GarrisonLandingPageMinimapButton:SetWidth(35)
   GarrisonLandingPageMinimapButton:SetHeight(35)
   GarrisonLandingPageMinimapButton:SetPoint("TOPRIGHT", Minimap, 18, 38) 
   
--[[local menuList = {
    {text = CHARACTER_BUTTON,
	notCheckable = true,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON,
	notCheckable = true,
    func = function() ToggleFrame(SpellBookFrame) end},
    {text = TALENTS_BUTTON,
	notCheckable = true,
    func = function() ToggleTalentFrame() end},
    {text = ACHIEVEMENT_BUTTON,
	notCheckable = true,
    func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON,
	notCheckable = true,
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = SOCIAL_BUTTON,
	notCheckable = true,
    func = function() ToggleFriendsFrame(1) end},
    {text = GUILD,
	notCheckable = true,
    func = function() ToggleGuildFrame() end},
    {text = PLAYER_V_PLAYER,
	notCheckable = true,
    func = function() ToggleFrame(PVPFrame) end},
    {text = LFG_TITLE,
	notCheckable = true,
    func = function() PVEFrame_ToggleFrame('GroupFinderFrame', LFDParentFrame) end},
	{text = PET_JOURNAL,
	notCheckable = true,
    func = function() TogglePetJournal() end},
    {text = HELP_BUTTON,
	notCheckable = true,
    func = function() ToggleHelpFrame() end},
    {text = SLASH_CALENDAR1:gsub("/(.*)","%1"),
    notCheckable = true,	
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
    {text = ENCOUNTER_JOURNAL,
	notCheckable = true,
	func = function() ToggleEncounterJournal() end},
}
]]
-- Click func
Minimap:SetScript("OnMouseUp", function(_, btn)
    if(btn=="MiddleButton") then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", 0, 0)
    elseif(btn=="RightButton") then
        EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1)
	else
		local x, y = GetCursorPosition()
		x = x / Minimap:GetEffectiveScale()
		y = y / Minimap:GetEffectiveScale()
		local cx, cy = Minimap:GetCenter()
		x = x - cx
		y = y - cy
		if ( sqrt(x * x + y * y) < (Minimap:GetWidth() / 2) ) then
			Minimap:PingLocation(x, y)
		end
		Minimap_SetPing(x, y, 1)
	end
end) 

-- Clock
if not IsAddOnLoaded("Blizzard_TimeManager") then
	LoadAddOn("Blizzard_TimeManager")
end
local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
clockFrame:Hide()
clockTime:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
clockTime:SetTextColor(1,1,1,0)
TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -3)
TimeManagerClockButton:SetScript("OnClick", function(_,btn)
 	if btn == "LeftButton" then
		TimeManager_Toggle()
	end 
	if btn == "RightButton" then
		if not CalendarFrame then
			LoadAddOn("Blizzard_Calendar")
		end
		Calendar_Toggle()
	end
end)



--世界标记
local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton

wm:SetParent("UIParent")
wm:ClearAllPoints()
wm:SetPoint("LEFT", Minimap, "LEFT", -10, 20)
wm:SetSize(16, 16)
wm:Hide()

wm.TopLeft:Hide()
wm.TopRight:Hide()
wm.BottomLeft:Hide()
wm.BottomRight:Hide()
wm.TopMiddle:Hide()
wm.MiddleLeft:Hide()
wm.MiddleRight:Hide()
wm.BottomMiddle:Hide()
wm.MiddleMiddle:Hide()

wm:RegisterEvent("GROUP_ROSTER_UPDATE")
wm:HookScript("OnEvent", function(self, event) 


   if UnitIsGroupAssistant("player") or UnitIsGroupLeader("player") or (IsInGroup() and not IsInRaid()) then 
      self:Show() 
   else 
      self:Hide() 
   end 
end)

local wmmenuFrame = CreateFrame("Frame", "wmRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local wmmenuList = {
    {text = "就位确认",
    func = function() DoReadyCheck() end},
    {text = "角色检查",
    func = function() InitiateRolePoll() end},
    {text = "转化为团队",
    func = function() ConvertToRaid() end},
    {text = "转化为小队",
    func = function() ConvertToParty() end},
}

wm:SetScript('OnMouseUp', function(self, button)
wm:StopMovingOrSizing()
    if (button=="RightButton") then
        EasyMenu(wmmenuList, wmmenuFrame, "cursor", -10, 90, "MENU", 2)
    end
end) 

--讓DropDownList1回到屏幕
--DropDownList1:SetClampedToScreen(true)

--保持随机图标鼠标提示不出屏幕
--LFDSearchStatus:SetClampedToScreen(true)
--LFDDungeonReadyStatus:SetClampedToScreen(true)

local lock_map_position = true  					-- lock your map in set position
local mpos = {"CENTER",UIParent,"CENTER",0,65}		-- set position for locked map

local player, cursor
local function gen_string(point, X, Y)
	local t = WorldMapButton:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	t:SetFont("Fonts\\FRIZQT__.TTF",12)
	t:SetPoint('BOTTOMLEFT', WorldMapButton, point, X, Y)
	t:SetJustifyH('LEFT')
	return t
end
local function Cursor()
	local left, top = WorldMapDetailFrame:GetLeft() or 0, WorldMapDetailFrame:GetTop() or 0
	local width, height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()
	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height
	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then return end
	return cx, cy
end
local function OnUpdate(player, cursor)
	local cx, cy = Cursor()
	local px, py = GetPlayerMapPosition("player")
	if cx and cy then
		cursor:SetFormattedText('Cursor: %.2d,%.2d', 100 * cx, 100 * cy)
	else
		cursor:SetText("")
	end
	if px == 0 or py == 0 then
		player:SetText("")
	else
		player:SetFormattedText('Player: %.2d,%.2d', 100 * px, 100 * py)
	end
	-- gotta change coords position for maximized world map
	if WorldMapQuestScrollFrame:IsShown() then
		player:SetPoint('BOTTOMLEFT', WorldMapButton, 'BOTTOM',-120,0)
		cursor:SetPoint('BOTTOMLEFT', WorldMapButton, 'BOTTOM',50,0)
	else
		player:SetPoint('BOTTOMLEFT', WorldMapButton, 'BOTTOM',-120,-19)
		cursor:SetPoint('BOTTOMLEFT', WorldMapButton, 'BOTTOM',50,-19)
	end
end



