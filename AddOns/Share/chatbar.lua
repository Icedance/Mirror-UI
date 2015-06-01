local config = {
	--["CopyURL"] = true,	--复制链接
	--["CopyChat"] = true,	--复制聊天
	--["ChatScroll"] = true,	--卷动
	--["MoveEditBox"] = true,	--移动输入框到聊天框顶上
	["ChatBar"] = true,		--频道条
	["ChatBarOnMouseOver"] = true,	--频道条鼠标可见
	["ChatBarFadeOutAlpha"] = 0.7,	--淡出时的透明度
		}

	-----------------------------------------------------------------------------
	-- chat bar
	-----------------------------------------------------------------------------
	if config.ChatBar then
		local backdrop = { 
		  bgFile = "Interface\\Buttons\\WHITE8x8", 
		  edgeFile = "Interface\\Buttons\\WHITE8x8", 
		  tile = false, tileSize = 0, edgeSize = 1, 
		  insets = { left = 1, right = 1, top = 1, bottom = 1 }
		}
--		local chatFrame = SELECTED_DOCK_FRAME or DEFAULT_CHAT_FRAME
--		local editBox = chatFrame.editBox
--		COLORSCHEME_BORDER = {0.3,0.3,0.3,1}
		local editBox = ChatEdit_ChooseBoxForSend()
		local chatFrame = editBox.chatFrame
		
		local chatbar = CreateFrame("Frame","MyChatBar",UIParent)
		chatbar:SetSize(158,6)
		chatbar:SetPoint("BOTTOMLEFT",220,5) --位置
		if UIMovableFrames then table.insert(UIMovableFrames,chatbar) end
		
		chatbar:SetBackdrop(backdrop)
		chatbar:SetBackdropColor(0,0,0,0.4)
		chatbar:SetBackdropBorderColor(0,0,0)
		
		local CreateText = function(channel,Clickfunction,posX,r,g,b)
			-- local LC= {
			-- ["SAY"] = "说",
			-- ["YELL"] = "喊",
			-- ["PARTY"] = "队",
			-- ["RAID"] = "团",
			-- ["BG"] = "战",
			-- ["GUILD"] = "会",
			-- ["WHISPER"] = "密",
			-- ["CHANNEL1"] = "综",
			-- }
			
			local frame = CreateFrame("Button","MyChatBar"..channel,chatbar)
			frame:SetSize(12,12)
			frame:SetPoint("LEFT",posX,0)
			frame:RegisterForClicks("AnyUp")
			frame:SetScript("OnClick", function() Clickfunction() end)
			frame:SetBackdrop(backdrop)
			frame:SetBackdropColor(r,g,b)
			frame:SetBackdropBorderColor(0,0,0)			
			
			-- frame.text = frame:CreateFontString("MyChatBar"..channel.."TEXT","OVERLAY")
			-- frame.text:SetFont("Fonts\\ARKai_T.ttf", 12, "OUTLINE")
			-- frame.text:SetJustifyH("CENTER")
			-- frame.text:SetText(LC[channel])
			-- frame.text:SetAllPoints()
			-- frame.text:SetTextColor(r,g,b)
		end
				
		local offset = 5
		
		--say
		local function say_OnClick()
			ChatFrame_OpenChat("/s ",chatFrame)
		end
		CreateText("SAY",say_OnClick,offset,1,1,1)
		offset = offset + 17
		
		--yell
		local function yell_OnClick()
			ChatFrame_OpenChat("/y ",chatFrame)
		end
		CreateText("YELL",yell_OnClick,offset,1,64/255,64/255)
		offset = offset + 17
		
		--party
		local function party_OnClick()
			ChatFrame_OpenChat("/p ",chatFrame)
		end
		CreateText("PARTY",party_OnClick,offset,170/255,170/255,1)
		offset = offset + 17
		
		--raid
		local function raid_OnClick()
			ChatFrame_OpenChat("/ra ",chatFrame)
		end
		CreateText("RAID",raid_OnClick,offset,255/255,127/255,0)
		offset = offset + 17
		
		--bg
		local function bg_OnClick()
			ChatFrame_OpenChat("/bg ",chatFrame)
		end
		CreateText("BG",bg_OnClick,offset,255/255,127/255,0)
		offset = offset + 17
		
		--GUILD
		local function guild_OnClick()
			ChatFrame_OpenChat("/g ",chatFrame)
		end
		CreateText("GUILD",guild_OnClick,offset,64/255,255/255,64/255)
		offset = offset + 17
		
		--whisper
		local function whisper_OnClick(self,button)
			if button == "RightButton" then
				 ChatFrame_ReplyTell(chatFrame)
				if not editBox:IsVisible() or editBox:GetAttribute("chatType") ~= "WHISPER" then
					ChatFrame_OpenChat("/w ", chatFrame)
				end
			else
				if(UnitExists("target") and UnitName("target") and UnitIsPlayer("target") and GetDefaultLanguage("player")==GetDefaultLanguage("target") )then
					local name, realm = UnitName("target")
					ChatFrame_OpenChat("/w "..name.." " , chatFrame);
				else
					ChatFrame_OpenChat("/w ", chatFrame);
				end
			end
		end
		CreateText("WHISPER",whisper_OnClick,offset,255/255,128/255,255/255)
		offset = offset + 17
		
		--CHANNEL1
		local function channel1_OnClick()
			ChatFrame_OpenChat("/1. ",chatFrame)
		end
		CreateText("CHANNEL1",channel1_OnClick,offset,255/255, 207/255, 164/255)
		offset = offset + 17
		
		--roll
		local roll = CreateFrame("Button", "MyChatBarROLL", chatbar, "SecureActionButtonTemplate")
		roll:SetAttribute("*type*", "macro")
		roll:SetAttribute("macrotext", "/roll")
		roll:SetWidth(12)
		roll:SetHeight(12)
		roll:SetPoint("LEFT",offset,0)
		roll:SetBackdrop({ 
			  bgFile = "Interface\\Buttons\\WHITE8x8", 
			  edgeFile = "Interface\\Buttons\\WHITE8x8", 
			  tile = false, tileSize = 0, edgeSize = 1, 
			  insets = { left = 1, right = 1, top = 1, bottom = 1 }
			})
		roll:SetBackdropColor(0.5,0.5,0.2)
		roll:SetBackdropBorderColor(0,0,0)	

		-- rollText =roll:CreateFontString("rollText", "OVERLAY")
		-- rollText:SetFont("fonts\\ARhei.ttf", 12, "OUTLINE")
		-- rollText:SetJustifyH("CENTER")
		-- rollText:SetWidth(20)
		-- rollText:SetHeight(20)
		-- rollText:SetText("掷")
		-- rollText:SetPoint("CENTER", 0, 0)
		-- rollText:SetTextColor(0.5, 0.5, 0.2)
		if config.ChatBarOnMouseOver then
			local _G = _G
			local fs = {
					"SAY",
					"YELL",
					"PARTY",
					"RAID",
					"BG",
					"GUILD",
					"WHISPER",
					"CHANNEL1",
					"ROLL",
					}
			local lighton = function(a)
				for i,v in pairs(fs) do
					local f = _G["MyChatBar"..v]
					 f:SetAlpha(a)
				end
					_G["MyChatBar"]:SetAlpha(a)
			end
			
			_G["MyChatBar"]:SetAlpha(config.ChatBarFadeOutAlpha or 0)
			-- _G["MyChatBar"]:SetScript("OnEnter", function(self) lighton(1) end)
			-- _G["MyChatBar"]:SetScript("OnLeave", function(self) lighton(config.ChatBarFadeOutAlpha or 0) end)
			for i,v in pairs(fs) do
				local f = _G["MyChatBar"..v]
				f:SetAlpha(config.ChatBarFadeOutAlpha or 0)
				f:HookScript("OnEnter", function(self) UIFrameFadeIn(f, .2, f:GetAlpha(), 1) end)
				f:HookScript("OnLeave", function(self) UIFrameFadeIn(f, .3, f:GetAlpha(), config.ChatBarFadeOutAlpha) end)			
			end
		end
	end