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
	cfg.maincolor = {53/255, 69/255, 105/255}				-- portrait BG, raid health bar, castbar color头像背景,团队血条,施法条颜色
	cfg.sndcolor = {255/255, 207/255, 164/255}				-- font color, ...字体颜色
	cfg.trdcolor = {30/255, 30/255, 30/255}					-- castbar color施法条颜色
	cfg.backdropcolor = {26/255, 25/255, 31/255}			-- backdrop color背景颜色	
	cfg.brdcolor = {0/255, 0/255, 0/255}					-- border color边框颜色

		cfg.TransparencyMode = true						-- 启用/禁用 透明模式 - 透明化血条, 伴随 职业/反转染色的背景. 除了看起來漂亮, 对治疗来说也很友好.
	cfg.hpTransMcolor = {40/255, 40/255, 40/255}			-- health bar color - Transparency Mode, only生命条颜色 - 仅限于透明模式
	cfg.hpTransMalpha = 0.4									-- healthbar alpha - Transparency Mode, only生命条透明度 - 仅限于透明模式
	
-----------	
-- media --
-----------
	cfg.HPtex = mediaFolder.."dM3"							-- health bar texture生命条材质
	cfg.PPtex = mediaFolder.."dM2"							-- power bar texture能量条材质
	cfg.CBtex = mediaFolder.."dM2"							-- castbar texture施法条材质
	cfg.Itex = blankTex										-- BG texture背景材质
	cfg.Auratex = mediaFolder.."dBBorderL"					-- border texture for buffs/debuffs buff和debuff的边框材质

	cfg.NameFont = STANDARD_TEXT_FONT				-- font used for text (names)姓名文字的字体		
	cfg.NumbFont = STANDARD_TEXT_FONT, 9, "OUTLINE MONOCHROME"				-- font used for numbers数字的字体		
	cfg.NameFS = 14											-- name font size姓名字体大小
	cfg.NumbFS = 13 										-- number font size (power value, etc.)数字字体大小(比如能量值字体)
	cfg.hpNumbFS = 15										-- health value font size (player, target, focus)生命值字体大小(玩家,目标,焦点)
	cfg.CastFS = 14											-- castbar font size施法条字体大小		
	cfg.ComboFS = 9										-- combo point and class points font size连击点和职业点字体大小
	cfg.RaidFS = 12											-- font size for numbers (aura, class tags) on raid frames团队框体的aura或职业标签数字字体大小
	cfg.FontF = "THINOUTLINE"						-- "THINOUTLINE", "OUTLINE MONOCHROME", "OUTLINE" or nil (no outline)4种选择分别是细描边，像素描边，粗描边，无描边
	cfg.fontFNum = "THINOUTLINE"							
	
----------------------
-- general settings --
----------------------	
	cfg.Numberzzz = 1						-- 0 will display 18400k as 18k, 1 = 18.4k, ....0 将会把 18400 显示为 18k, 1 = 18.4k等等
	cfg.FadeOutAlpha = 0.3 					-- alpha for out of range units (oUF_SpellRange plugin, required)超出距离单位透明度(需要插件oUF_SpellRange)
	cfg.BarFadeAlpha = 0.0					-- alpha for oUF_BarFader (required) plugin (can be 0 - 1)oUF_BarFader 的透明度
	
	-- switches -- true/false (on/off)
	cfg.useCastbar = true					-- show/hide player, target, focus castbar显示/隐藏 玩家,目标,焦点施法条
	cfg.useSpellIcon = true					-- show/hide castbar spellicon显示/隐藏 施法条图标
	cfg.Castbarsafe = false 				-- 施法条延迟
	cfg.showXpRep = false					-- show/hide xp/rep display on mouseover (player)显示/隐藏 鼠标左键点击显示玩家的经验/声望
	cfg.delay = 2							-- delay in seconds until xp/rep is shown显示 经验/声望的延迟
	
	cfg.buSize = 20							-- aura size for all frames except raid所有框架(除了团队)的aura大小
	cfg.buSizeRaid = 22						-- aura size for raid团队框架的aura大小
	cfg.buHeightMulti = 1					-- aura size height multiplier (1 = square), rectangle ftw :p aura的宽高比例 (1 = 正方形), 也许你会喜欢长方形 :p
	
------------
-- player --
------------
	cfg.showDebuff = false					--在oUF头像上显示玩家自身的debuff
	cfg.PlayerRightSideSpellIcon = true		-- switch player's castbars spell icon position from left to right把玩家的施法条图标从左边移动到右边
		
