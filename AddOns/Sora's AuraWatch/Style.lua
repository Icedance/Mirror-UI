----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig
local class = select(2, UnitClass("player")) 
local CLASS_COLORS = RAID_CLASS_COLORS[class]


-- BuildICON
function cfg.BuildICON(iconSize)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetWidth(iconSize)
	Frame:SetHeight(iconSize)
	--√
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetAllPoints()
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) 
	--√
	Frame.Shadow = CreateFrame("Frame", nil, Frame)
	Frame.Shadow:SetPoint("TOPLEFT", 0, 0)
	Frame.Shadow:SetPoint("BOTTOMRIGHT", 0, 0)
	Frame.Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex , edgeSize = 1,
	})
	Frame.Shadow:SetBackdropBorderColor(0,0,0,1)
	Frame.Shadow:SetFrameLevel(0)
	
	Frame.Border = CreateFrame("Frame", nil, Frame)
	Frame.Border:SetPoint("TOPLEFT", -1, 1)
	Frame.Border:SetPoint("BOTTOMRIGHT", 1, -1)
	Frame.Border:SetBackdrop({ 
		edgeFile = cfg.Solid , edgeSize = 1,
	})
	Frame.Border:SetBackdropBorderColor(0, 0, 0, 1)
	Frame.Border:SetFrameLevel(0)
    --√
	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 14, "THINOUTLINE") 
	Frame.Count:SetPoint("BOTTOMRIGHT", 3, -1)
	--√
	Frame.Cooldown = CreateFrame("Cooldown", nil, Frame, "CooldownFrameTemplate") 
	Frame.Cooldown:SetAllPoints() 
	Frame.Cooldown:SetReverse(true)

	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 9, "OUTLINE MONOCHROME") 
	Frame.Count:SetPoint("TOP", 2, 9)
	
	Frame.Value = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Value:SetFont(cfg.Font, 15, "THINOUTLINE") 
	Frame.Value:SetPoint("BOTTOMLEFT",Frame.Icon,"BOTTOMRIGHT",0,0)

	Frame:Hide()
	return Frame
end

-- BuildBAR
function cfg.BuildBAR(barWidth, iconSize)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetWidth(barWidth)
	Frame:SetHeight(iconSize)
	--√
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetWidth(iconSize)
	Frame.Icon:SetHeight(iconSize)
	Frame.Icon:SetPoint("RIGHT", Frame, "LEFT", -5, 0)
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	Frame.Border = CreateFrame("Frame", nil, Frame)
	Frame.Border:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
	Frame.Border:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
	Frame.Border:SetBackdrop({edgeFile = cfg.Solid , edgeSize = 1})
	Frame.Border:SetBackdrop({ 
		edgeFile = cfg.Solid , edgeSize = 1,
	})
	Frame.Border:SetBackdropBorderColor(0.8, 0.8, 0.8, 1)
	Frame.Border:SetFrameLevel(0)
	--√
	Frame.Border.Shadow = CreateFrame("Frame", nil, Frame.Border)
	Frame.Border.Shadow:SetPoint("TOPLEFT", 0, 0)
	Frame.Border.Shadow:SetPoint("BOTTOMRIGHT", 0, 0)
	Frame.Border.Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex , edgeSize = 3,
	})
	Frame.Border.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	Frame.Border.Shadow:SetFrameLevel(0)
	
	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame) 
	Frame.Statusbar:SetHeight(iconSize/4)	
	Frame.Statusbar:SetPoint("BOTTOMLEFT", 0, 0)
	Frame.Statusbar:SetPoint("BOTTOMRIGHT", 0, 0)
	Frame.Statusbar:SetStatusBarTexture(cfg.Statusbar) 
	Frame.Statusbar:SetStatusBarColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b, 0.9)
	Frame.Statusbar:SetMinMaxValues(0, 1) 
	Frame.Statusbar:SetValue(0) 
    --√
	Frame.Statusbar.Shadow = CreateFrame("Frame", nil, Frame.Statusbar)
	Frame.Statusbar.Shadow:SetPoint("TOPLEFT", -2, 2)
	Frame.Statusbar.Shadow:SetPoint("BOTTOMRIGHT", 2, -2)
	Frame.Statusbar.Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex , edgeSize = 2,
	})
	Frame.Statusbar.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	Frame.Statusbar.Shadow:SetFrameLevel(0)
    --√
	Frame.Statusbar.BG = Frame.Statusbar:CreateTexture(nil, "BACKGROUND")
	Frame.Statusbar.BG:SetAllPoints() 
	Frame.Statusbar.BG:SetTexture(cfg.Statusbar)
	Frame.Statusbar.BG:SetVertexColor(1, 1, 1, 0.2) 
	--√
	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 14, "THINOUTLINE") 
	Frame.Count:SetPoint("BOTTOMRIGHT", Frame.Icon, "BOTTOMRIGHT", 3, -1) 
    --√
	Frame.Time = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Time:SetFont(cfg.Font, 16, "THINOUTLINE") 
	Frame.Time:SetPoint("RIGHT", 0, 10) 
    
	Frame.Spellname = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Spellname:SetFont(cfg.Font, 14, "OUTLINE") 
	Frame.Spellname:SetPoint("LEFT", 5, 10) 
	
	Frame:Hide()
	return Frame
