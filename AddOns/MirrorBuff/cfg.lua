



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\MirrorBuff\\media\\"
cfg.Font = Media.."Hooge.ttf"
cfg.ROADWAY = Media.."Hooge.ttf"
cfg.GlowTex = Media.."solid"
cfg.IconSize = 32 											-- 图标大小
cfg.Spacing = 2												-- 图标间距
cfg.BUFFpos = {"TOPLEFT", UIParent, "TOPLEFT", 10, -10} 	-- BUFF位置
cfg.DEUFFpos = {"TOPLEFT", UIParent, "TOPLEFT", 655, -500}	-- DEBUFF位置
cfg.BuffDirection = 2										-- Buff增长方向 1:从右向左 2:从左向右
cfg.DebuffDirection = 1										-- Debuff增长方向 1:从右向左 2:从左向右
cfg.WarningTime = 2											-- 闪耀提示的时间(秒)
	
----------------
--  命名空间  --
----------------

local _, MR = ...
MR.BuffConfig = cfg

