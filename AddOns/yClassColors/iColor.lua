local myName = UnitName("player")
local myRace = UnitRace("player")
local normal = NORMAL_FONT_COLOR
local green = GREEN_FONT_COLOR
local white = HIGHLIGHT_FONT_COLOR
local defColor = FRIENDS_WOW_NAME_COLOR_CODE
local font = GameFontHighlightSmall:GetFont()
local _G = _G

local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do BC[v] = k end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do BC[v] = k end

local function colorString(string, class)
	local color = class and RAID_CLASS_COLORS[class] or GetQuestDifficultyColor(string)
	if class then
		return format(PLAYER_CLASS_NO_SPEC, color.colorStr, string)			-- PLAYER_CLASS_NO_SPEC = "|c%s%s|r"
	end
	return format("|cff%2x%2x%2x%s|r", color.r*255, color.g*255, color.b*255, string)
end

local function guildRankColor(index)
	local r, g, b = 1, 1, 1
	local pct = index / GuildControlGetNumRanks()
	if pct <= 1.0 and pct >= 0.5 then
		r, g, b = (1.0-pct)*2, 1, 0
	elseif pct >= 0 and pct < 0.5 then
		r, g, b = 1, pct*2, 0
	end
	return r, g, b
end
---------------------------------------------------------------------------------------------------------

local _VIEW
local function setView(view)
	_VIEW = view
end

local function updateGuild()
	_VIEW = _VIEW or GetCVar("guildRosterView")
	local myZone = GetRealZoneText()
	local buttons = GuildRosterContainer.buttons

	for i, button in ipairs(buttons) do
		if button:IsShown() and button.online and button.guildIndex then
			if _VIEW == "tradeskill" then
				local _, _, _, headerName, _, _, _, _, _, _, _, zone = GetGuildTradeSkillInfo(button.guildIndex)
				if not headerName and zone == myZone then
					button.string2:SetTextColor(green.r, green.g, green.b)
				end
			else
				local _, _, rankIndex, level, _, zone = GetGuildRosterInfo(button.guildIndex)
				if _VIEW == "guildStatus" and rankIndex then
					local r, g, b = guildRankColor(rankIndex)
					button.string2:SetTextColor(r, g, b)
				else
					local color = level and GetQuestDifficultyColor(level) or white
					button.string1:SetTextColor(color.r, color.g, color.b)
					if _VIEW == "playerStatus" and zone == myZone then
						button.string3:SetTextColor(green.r, green.g, green.b)
					end
				end
			end
		end
	end
end

local loaded = false
hooksecurefunc("GuildFrame_LoadUI", function()
	if loaded then
		return
	else
		loaded = true
		hooksecurefunc("GuildRoster_SetView", setView)
		hooksecurefunc("GuildRoster_Update", updateGuild)
		hooksecurefunc(GuildRosterContainer, "update", updateGuild)
	end
end)

local function updateFriends()
	local buttons = FriendsFrameFriendsScrollFrame.buttons
	local myZone = GetRealZoneText()

	for i = 1, #buttons do
		local nameText, infoText
		local button = buttons[i]
		if button:IsShown() then
			if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
				local name, level, class, area, connected = GetFriendInfo(button.id)
				if connected then
					name = colorString(name, BC[class])
					level = colorString(level)
					class = colorString(class, BC[class])
					nameText = name .. ", " .. LEVEL .. level .. " " .. class
					if area and area == myZone then infoText = format("|cff00ff00%s|r", area) end
				end
			elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
				local _, presenceName, _, _, _, toonID, client, isOnline = BNGetFriendInfo(button.id)
				if isOnline and client == BNET_CLIENT_WOW then
					local _, toonName, _, _, _, _, _, class, _, zoneName, level = BNGetToonInfo(toonID)
					if presenceName and toonName then
						level = colorString(level)
						toonName = colorString(toonName, BC[class])
						nameText = presenceName .. " " .. defColor .. "(Lv" .. level .. " " .. toonName .. defColor .. ")"
					end
					if zoneName and zoneName == myZone then infoText = format("|cff00ff00%s|r", zoneName) end
				end
			end
		end
		if nameText then button.name:SetText(nameText) end
		if infoText then button.info:SetText(infoText) end
	end
end

hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", updateFriends)
hooksecurefunc("FriendsFrame_UpdateFriends", updateFriends)

hooksecurefunc("WhoList_Update", function()
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	local menu = UIDropDownMenu_GetSelectedID(WhoFrameDropDown)
	local myZone = GetRealZoneText()
	local myGuild = GetGuildInfo("player")
	local myInfo = { myZone, myGuild, myRace }

	for i = 1, WHOS_TO_DISPLAY, 1 do
		local name, guild, level, race, class, zone, classFileName = GetWhoInfo(whoOffset + i)
		if not name then break end

		local color = classFileName and RAID_CLASS_COLORS[classFileName] or normal
		_G["WhoFrameButton"..i.."Name"]:SetTextColor(color.r, color.g, color.b)
		color = level and GetQuestDifficultyColor(level) or white
		_G["WhoFrameButton"..i.."Level"]:SetTextColor(color.r, color.g, color.b)
		local columnTable = { zone, guild, race }
		color = columnTable[menu] == myInfo[menu] and green or white
		_G["WhoFrameButton"..i.."Variable"]:SetTextColor(color.r, color.g, color.b)
	end
end)

hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local name, level, _, _, _, _, _, class, _, _, isIneligible = SearchLFGGetResults(index);
	if name and name ~= myName and not isIneligible then
		local color = class and RAID_CLASS_COLORS[class] or normal
		button.name:SetTextColor(color.r, color.g, color.b)
		color = level and GetQuestDifficultyColor(level) or white
		button.level:SetTextColor(color.r, color.g, color.b)
	end
end)

hooksecurefunc("WorldStateScoreFrame_Update", function()
	local isArena = IsActiveBattlefieldArena()
	local scrollOffset = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame)

	for i = 1, MAX_WORLDSTATE_SCORE_BUTTONS do
		local scoreButton = _G["WorldStateScoreButton"..i]
		local name, _, _, _, _, faction, _, _, classToken = GetBattlefieldScore(scrollOffset + i)
		if name and faction and classToken then
			local n, s = strsplit("-", name, 2)
			n = colorString(n, classToken)
			if n == myName then
				n = "> " .. n .. " <"
			end
			if s then
				if isArena then
					n = n.."|cffffffff - |r"..(faction==0 and "|cff20ff20" or "|cffffd200")..s.."|r"
				else
					n = n.."|cffffffff - |r"..(faction==0 and "|cffff2020" or "|cff00aef0")..s.."|r"
				end
			end
			scoreButton.name.text:SetText(n)
		end
	end
end)