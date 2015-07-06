local addon
gsddddddf,info_bar_ns = ...
local cfg = CreateFrame("Frame")

-- enable modules


--left



cfg.Friends = true
cfg.FriendsPoint = {"right", UIParent, "topright", -295, -20}

cfg.Guild = true
cfg.GuildPoint = {"right", UIParent, "topright", -220, -20}

cfg.Bags = false
cfg.BagsPoint = {"right", UIParent, "topright", -370, -20}

cfg.Gold = true
cfg.GoldPoint = {"right", UIParent, "topright", -370, -20}

cfg.Mail = false
cfg.MailPoint = {"bottomleft", UIParent, 290, 7}

--right


cfg.Time = true
cfg.TimePoint = {"BOTTOM", "Minimap", "BOTTOM", 0, 5}

cfg.System = true
cfg.SystemPoint = {"right", UIParent, "topright", -88, -20}

cfg.Memory = true
cfg.MemoryPoint = {"right", UIParent, "topright", -16, -20}
cfg.MaxAddOns = 20


cfg.Goodfortune = false
cfg.GoodfortunePoint = {"bottomright", UIParent, -600, 7}

--

cfg.Positions = true
cfg.PositionsPoint = {"BOTTOM", "Minimap", "TOP", 0, 14}

cfg.Spec = false
cfg.SpecPoint = {"bottomright", UIParent, -210,1}

cfg.Coords = false
cfg.CoordsPoint = {"bottom", Minimap, 0,1}

cfg.Durability = true
cfg.DurabilityPoint = {"right", UIParent, "topright", -455, -20}

--Fonts and Colors
cfg.Fonts = {STANDARD_TEXT_FONT, 14, "thinoutline"}
cfg.ColorClass = false


info_bar_ns.cfg = cfg