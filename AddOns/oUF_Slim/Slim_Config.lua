local addon, ns = ...
local cfg = CreateFrame("Frame")
local mediaFolder = "Interface\\AddOns\\dMedia\\"	-- don't touch this ...
local blankTex = "Interface\\Buttons\\WHITE8x8"

local SMOOTH = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
}

cfg.TTColors = {
	[1] = {0.752,0.172,0.02},
	[2] = {0.741,0.580,0.04},		
	[3] = {0,0.443,0.631},
	[4] = {0.6,1,0.945},	
}

local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local WHITE_HEX = '|cffffffff'

local function Hex(r, g, b)
	if(type(r) == 'table') then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	
	if(not r or not g or not b) then
		r, g, b = 1, 1, 1
	end
	
	return format('|cff%02x%02x%02x', r*255, g*255, b*255)
end
-- http://www.wowwiki.com/ColorGradient
local function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end
	
	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

------------
-- colors --
------------
	cfg.maincolor = {53/255, 69/255, 105/255}				-- portrait BG, raid health bar, castbar colorͷ�񱳾�,�Ŷ�Ѫ��,ʩ������ɫ
	cfg.sndcolor = {255/255, 207/255, 164/255}				-- font color, ...������ɫ
	cfg.trdcolor = {30/255, 30/255, 30/255}					-- castbar colorʩ������ɫ
	cfg.backdropcolor = {26/255, 25/255, 31/255}			-- backdrop color������ɫ	
	cfg.brdcolor = {0/255, 0/255, 0/255}					-- border color�߿���ɫ

		cfg.TransparencyMode = true						-- ����/���� ͸��ģʽ - ͸����Ѫ��, ���� ְҵ/��תȾɫ�ı���. ���˿�����Ư��, ��������˵Ҳ���Ѻ�.
	cfg.hpTransMcolor = {40/255, 40/255, 40/255}			-- health bar color - Transparency Mode, only��������ɫ - ������͸��ģʽ
	cfg.hpTransMalpha = 0.4									-- healthbar alpha - Transparency Mode, only������͸���� - ������͸��ģʽ
	
-----------	
-- media --
-----------
	cfg.HPtex = mediaFolder.."dM3"							-- health bar texture����������
	cfg.PPtex = mediaFolder.."dM2"							-- power bar texture����������
	cfg.CBtex = mediaFolder.."dM2"							-- castbar textureʩ��������
	cfg.Itex = blankTex										-- BG texture��������
	cfg.Auratex = mediaFolder.."dBBorderL"					-- border texture for buffs/debuffs buff��debuff�ı߿����

	cfg.NameFont = STANDARD_TEXT_FONT				-- font used for text (names)�������ֵ�����		
	cfg.NumbFont = STANDARD_TEXT_FONT, 9, "OUTLINE MONOCHROME"				-- font used for numbers���ֵ�����		
	cfg.NameFS = 14											-- name font size���������С
	cfg.NumbFS = 13 										-- number font size (power value, etc.)���������С(��������ֵ����)
	cfg.hpNumbFS = 15										-- health value font size (player, target, focus)����ֵ�����С(���,Ŀ��,����)
	cfg.CastFS = 14											-- castbar font sizeʩ���������С		
	cfg.ComboFS = 9										-- combo point and class points font size�������ְҵ�������С
	cfg.RaidFS = 12											-- font size for numbers (aura, class tags) on raid frames�Ŷӿ����aura��ְҵ��ǩ���������С
	cfg.FontF = "THINOUTLINE"						-- "THINOUTLINE", "OUTLINE MONOCHROME", "OUTLINE" or nil (no outline)4��ѡ��ֱ���ϸ��ߣ�������ߣ�����ߣ������
	cfg.fontFNum = "THINOUTLINE"							
	
----------------------
-- general settings --
----------------------	
	cfg.Numberzzz = 1						-- 0 will display 18400k as 18k, 1 = 18.4k, ....0 ����� 18400 ��ʾΪ 18k, 1 = 18.4k�ȵ�
	cfg.FadeOutAlpha = 0.3 					-- alpha for out of range units (oUF_SpellRange plugin, required)�������뵥λ͸����(��Ҫ���oUF_SpellRange)
	cfg.BarFadeAlpha = 0.0					-- alpha for oUF_BarFader (required) plugin (can be 0 - 1)oUF_BarFader ��͸����
	
	-- switches -- true/false (on/off)
	cfg.useCastbar = true					-- show/hide player, target, focus castbar��ʾ/���� ���,Ŀ��,����ʩ����
	cfg.useSpellIcon = true					-- show/hide castbar spellicon��ʾ/���� ʩ����ͼ��
	cfg.Castbarsafe = false 				-- ʩ�����ӳ�
	cfg.showXpRep = false					-- show/hide xp/rep display on mouseover (player)��ʾ/���� �����������ʾ��ҵľ���/����
	cfg.delay = 2							-- delay in seconds until xp/rep is shown��ʾ ����/�������ӳ�
	
	cfg.buSize = 20							-- aura size for all frames except raid���п��(�����Ŷ�)��aura��С
	cfg.buSizeRaid = 22						-- aura size for raid�Ŷӿ�ܵ�aura��С
	cfg.buHeightMulti = 1					-- aura size height multiplier (1 = square), rectangle ftw :p aura�Ŀ�߱��� (1 = ������), Ҳ�����ϲ�������� :p
	
