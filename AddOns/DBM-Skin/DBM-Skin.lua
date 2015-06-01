--[[
Author: Affli@RU-Howling Fjord, 
Modified: Loshine
All rights reserved.
]]--
--Config

local DBMskin = true
local croprwicons = true			-- crops blizz shitty borders from icons in RaidWarning messages
local rwiconsize = 18			-- RaidWarning icon size, because 12 is small for me. Works only if croprwicons=true
local buttonsize = 24
local shadow = false  --true for shadow style, false for 1px style
--local StatusBarTexture = "Interface\\AddOns\\DBM-Skin\\media\\Minimalist"
local StatusBarTexture = "Interface\\AddOns\\DBM-Skin\\media\\statusbar"

--Config End


local applyFailed = false

if DBMskin then
	local DBMSkin = CreateFrame("Frame")
	DBMSkin:RegisterEvent("PLAYER_LOGIN")
	DBMSkin:SetScript("OnEvent", function()
		if IsAddOnLoaded("DBM-Core") then
			local mult = 768 / string.match(GetCVar("gxResolution"), "%d+x(%d+)") / min(2, max(0.64, 768 / string.match(GetCVar("gxResolution"), "%d+x(%d+)")))
			local function CreateShadow(self)
				self.shadow = CreateFrame("Frame", nil, self)
				self.shadow:SetFrameLevel(1)
				self.shadow:SetFrameStrata(self:GetFrameStrata())
				self.shadow:SetPoint("TOPLEFT", -3, 3)
				self.shadow:SetPoint("BOTTOMRIGHT", 3, -3)
				self.shadow:SetBackdrop({
					edgeFile = "Interface\\AddOns\\DBM-Skin\\media\\glowTex", 
					edgeSize = 5,
					insets = { left = 4, right = 4, top = 4, bottom = 4 }
				})
				self.shadow:SetBackdropBorderColor(0,0,0)
			end

			local function CreateBorder(self)
				self.Border = CreateFrame("Frame", nil, self)
				self.Border:SetPoint("TOPLEFT", 1, -1)
				self.Border:SetPoint("BOTTOMRIGHT", -1, 1)
				self.Border:SetBackdrop({
					edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = mult, 
					insets = {left = -mult, right = -mult, top = -mult, bottom = -mult} 
				})
				self.Border:SetBackdropBorderColor(0, 0, 0, 1)
				self.Border:SetFrameLevel(0)
			end
			
			local function SkinBars(self)
				for bar in self:GetBarIterator() do
					if not bar.injected then
						bar.ApplyStyle=function()
							applyFailed = true
							local frame = bar.frame
							local tbar = _G[frame:GetName().."Bar"]
							local spark = _G[frame:GetName().."BarSpark"]
							local texture = _G[frame:GetName().."BarTexture"]
							local icon1 = _G[frame:GetName().."BarIcon1"]
							local icon2 = _G[frame:GetName().."BarIcon2"]
							local name = _G[frame:GetName().."BarName"]
							local timer = _G[frame:GetName().."BarTimer"]

							if not (icon1.overlay) then
								icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
								--icon1.overlay:CreatePanel(template, buttonsize+2, buttonsize+2, "BOTTOMRIGHT", tbar, "BOTTOMLEFT", -buttonsize/4, -3)
								icon1.overlay:SetFrameLevel(1)
								icon1.overlay:SetSize(buttonsize+2, buttonsize+2)
								icon1.overlay:SetFrameStrata("BACKGROUND")
								icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -buttonsize/4, -3)

								local backdroptex = icon1.overlay:CreateTexture(nil, "BORDER")
								backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=])
								backdroptex:SetPoint("TOPLEFT", icon1.overlay, "TOPLEFT", 3, -3)
								backdroptex:SetPoint("BOTTOMRIGHT", icon1.overlay, "BOTTOMRIGHT", -3, 3)
								backdroptex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
								CreateBorder(icon1.overlay)
								if shadow then
									CreateShadow(icon1.overlay)
								end
							end

							if not (icon2.overlay) then
								icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
								--icon2.overlay:CreatePanel(template, buttonsize+2, buttonsize+2, "BOTTOMLEFT", tbar, "BOTTOMRIGHT", buttonsize/4, -3)
								icon2.overlay:SetFrameLevel(1)
								icon2.overlay:SetSize(buttonsize+2, buttonsize+2)
								icon2.overlay:SetFrameStrata("BACKGROUND")
								icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", buttonsize/4, -3)

								local backdroptex = icon2.overlay:CreateTexture(nil, "BORDER")
								backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=])
								backdroptex:SetPoint("TOPLEFT", icon2.overlay, "TOPLEFT", 3, -3)
								backdroptex:SetPoint("BOTTOMRIGHT", icon2.overlay, "BOTTOMRIGHT", -3, 3)
								backdroptex:SetTexCoord(0.08, 0.92, 0.08, 0.92)		
								CreateBorder(icon2.overlay)
								if shadow then
									CreateShadow(icon2.overlay)
								end
							end

							if bar.color then
								tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
							else
								tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
							end

							if bar.enlarged then frame:SetWidth(bar.owner.options.HugeWidth) else frame:SetWidth(bar.owner.options.Width) end
							if bar.enlarged then tbar:SetWidth(bar.owner.options.HugeWidth) else tbar:SetWidth(bar.owner.options.Width) end

							if not frame.styled then
								frame:SetScale(1)
								frame.SetScale = function() return end
								frame:SetHeight(buttonsize/2)
								if shadow then
									if not frame.bg then
										frame.bg = CreateFrame("Frame", nil, frame)
										frame.bg:SetPoint("TOPLEFT", 0, 0)
										frame.bg:SetPoint("BOTTOMRIGHT", 0, 0)
									end
									CreateShadow(frame.bg)
								else
									CreateBorder(frame)
								end
								frame.styled=true
							end

							if not spark.killed then
								spark:SetAlpha(0)
								spark:SetTexture(nil)
								spark.killed=true
							end

							if not icon1.styled then
								icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)
								icon1:ClearAllPoints()
								icon1:SetPoint("TOPLEFT", icon1.overlay, 3, -3)
								icon1:SetPoint("BOTTOMRIGHT", icon1.overlay, -3, 3)
								icon1.styled=true
							end

							if not icon2.styled then
								icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
								icon2:ClearAllPoints()
								icon2:SetPoint("TOPLEFT", icon2.overlay, 3, -3)
								icon2:SetPoint("BOTTOMRIGHT", icon2.overlay, -3, 3)
								icon2.styled=true
							end

							if not texture.styled then
								texture:SetTexture(StatusBarTexture)
								texture.styled=true
							end

							tbar:SetStatusBarTexture(StatusBarTexture)
							if not tbar.styled then
								tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
								tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)

								tbar.styled=true
							end

							if not name.styled then
								name:ClearAllPoints()
								name:SetPoint("LEFT", frame, "LEFT", 4, 2)
								name:SetWidth(165)
								name:SetHeight(8)
								name:SetFont(GameTooltipText:GetFont(), 14, "THINOUTLINE")
								name:SetJustifyH("LEFT")
								name:SetShadowColor(0, 0, 0, 0)
								name.SetFont = function() return end
								name.styled=true
							end

							if not timer.styled then	
								timer:ClearAllPoints()
								timer:SetPoint("RIGHT", frame, "RIGHT", -4, 2)
								timer:SetFont(GameTooltipText:GetFont(), 14, "THINOUTLINE")
								timer:SetJustifyH("RIGHT")
								timer:SetShadowColor(0, 0, 0, 0)
								timer.SetFont = function() return end
								timer.styled=true
							end

							if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
							if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
							tbar:SetAlpha(1)
							frame:SetAlpha(1)
							texture:SetAlpha(1)
							frame:Show()
							bar:Update(0)
							bar.injected=true
							applyFailed = false
						end
						bar:ApplyStyle()
					end
					if applyFailed then
						applyFailed = false
					end
				end
			end
	 
			local SkinBossTitle=function()
				local anchor=DBMBossHealthDropdown:GetParent()
				if not anchor.styled then
					local header={anchor:GetRegions()}
						if header[1]:IsObjectType("FontString") then
							header[1]:SetFont(GameTooltipText:GetFont(), 14, "THINOUTLINE")
							header[1]:SetTextColor(1,1,1,1)
							header[1]:SetShadowColor(0, 0, 0, 0)
							anchor.styled=true	
						end
					header=nil
				end
				anchor=nil
			end

			local SkinBoss=function()
				local count = 1
				while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
					local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
					local background = _G[bar:GetName().."BarBorder"]
					local progress = _G[bar:GetName().."Bar"]
					local name = _G[bar:GetName().."BarName"]
					local timer = _G[bar:GetName().."BarTimer"]
					local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]	

					if (count == 1) then
						local	_, anch, _ ,_, _ = bar:GetPoint()
						bar:ClearAllPoints()
						if DBM.Options.HealthFrameGrowUp then
							bar:SetPoint("BOTTOM", anch, "TOP" , 0 , 12)
						else
							bar:SetPoint("TOP", anch, "BOTTOM" , 0, -buttonsize)
						end
					else
						bar:ClearAllPoints()
						if DBM.Options.HealthFrameGrowUp then
							bar:SetPoint("TOPLEFT", prev, "TOPLEFT", 0, buttonsize+4)
						else
							bar:SetPoint("TOPLEFT", prev, "TOPLEFT", 0, -(buttonsize+4))
						end
					end

					if not bar.styled then
						bar:SetHeight(buttonsize/2)
						if shadow then
							if not bar.bg then
								bar.bg = CreateFrame("Frame", nil, bar)
								bar.bg:SetPoint("TOPLEFT", 0, 0)
								bar.bg:SetPoint("BOTTOMRIGHT", 0, 0)
							end
							CreateShadow(bar.bg)
						else
							CreateBorder(bar)
						end
						background:SetNormalTexture(nil)
						bar.styled=true
					end	
			
					if not progress.styled then
						progress:SetStatusBarTexture(StatusBarTexture)
						progress.styled=true
					end				
					progress:ClearAllPoints()
					progress:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, -2)
					progress:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)
		
					if not name.styled then
						name:ClearAllPoints()
						name:SetPoint("LEFT", bar, "LEFT", 4, 2)
						name:SetFont(GameTooltipText:GetFont(), 14, "THINOUTLINE")
						name:SetJustifyH("LEFT")
						name:SetShadowColor(0, 0, 0, 0)
						name.styled=true
					end
			
					if not timer.styled then
						timer:ClearAllPoints()
						timer:SetPoint("RIGHT", bar, "RIGHT", -4, 2)
						timer:SetFont(GameTooltipText:GetFont(), 14, "THINOUTLINE")
						timer:SetJustifyH("RIGHT")
						timer:SetShadowColor(0, 0, 0, 0)
						timer.styled=true
					end
					count = count + 1
				end
			end

			-- mwahahahah, eat this ugly DBM.
			hooksecurefunc(DBT,"CreateBar",SkinBars)
			hooksecurefunc(DBM.BossHealth,"Show",SkinBossTitle)
			hooksecurefunc(DBM.BossHealth,"AddBoss",SkinBoss)
			hooksecurefunc(DBM.BossHealth,"UpdateSettings",SkinBoss)

			local RaidNotice_AddMessage_=RaidNotice_AddMessage
			RaidNotice_AddMessage=function(noticeFrame, textString, colorInfo)
				if textString:find(" |T") then
					textString = string.gsub(textString,"(:12:12)",":18:18:0:0:64:64:5:59:5:59")
				end
				return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
			end
		end
	end)
		
		
	local ForceOptions = function()
		DBM.Options.Enabled=true
		DBT_PersistentOptions["Scale"] = 1
		DBT_PersistentOptions["HugeScale"] = 1.2
		DBT_PersistentOptions["BarYOffset"] = 18
		DBT_PersistentOptions["HugeBarYOffset"] = 22
		DBT_PersistentOptions["ExpandUpwards"] = true
		DBT_PersistentOptions["Height"] = 10
	end

	local loadOptions = CreateFrame("Frame")
	loadOptions:RegisterEvent("PLAYER_LOGIN")
	loadOptions:SetScript("OnEvent", ForceOptions)

end