end

-- BuildBAR2
function cfg.BuildBAR2(barWidth, iconSize)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetWidth(barWidth)
	Frame:SetHeight(iconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetWidth(iconSize)
	Frame.Icon:SetHeight(iconSize)
	Frame.Icon:SetPoint("RIGHT", Frame, "LEFT", -5, 0)
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	Frame.Border = CreateFrame("Frame", nil, Frame)
	Frame.Border:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
	Frame.Border:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
	Frame.Border:SetBackdrop({edgeFile = cfg.Solid , edgeSize = 1})
	Frame.Border:SetBackdropBorderColor(0.8, 0.8, 0.8, 1)
	Frame.Border:SetFrameLevel(0)
	
	Frame.Border.Shadow = CreateFrame("Frame", nil, Frame.Border)
	Frame.Border.Shadow:SetPoint("TOPLEFT", -3, 3)
	Frame.Border.Shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	Frame.Border.Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex , edgeSize = 3,
	})
	Frame.Border.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	Frame.Border.Shadow:SetFrameLevel(0)
	
	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame) 
	Frame.Statusbar:SetHeight(iconSize/5)	
	Frame.Statusbar:SetPoint("BOTTOMLEFT", 0, 0)
	Frame.Statusbar:SetPoint("BOTTOMRIGHT", 0, 0)
	Frame.Statusbar:SetStatusBarTexture(cfg.Statusbar) 
	Frame.Statusbar:SetStatusBarColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b, 0.9)
	Frame.Statusbar:SetMinMaxValues(0, 1) 
	Frame.Statusbar:SetValue(0) 

	Frame.Statusbar.Shadow = CreateFrame("Frame", nil, Frame.Statusbar)
	Frame.Statusbar.Shadow:SetPoint("TOPLEFT", -1.5, 1.5)
	Frame.Statusbar.Shadow:SetPoint("BOTTOMRIGHT", 1.5, -1.5)
	Frame.Statusbar.Shadow:SetBackdrop({edgeFile = cfg.GlowTex , edgeSize = 1.5})
	Frame.Statusbar.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	Frame.Statusbar.Shadow:SetFrameLevel(0)

	Frame.Statusbar.BG = Frame.Statusbar:CreateTexture(nil, "BACKGROUND")
	Frame.Statusbar.BG:SetAllPoints() 
	Frame.Statusbar.BG:SetTexture(cfg.Statusbar)
	Frame.Statusbar.BG:SetVertexColor(1, 1, 1, 0) 
	
	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 14, "THINOUTLINE") 
	Frame.Count:SetPoint("BOTTOMRIGHT", Frame.Icon, "BOTTOMRIGHT", 3, -1) 

	Frame.Time = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Time:SetFont(cfg.Font, 16, "THINOUTLINE") 
	Frame.Time:SetPoint("RIGHT", 0, 10) 

	Frame.Spellname = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Spellname:SetFont(cfg.Font, 14, "OUTLINE") 
	Frame.Spellname:SetPoint("LEFT", 5, 10) 
	
	Frame:Hide()
	return Frame
end

SR.AuraWatchConfig = cfg