



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's AuraWatch\\Media\\"
--cfg.Font = "Fonts\\FRIZQT__.ttf"
cfg.Font =STANDARD_TEXT_FONT
cfg.Statusbar = Media.."statusbar"
cfg.GlowTex = Media.."glowTex"
cfg.Solid = Media.."solid"
	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.AuraWatchConfig = cfg

