-- Thanks to Aurora for the code

local addon, ns = ...
ns.icrowMedia = {}

local M = M or ns.icrowMedia

M.media = {
	["solid"] = "Interface\\AddOns\\SYRoll\\Media\\Solid",
	["statusbar"] = "Interface\\AddOns\\SYRoll\\Media\\Statusbar",
	["shadow"] = "Interface\\AddOns\\SYRoll\\Media\\GlowTex",
	["font"] = ChatFontNormal:GetFont(),
	["pixelfont"] = "Interface\\AddOns\\SYRoll\\Media\\semplice.ttf",
}

M.dummy = function() end

M.CreateBG = function(f, a, anchor)
	if f.bg then return end
	local p = anchor or f
	local bg = CreateFrame("Frame", nil, f)
	local level = f:GetFrameLevel() > 0 and f:GetFrameLevel() - 1 or 0
	bg:SetFrameLevel(level)
	bg:SetBackdrop({
		bgFile = M.media.solid,
		edgeFile = M.media.solid,
		edgeSize = 1,
	})
	bg:SetPoint("TOPLEFT", p, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", p, 1, -1)
	bg:SetBackdropColor(.05, .05, .05, a or .95)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	f.bg = bg
	return bg
end

M.CreateSD = function(f, offset)
	if f.shadow then return end
	local sd = CreateFrame("Frame", nil, f)
	sd.offset = offset or 0
	local level = f:GetFrameLevel() > 0 and f:GetFrameLevel() - 1 or 0
	sd:SetFrameLevel(level)
	sd:SetBackdrop({
		edgeFile = M.media.shadow,
		edgeSize = 4,
	})
	sd:SetPoint("TOPLEFT", f, -4 - sd.offset, 4 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", f, 4 + sd.offset, -4 - sd.offset)
	sd:SetBackdropBorderColor(0, 0, 0, 1)
	f.shadow = sd
	return sd
end

M.CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture(M.media.solid)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
end

icrowMedia = ns.icrowMedia