------------
-- target --
------------
	cfg.totot = false						--目标的目标的目标
	cfg.TargetRightSideSpellIcon = false	-- switch target's castbars spell icon position from left to right把目标的施法条图标从左边移动到右边
	
	cfg.onlyShowPlayerBuffs = false 		-- only show buffs casted by player (target and focus)(对目标和焦点生效)
	cfg.onlyShowPlayerDebuffs = false		-- only show debuffs casted by player (target and focus)(对目标和焦点生效)	
	
-----------
-- focus --
-----------
	cfg.FocusRightSideSpellIcon = false		-- switch focus's castbars spell icon position from left to right焦点的施法条图标从左边移动到右边
	
-----------
-- party --
-----------
	cfg.PartyFrames = true				-- set to false to disable party frames启用/禁用 小队框架
	cfg.PartyTarget = true			--队伍目标
----------
-- raid --
----------
	cfg.RaidFrames = false	 				-- set to false to disable raid frame groups 1-5 启用/禁用 团队框架(队伍1-5)
	cfg.RaidFrames2 = false	 				-- set to false to disable raid frame groups 6-8 启用/禁用 团队框架(队伍6-8)
	cfg.disableRaidFrameManager = false		-- enable/disable blizzards raidframe manager启用/禁用 blizzards团队管理
	cfg.RaidDebuffNumb = 2					-- maximum number of visible debuffs on raidframes团队框架中可显示的debuff最大数量
	
-----------
-- arena --
-----------
	cfg.ArenaFrames = false	 				-- set to false to disable arena frames启用/禁用 竞技场框架
	
---------------
-- main tank --
---------------
	cfg.MTFrames = false	 					-- set to false to disable main tank frames启用/禁用 主坦克框架

----------
-- boss --
----------
	cfg.BossFrames = false	 				-- set to false to disable boss frames	启用/禁用 Boss框架

-------------------
-- aura specific --
-------------------
	cfg.HideBlizzardAuras = false			-- hide blizzard buff, debuff and weapon enchant frame AND replace them with oUF's buffs/debuffs禁用/启用自身的buff/debuff只显示oUF头像的
	cfg.HideAuraTimer = 180					-- spell timer is shown for shorter durations, than set value, hidden otherwise超过设定值则法术计时器显示较短的时间,否则隐藏
	cfg.FilterAuras = true					-- filter arena, party and raid auras by applying a whitelist (the whitelist can be found in Slim_AuraFilterList.lua)通过提供一份白名单来过滤竞技场,小队和团队 Auras (白名单列表在Slim_AuraFilterList.lua中)
	
---------------	
-- framesize --
---------------
	-- height
	cfg.heightP = 14		-- player玩家
	cfg.heightT = 14		-- target目标
	cfg.heightF = 12		-- Focus焦点	
	cfg.heightS = 14 		-- ToT, FocusTarget, pet目标的目标, 焦点目标, 宠物
	cfg.heightM = 10 		-- MT, boss frames	主坦克, Boss框体	
	cfg.heightPA = 11		-- party, party pet - arena小队, 小队宠物 - 竞技场
	cfg.heightR = 24		-- raid团队
	cfg.heightCB = 4		-- class bar 职业条高度

	-- width
	cfg.widthP = 225		-- player玩家
	cfg.widthT = 225		-- target目标
	cfg.widthF = 200		-- Focus	焦点	
	cfg.widthM = 180 		-- MT, boss frames主坦克, Boss框体
	cfg.widthS = 46 		-- ToT, FocusTarget, pet, party pet目标的目标, 焦点目标, 宠物, 小队宠物
	cfg.widthPA = 200 		-- party - arena小队 - 竞技场
	cfg.widthR = 64 		-- raid团队
	cfg.widthCB = 30		-- class bar
	
	-- hp|pp height, pp|info offset (optional)
	cfg.heightHP = 18		-- change frame height above, instead
	cfg.heightPP = 3.5		-- power height蓝条高度
	cfg.PPyOffset = 3.5		-- power y-Offset, can be a positiv/negative (down/up) value蓝条的位置
	
--------------------------------	
-- oUF_WeaponEnchant settings ----oUF武器附魔模块oUF_WeaponEnchant设置
--------------------------------
	cfg.WeapEnchantIconSize	= 30			-- oUF_WeaponEnchant icon size武器附魔图标大小(需oUF_WeaponEnchant)

	
ns.cfg = cfg	-- don't touch this ...别碰这里