------------
-- player --
------------
	cfg.showDebuff = false					--��oUFͷ������ʾ��������debuff
	cfg.PlayerRightSideSpellIcon = true		-- switch player's castbars spell icon position from left to right����ҵ�ʩ����ͼ�������ƶ����ұ�
		
------------
-- target --
------------
	cfg.totot = false						--Ŀ���Ŀ���Ŀ��
	cfg.TargetRightSideSpellIcon = false	-- switch target's castbars spell icon position from left to right��Ŀ���ʩ����ͼ�������ƶ����ұ�
	
	cfg.onlyShowPlayerBuffs = false 		-- only show buffs casted by player (target and focus)(��Ŀ��ͽ�����Ч)
	cfg.onlyShowPlayerDebuffs = false		-- only show debuffs casted by player (target and focus)(��Ŀ��ͽ�����Ч)	
	
-----------
-- focus --
-----------
	cfg.FocusRightSideSpellIcon = false		-- switch focus's castbars spell icon position from left to right�����ʩ����ͼ�������ƶ����ұ�
	
-----------
-- party --
-----------
	cfg.PartyFrames = true				-- set to false to disable party frames����/���� С�ӿ��
	cfg.PartyTarget = true			--����Ŀ��
----------
-- raid --
----------
	cfg.RaidFrames = false	 				-- set to false to disable raid frame groups 1-5 ����/���� �Ŷӿ��(����1-5)
	cfg.RaidFrames2 = false	 				-- set to false to disable raid frame groups 6-8 ����/���� �Ŷӿ��(����6-8)
	cfg.disableRaidFrameManager = false		-- enable/disable blizzards raidframe manager����/���� blizzards�Ŷӹ���
	cfg.RaidDebuffNumb = 2					-- maximum number of visible debuffs on raidframes�Ŷӿ���п���ʾ��debuff�������
	
-----------
-- arena --
-----------
	cfg.ArenaFrames = false	 				-- set to false to disable arena frames����/���� ���������
	
---------------
-- main tank --
---------------
	cfg.MTFrames = false	 					-- set to false to disable main tank frames����/���� ��̹�˿��

----------
-- boss --
----------
	cfg.BossFrames = false	 				-- set to false to disable boss frames	����/���� Boss���

-------------------
-- aura specific --
-------------------
	cfg.HideBlizzardAuras = false			-- hide blizzard buff, debuff and weapon enchant frame AND replace them with oUF's buffs/debuffs����/���������buff/debuffֻ��ʾoUFͷ���
	cfg.HideAuraTimer = 180					-- spell timer is shown for shorter durations, than set value, hidden otherwise�����趨ֵ������ʱ����ʾ�϶̵�ʱ��,��������
	cfg.FilterAuras = true					-- filter arena, party and raid auras by applying a whitelist (the whitelist can be found in Slim_AuraFilterList.lua)ͨ���ṩһ�ݰ����������˾�����,С�Ӻ��Ŷ� Auras (�������б���Slim_AuraFilterList.lua��)
	
---------------	
-- framesize --
---------------
	-- height
	cfg.heightP = 14		-- player���
	cfg.heightT = 14		-- targetĿ��
	cfg.heightF = 12		-- Focus����	
	cfg.heightS = 14 		-- ToT, FocusTarget, petĿ���Ŀ��, ����Ŀ��, ����
	cfg.heightM = 10 		-- MT, boss frames	��̹��, Boss����	
	cfg.heightPA = 11		-- party, party pet - arenaС��, С�ӳ��� - ������
	cfg.heightR = 24		-- raid�Ŷ�
	cfg.heightCB = 4		-- class bar ְҵ���߶�

	-- width
	cfg.widthP = 225		-- player���
	cfg.widthT = 225		-- targetĿ��
	cfg.widthF = 200		-- Focus	����	
	cfg.widthM = 180 		-- MT, boss frames��̹��, Boss����
	cfg.widthS = 46 		-- ToT, FocusTarget, pet, party petĿ���Ŀ��, ����Ŀ��, ����, С�ӳ���
	cfg.widthPA = 200 		-- party - arenaС�� - ������
	cfg.widthR = 64 		-- raid�Ŷ�
	cfg.widthCB = 30		-- class bar
	
	-- hp|pp height, pp|info offset (optional)
	cfg.heightHP = 18		-- change frame height above, instead
	cfg.heightPP = 3.5		-- power height�����߶�
	cfg.PPyOffset = 3.5		-- power y-Offset, can be a positiv/negative (down/up) value������λ��
	
--------------------------------	
-- oUF_WeaponEnchant settings ----oUF������ħģ��oUF_WeaponEnchant����
--------------------------------
	cfg.WeapEnchantIconSize	= 30			-- oUF_WeaponEnchant icon size������ħͼ���С(��oUF_WeaponEnchant)

	
ns.cfg = cfg	-- don't touch this ...��������
