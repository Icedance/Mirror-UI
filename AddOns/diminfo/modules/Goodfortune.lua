local addon, ns = ...
local cfg = ns.cfg
local panel = CreateFrame("Frame", nil, UIParent)

if cfg.Goodfortune == true then
    local Stat = CreateFrame("Frame")
    Stat:EnableMouse(true)

    local Text  = panel:CreateFontString(nil, "OVERLAY")
    Text:SetFont(unpack(cfg.Fonts))
    Text:SetPoint(unpack(cfg.GoodfortunePoint))
	Stat:SetAllPoints(Text)
	
	local Goodfortune = 0
	local a,b
	local function formatGoodfortune() return format("%d".."|cffffd700要塞资源|r", Goodfortune) end
	
	Stat:SetScript("OnUpdate", function()
		a, Goodfortune, b = GetCurrencyInfo(824)
		Text:SetText(formatGoodfortune())
	end)

end