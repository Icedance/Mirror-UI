



------------
--  ����  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\MirrorBuff\\media\\"
cfg.Font = Media.."Hooge.ttf"
cfg.ROADWAY = Media.."Hooge.ttf"
cfg.GlowTex = Media.."solid"
cfg.IconSize = 32 											-- ͼ���С
cfg.Spacing = 2												-- ͼ����
cfg.BUFFpos = {"TOPLEFT", UIParent, "TOPLEFT", 10, -10} 	-- BUFFλ��
cfg.DEUFFpos = {"TOPLEFT", UIParent, "TOPLEFT", 655, -500}	-- DEBUFFλ��
cfg.BuffDirection = 2										-- Buff�������� 1:�������� 2:��������
cfg.DebuffDirection = 1										-- Debuff�������� 1:�������� 2:��������
cfg.WarningTime = 2											-- ��ҫ��ʾ��ʱ��(��)
	
----------------
--  �����ռ�  --
----------------

local _, MR = ...
MR.BuffConfig = cfg

